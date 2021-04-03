// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Status: View {
    @ObservedObject private var client = Client.shared

    var body: some View {
        if let status = client.statusResponse {
            VStack() {
                Text(verbatim: status.moves >= 0 ? "\(status.moves) move\(status.moves != 1 ? "s" : "") " : "Paused ") +
                    Text(health: status.currentHealth, maxHealth: status.maxHealth, asPercentage: true) +
                    Text(verbatim: (status.isCloaked ? " (C)" : "") + (status.isInvulnerable ? " (I)" : "") + (status.isSleeping ? " (Z)" : "") + (status.carrier.name != nil ? " (D)" : ""))
                Text(verbatim: status.destinationSector == .none ? status.currentSector.description : "Hypering to " + status.destinationSector.description)
            }
            .font(.footnote)
            .accessibilityElement(children: .combine)
        }
    }
}
