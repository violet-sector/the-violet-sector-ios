//
//  TopPilotsModel.swift
//  The Violet Sector
//
//  Created by João Santos on 20/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import Foundation
import Combine

final class TopPilotsModel: ObservableObject {
    @Published private(set) var matches: [(rank: Int, pilot: Pilot)]?
    private var response: Response? {didSet {refresh()}}
    private var rankedPilots: [(rank: Int, pilot: Pilot)]?
    private var pattern = ""
    private var timer: Cancellable?
    private var request: Cancellable?

    static let shared = TopPilotsModel()
    private static let resource = "rankings_pilots.php"
    private static let refreshInterval = TimeInterval(60.0)

    private init() {
        request = Client.shared.fetch(resource: TopPilotsModel.resource, assignTo: \.response, on: self)
        timer = Timer.publish(every: TopPilotsModel.refreshInterval, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: {[unowned self] (_) in self.request = Client.shared.fetch(resource: TopPilotsModel.resource, assignTo: \.response, on: self)})
    }

    private func refresh() {
        guard let response = response else {
            return
        }
        StatusModel.shared.refresh(data: response.status)
        let pilots = response.pilots.sorted(by: {$0.score > $1.score})
        rankedPilots = pilots.indices.map({(rank: $0 + 1, pilot: pilots[$0])})
        search(for: pattern)
    }

    func search(for pattern: String) {
        self.pattern = pattern
        guard !pattern.isEmpty else {
            matches = rankedPilots
            return
        }
        matches = rankedPilots!.filter() {(rankedPilot) in
            let tolerance = max(pattern.count, rankedPilot.pilot.name.count) * 2 / 5
            let distance = pattern ~= rankedPilot.pilot.name
            return distance <= tolerance
        }
    }

    private struct Response: Decodable {
        let pilots: [Pilot]
        let status: Status

        enum CodingKeys: String, CodingKey {
            case pilots = "rankings_pilots"
            case status = "player"
        }
    }
}
