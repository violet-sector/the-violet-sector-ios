//
//  StatusView.swift
//  The Violet Sector
//
//  Created by João Santos on 20/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import SwiftUI

struct StatusView: View {
    var status: Status?

    var body: some View {
        var moves = "-"
        var healthView = HealthView(current: 0, max: 0)
        var sector = "Void"
        if let status = status {
            moves = "\(status.moves)"
            healthView = HealthView(current: status.currentHealth, max: status.maxHealth)
            if status.currentSector != .none {
                sector = "\(status.currentSector)"
            } else if status.destinationSector != .none {
                sector = "hypering to \(status.destinationSector)"
            } else {
                sector = "Void"
            }
            if status.isSleeping {
                sector += " (zZzZ)"
            }
            if status.isCloaked {
                sector += " (Cloaked)"
            }
            if status.isInvulnerable {
                sector += " (Invulnerable)"
            }
        }
        return VStack() {
            HStack() {
                Text("Moves: \(moves)")
                    .frame(alignment: .leading)
                HStack(spacing: 0.0) {
                    Text("Hitpoints: ")
                    healthView
                }
                .frame(alignment: .leading)
                .accessibilityElement(children: .combine)
                .accessibility(label: Text("Hitpoints: " + (status != nil ? "\(status!.currentHealth)/\(status!.maxHealth)" : "Unknown")))
            }
            Text("Sector: \(sector)")
                .frame(alignment: .leading)
        }
    }
}
