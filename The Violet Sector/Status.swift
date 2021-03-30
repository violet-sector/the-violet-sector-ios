// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Status: View {
    @ObservedObject private var client = Client.shared

    var body: some View {
        if let data = client.statusResponse {
            VStack() {
                Text(verbatim: data.moves >= 0 ? "\(data.moves) move\(data.moves != 1 ? "s" : "") " : "Paused ") +
                    Text(health: data.currentHealth, maxHealth: data.maxHealth, asPercentage: false) +
                    Text(verbatim: (data.isCloaked ? " (C)" : "") + (data.isInvulnerable ? " (I)" : "") + (data.isSleeping ? " (Z)" : "") + (data.carrier.name != nil ? " (D)" : ""))
                Text(verbatim: data.destinationSector == .none ? data.currentSector.description : "Hypering to " + data.destinationSector.description)
            }
            .font(.footnote)
            .accessibilityElement(children: .combine)
        }
    }
}
