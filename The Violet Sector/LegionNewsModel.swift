//
//  LegionNewsModel.swift
//  The Violet Sector
//
//  Created by João Santos on 15/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import Foundation
import Combine

final class LegionNewsModel: ObservableObject {
    @Published private(set) var response: Response?
    private var timer: Cancellable?
    private var request: Cancellable?

    static let shared = LegionNewsModel()
    private static let resource = "legion_news.php"
    private static let refreshInterval = TimeInterval(30.0)

    private init() {
        request = Client.shared.fetch(resource: LegionNewsModel.resource, assignTo: \.response, on: self)
        timer = Timer.publish(every: LegionNewsModel.refreshInterval, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: {[unowned self] (_) in self.request = Client.shared.fetch(resource: LegionNewsModel.resource, assignTo: \.response, on: self)})
    }

    struct Response: Decodable {
        let data: Content
        let status: Status

        private enum CodingKeys: String, CodingKey {
            case data = "legion_news"
            case status = "player"
        }

        struct Content: Decodable {
            let author: String
            let time: Int64
            let turn: Int64
            let text: String

            private enum CodingKeys: String, CodingKey {
                case author
                case time = "news_time"
                case turn = "news_tick"
                case text = "news_text"
            }
        }
    }
}
