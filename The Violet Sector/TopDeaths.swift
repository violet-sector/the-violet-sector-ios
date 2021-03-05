// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TopDeaths: View {
    @State private var search = ""

    var body: some View {
        Page(title: "Top Deaths", resource: "rankings_att.php") {(_ data: Data) in
            HStack {
                TextField("Search", text: $search)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .frame(width: 200.0)
                Button(action: {self.search = ""}, label: {Image(systemName: "xmark.circle")})
                    .accessibilityLabel("Clear")
            }
            let enumeratedPilots = data.content.sorted(by: {$0.score > $1.score}).enumerated().filter({search.isEmpty || $0.element.name ~= search})
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

    private struct Data: Decodable {
        let content: [Death]
        let status: Status.Data

        private enum CodingKeys: String, CodingKey {
            case content = "rankings_att"
            case status = "player"
        }

        struct Death: Decodable {
            let name: String
            let turn: UInt
            let score: UInt

            private enum CodingKeys: String, CodingKey {
                case name = "tvs_username"
                case turn = "tick"
                case score
            }
        }
    }
}
