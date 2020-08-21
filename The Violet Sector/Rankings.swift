//
//  Rankings.swift
//  The Violet Sector
//
//  Created by João Santos on 20/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import Foundation
import Combine

final class Rankings: ObservableObject {
    @Published private(set) var response: Response?
    private var timer: Cancellable?
    private var request: Cancellable?

    static let shared = Rankings()
    private static let resource = "rankings_pilots.php"
    private static let refreshInterval = TimeInterval(60.0)

    private init() {
        request = Client.shared.fetch(resource: Rankings.resource, assignTo: \.response, on: self)
        timer = Foundation.Timer.publish(every: Rankings.refreshInterval, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: {[unowned self] (_) in self.request = Client.shared.fetch(resource: Rankings.resource, assignTo: \.response, on: self)})
    }

    struct Response: Decodable {
        let content: [Pilot]
        let status: Status

        enum CodingKeys: String, CodingKey {
            case content = "rankings_pilots"
            case status = "player"
        }
    }
 }
