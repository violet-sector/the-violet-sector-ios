// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TopLegions: View {
    @ObservedObject var model = Model<Data>(resource: "rankings_legions.php")

    var body: some View {
        let legions = model.data?.content.sorted(by: {$0.score > $1.score})
        return VStack() {
            Text(verbatim: "Top Legions")
                .bold()
                .accessibility(addTraits: .isHeader)
            if legions != nil {
                if !legions!.isEmpty {
                    List(legions!.indices, id: \.self) {(index) in
                        HStack() {
                            Text(verbatim: "\(index + 1)")
                                .frame(width: 32.0, alignment: .trailing)
                            GeometryReader() {(geometry) in
                                HStack(spacing: 0.0) {
                                    Text(verbatim: "\(legions![index].legion)")
                                        .frame(width: geometry.size.width * 0.5, alignment: .leading)
                                    Text(verbatim: "\(legions![index].score)")
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
            } else if model.error != nil {
                FriendlyError(error: model.error!)
            } else {
                Loading()
            }
            Status(data: model.data?.status)
        }
    }

    struct Data: Decodable {
        let content: [Content]
        let status: Status.Data

        private enum CodingKeys: String, CodingKey {
            case content = "rankings_legions"
            case status = "player"
        }

        struct Content: Decodable {
            let legion: Legions
            let score: UInt

            private enum CodingKeys: String, CodingKey {
                case legion
                case score
            }
        }
    }
}
