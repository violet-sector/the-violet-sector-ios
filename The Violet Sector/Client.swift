// Created by João Santos for project The Violet Sector.

import Foundation
import Combine

final class Client {
    weak var refreshable: Refreshable? {didSet {if let refreshable = refreshable {refreshable.refresh()}}}
    private let session: URLSession
    private let decoder = JSONDecoder()

    static let shared = Client()
    private static let baseURL = URL(string: "https://www.violetsector.com/json/")!

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
    }

    func fetch<Target: Fetchable>(_ target: Target) -> Cancellable {
        return session.dataTaskPublisher(for: Client.baseURL.appendingPathComponent(Target.resource, isDirectory: false))
            .tryMap({if $0.response.mimeType == nil || $0.response.mimeType! != "application/json" {throw Errors.invalidContentType}; return $0.data})
            .decode(type: Target.Response?.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .catch({(error) -> Just<Target.Response?> in target.error = error; return Just(Target.Response?.none)})
            .assign(to: \.response, on: target)
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
