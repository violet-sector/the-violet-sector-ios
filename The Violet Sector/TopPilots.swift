// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TopPilots: View {
    @ObservedObject private var model = Model<Data>(resource: "rankings_pilots.php")
    @State private var search = ""

    var body: some View {
        VStack(spacing: 10.0) {
            Title("Top Pilots")
            if let content = model.data?.content {
                HStack {
                    TextField("Search", text: $search)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .frame(width: 200.0)
                    Button(action: {self.search = ""}, label: {Image(systemName: "xmark.circle")})
                        .accessibilityLabel("Clear")
                }
                let enumeratedPilots = content.sorted(by: {$0.score > $1.score}).enumerated().filter({search.isEmpty || $0.element.name ~= search})
                if !enumeratedPilots.isEmpty {
                    List(enumeratedPilots, id: \.element.name) {(enumeratedPilot) in
                        NavigationLink(destination: TargetDetails(rank: enumeratedPilot.offset + 1, data: enumeratedPilot.element)) {
                            HStack() {
                                Text(verbatim: "\(enumeratedPilot.offset + 1)")
                                    .frame(width: 32.0, alignment: .trailing)
                                GeometryReader() {(geometry) in
                                    HStack(spacing: 0.0) {
                                        (Text(verbatim: "\(enumeratedPilot.element.name)\(enumeratedPilot.element.isOnline ? "*" : "") [") + Text(verbatim: "\(enumeratedPilot.element.legion.description.first!)").bold().foregroundColor(Color("Legions/\(enumeratedPilot.element.legion)")) + Text(verbatim: "]"))
                                            .frame(width: geometry.size.width * 0.5, alignment: .leading)
                                        Health(current: enumeratedPilot.element.currentHealth, max: enumeratedPilot.element.maxHealth)
                                            .percentage()
                                            .frame(width: geometry.size.width * 0.2, alignment: .trailing)
                                        Text(verbatim: "\(enumeratedPilot.element.score >= 10000 ? "\(enumeratedPilot.element.score / 1000)k" : "\(enumeratedPilot.element.score)") (\(enumeratedPilot.element.level)")
                                            .frame(width: geometry.size.width * 0.3, alignment: .trailing)
                                    }
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
        let content: [Target]
        let status: Status.Data

        private enum CodingKeys: String, CodingKey {
            case content = "rankings_pilots"
            case status = "player"
        }
    }
}
