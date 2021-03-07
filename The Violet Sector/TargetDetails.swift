// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TargetDetails: View {
    var rank: Int
    var data: Target

    var body: some View {
        VStack() {
            GeometryReader() {(geometry) in
                VStack() {
                    if data.ship != .planet {
                        Image(decorative: "Ships/\(data.ship)")
                    }
                    Text(verbatim: "\(data.ship)\(data.isCloaked ?? false ? " (Cloaked)" : "")")
                    let details: [(name: String, value: Text?)] = [
                        (name: "Rank", value: rank > 0 ? Text(verbatim: String(rank)) : nil),
                        (name: "Legion", value: Text(verbatim: data.legion.description)),
                        (name: "Hitpoints", value: Text(health: data.currentHealth, maxHealth: data.maxHealth, asPercentage: false)),
                        (name: "Score", value: Text(verbatim: String(data.score))),
                        (name: "Level", value: Text(verbatim: String(data.level))),
                        (name: "Kills", value: data.kills != nil ? Text(verbatim: String(data.kills!)) : nil),
                        (name: "Deaths", value: data.deaths != nil ? Text(verbatim: String(data.deaths!)) : nil)
                    ]
                    GeometryReader() {(geometry) in
                        Details(details: details, geometry: geometry)
                    }
                }
            }
            Status()
        }
        .navigationBarTitle("\(data.name)\(data.isOnline ? "*" : "")")
        .navigationBarTitleDisplayMode(.inline)
    }
}
