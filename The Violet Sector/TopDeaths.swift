// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TopDeaths: View {
    @StateObject private var model = Model(resource: "rankings_att.php", responseType: Response.self)

    var body: some View {
        Page(model: model) {(response) in
            let indices = response.content.indices
            if !indices.isEmpty {
                GeometryReader() {(geometry) in
                    ScrollView() {
                        LazyVStack() {
                            ForEach(indices, id: \.self) {(index) in
                                HStack(spacing: 5.0) {
                                    Text(verbatim: String(index + 1))
                                        .frame(width: 20.0, alignment: .trailing)
                                    Text(verbatim: response.content[index].name)
                                        .frame(width: (geometry.size.width - 35.0) * 0.5, alignment: .leading)
                                    Text(verbatim: String(response.content[index].score))
                                        .frame(width: (geometry.size.width - 35.0) * 0.3, alignment: .trailing)
                                    Text(verbatim: String(response.content[index].turn))
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

    private struct Response: Decodable {
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
