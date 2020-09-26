// Created by João Santos for project The Violet Sector.

import Foundation
import Combine

final class Client: ObservableObject {
    @Published private(set) var settings: Settings? {didSet {guard settings == nil else {return}; retryFetchSettings()}}
    @Published private(set) var error: Error?
    var refreshable: Refreshable?
    private let session: URLSession
    private var request: Cancellable?
    private var timer: Cancellable?
    private let decoder = JSONDecoder()

    static let shared = Client()
    private static let baseURL = URL(string: "https://www.violetsector.com/json/")!
    private static let settingsResource = "config.php"
    private static let settingsFetchRetry = TimeInterval(10.0)

    private init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.networkServiceType = .responsiveData
        configuration.allowsCellularAccess = true
        configuration.waitsForConnectivity = true
        configuration.httpCookieAcceptPolicy = .never
        configuration.httpShouldSetCookies = false
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.allowsConstrainedNetworkAccess = true
        configuration.allowsExpensiveNetworkAccess = true
        session = URLSession(configuration: configuration)
        fetchSettings()
    }

    func fetch<Root, Response: Decodable>(_ resource: String, setResponse response: ReferenceWritableKeyPath<Root, Response?>, setFailure failure: ReferenceWritableKeyPath<Root, Error?>, on root: Root) -> Cancellable {
        return session.dataTaskPublisher(for: Self.baseURL.appendingPathComponent(resource, isDirectory: false))
            .tryMap({let response = $0.response as! HTTPURLResponse; if response.statusCode != 200 {throw Errors.serverError(response.statusCode)} else if response.mimeType == nil {throw Errors.noContentType} else if response.mimeType! != "application/json" {throw Errors.invalidContentType(response.mimeType!)}; return $0.data})
            .decode(type: Response?.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .catch({(error) -> Just<Response?> in root[keyPath: failure] = error; return Just(Response?.none)})
            .assign(to: response, on: root)
    }

    private func fetchSettings() {
        settings = nil
        error = nil
        request = fetch(Self.settingsResource, setResponse: \.settings, setFailure: \.error, on: self)
    }

    private func retryFetchSettings() {
        timer = Foundation.Timer.publish(every: Self.settingsFetchRetry, on: .main, in: .default)
            .autoconnect()
            .first()
            .sink(receiveValue: {[unowned self] (_) in self.retryFetchSettings()})
    }

    struct Settings: Decodable {
        let news: String
        let isOuterRimEnabled: Bool

        private enum CodingKeys: String, CodingKey {
            case news = "NEWS"
            case isOuterRimEnabled = "OUTER_RING"
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
