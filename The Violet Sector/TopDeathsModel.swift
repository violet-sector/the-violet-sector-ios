// Created by João Santos for project The Violet Sector.

import Combine

final class TopDeathsModel: ObservableObject, Refreshable, Fetchable {
    typealias RankedDeath = (rank: Int, death: Death)

    @Published private(set) var matches: [RankedDeath]?
    @Published var term = ""
    @Published var error: Error?
    var response: Response? {didSet {update()}}
    var request: Cancellable?
    private var rankedDeaths: [RankedDeath]?

    static let shared = TopDeathsModel()
    static let resource = "rankings_att.php"

    private init() {}

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

    private func update() {
        request = nil
        guard let response = response else {
            matches = nil
            return
        }
        StatusModel.shared.refresh(data: response.status)
        let deaths = response.deaths.sorted(by: {$0.score > $1.score})
        rankedDeaths = deaths.indices.map({(rank: $0 + 1, death: deaths[$0])})
        matches = rankedDeaths
        term = ""
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
