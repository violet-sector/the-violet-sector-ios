//
//  Client.swift
//  The Violet Sector
//
//  Created by João Santos on 01/08/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

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
            .tryMap({[unowned self] in Target.Response?(try self.decoder.decode(Target.Response.self, from: $0.data))})
            .receive(on: RunLoop.main)
            .catch({(error) -> Just<Target.Response?> in target.handleError(error); return Just(Target.Response?.none)})
            .assign(to: \.response, on: target)
    }
}
