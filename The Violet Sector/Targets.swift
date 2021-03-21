// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Targets: View {
    let data: [Target]
    @State private var selection: Target.Identifier?

    var body: some View {
        if !data.isEmpty {
            GeometryReader() {(geometry) in
                ScrollView() {
                    LazyVStack() {
                        ForEach(data) {(target) in
                            Button(action: {selection = target.id}) {
                                HStack(spacing: 5.0) {
                                    (Text(verbatim: "\(target.name)\(target.isOnline ? "*" : "") [") + Text(verbatim: "\(target.legion.description.first!)").bold().foregroundColor(Color("Legions/\(target.legion)")) + Text(verbatim: "]"))
                                        .frame(width: (geometry.size.width - 15.0) * 0.5, alignment: .leading)
                                    Text(health: target.currentHealth, maxHealth: target.maxHealth, asPercentage: true)
                                        .frame(width: (geometry.size.width - 15.0) * 0.2, alignment: .trailing)
                                    Text(verbatim: "\(target.score >= 10000 ? "\(target.score / 1000)k" : "\(target.score)") (\(target.level))")
                                        .frame(width: (geometry.size.width - 15.0) * 0.3, alignment: .trailing)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(height: 32.0)
                            .accessibilityElement(children: .combine)
                        }
                    }
                }
            }
            if selection != nil {
                NavigationLink(destination: TargetDescription(targets: data, selection: selection!, showRank: false), tag: selection!, selection: $selection, label: {EmptyView()})
                    .hidden()
                    .onChange(of: data, perform: {if !$0.contains(where: {$0.id == selection!}) {selection = nil}})
            }
        } else {
            Spacer()
            Text(verbatim: "Nothing to show.")
            Spacer()
        }
    }
}
