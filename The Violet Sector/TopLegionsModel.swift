//
//  TopLegionsModel.swift
//  The Violet Sector
//
//  Created by João Santos on 28/08/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

import Foundation
import Combine

final class TopLegionsModel: ObservableObject {
    @Published private(set) var rankedLegions: [(rank: Int, legion: Response.Content)]?
    private var response: Response? {didSet {refresh()}}
    private var timer: Cancellable?
    private var request: Cancellable?

    static let shared = TopLegionsModel()
    private static let resource = "rankings_legions.php"
    private static let refreshInterval = TimeInterval(30.0)

    private init() {
        request = Client.shared.fetch(resource: TopLegionsModel.resource, assignTo: \.response, on: self)
        timer = Timer.publish(every: TopLegionsModel.refreshInterval, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: {[unowned self] (_) in self.request = Client.shared.fetch(resource: TopLegionsModel.resource, assignTo: \.response, on: self)})
    }

    private func refresh() {
        guard let response = response else {
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
