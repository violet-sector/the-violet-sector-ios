//
//  TopDeathsModel.swift
//  The Violet Sector
//
//  Created by João Santos on 27/08/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

import Combine

final class TopDeathsModel: ObservableObject, Refreshable, Fetchable {
    @Published private(set) var matches: [(rank: Int, death: Death)]?
    @Published var term = ""
    @Published var error: Error?
    var response: Response? {didSet {update()}}
    var request: Cancellable?
    private var rankedDeaths: [(rank: Int, death: Death)]?

    static let shared = TopDeathsModel()
    static let resource = "rankings_att.php"

    private init() {}

    private func update() {
        request = nil
        guard let response = response else {
            matches = nil
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

    struct Response: Decodable {
        let deaths: [Death]
        let status: Status

        private enum CodingKeys: String, CodingKey {
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
