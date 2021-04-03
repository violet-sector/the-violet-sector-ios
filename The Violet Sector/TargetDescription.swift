// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TargetDescription: View {
    private let rank: Int?
    private let data: Target
    @StateObject private var enterAction = Action(resource: "carrier_enter.php", responseType: EnterResponse.self)

    var body: some View {
        VStack() {
            if data.ship != .dock {
                if data.ship != .planet {
                    Image("Ships/\(data.ship)")
                        .accessibilityLabel(data.ship.description)
                    Text(verbatim: "\(data.ship): \(data.ship.type)" + (data.isCloaked ?? false ? " (Cloaked)" : ""))
                        .font(.caption)
                } else {
                    Image("Sectors/Images/\(data.legion.base.description)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 125.0, height: 125.0)
                        .accessibilityLabel(data.ship.description)
                    Text(verbatim: data.ship.description)
                        .font(.caption)
                }
            }
            HStack() {
                if case let .intValue(id) = data.id, let canDock = data.canDock, canDock {
                    Button("Enter", action: {enterAction.perform(query: ["carrier": String(id)], completionHandler: {Client.shared.activeModel.refresh()})})
                        .disabled(enterAction.isLoading)
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
        .alert(item: $enterAction.alert, content: {Alert(title: Text(verbatim: "Error Performing Enter Action"), message: Text(verbatim: $0))})
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

    private struct EnterResponse: Decodable {
        let success: Bool
    }
}
