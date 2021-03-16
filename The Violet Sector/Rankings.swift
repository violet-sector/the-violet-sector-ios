// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Rankings: View {
    @Binding var tabIndex: Int
    let thisTabIndex: Int
    @StateObject private var topPilotsModel = Model<TopPilots.Data>(resource: "rankings_pilots.php")
    @StateObject private var topDeathsModel = Model<TopDeaths.Data>(resource: "rankings_att.php")
    @StateObject private var topLegionsModel = Model<TopLegions.Data>(resource: "rankings_legions.php")
    @State private var tab = Tabs.topPilots

    var body: some View {
        NavigationView() {
            VStack(spacing: 10.0) {
                HStack() {
                    Button("Top Pilots", action: {self.tab = .topPilots; refreshModel()})
                    Button("Top Deaths", action: {self.tab = .topDeaths; refreshModel()})
                    Button("Top Legions", action: {self.tab = .topLegions; refreshModel()})
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
            .navigationTitle("Rankings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {Refresh(action: {refreshModel()})})
            .onChange(of: tabIndex, perform: {if $0 == thisTabIndex {refreshModel()}})
        }
    }

    private func refreshModel() {
        switch tab {
        case .topPilots:
            topPilotsModel.refresh()
        case .topDeaths:
            topDeathsModel.refresh()
        case .topLegions:
            topLegionsModel.refresh()
        }
    }

    private enum Tabs {
        case topPilots
        case topDeaths
        case topLegions
    }
}
