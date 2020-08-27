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
            if model.data != nil {
            VStack() {
                    HStack() {
                        Text(verbatim: "\(model.data!.moves) \(model.data!.moves != 1 ? "Moves" : "Move")")
                        HealthView(current: model.data!.currentHealth, max: model.data!.maxHealth)
                        Text(verbatim: (model.data!.destinationSector == .none ? "\(model.data!.currentSector)" : "Hypering to \(model.data!.destinationSector)") + (model.data!.isSleeping ? " (zZzZ)" : "") + (model.data!.isCloaked ? " (Cloaked)" : "") + (model.data!.isInvulnerable ? " (Invulnerable)" : ""))
                    }
                    .accessibilityElement(children: .combine)
                TimerView()
                }
            }
        }
    }
}
