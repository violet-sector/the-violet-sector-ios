//
//  TopDeathsModel.swift
//  The Violet Sector
//
//  Created by João Santos on 27/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import Foundation
import Combine

final class TopDeathsModel: ObservableObject {
    @Published private(set) var matches: [(rank: Int, death: Death)]?
    @Published var term = ""
    private var response: Response? {didSet {refresh()}}
    private var rankedDeaths: [(rank: Int, death: Death)]?
    private var timer: Cancellable?
    private var request: Cancellable?

    static let shared = TopDeathsModel()
    private static let resource = "rankings_att.php"
    private static let refreshInterval = TimeInterval(30.0)

    private init() {
        request = Client.shared.fetch(resource: TopDeathsModel.resource, assignTo: \.response, on: self)
        timer = Timer.publish(every: TopDeathsModel.refreshInterval, on: .main, in: .common)
        .autoconnect()
            .sink(receiveValue: {(_) in self.request = Client.shared.fetch(resource: TopDeathsModel.resource, assignTo: \.response, on: self)})
    }

    private func refresh() {
        guard let response = response else {
            return
        }
        StatusModel.shared.refresh(data: response.status)
        let deaths = response.deaths.sorted(by: {$0.score > $1.score})
        rankedDeaths = deaths.indices.map({(rank: $0 + 1, death: deaths[$0])})
        search()
    }

    func search() {
        guard !term.isEmpty else {
            matches = rankedDeaths
            return
        }
        matches = rankedDeaths!.filter() {(rankedDeath) in
            let tolerance = max(term.count, rankedDeath.death.name.count) * 2 / 5
            let distance = term ~= rankedDeath.death.name
            return distance <= tolerance
        }
    }

    private struct Response: Decodable {
        let deaths: [Death]
        let status: Status

        enum CodingKeys: String, CodingKey {
            case deaths = "rankings_att"
            case status = "player"
        }
    }

    struct Death: Decodable {
        let name: String
        let turn: UInt
        let score: UInt

        private enum CodingKeys: String, CodingKey {
            case name = "tvs_username"
            case turn = "tick"
            case score
        }
    }
}
