//
//  StatusView.swift
//  The Violet Sector
//
//  Created by João Santos on 20/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import SwiftUI

struct StatusView: View {
    @ObservedObject var model = StatusModel.shared

    var body: some View {
        Group {
            if model.isReady {
                VStack(alignment: .leading) {
                    HStack() {
                        Text(verbatim: "Moves: \(model.moves)")
                            .frame(idealWidth: .infinity, alignment: .leading)
                        HealthView(current: model.currentHealth, max: model.maxHealth, showLabel: true)
                            .frame(idealWidth: .infinity, alignment: .leading)
                    }
                    Text(verbatim: "Sector: " + (model.destinationSector == .none ? "\(model.currentSector)" : "hypering to \(model.destinationSector)") + (model.isSleeping ? " (zZzZ)" : "") + (model.isCloaked ? " (Cloaked)" : "") + (model.isInvulnerable ? " (Invulnerable)" : ""))
                        .frame(idealWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}
