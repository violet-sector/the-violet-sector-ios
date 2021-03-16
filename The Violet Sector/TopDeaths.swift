// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TopDeaths: View {
    @ObservedObject var model: Model<Data>

    var body: some View {
        Page(title: "Top Deaths", model: model) {(data) in
            let enumeratedPilots = Array(data.content.sorted(by: {$0.score > $1.score}).enumerated())
            if !enumeratedPilots.isEmpty {
                List(enumeratedPilots, id: \.offset) {(enumeratedPilot) in
                    HStack() {
                        Text(verbatim: "\(enumeratedPilot.offset + 1)")
                            .frame(width: 32.0, alignment: .trailing)
                        GeometryReader() {(geometry) in
                            HStack(spacing: 0.0) {
                                Text(verbatim: enumeratedPilot.element.name)
                                    .frame(width: geometry.size.width * 0.5, alignment: .leading)
                                Text(verbatim: "\(enumeratedPilot.element.score)")
                                    .frame(width: geometry.size.width * 0.3, alignment: .trailing)
                                Text(verbatim: "\(enumeratedPilot.element.turn)")
                                    .frame(width: geometry.size.width * 0.2, alignment: .trailing)
                            }
                        }
                    }
                    .accessibilityElement(children: .combine)
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
