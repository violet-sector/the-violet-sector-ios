// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Targets: View {
    let title: String
    @ObservedObject var model: Model<Targets.Data>

    var body: some View {
        Page(title: title, model: model) {(data) in
            if !data.content.isEmpty {
                List(data.content.sorted(by: {$0.score > $1.score})) {(target) in
                    NavigationLink(destination: TargetDescription(rank: 0, data: target, refresh: {model.refresh()})) {
                        GeometryReader() {(geometry) in
                            HStack(spacing: 0.0) {
                                (Text(verbatim: "\(target.name)\(target.isOnline ? "*" : "") [") + Text(verbatim: "\(target.legion.description.first!)").bold().foregroundColor(Color("Legions/\(target.legion)")) + Text(verbatim: "]"))
                                    .frame(width: geometry.size.width * 0.5, alignment: .leading)
                                Text(health: target.currentHealth, maxHealth: target.maxHealth, asPercentage: true)
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
        }
    }

    struct Data: Decodable {
        let content: [Target]

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if container.contains(.friendlies) {
                content = try container.decode([Target].self, forKey: .friendlies)
            } else if container.contains(.incoming) {
                content = try container.decode([Target].self, forKey: .incoming)
            } else if container.contains(.outgoing) {
                content = try container.decode([Target].self, forKey: .outgoing)
            } else {
                content = []
            }
        }

        private enum CodingKeys: String, CodingKey {
            case friendlies = "scans_friendlies"
            case incoming = "scans_incoming"
            case outgoing = "scans_outgoing"
        }
    }
}
