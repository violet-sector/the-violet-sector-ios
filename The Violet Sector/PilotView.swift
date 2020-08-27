//
//  PilotView.swift
//  The Violet Sector
//
//  Created by João Santos on 20/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import SwiftUI

struct PilotView: View {
    let rank: Int
    let data: Pilot
    private let legionColor: (red: Double, green: Double, blue: Double)

    var body: some View {
        NavigationLink(destination: Detail(rank: rank, data: data)) {
            HStack(spacing: 0.0) {
                if rank > 0 {
                    Text(verbatim: "\(rank)")
                        .frame(width: 32.0)
                }
                GeometryReader() {(geometry) in
                    HStack(spacing: 0.0) {
                        (Text(verbatim: "\(self.data.name)\(self.data.isOnline ? "*" : "") [") + Text(verbatim: "\(self.data.legion.description.first!)").bold().foregroundColor(Color(.sRGB, red: self.legionColor.red, green: self.legionColor.green, blue: self.legionColor.blue, opacity: 1.0)) + Text(verbatim: "]"))
                            .frame(width: geometry.size.width * 0.5, alignment: .leading)
                        HealthView(current: self.data.currentHealth, max: self.data.maxHealth)
                            .percentage()
                            .frame(width: geometry.size.width * 0.2, alignment: .trailing)
                        Text(verbatim: "\(self.data.score > 10000 ? "\(self.data.score / 1000)k" : "\(self.data.score)") (\(self.data.level)")
                            .frame(width: geometry.size.width * 0.3, alignment: .trailing)
                    }
                }
            }
        }
        .accessibilityElement(children: .combine)
    }

    init(rank: Int = 0, data: Pilot) {
        self.rank = rank
        self.data = data
        legionColor = data.legion.color
    }

    private struct Detail: View {
        var rank: Int
        var data: Pilot

        var body: some View {
            NavigationView() {
                GeometryReader() {(geometry) in
                    VStack() {
                        Text(verbatim: "\(self.data.ship)")
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
                            HealthView(current: self.data.currentHealth, max: self.data.maxHealth)
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
                        HStack(spacing: 20.0) {
                            Text(verbatim: "Kills")
                                .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .trailing)
                            Text(verbatim: "\(self.data.kills)")
                                .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .leading)
                        }
                        .accessibilityElement(children: .combine)
                        HStack(spacing: 20.0) {
                            Text(verbatim: "Deaths")
                                .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .trailing)
                            Text(verbatim: "\(self.data.deaths)")
                                .frame(width: geometry.size.width * 0.5 - 10.0, alignment: .leading)
                        }
                        .accessibilityElement(children: .combine)
                    }
                }
                .navigationBarTitle("\(data.name)\(data.isOnline ? "*" : "")", displayMode: .inline)
            }
        }
    }
}
