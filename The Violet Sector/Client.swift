// Created by João Santos for project The Violet Sector.

import Foundation
import Combine
import UIKit

final class Client: ObservableObject {
    @Published var tab: Tabs?
    @Published private(set) var statusResponse: StatusResponse? {didSet {if statusResponse == nil && oldValue != nil {statusResponse = oldValue}}}
    @Published private(set) var settings: Settings?
    @Published private(set) var error: String?
    weak var activeModel: ModelProtocol!
    private let session: URLSession
    private var request: URLRequest
    private var settingsSubscriber: Cancellable?
    private let decoder = JSONDecoder()

    static let shared = Client()
    private static let baseURL = "https://www.violetsector.com/json/"
    private static let settingsResource = "config.php"
    private static let retryInterval = TimeInterval(10.0)

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
        request = URLRequest(url: URL(string: Self.baseURL)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
        request.setValue(Self.baseURL, forHTTPHeaderField: "Referer")
        request.setValue("\(Bundle.main.object(forInfoDictionaryKey: "CFBundleName")!) \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!) \(UIDevice.current.systemName)", forHTTPHeaderField: "User-Agent")
        request.mainDocumentURL = URL(string: Self.baseURL + Self.settingsResource)
        request.httpShouldHandleCookies = true
        request.allowsCellularAccess = true
        request.allowsConstrainedNetworkAccess = true
        request.allowsExpensiveNetworkAccess = true
        request.networkServiceType = .responsiveData
        fetchSettings()
    }

    func fetch<Root: AnyObject, Response: Decodable>(_ resource: String, post: [String: String]? = nil, setResponse response: ReferenceWritableKeyPath<Root, Response?>, setWarning warning: ReferenceWritableKeyPath<Root, String?>? = nil, setError error: ReferenceWritableKeyPath<Root, String?>? = nil, on root: Root, completionHandler: @escaping () -> Void) -> Cancellable {
        #if DEBUG
        let resource = resource + "?rpirw=true"
        #endif
        var request = self.request
        request.url = URL(string: Self.baseURL + resource)!
        if let post = post {
            var query = ""
            for (key: key, value: value) in post {
                if !query.isEmpty {
                    query += "&"
                }
                query += key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                query += "="
                query += value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            }
            let postData = query.data(using: .ascii)!
            request.httpMethod = "POST"
            request.httpBody = postData
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        let dataPublisher = session.dataTaskPublisher(for: request)
            .tryMap({(_ input: (data: Data, response: URLResponse)) -> Data in let response = input.response as! HTTPURLResponse; if response.statusCode != 200 {throw Errors.serverError(response.statusCode)} else if response.mimeType == nil {throw Errors.noContentType} else if response.mimeType! != "application/json" {throw Errors.invalidContentType(response.mimeType!)}; return input.data})
            .share()
        let responsePublisher = dataPublisher
            .decode(type: Response?.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .tryCatch({[unowned root] (_ failure: Error) -> Just<Response?> in if post == nil, let error = error, failure is DecodingError {root[keyPath: error] = Self.describeError(failure); return Just(Response?.none)}; throw failure})
        let commonPublisher = dataPublisher
            .decode(type: CommonResponse?.self, decoder: decoder)
            .tryCatch({(_ error: Error) -> Just<CommonResponse?> in if error is DecodingError {return Just(CommonResponse?.none)}; throw error})
        return responsePublisher
            .zip(commonPublisher)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {[unowned root] in if let error = error, case let .failure(failure) = $0 {root[keyPath: error] = Self.describeError(failure)}; completionHandler()}, receiveValue: {[unowned self, unowned root] in root[keyPath: response] = $0.0; statusResponse = $0.1?.status; if let warning = warning {root[keyPath: warning] = $0.1?.error}})
    }

    private func fetchSettings() {
        error = nil
        settingsSubscriber = fetch(Self.settingsResource, setResponse: \.settings, setError: \.error, on: self) {[unowned self] in
            if settings == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + Self.retryInterval, execute: {[unowned self] in fetchSettings()})
            }
        }
    }

    private static func describeError(_ error: Error) -> String {
        switch error {
        case _ as DecodingError:
            return "Unable to decode resource."
        case let error as LocalizedError:
            return error.errorDescription ?? "Unknown error."
        case let error as NSError:
            return error.localizedDescription
        default:
            return "Unknown error."
        }
    }

    struct CommonResponse: Decodable {
        let status: StatusResponse
        let error: String?

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            status = try container.decode(StatusResponse.self, forKey: .status)
            let error = try container.decodeIfPresent([String].self, forKey: .error)
            self.error = error?.first
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

    struct Settings: Decodable {
        let news: String
        let isOuterRimEnabled: Bool
        let movesToSelfRepair: Int
        let movesToCloak: Int
        let movesToDecloak: Int
        let movesToDock: Int
        let movesToUndock: Int
        let movesToHyper: Int
        let maxCarriedScrap: Int
        let hyperTimeBufferStart: Int64
        let hyperTimeBufferEnd: Int64

        private enum CodingKeys: String, CodingKey {
            case news = "NEWS"
            case isOuterRimEnabled = "OUTER_RING"
            case movesToSelfRepair = "MOVES_SELF_REP"
            case movesToCloak = "MOVES_CLOAK"
            case movesToDecloak = "MOVES_DECLOAK"
            case movesToDock = "MOVES_CARRIER_ENTER"
            case movesToUndock = "MOVES_CARRIER_EXIT"
            case movesToHyper = "MOVES_HYPER"
            case maxCarriedScrap = "SCRAP_LIMIT"
            case hyperTimeBufferStart = "START_BUFFER"
            case hyperTimeBufferEnd = "END_BUFFER"
        }
    }

    enum Tabs {
        case computer
        case journal
        case friendlyScans
        case pickupScans
        case incomingScans
        case outgoingScans
        case news
        case map
        case topPilots
        case topDeaths
        case topLegions

        var title: String {
            switch self {
            case .computer:
                return "Ship Computer"
            case .journal:
                return "Journal"
            case .friendlyScans:
                return "Friendly Scans"
            case .pickupScans:
                return "Pickup Scans"
            case .incomingScans:
                return "Incoming Scans"
            case .outgoingScans:
                return "Outgoing Scans"
            case .news:
                return "Legion News"
            case .map:
                return "Map"
            case .topPilots:
                return "Top Pilots"
            case .topDeaths:
                return "Top Deaths"
            case .topLegions:
                return "Top Legions"
            }
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
