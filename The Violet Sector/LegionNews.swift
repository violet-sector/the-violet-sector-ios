// Created by João Santos for project The Violet Sector.

import SwiftUI

struct LegionNews: View {
    var body: some View {
        Page(title: "Legion News", resource: "legion_news.php") {(_ data: Data) in
            ScrollView() {
                Text(verbatim: "Set by \(data.content.author) on turn \(data.content.turn) (\(DateFormatter.localizedString(from: Date(timeIntervalSince1970: TimeInterval(data.content.time)), dateStyle: .short, timeStyle: .short)))\n\n\(data.content.text)")
                    .multilineTextAlignment(.leading)
            }
            .padding(5.0)
            .border(Color.primary)
            .frame(width: 240.0)
        }
    }

    private struct Data: Decodable {
        let content: Content
        let status: Status.Data

        private enum CodingKeys: String, CodingKey {
            case content = "legion_news"
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
