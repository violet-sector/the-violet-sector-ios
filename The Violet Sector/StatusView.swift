//
//  StatusView.swift
//  The Violet Sector
//
//  Created by João Santos on 20/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import SwiftUI

struct StatusView: View {
    var status: Status

    var body: some View {
        var sector = "Sector: "
        if status.destinationSector == .none {
            sector += "\(status.currentSector)"
        } else {
            sector += "hypering to \(status.destinationSector)"
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
        return VStack(alignment: .leading) {
            HStack() {
                Text(verbatim: "Moves: \(status.moves)")
                    .frame(idealWidth: .infinity, alignment: .leading)
                HealthView(current: status.currentHealth, max: status.maxHealth, showLabel: true)
                    .frame(idealWidth: .infinity, alignment: .leading)
            }
            Text(verbatim: sector)
                .frame(idealWidth: .infinity, alignment: .leading)
        }
    }
}
