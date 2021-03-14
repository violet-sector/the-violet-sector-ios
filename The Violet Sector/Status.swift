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
                    Text(verbatim: makeSectorString())
                }
                .accessibilityElement(children: .combine)
            }
            Timer()
        }
    }

    private func makeSectorString() -> String {
        guard let data = client.statusResponse else {
            return ""
        }
        var sector = data.destinationSector == .none ? data.currentSector.description : "Hypering to " + data.destinationSector.description
        if data.isSleeping {
            sector += " (zZzZ)"
        }
        if data.isInvulnerable {
            sector += " (Invulnerable)"
        }
        if data.isCloaked {
            sector += " (Cloaked)"
        }
        if let name = data.carrier.name, let isOnline = data.carrier.isOnline {
            sector += " (inside \(name + (isOnline ? "*" : "")))"
        }
        return sector
    }
}
