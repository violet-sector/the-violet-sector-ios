// Created by João Santos for project The Violet Sector.

import Combine

final class TopPilotsModel: ObservableObject, Refreshable, Fetchable {
    typealias RankedPilot = (rank: Int, pilot: Target)

    @Published private(set) var matches: [RankedPilot]?
    @Published var term = ""
    @Published var error: Error?
    var response: Response? {didSet {update()}}
    var request: Cancellable?
    private var rankedPilots: [RankedPilot]?

    static let shared = TopPilotsModel()
    static let resource = "rankings_pilots.php"

    private init() {}

    private func update() {
        request = nil
        guard let response = response else {
            matches = nil
            return
        }
        StatusModel.shared.refresh(data: response.status)
        let pilots = response.pilots.sorted(by: {$0.score > $1.score})
        rankedPilots = pilots.indices.map({(rank: $0 + 1, pilot: pilots[$0])})
        search()
    }

    func search() {
        guard !term.isEmpty else {
            matches = rankedPilots
            return
        }
        matches = rankedPilots!.filter() {(rankedPilot) in
            let tolerance = max(term.count, rankedPilot.pilot.name.count) * 2 / 5
            let distance = term ~= rankedPilot.pilot.name
            return distance <= tolerance
        }
    }

    struct Response: Decodable {
        let pilots: [Target]
        let status: Status

        private enum CodingKeys: String, CodingKey {
            case pilots = "rankings_pilots"
            case status = "player"
        }
    }
}
