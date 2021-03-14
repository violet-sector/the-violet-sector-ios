// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TargetDescription: View {
    let rank: Int
    let data: Target
    let refresh: (() -> Void)?
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack() {
            if data.ship != .planet {
                Image("Ships/\(data.ship)")
                    .accessibilityLabel(data.ship.description)
            }
            Text(verbatim: "\(data.ship): \(data.ship.type)" + (data.isCloaked ?? false ? " (Cloaked)" : ""))
            HStack() {
                if let dock = data.dock, let refresh = refresh, dock > 0 {
                    Button("Dock", action: {Client.shared.post("carrier_enter.php", query: ["carrier": String(dock)], completionHandler: {presentationMode.wrappedValue.dismiss(); refresh()})})
                        .frame(width: 80.0)
                }
            }
            Description() {
                if rank > 0 {
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
