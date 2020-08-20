//
//  Client.swift
//  The Violet Sector
//
//  Created by João Santos on 01/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import Foundation
import Combine

final class Client: ObservableObject {
    @Published var error: String? {didSet {if error != nil {showingError = true}}}
    @Published var showingError = false
    private var lastError: Error?
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

    func fetch<Root: AnyObject, Target: Decodable>(resource: String, assignTo keyPath: ReferenceWritableKeyPath<Root, Target>, on root: Root) -> Cancellable {
        return session.dataTaskPublisher(for: Client.baseURL.appendingPathComponent(resource, isDirectory: false))
            .tryMap({[unowned self] in try self.decoder.decode(Target.self, from: $0.data)})
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {[unowned self] in if case let .failure(error) = $0 {self.showError(error)}}, receiveValue: {root[keyPath: keyPath] = $0})
    }

    private func showError(_ error: Error) {
        var message = String()
        switch error {
        case _ as DecodingError:
            message = "Error decoding information from the server."
        case let error as LocalizedError:
            message = error.errorDescription ?? "Unknown error."
        case let error as NSError:
            message = error.localizedDescription
        default:
            message = "Unknown error."
        }
        guard !showingError && (self.error == nil || self.error != message) else {
            return
        }
        self.error = message
    }
}
