// Created by João Santos for project The Violet Sector.

import Combine

final class TopLegionsModel: ObservableObject, Refreshable, Fetchable {
    typealias RankedLegion = (rank: Int, legion: Response.Content)

    @Published private(set) var rankedLegions: [RankedLegion]?
    @Published var error: Error?
    var response: Response? {didSet {update()}}
    var request: Cancellable?

    static let shared = TopLegionsModel()
    static let resource = "rankings_legions.php"

    private init() {}

    private func update() {
        request = nil
        guard let response = response else {
            rankedLegions = nil
            return
        }
        StatusModel.shared.refresh(data: response.status)
        let legions = response.data.sorted(by: {$0.score > $1.score})
        rankedLegions = legions.indices.map({(rank: $0 + 1, legion: legions[$0])})
    }

    struct Response: Decodable {
        let data: [Content]
        let status: Status

        private enum CodingKeys: String, CodingKey {
            case data = "rankings_legions"
            case status = "player"
        }

        struct Content: Decodable {
            let legion: Legions
            let score: UInt

            private enum CodingKeys: String, CodingKey {
                case legion
                case score
            }
        }
    }
}
