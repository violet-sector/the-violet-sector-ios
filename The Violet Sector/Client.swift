// Created by João Santos for project The Violet Sector.

import Foundation
import Combine
import Dispatch

final class Client: ObservableObject {
    @Published var tab: Tabs?
    @Published var errorResponse: CommonError?
    @Published private(set) var timer = "Loading..."
    @Published private(set) var statusResponse: StatusResponse? {didSet {if statusResponse == nil && oldValue != nil {statusResponse = oldValue}}}
    @Published private(set) var settings: Settings?
    @Published private(set) var error: String?
    weak var activeModel: ModelProtocol!
    private let session: URLSession
    private var responseSubscriber: Cancellable?
    private var settingsSubscriber: Cancellable?
    private var timerSubscriber: Cancellable?
    private let decoder = JSONDecoder()
    private var timerResponse: TimerResponse?
    private var referenceTime: Int64 = 0
    private var referenceTurn: Int64 = 0
    private var turnDuration: Int64 = 0
    private var serverHour: Int64 = 0
    private var deltaTime: Int64 = 0

    static let shared = Client()
    #if !DEBUG
    private static let baseURL = "https://www.violetsector.com/json/"
    #else
    private static let baseURL = "https://ucs.violetsector.com/json/"
    #endif
    private static let settingsResource = "config.php"
    private static var timerResource = "timer.php"
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
        fetchSettings()
        fetchTimer()
    }

    func get<Root: AnyObject, Response: Decodable>(_ resource: String, setResponse response: ReferenceWritableKeyPath<Root, Response?>, setWarning warning: ReferenceWritableKeyPath<Root, String?>? = nil, setError error: ReferenceWritableKeyPath<Root, String?>? = nil, on root: Root, completionHandler: @escaping () -> Void) -> Cancellable {
        #if DEBUG
        let resource = resource + "?rpirw=true"
        #endif
        let dataPublisher = session.dataTaskPublisher(for: URL(string: Self.baseURL + resource)!)
            .tryMap({(_ input: (data: Data, response: URLResponse)) -> Data in let response = input.response as! HTTPURLResponse; if response.statusCode != 200 {throw Errors.serverError(response.statusCode)} else if response.mimeType == nil {throw Errors.noContentType} else if response.mimeType! != "application/json" {throw Errors.invalidContentType(response.mimeType!)}; return input.data})
            .prefix(2)
        let responsePublisher = dataPublisher
            .decode(type: Response?.self, decoder: decoder)
            .tryCatch({[unowned root] (_ failure: Error) -> Just<Response?> in if let error = error, failure is DecodingError {root[keyPath: error] = Self.describeError(failure); return Just(Response?.none)}; throw failure})
        let commonPublisher = dataPublisher
            .decode(type: CommonResponse?.self, decoder: decoder)
            .tryCatch({(_ error: Error) -> Just<CommonResponse?> in if error is DecodingError {return Just(CommonResponse?.none)}; throw error})
        return responsePublisher
            .zip(commonPublisher)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {[unowned root] in if let error = error, case let .failure(failure) = $0 {root[keyPath: error] = Self.describeError(failure)}; completionHandler()}, receiveValue: {[unowned self, unowned root] in root[keyPath: response] = $0.0; statusResponse = $0.1?.status; if let warning = warning {root[keyPath: warning] = $0.1?.error?.message}})
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
        settingsSubscriber = get(Self.settingsResource, setResponse: \.settings, setError: \.error, on: self) {[unowned self] in
            settingsSubscriber = nil
            if settings == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + Self.retryInterval, execute: {[unowned self] in fetchSettings()})
            }
        }
    }

    private func fetchTimer() {
        guard timerSubscriber == nil else {
            return
        }
        timerSubscriber = get(Self.timerResource, setResponse: \.timerResponse, on: self) {[unowned self] in
            timerSubscriber = nil
            if timerResponse == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + Self.retryInterval, execute: {[unowned self] in fetchTimer()})
            } else {
                setupTimer()
            }
        }
    }

    private func setupTimer() {
        guard let data = timerResponse else {
            return
        }
        guard data.turnDuration > 0 else {
            return
        }
        turnDuration = data.turnDuration
        referenceTurn = data.referenceTurn
        let currentTime = Int64(Date().timeIntervalSince1970)
        referenceTime = currentTime - (turnDuration - data.remainingTime)
        deltaTime = currentTime - data.serverTime
        serverHour = data.serverTime - data.serverTime % (60 * 60)
        timerSubscriber = Timer.publish(every: 1.0, on: .main, in: .default)
            .autoconnect()
            .sink() {[unowned self] (date) in
                let currentTime = Int64(date.timeIntervalSince1970)
                var elapsedTime = currentTime - self.referenceTime
                let turn = referenceTurn + elapsedTime / turnDuration
                elapsedTime %= turnDuration
                var remainingTime = turnDuration - elapsedTime
                let hours = remainingTime / (60 * 60)
                remainingTime %= 60 * 60
                let minutes = remainingTime / 60
                remainingTime %= 60
                let seconds = remainingTime
                timer = String(format: "T%ld %ld:%02ld:%02ld", turn, hours, minutes, seconds)
                if currentTime - deltaTime - serverHour >= 60 * 60 && currentTime % 5 == 0 {
                    fetchTimer()
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
        var id: String {message}
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

    struct TimerResponse: Decodable {
        let turnDuration: Int64
        let referenceTurn: Int64
        let remainingTime: Int64
        let serverTime: Int64

        private enum CodingKeys: String, CodingKey {
            case turnDuration = "tick_length"
            case referenceTurn = "tick"
            case remainingTime = "secs_left"
            case serverTime = "now"
        }
    }

    enum Tabs {
        case main
        case friendlyScans
        case incomingScans
        case outgoingScans
        case map
        case topPilots
        case topDeaths
        case topLegions

        var title: String {
            switch self {
            case .main:
                return "Main"
            case .friendlyScans:
                return "Friendly Scans"
            case .incomingScans:
                return "Incoming Scans"
            case .outgoingScans:
                return "Outgoing Scans"
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
