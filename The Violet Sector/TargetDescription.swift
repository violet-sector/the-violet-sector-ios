// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TargetDescription: View {
    private let rank: Int?
    private let data: Target
    private let refresh: () -> Void

    var body: some View {
        VStack() {
            if data.ship != .planet {
                Image("Ships/\(data.ship)")
                    .accessibilityLabel(data.ship.description)
            }
            Text(verbatim: "\(data.ship): \(data.ship.type)" + (data.isCloaked ?? false ? " (Cloaked)" : ""))
            HStack() {
                if case let .intValue(id) = data.id, let canDock = data.canDock, canDock {
                    Button("Dock", action: {Client.shared.post("carrier_enter.php", query: ["carrier": String(id)], completionHandler: refresh)})
                        .frame(width: 80.0)
                }
            }
            Description() {
                if let rank = rank {
                    DescriptionItem(name: "Rank") {Text(verbatim: String(rank))}
                }
                DescriptionItem(name: "Legion") {Text(verbatim: data.legion.description)}
                DescriptionItem(name: "Hitpoints") {Text(health: data.currentHealth, maxHealth: data.maxHealth, asPercentage: false)}
                DescriptionItem(name: "Score") {Text(verbatim: String(data.score))}
                DescriptionItem(name: "Level") {Text(verbatim: String(data.level))}
                if let kills = data.kills {
                    DescriptionItem(name: "Kills") {Text(verbatim: String(kills))}
                }
                if let deaths = data.deaths {
                    DescriptionItem(name: "Deaths") {Text(verbatim: String(deaths))}
                }
            }
            Spacer()
        }
        .navigationTitle("\(data.name)\(data.isOnline ? "*" : "")")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {Refresh(action: refresh)})
    }

    init?(targets: [Target], selection: Target.Identifier, showRank: Bool, refresh: @escaping () -> Void) {
        guard let index = targets.firstIndex(where: {$0.id == selection}) else {
            return nil
        }
        data = targets[index]
        if showRank {
            rank = index + 1
        } else {
            rank = nil
        }
        self.refresh = refresh
    }
}
