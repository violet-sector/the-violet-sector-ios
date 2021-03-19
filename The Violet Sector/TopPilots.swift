// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TopPilots: View {
    @ObservedObject var model: Model<Data>
    @State private var searchInput = ""
    @State private var search = ""
    @State private var selection: Target.Identifier?

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
            let indices = data.content.indices.filter({search.isEmpty || data.content[$0].name ~= search})
            if !indices.isEmpty {
                GeometryReader() {(geometry) in
                    ScrollView() {
                        LazyVStack() {
                            ForEach(indices, id: \.self) {(index) in
                                Button(action: {selection = data.content[index].id}) {
                                    HStack(spacing: 5.0) {
                                        Text(verbatim: String(index + 1))
                                            .frame(width: 20.0, alignment: .trailing)
                                        (Text(verbatim: "\(data.content[index].name)\(data.content[index].isOnline ? "*" : "") [") + Text(verbatim: String(data.content[index].legion.description.first!)).bold().foregroundColor(Color("Legions/\(data.content[index].legion)")) + Text(verbatim: "]"))
                                            .frame(width: (geometry.size.width - 35.0) * 0.5, alignment: .leading)
                                        Text(health: data.content[index].currentHealth, maxHealth: data.content[index].maxHealth, asPercentage: true)
                                            .frame(width: (geometry.size.width - 35.0) * 0.2, alignment: .trailing)
                                        Text(verbatim: "\(data.content[index].score >= 10000 ? "\(data.content[index].score / 1000)k" : "\(data.content[index].score)") (\(data.content[index].level))")
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
                if selection != nil {
                    NavigationLink(destination: TargetDescription(targets: data.content, selection: selection!, showRank: true, refresh: {model.refresh()}), tag: selection!, selection: $selection, label: {EmptyView()})
                        .hidden()
                        .onChange(of: model.data?.content, perform: {if let targets = $0, !targets.contains(where: {$0.id == selection!}) {selection = nil}})
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
