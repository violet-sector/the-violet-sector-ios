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
    @Published var showingError = false {didSet {if !showingError {error = nil}}}
    private let session: URLSession

    static let shared = Client()

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

    func fetch<Root: AnyObject>(url: URL, assignTo keyPath: ReferenceWritableKeyPath<Root, Any>, on target: Root) -> Cancellable {
        return session.dataTaskPublisher(for: url)
            .tryMap({try JSONSerialization.jsonObject(with: $0.data)})
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {[unowned self] in if case let .failure(error) = $0 {self.showError(error)}}, receiveValue: {target[keyPath: keyPath] = $0})
    }

    func showError(_ error: Error) {
        switch error {
        case let error as LocalizedError:
            self.error = error.errorDescription
        case let error as NSError:
            self.error = error.localizedDescription
        default:
            self.error = "Unknown error."
        }
    }
}
