// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TopLegions: View {
    @ObservedObject var model: Model<Data>

    var body: some View {
        Page(title: "Top Legions", model: model) {(data) in
            let legions = data.content.sorted(by: {$0.score > $1.score})
            if !legions.isEmpty {
                GeometryReader() {(geometry) in
                    VStack() {
                        ForEach(legions.indices, id: \.self) {(index) in
                            HStack(spacing: 0.0) {
                                Text(verbatim: "\(index + 1)")
                                    .frame(width: 32.0, alignment: .trailing)
                                Text(verbatim: "\(legions[index].legion)")
                                    .frame(width: (geometry.size.width - 32.0) * 0.5, alignment: .leading)
                                Text(verbatim: "\(legions[index].score)")
                                    .frame(width: (geometry.size.width - 32.0) * 0.5, alignment: .trailing)
                            }
                            .frame(height: 32.0)
                            .accessibilityElement(children: .combine)
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
        let content: [Legion]

        private enum CodingKeys: String, CodingKey {
            case content = "rankings_legions"
        }

        struct Legion: Decodable {
            let legion: Legions
            let score: Int

            private enum CodingKeys: String, CodingKey {
                case legion
                case score
            }
        }
    }
}
