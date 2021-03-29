// Created by João Santos for project The Violet Sector.

import SwiftUI

struct News: View {
    var body: some View {
        Page(dataType: Data.self) {(data) in
            Text(verbatim: "Set by \(data.content.author) on T\(data.content.turn)\n\(DateFormatter.localizedString(from: Date(timeIntervalSince1970: TimeInterval(data.content.time)), dateStyle: .short, timeStyle: .short))")
            GeometryReader() {(geometry) in
                ScrollView() {
                    Text(verbatim: data.content.text)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .padding(5.0)
                .frame(width: geometry.size.width - 20.0, height: geometry.size.height)
                .background(RoundedRectangle(cornerRadius: 8.0).stroke(Color.accentColor, lineWidth: 2.0))
                .padding([.leading, .trailing], 10.0)
            }
        }
    }

    struct Data: Decodable {
        let content: Content

        private enum CodingKeys: String, CodingKey {
            case content = "legion_news"
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
