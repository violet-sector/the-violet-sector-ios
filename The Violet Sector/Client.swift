// Created by João Santos for project The Violet Sector.

import Foundation
import Combine

final class Client: ObservableObject {
    @Published private(set) var settings: Settings?
    @Published private(set) var error: Error? {didSet {guard error != nil else {return}; RunLoop.main.schedule(after: RunLoop.SchedulerTimeType(Date(timeIntervalSinceNow: 10.0)), tolerance: RunLoop.SchedulerTimeType.Stride(.infinity), options: nil, {[unowned self] in self.fetchSettings()})}}
    weak var refreshable: Refreshable? {didSet {if let refreshable = refreshable {refreshable.refresh()}}}
    private let session: URLSession
    private var request: Cancellable?
    private let decoder = JSONDecoder()

    static let shared = Client()
    private static let baseURL = URL(string: "https://www.violetsector.com/json/")!
    private static let settingsResource = "config.php"

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

    func fetch<Target: Fetchable>(_ target: Target) -> Cancellable {
        return session.dataTaskPublisher(for: Client.baseURL.appendingPathComponent(Target.resource, isDirectory: false))
            .tryMap({if $0.response.mimeType == nil || $0.response.mimeType! != "application/json" {throw Errors.invalidContentType}; return $0.data})
            .decode(type: Target.Response?.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .catch({(error) -> Just<Target.Response?> in target.error = error; return Just(Target.Response?.none)})
            .assign(to: \.response, on: target)
    }

    private func fetchSettings() {
        error = nil
        request = session.dataTaskPublisher(for: Client.baseURL.appendingPathComponent(Client.settingsResource, isDirectory: false))
            .tryMap({if $0.response.mimeType == nil || $0.response.mimeType! != "application/json" {throw Errors.invalidContentType}; return $0.data})
            .decode(type: Client.Settings?.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .catch({[unowned self] (error) -> Just<Client.Settings?> in self.error = error; return Just(Client.Settings?.none)})
            .assign(to: \.settings, on: self)
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
        case invalidContentType

        var errorDescription: String? {
            switch self {
            case .invalidContentType:
                return "Invalid content type."
            }
        }
    }
}
