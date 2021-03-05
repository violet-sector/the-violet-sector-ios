// Created by João Santos for project The Violet Sector.

import Foundation
import Combine

final class Client: ObservableObject {
    @Published private(set) var settings: Settings?
    @Published private(set) var error: Error?
    var refreshable: Refreshable? {didSet {guard let refreshable = refreshable else {return}; refreshable.refresh()}}
    private let session: URLSession
    private var request: Cancellable?
    private var timer: Cancellable?
    private let decoder = JSONDecoder()

    static let shared = Client()
    private static let baseURL = "https://www.violetsector.com/json/"
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

    func fetch<Root, Response: Decodable>(_ resource: String, postData data: Data? = nil, setResponse response: ReferenceWritableKeyPath<Root, Response?>, setFailure failure: ReferenceWritableKeyPath<Root, Error?>, on root: Root) -> Cancellable {
        #if DEBUG
        let resource = resource + "?rpirw=true"
        #endif
        let url = URL(string: Self.baseURL + resource)!
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
        if let data = data {
            request.httpMethod = "POST"
            request.httpBody = data
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue(Self.baseURL, forHTTPHeaderField: "Referer")
        }
        request.httpShouldHandleCookies = false
        request.allowsCellularAccess = true
        request.allowsConstrainedNetworkAccess = true
        request.allowsExpensiveNetworkAccess = true
        request.networkServiceType = .responsiveData
        return session.dataTaskPublisher(for: request)
            .tryMap({let response = $0.response as! HTTPURLResponse; if response.statusCode != 200 {throw Errors.serverError(response.statusCode)} else if response.mimeType == nil {throw Errors.noContentType} else if response.mimeType! != "application/json" {throw Errors.invalidContentType(response.mimeType!)}; return $0.data})
            .decode(type: Response?.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .catch({(error) -> Just<Response?> in root[keyPath: failure] = error; return Just(Response?.none)})
            .assign(to: response, on: root)
    }

    private func fetchSettings() {
        settings = nil
        error = nil
        request = session.dataTaskPublisher(for: URL(string: Self.baseURL + Self.settingsResource)!)
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
