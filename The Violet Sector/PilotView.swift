//
//  PilotView.swift
//  The Violet Sector
//
//  Created by João Santos on 20/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import SwiftUI

struct PilotView: View {
    let pilot: Pilot

    var body: some View {
        GeometryReader() {(geometry) in
            VStack() {
                HStack() {
                    VStack(alignment: .leading) {
                        Text(verbatim: self.pilot.name + (self.pilot.isOnline ? "*" : ""))
                        HealthView(current: self.pilot.currentHealth, max: self.pilot.maxHealth)
                    }
                    .frame(width: geometry.size.width * 0.5)
                    VStack(alignment: .leading) {
                        Text(verbatim: "\(self.pilot.legion)")
                        Text(verbatim: "\(self.pilot.score) (\(self.pilot.level))")
                    }
                    .frame(width: geometry.size.width * 0.5)
                }
                Text(verbatim: "\(self.pilot.ship)")
                HStack() {
                    Text(verbatim: "\(self.pilot.kills)K")
                        .accessibility(label: Text(verbatim: "\(self.pilot.kills) Kills"))
                    Text(verbatim: "\(self.pilot.deaths)D")
                        .accessibility(label: Text(verbatim: "\(self.pilot.deaths) Deaths"))
                }
            }
        }
    }
}
