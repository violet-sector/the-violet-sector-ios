// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TargetsView: View {
    @ObservedObject var model: TargetsModel

    var body: some View {
        VStack() {
            if model is TargetsModel.Incoming {
                Text(verbatim: "Incoming")
                    .bold()
                    .accessibility(addTraits: .isHeader)
            } else if model is TargetsModel.Outgoing {
                Text(verbatim: "Outgoing")
                    .bold()
                    .accessibility(addTraits: .isHeader)
            }
            if model.targets != nil {
                if !model.targets!.isEmpty {
                    List(model.targets!, id: \.name) {(target) in
                        NavigationLink(destination: TargetView(rank: 0, data: target)) {
                            GeometryReader() {(geometry) in
                                HStack(spacing: 0.0) {
                                    (Text(verbatim: "\(target.name)\(target.isOnline ? "*" : "") [") + Text(verbatim: "\(target.legion.description.first!)").bold().foregroundColor(Color(.sRGB, red: target.legion.color.red, green: target.legion.color.green, blue: target.legion.color.blue, opacity: 1.0)) + Text(verbatim: "]"))
                                        .frame(width: geometry.size.width * 0.5, alignment: .leading)
                                    HealthView(current: target.currentHealth, max: target.maxHealth)
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
                ErrorView(error: model.error!)
            } else {
                LoadingView()
            }
        }
        .onAppear(perform: {Client.shared.refreshable = self.model})
    }
}
