//
//  TopPilotsModel.swift
//  The Violet Sector
//
//  Created by João Santos on 20/08/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

import Combine

final class TopPilotsModel: ObservableObject, Refreshable, Fetchable {
    @Published private(set) var matches: [(rank: Int, pilot: Pilot)]?
    @Published var term = ""
    @Published var error: String?
    var response: Response? {didSet {update()}}
    var request: Cancellable?
    private var rankedPilots: [(rank: Int, pilot: Pilot)]?

    static let shared = TopPilotsModel()
    static let resource = "rankings_pilots.php"

    private init() {}

    private func update() {
        request = nil
        guard let response = response else {
            matches = nil
            return
        }
        error = nil
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
        let pilots: [Pilot]
        let status: Status

        private enum CodingKeys: String, CodingKey {
            case pilots = "rankings_pilots"
            case status = "player"
        }
    }
}
