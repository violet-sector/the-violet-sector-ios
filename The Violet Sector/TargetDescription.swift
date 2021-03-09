// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TargetDescription: View {
    var rank: Int
    var data: Target

    var body: some View {
        VStack() {
            if data.ship != .planet {
                Image(decorative: "Ships/\(data.ship)")
            }
            Text(verbatim: "\(data.ship)\(data.isCloaked ?? false ? " (Cloaked)" : "")")
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
            Status()
        }
        .navigationBarTitle("\(data.name)\(data.isOnline ? "*" : "")")
        .navigationBarTitleDisplayMode(.inline)
    }
}
