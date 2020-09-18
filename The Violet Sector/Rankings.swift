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
                if tab == .topPilots {
                    TopPilots()
                } else if tab == .topDeaths {
                    TopDeaths()
                } else if tab == .topLegions {
                    TopLegions()
                }
            }
            .navigationBarTitle("Rankings", displayMode: .inline)
            .navigationBarItems(trailing: Refresh())
        }
    }

    private enum Tabs {
        case topPilots
        case topDeaths
        case topLegions
    }
}
