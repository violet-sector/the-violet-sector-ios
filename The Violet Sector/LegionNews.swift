// Created by João Santos for project The Violet Sector.

import SwiftUI

struct LegionNews: View {
    @ObservedObject private var model = Model<Data>(resource: "legion_news.php")

    var body: some View {
        VStack() {
            Text(verbatim: "Legion News")
                .bold()
                .accessibility(addTraits: .isHeader)
            if model.data != nil {
                GeometryReader() {(geometry) in
                    ScrollView() {
                        Text(verbatim: "Set by \(self.model.data!.content.author) on turn \(self.model.data!.content.turn) (\(DateFormatter.localizedString(from: Date(timeIntervalSince1970: TimeInterval(self.model.data!.content.time)), dateStyle: .short, timeStyle: .short)))\n\n\(self.model.data!.content.text)")
                            .frame(maxWidth: geometry.size.width * 0.9, maxHeight: .infinity, alignment: .topLeading)
                    }
                    .padding(1.0)
                    .border(Color.primary)
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height - 5.0)
                }
            } else if model.error != nil {
                FriendlyError(error: model.error!)
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
