// Created by João Santos for project The Violet Sector.

import Foundation
import Combine

final class Client: ObservableObject {
    @Published private(set) var statusResponse: StatusResponse? {didSet {if statusResponse == nil && oldValue != nil {statusResponse = oldValue}}}
    @Published var errorResponse: CommonError?
    @Published private(set) var settings: Settings?
    @Published private(set) var error: Error?
    private let session: URLSession
    private var responseSubscriber: Cancellable?
    private var settingsSubscriber: Cancellable?
    private var timer: Cancellable?
    private let decoder = JSONDecoder()

    static let shared = Client()
    #if !DEBUG
    private static let baseURL = "https://www.violetsector.com/json/"
    #else
    private static let baseURL = "https://ucs.violetsector.com/json/"
    #endif
    private static let settingsResource = "config.php"
    private static let settingsFetchRetry = TimeInterval(10.0)

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.networkServiceType = .responsiveData
        configuration.allowsCellularAccess = true
        configuration.waitsForConnectivity = false
        configuration.httpCookieAcceptPolicy = .always
        configuration.httpShouldSetCookies = true
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.allowsConstrainedNetworkAccess = true
        configuration.allowsExpensiveNetworkAccess = true
        session = URLSession(configuration: configuration)
        fetchSettings()
    }

    func get<Root: AnyObject, Response: Decodable>(_ resource: String, setResponse response: ReferenceWritableKeyPath<Root, Response?>, setFailure failure: ReferenceWritableKeyPath<Root, Error?>, on root: Root, completionHandler: (() -> Void)? = nil) -> Cancellable {
        #if DEBUG
        let resource = resource + "?rpirw=true"
        #endif
        let dataPublisher = session.dataTaskPublisher(for: URL(string: Self.baseURL + resource)!)
            .tryMap({(_ input: (data: Data, response: URLResponse)) -> Data in let response = input.response as! HTTPURLResponse; if response.statusCode != 200 {throw Errors.serverError(response.statusCode)} else if response.mimeType == nil {throw Errors.noContentType} else if response.mimeType! != "application/json" {throw Errors.invalidContentType(response.mimeType!)}; return input.data})
            .prefix(2)
        let responsePublisher = dataPublisher
            .decode(type: Response?.self, decoder: decoder)
            .tryCatch({[unowned root] (_ error: Error) -> Just<Response?> in if error is DecodingError {root[keyPath: failure] = error; return Just(Response?.none)}; throw error})
        let commonPublisher = dataPublisher
            .decode(type: CommonResponse?.self, decoder: decoder)
            .tryCatch({(_ error: Error) -> Just<CommonResponse?> in if error is DecodingError {return Just(CommonResponse?.none)}; throw error})
        return responsePublisher
            .zip(commonPublisher)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {[unowned root] in if case let .failure(error) = $0 {root[keyPath: failure] = error}; guard let completionHandler = completionHandler else {return}; completionHandler()}, receiveValue: {[unowned self, unowned root] in root[keyPath: response] = $0.0; statusResponse = $0.1?.status; errorResponse = $0.1?.error})
    }

    func post(_ resource: String, query: [String: String], completionHandler: @escaping () -> Void) {
        var queryString = ""
        for (key: key, value: value) in query {
            if !queryString.isEmpty {
                queryString += "&"
            }
            queryString += key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            queryString += "="
            queryString += value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
        let postData = queryString.data(using: .ascii)!
        #if DEBUG
        let resource = resource + "?rpirw=true"
        #endif
        var postRequest = URLRequest(url: URL(string: Self.baseURL + resource)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
        postRequest.httpMethod = "POST"
        postRequest.httpBody = postData
        postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        postRequest.setValue(Self.baseURL, forHTTPHeaderField: "Referer")
        postRequest.httpShouldHandleCookies = true
        postRequest.allowsCellularAccess = true
        postRequest.allowsConstrainedNetworkAccess = true
        postRequest.allowsExpensiveNetworkAccess = true
        postRequest.networkServiceType = .responsiveData
        responseSubscriber = session.dataTaskPublisher(for: postRequest)
            .map({$0.data})
            .decode(type: CommonResponse?.self, decoder: decoder)
            .catch({(_) in Just(CommonResponse?.none)})
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {[unowned self] (_) in responseSubscriber = nil; completionHandler()}, receiveValue: {[unowned self] in statusResponse = $0?.status; errorResponse = $0?.error})
    }

    private func fetchSettings() {
        settings = nil
        error = nil
        settingsSubscriber = session.dataTaskPublisher(for: URL(string: Self.baseURL + Self.settingsResource)!)
            .tryMap({let response = $0.response as! HTTPURLResponse; if response.statusCode != 200 {throw Errors.serverError(response.statusCode)} else if response.mimeType == nil {throw Errors.noContentType} else if response.mimeType! != "application/json" {throw Errors.invalidContentType(response.mimeType!)}; return $0.data})
            .decode(type: Settings.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {[unowned self] in if case let .failure(error) = $0 {self.error = error; self.retryFetchSettings()}}, receiveValue: {[unowned self] in self.settings = $0; self.error = nil; self.timer = nil})
    }

    private func retryFetchSettings() {
        timer = Foundation.Timer.publish(every: Self.settingsFetchRetry, on: .main, in: .default)
            .autoconnect()
            .first()
            .sink(receiveValue: {[unowned self] (_) in self.fetchSettings()})
    }

    struct CommonResponse: Decodable {
        let status: StatusResponse
        let error: CommonError?

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            status = try container.decode(StatusResponse.self, forKey: .status)
            let error = try container.decodeIfPresent([String].self, forKey: .error)
            self.error = error?.first != nil ? CommonError(message: error!.first!) : nil
        }

        private enum CodingKeys: String, CodingKey {
            case status = "player"
            case error = "errors"
        }
    }

    struct StatusResponse: Decodable {
        let name: String
        let currentHealth: Int
        let maxHealth: Int
        let moves: Int
        let score: Int
        let ship: Ships
        let legion: Legions
        let currentSector: Sectors
        let destinationSector: Sectors
        let isCloaked: Bool
        let isInvulnerable: Bool
        let isSleeping: Bool
        let carrier: Carrier

        var level: Int {
            switch self.score {
            case ..<4000:
                return 1
            case ..<8000:
                return 2
            case ..<16000:
                return 3
            case ..<32000:
                return 4
            case 32000...:
                return 5
            default:
                return 0
            }
        }
        private enum CodingKeys: String, CodingKey {
            case name = "tvs_username"
            case currentHealth = "hp"
            case maxHealth = "maxhp"
            case moves
            case score
            case ship
            case legion
            case currentSector = "sector"
            case destinationSector = "destination"
            case isCloaked = "cloaked"
            case isInvulnerable = "invulnerable"
            case isSleeping = "sleep_tick"
            case carrier
        }

        struct Carrier: Decodable {
            let name: String?
            let isOnline: Bool?

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                name = try container.decodeIfPresent(String.self, forKey: .name)
                isOnline = try container.decodeIfPresent(Bool.self, forKey: .isOnline)
            }

            private enum CodingKeys: String, CodingKey {
                case name = "tvs_username"
                case isOnline = "online"
            }
        }
    }

    struct CommonError: Identifiable {
        let message: String
        var id: Int {message.hashValue}
    }

    struct Settings: Decodable {
        let news: String
        let isOuterRimEnabled: Bool
        let movesToSelfRepair: Int
        let movesToCloak: Int
        let movesToDecloak: Int
        let movesToHyper: Int
        let hyperTimeBufferStart: Int64
        let hyperTimeBufferEnd: Int64

        private enum CodingKeys: String, CodingKey {
            case news = "NEWS"
            case isOuterRimEnabled = "OUTER_RING"
            case movesToSelfRepair = "MOVES_SELF_REP"
            case movesToCloak = "MOVES_CLOAK"
            case movesToDecloak = "MOVES_DECLOAK"
            case movesToHyper = "MOVES_HYPER"
            case hyperTimeBufferStart = "START_BUFFER"
            case hyperTimeBufferEnd = "END_BUFFER"
        }
    }

    enum Errors: LocalizedError {
        case serverError(Int)
        case noContentType
        case invalidContentType(String)

        var errorDescription: String? {
            switch self {
            case let .serverError(code):
                return "Server error (\(code))."
            case .noContentType:
                return "No content type specified."
            case let .invalidContentType(contentType):
                return "Invalid content type (\(contentType))."
            }
        }
    }
}
