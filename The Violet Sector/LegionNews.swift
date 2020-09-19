// Created by João Santos for project The Violet Sector.

import SwiftUI

struct LegionNews: View {
    @ObservedObject private var model = Model<Data>(resource: "legion_news.php")

    var body: some View {
        VStack(spacing: 10.0) {
            Title("Legion News")
            if let content = model.data?.content {
                ScrollView() {
                    Text(verbatim: "Set by \(content.author) on turn \(content.turn) (\(DateFormatter.localizedString(from: Date(timeIntervalSince1970: TimeInterval(content.time)), dateStyle: .short, timeStyle: .short)))\n\n\(content.text)")
                        .multilineTextAlignment(.leading)
                }
                .padding(5.0)
                .border(Color.primary)
                .frame(width: 240.0)
            } else if let error = model.error {
                FriendlyError(error: error)
            } else {
                Loading()
            }
            Status(data: model.data?.status)
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
