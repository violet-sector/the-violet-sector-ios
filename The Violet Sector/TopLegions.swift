// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TopLegions: View {
    var body: some View {
        Page(dataType: Data.self) {(data) in
            let legions = data.content
            if !legions.isEmpty {
                GeometryReader() {(geometry) in
                    VStack() {
                        ForEach(legions.indices, id: \.self) {(index) in
                            HStack(spacing: 5.0) {
                                Text(verbatim: "\(index + 1)")
                                    .frame(width: 20.0, alignment: .trailing)
                                Text(verbatim: "\(legions[index].legion)")
                                    .frame(width: (geometry.size.width - 30.0) * 0.5, alignment: .leading)
                                Text(verbatim: "\(legions[index].score)")
                                    .frame(width: (geometry.size.width - 30.0) * 0.5, alignment: .trailing)
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
