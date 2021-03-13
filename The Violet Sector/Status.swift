// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Status: View {
    @ObservedObject private var client = Client.shared
    
    var body: some View {
        VStack() {
            if let data = client.statusResponse {
                HStack() {
                    if data.moves >= 0 {
                        Text(verbatim: "\(data.moves) \(data.moves != 1 ? "Moves" : "Move")")
                    } else {
                        Text(verbatim: "Paused")
                    }
                    Text(health: data.currentHealth, maxHealth: data.maxHealth, asPercentage: true)
                    Text(verbatim: (data.destinationSector == .none ? "\(data.currentSector)" : "Hypering to \(data.destinationSector)") + (data.isSleeping ? " (zZzZ)" : "") + (data.isCloaked ? " (Cloaked)" : "") + (data.isInvulnerable ? " (Invulnerable)" : ""))
                }
                .accessibilityElement(children: .combine)
            }
            Timer()
        }
    }
}
