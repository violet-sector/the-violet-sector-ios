// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Status: View {
    @ObservedObject private var client = Client.shared

    var body: some View {
        if let data = client.statusResponse {
            HStack() {
                if data.moves >= 0 {
                    Text(verbatim: "\(data.moves) \(data.moves != 1 ? "Moves" : "Move")")
                } else {
                    Text(verbatim: "Paused")
                }
                Text(health: data.currentHealth, maxHealth: data.maxHealth, asPercentage: true)
                makeSectorText()
            }
            .font(.footnote)
            .accessibilityElement(children: .combine)
        }
    }

    private func makeSectorText() -> Text {
        guard let data = client.statusResponse else {
            return Text(verbatim: "")
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
        var sectorText = Text(verbatim: sector)
        if let name = data.carrier.name, let isOnline = data.carrier.isOnline {
            sectorText = sectorText + Text(verbatim: " (inside \(name)")
            if isOnline {
                sectorText = sectorText + Text(verbatim: "*").foregroundColor(Color("Colors/Online"))
            }
            sectorText = sectorText + Text(verbatim: ")")
        }
        return sectorText
    }
}
