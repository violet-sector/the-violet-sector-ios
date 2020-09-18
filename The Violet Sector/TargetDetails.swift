// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TargetDetails: View {
    var rank: Int
    var data: Target

    var body: some View {
        VStack() {
            GeometryReader() {(geometry) in
                VStack() {
                    Image("\(self.data.ship)")
                    Text(verbatim: "\(self.data.ship)\(self.data.isCloaked ?? false ? " (Cloaked)" : "")")
                    if self.rank > 0 {
                        HStack(spacing: 20.0) {
                            Text(verbatim: "Rank")
                                .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .trailing)
                            Text(verbatim: "\(self.rank)")
                                .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .leading)
                        }
                        .accessibilityElement(children: .combine)
                    }
                    HStack(spacing: 20.0) {
                        Text(verbatim: "Legion")
                            .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .trailing)
                        Text(verbatim: "\(self.data.legion)")
                            .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .leading)
                    }
                    .accessibilityElement(children: .combine)
                    HStack(spacing: 20.0) {
                        Text(verbatim: "Hitpoints")
                            .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .trailing)
                        Health(current: self.data.currentHealth, max: self.data.maxHealth)
                            .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .leading)
                    }
                    .accessibilityElement(children: .combine)
                    HStack(spacing: 20.0) {
                        Text(verbatim: "Score")
                            .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .trailing)
                        Text(verbatim: "\(self.data.score)")
                            .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .leading)
                    }
                    .accessibilityElement(children: .combine)
                    HStack(spacing: 20.0) {
                        Text(verbatim: "Level")
                            .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .trailing)
                        Text(verbatim: "\(self.data.level)")
                            .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .leading)
                    }
                    .accessibilityElement(children: .combine)
                    if self.data.kills != nil {
                        HStack(spacing: 20.0) {
                            Text(verbatim: "Kills")
                                .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .trailing)
                            Text(verbatim: "\(self.data.kills!)")
                                .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .leading)
                        }
                        .accessibilityElement(children: .combine)
                    }
                    if self.data.deaths != nil {
                        HStack(spacing: 20.0) {
                            Text(verbatim: "Deaths")
                                .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .trailing)
                            Text(verbatim: "\(self.data.deaths!)")
                                .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .leading)
                        }
                        .accessibilityElement(children: .combine)
                    }
                    Spacer()
                }
            }
            Status()
        }
        .navigationBarTitle("\(data.name)\(data.isOnline ? "*" : "")", displayMode: .inline)
    }
}
