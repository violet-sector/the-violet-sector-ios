// Created by João Santos for project The Violet Sector.

import SwiftUI

struct RankingsView: View {
    @State private var tab = Tabs.topPilots

    var body: some View {
        NavigationView() {
            VStack() {
                HStack() {
                    Button("Top Pilots", action: {self.tab = .topPilots})
                    Button("Top Deaths", action: {self.tab = .topDeaths})
                    Button("Top Legions", action: {self.tab = .topLegions})
                }
                if tab == .topPilots {
                    TopPilotsView()
                } else if tab == .topDeaths {
                    TopDeathsView()
                } else if tab == .topLegions {
                    TopLegionsView()
                }
            }
                .navigationBarTitle("Rankings", displayMode: .inline)
            .navigationBarItems(trailing: RefreshButtonView())
        }
    }

    private enum Tabs {
        case topPilots
        case topDeaths
        case topLegions
    }
}
