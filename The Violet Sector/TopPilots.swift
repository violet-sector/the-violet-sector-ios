// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TopPilots: View {
    @StateObject private var model = Model(resource: "rankings_pilots.php", responseType: Response.self)
    @State private var searchInput = ""
    @State private var search = ""
    @State private var selection: Target.Identifier?

    var body: some View {
        Page(model: model) {(response) in
            HStack {
                TextField("Search", text: $searchInput, onCommit: {search = searchInput})
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .frame(width: 200.0)
                Button(action: {search = ""; searchInput = ""}, label: {Image(systemName: "xmark.circle")})
                    .accessibilityLabel("Clear")
            }
            let indices = response.content.indices.filter({search.isEmpty || response.content[$0].name ~= search})
            if !indices.isEmpty {
                GeometryReader() {(geometry) in
                    ScrollView() {
                        LazyVStack() {
                            ForEach(indices, id: \.self) {(index) in
                                Button(action: {selection = response.content[index].id}) {
                                    HStack(spacing: 5.0) {
                                        Text(verbatim: String(index + 1))
                                            .frame(width: 20.0, alignment: .trailing)
                                        let name = Text(verbatim: response.content[index].name) +
                                            Text(verbatim: response.content[index].isOnline ? "*" : "").foregroundColor(Color("Colors/Online")) +
                                            Text(verbatim: " [") +
                                            Text(verbatim: "\(response.content[index].legion.description.first!)").bold().foregroundColor(Color("Colors/\(response.content[index].legion)")) +
                                            Text(verbatim: "]")
                                        name.frame(width: (geometry.size.width - 35.0) * 0.5, alignment: .leading)
                                        Text(health: response.content[index].currentHealth, maxHealth: response.content[index].maxHealth, asPercentage: true)
                                            .frame(width: (geometry.size.width - 35.0) * 0.2, alignment: .trailing)
                                        Text(verbatim: "\(response.content[index].score >= 10000 ? "\(response.content[index].score / 1000)k" : "\(response.content[index].score)") (\(response.content[index].level))")
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
                    NavigationLink(destination: TargetDescription(targets: response.content, selection: selection!, showRank: true), tag: selection!, selection: $selection, label: {EmptyView()})
                        .hidden()
                        .onChange(of: response.content, perform: {if !$0.contains(where: {$0.id == selection!}) {selection = nil}})
                }
            } else {
                Spacer()
                Text(verbatim: "Nothing to show.")
                Spacer()
            }
        }
    }

    private struct Response: Decodable {
        let content: [Target]

        private enum CodingKeys: String, CodingKey {
            case content = "rankings_pilots"
        }
    }
}
