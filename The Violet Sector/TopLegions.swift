// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TopLegions: View {
    var body: some View {
        Page(title: "Top Legions", resource: "rankings_legions.php") {(_ data: Data) in
            let legions = data.content.sorted(by: {$0.score > $1.score})
            if !legions.isEmpty {
                List(legions.indices, id: \.self) {(index) in
                    HStack() {
                        Text(verbatim: "\(index + 1)")
                            .frame(width: 32.0, alignment: .trailing)
                        GeometryReader() {(geometry) in
                            HStack(spacing: 0.0) {
                                Text(verbatim: "\(legions[index].legion)")
                                    .frame(width: geometry.size.width * 0.5, alignment: .leading)
                                Text(verbatim: "\(legions[index].score)")
                                    .frame(width: geometry.size.width * 0.5, alignment: .trailing)
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
        let content: [Legion]
        let status: Status.Data

        private enum CodingKeys: String, CodingKey {
            case content = "rankings_legions"
            case status = "player"
        }

        struct Legion: Decodable {
            let legion: Legions
            let score: UInt

            private enum CodingKeys: String, CodingKey {
                case legion
                case score
            }
        }
    }
}
