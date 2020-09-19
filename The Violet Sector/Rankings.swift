// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Rankings: View {
    @State private var tab = Tabs.topPilots

    var body: some View {
        NavigationView() {
            VStack() {
                HStack() {
                    Button("Top Pilots", action: {self.tab = .topPilots})
                    Button("Top Deaths", action: {self.tab = .topDeaths})
                    Button("Top Legions", action: {self.tab = .topLegions})
                }
                switch tab {
                case .topPilots:
                    TopPilots()
                case .topDeaths:
                    TopDeaths()
                case .topLegions:
                    TopLegions()
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
