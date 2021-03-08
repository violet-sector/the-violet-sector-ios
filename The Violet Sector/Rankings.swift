// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Rankings: View {
    @StateObject private var topPilotsModel = Model<TopPilots.Data>(resource: "rankings_pilots.php")
    @StateObject private var topDeathsModel = Model<TopDeaths.Data>(resource: "rankings_att.php")
    @StateObject private var topLegionsModel = Model<TopLegions.Data>(resource: "rankings_legions.php")
    @State private var tab = Tabs.topPilots

    var body: some View {
        NavigationView() {
            VStack(spacing: 10.0) {
                HStack() {
                    Button("Top Pilots", action: {self.tab = .topPilots})
                    Button("Top Deaths", action: {self.tab = .topDeaths})
                    Button("Top Legions", action: {self.tab = .topLegions})
                }
                switch tab {
                case .topPilots:
                    TopPilots(model: topPilotsModel)
                case .topDeaths:
                    TopDeaths(model: topDeathsModel)
                case .topLegions:
                    TopLegions(model: topLegionsModel)
                }
            }
            .navigationBarTitle("Rankings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {Refresh()})
        }
    }

    private enum Tabs {
        case topPilots
        case topDeaths
        case topLegions
    }
}
