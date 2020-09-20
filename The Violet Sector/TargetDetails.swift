// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TargetDetails: View {
    var rank: Int
    var data: Target

    var body: some View {
        VStack() {
            GeometryReader() {(geometry) in
                VStack() {
                    Image("\(data.ship)")
                    Text(verbatim: "\(data.ship)\(data.isCloaked ?? false ? " (Cloaked)" : "")")
                    if rank > 0 {
                        HStack(spacing: 20.0) {
                            Text(verbatim: "Rank")
                                .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .trailing)
                            Text(verbatim: "\(rank)")
                                .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .leading)
                        }
                        .accessibilityElement(children: .combine)
                    }
                    HStack(spacing: 20.0) {
                        Text(verbatim: "Legion")
                            .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .trailing)
                        Text(verbatim: "\(data.legion)")
                            .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .leading)
                    }
                    .accessibilityElement(children: .combine)
                    HStack(spacing: 20.0) {
                        Text(verbatim: "Hitpoints")
                            .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .trailing)
                        Health(current: data.currentHealth, max: data.maxHealth)
                            .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .leading)
                    }
                    .accessibilityElement(children: .combine)
                    HStack(spacing: 20.0) {
                        Text(verbatim: "Score")
                            .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .trailing)
                        Text(verbatim: "\(data.score)")
                            .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .leading)
                    }
                    .accessibilityElement(children: .combine)
                    HStack(spacing: 20.0) {
                        Text(verbatim: "Level")
                            .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .trailing)
                        Text(verbatim: "\(data.level)")
                            .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .leading)
                    }
                    .accessibilityElement(children: .combine)
                    if let kills = data.kills {
                        HStack(spacing: 20.0) {
                            Text(verbatim: "Kills")
                                .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .trailing)
                            Text(verbatim: "\(kills)")
                                .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .leading)
                        }
                        .accessibilityElement(children: .combine)
                    }
                    if let deaths = data.deaths {
                        HStack(spacing: 20.0) {
                            Text(verbatim: "Deaths")
                                .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .trailing)
                            Text(verbatim: "\(deaths)")
                                .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .leading)
                        }
                        .accessibilityElement(children: .combine)
                    }
                    Spacer()
                }
            }
            Status()
        }
        .navigationBarTitle("\(data.name)\(data.isOnline ? "*" : "")")
        .navigationBarTitleDisplayMode(.inline)
    }
}
