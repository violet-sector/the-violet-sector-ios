// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Targets: View {
    let title: String
    @ObservedObject private var model: Model<Data>

    var body: some View {
        VStack() {
            Text(verbatim: title)
                .bold()
                .accessibility(addTraits: .isHeader)
            if model.data != nil {
                if !model.data!.content.isEmpty {
                    List(model.data!.content.sorted(by: {$0.score < $1.score}), id: \.name) {(target) in
                        NavigationLink(destination: TargetDetails(rank: 0, data: target)) {
                            GeometryReader() {(geometry) in
                                HStack(spacing: 0.0) {
                                    (Text(verbatim: "\(target.name)\(target.isOnline ? "*" : "") [") + Text(verbatim: "\(target.legion.description.first!)").bold().foregroundColor(Color("\(target.legion)")) + Text(verbatim: "]"))
                                        .frame(width: geometry.size.width * 0.5, alignment: .leading)
                                    Health(current: target.currentHealth, max: target.maxHealth)
                                        .percentage()
                                        .frame(width: geometry.size.width * 0.2, alignment: .trailing)
                                    Text(verbatim: "\(target.score >= 10000 ? "\(target.score / 1000)k" : "\(target.score)") (\(target.level)")
                                        .frame(width: geometry.size.width * 0.3, alignment: .trailing)
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

    init(resource: String, title: String) {
        self.title = title
        model = Model<Data>(resource: resource)
    }

    private struct Data: Decodable {
        let content: [Target]
        let status: Status.Data

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if container.contains(.incoming) {
                content = try container.decode([Target].self, forKey: .incoming)
            } else if container.contains(.outgoing) {
                content = try container.decode([Target].self, forKey: .outgoing)
            } else {
                content = []
            }
            status = try container.decode(Status.Data.self, forKey: .status)
        }

        private enum CodingKeys: String, CodingKey {
            case incoming = "scans_incoming"
            case outgoing = "scans_outgoing"
            case status = "player"
        }
    }
}