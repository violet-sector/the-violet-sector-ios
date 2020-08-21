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
    @Published private(set) var response: Response? {didSet {search(for: pattern)}}
    @Published private(set) var matches: [(offset: Int, element: Pilot)]?
    private var pattern = ""
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

    func search(for pattern: String) {
        self.pattern = pattern
        guard response != nil else {
            matches = nil
            return
        }
        guard !pattern.isEmpty else {
            matches = [(offset: Int, element: Pilot)](response!.content.enumerated())
            return
        }
        matches = response!.content.enumerated().filter() {(rank) in
            let tolerance = max(pattern.count, rank.element.name.count) / 3
            let distance = pattern ~= rank.element.name
            return distance <= tolerance
        }
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
