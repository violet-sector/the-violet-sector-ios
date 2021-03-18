// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TopPilots: View {
    @ObservedObject var model: Model<Data>
    @State private var searchInput = ""
    @State private var search = ""

    var body: some View {
        Page(title: "Top Pilots", model: model) {(data) in
            HStack {
                TextField("Search", text: $searchInput, onCommit: {search = searchInput})
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .frame(width: 200.0)
                Button(action: {search = ""; searchInput = ""}, label: {Image(systemName: "xmark.circle")})
                    .accessibilityLabel("Clear")
            }
            let enumeratedPilots = data.content.enumerated().filter({search.isEmpty || $0.element.name ~= search})
            if !enumeratedPilots.isEmpty {
                GeometryReader() {(geometry) in
                    ScrollView() {
                        VStack() {
                            ForEach(enumeratedPilots, id: \.element.name) {(enumeratedPilot) in
                                NavigationLink(destination: TargetDescription(rank: enumeratedPilot.offset + 1, data: enumeratedPilot.element, refresh: nil)) {
                                    HStack(spacing: 5.0) {
                                        Text(verbatim: "\(enumeratedPilot.offset + 1)")
                                            .frame(width: 20.0, alignment: .trailing)
                                        (Text(verbatim: "\(enumeratedPilot.element.name)\(enumeratedPilot.element.isOnline ? "*" : "") [") + Text(verbatim: "\(enumeratedPilot.element.legion.description.first!)").bold().foregroundColor(Color("Legions/\(enumeratedPilot.element.legion)")) + Text(verbatim: "]"))
                                            .frame(width: (geometry.size.width - 35.0) * 0.5, alignment: .leading)
                                        Text(health: enumeratedPilot.element.currentHealth, maxHealth: enumeratedPilot.element.maxHealth, asPercentage: true)
                                            .frame(width: (geometry.size.width - 35.0) * 0.2, alignment: .trailing)
                                        Text(verbatim: "\(enumeratedPilot.element.score >= 10000 ? "\(enumeratedPilot.element.score / 1000)k" : "\(enumeratedPilot.element.score)") (\(enumeratedPilot.element.level))")
                                            .frame(width: (geometry.size.width - 35.0) * 0.3, alignment: .trailing)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .frame(height: 40.0)
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

    struct Data: Decodable {
        let content: [Target]

        private enum CodingKeys: String, CodingKey {
            case content = "rankings_pilots"
        }
    }
}
