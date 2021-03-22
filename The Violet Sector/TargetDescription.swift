// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TargetDescription: View {
    private let rank: Int?
    private let data: Target

    var body: some View {
        VStack() {
            if data.ship != .planet {
                Image("Ships/\(data.ship)")
                    .accessibilityLabel(data.ship.description)
            }
            Text(verbatim: "\(data.ship): \(data.ship.type)" + (data.isCloaked ?? false ? " (Cloaked)" : ""))
                .font(.caption)
            HStack() {
                if case let .intValue(id) = data.id, let canDock = data.canDock, canDock {
                    Button("Dock", action: {Client.shared.post("carrier_enter.php", query: ["carrier": String(id)], completionHandler: {Client.shared.activeModel.refresh()})})
                        .frame(width: 80.0)
                }
            }
            GeometryReader() {(geometry) in
                LazyVGrid(columns: [GridItem(.fixed(geometry.size.width * 0.5), alignment: .trailing), GridItem(.fixed(geometry.size.width * 0.5), alignment: .leading)]) {
                    if let rank = rank {
                        Description(name: "Rank") {Text(verbatim: String(rank))}
                    }
                    Description(name: "Legion") {Text(verbatim: data.legion.description)}
                    Description(name: "Hitpoints") {Text(health: data.currentHealth, maxHealth: data.maxHealth, asPercentage: false)}
                    Description(name: "Score") {Text(verbatim: String(data.score))}
                    Description(name: "Level") {Text(verbatim: String(data.level))}
                    if let kills = data.kills {
                        Description(name: "Kills") {Text(verbatim: String(kills))}
                    }
                    if let deaths = data.deaths {
                        Description(name: "Deaths") {Text(verbatim: String(deaths))}
                    }
                }
            }
            Spacer()
        }
        .navigationTitle("\(data.name)\(data.isOnline ? "*" : "")")
        .toolbar(content: {Refresh()})
    }

    init?(targets: [Target], selection: Target.Identifier, showRank: Bool) {
        guard let index = targets.firstIndex(where: {$0.id == selection}) else {
            return nil
        }
        data = targets[index]
        if showRank {
            rank = index + 1
        } else {
            rank = nil
        }
    }
}
