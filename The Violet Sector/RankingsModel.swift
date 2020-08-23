//
//  RankingsModel.swift
//  The Violet Sector
//
//  Created by João Santos on 20/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import Foundation
import Combine

final class RankingsModel: ObservableObject {
    @Published private(set) var isReady = false
    @Published private(set) var matches: [(offset: Int, element: Pilot)]?
    private var response: Response? {didSet {update()}}
    private var pattern = ""
    private var timer: Cancellable?
    private var request: Cancellable?

    static let shared = RankingsModel()
    private static let resource = "rankings_pilots.php"
    private static let refreshInterval = TimeInterval(60.0)

    private init() {
        request = Client.shared.fetch(resource: RankingsModel.resource, assignTo: \.response, on: self)
        timer = Foundation.Timer.publish(every: RankingsModel.refreshInterval, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: {[unowned self] (_) in self.request = Client.shared.fetch(resource: RankingsModel.resource, assignTo: \.response, on: self)})
    }

    private func update() {
        StatusModel.shared.update(status: response!.status)
        search(for: pattern)
        isReady = true
    }

    func search(for pattern: String) {
        self.pattern = pattern
        guard !pattern.isEmpty else {
            matches = response != nil ? [(offset: Int, element: Pilot)](response!.pilots.enumerated()) : nil
            return
        }
        matches = response?.pilots.enumerated().filter() {(rank) in
            let tolerance = max(pattern.count, rank.element.name.count) / 3
            let distance = pattern ~= rank.element.name
            return distance <= tolerance
        }
    }

    struct Response: Decodable {
        let pilots: [Pilot]
        let status: Status

        enum CodingKeys: String, CodingKey {
            case pilots = "rankings_pilots"
            case status = "player"
        }
    }
 }
