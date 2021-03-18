// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TopDeaths: View {
    @ObservedObject var model: Model<Data>

    var body: some View {
        Page(title: "Top Deaths", model: model) {(data) in
            let indices = data.content.indices
            if !indices.isEmpty {
                GeometryReader() {(geometry) in
                    ScrollView() {
                        LazyVStack() {
                            ForEach(indices, id: \.self) {(index) in
                                HStack(spacing: 5.0) {
                                    Text(verbatim: String(index + 1))
                                        .frame(width: 20.0, alignment: .trailing)
                                    Text(verbatim: data.content[index].name)
                                        .frame(width: (geometry.size.width - 35.0) * 0.5, alignment: .leading)
                                    Text(verbatim: String(data.content[index].score))
                                        .frame(width: (geometry.size.width - 35.0) * 0.3, alignment: .trailing)
                                    Text(verbatim: String(data.content[index].turn))
                                        .frame(width: (geometry.size.width - 35.0) * 0.2, alignment: .trailing)
                                }
                                .frame(height: 32.0)
                                .accessibilityElement(children: .combine)
                            }
                        }
                    }
                }
            } else {
                Spacer()
                Text(verbatim: "Nothing to show.")
                Spacer()
            }
        }
    }

    struct Data: Decodable {
        let content: [Death]

        private enum CodingKeys: String, CodingKey {
            case content = "rankings_att"
        }

        struct Death: Decodable {
            let name: String
            let turn: Int
            let score: Int

            private enum CodingKeys: String, CodingKey {
                case name = "tvs_username"
                case turn = "tick"
                case score
            }
        }
    }
}
