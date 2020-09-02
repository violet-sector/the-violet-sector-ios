//
//  LegionNewsModel.swift
//  The Violet Sector
//
//  Created by João Santos on 15/08/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

import Combine

final class LegionNewsModel: ObservableObject, Refreshable, Fetchable {
    @Published var response: Response? {didSet {update()}}
    @Published var error: String?
    var request: Cancellable?

    static let shared = LegionNewsModel()
    static let resource = "legion_news.php"

    private init() {}

    private func update() {
        request = nil
        guard let response = response else {
            return
        }
        error = nil
        StatusModel.shared.refresh(data: response.status)
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
