// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TopLegions: View {
    @ObservedObject private var model = Model<Data>(resource: "rankings_legions.php")

    var body: some View {
        VStack(spacing: 10.0) {
            Text(verbatim: "Top Legions")
                .bold()
                .accessibility(addTraits: .isHeader)
            if let content = model.data?.content {
                let legions = content.sorted(by: {$0.score > $1.score})
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
            } else if let error = model.error {
                FriendlyError(error: error)
            } else {
                Loading()
            }
            Status(data: model.data?.status)
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
