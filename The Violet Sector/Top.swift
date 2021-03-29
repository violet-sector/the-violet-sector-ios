// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Top: View {
    @ObservedObject private var client = Client.shared

    var body: some View {
        VStack(spacing: 10.0) {
            HStack(spacing: 5.0) {
                Button("Pilots", action: {client.tab = .topPilots})
                Button("Deaths", action: {client.tab = .topDeaths})
                Button("Legions", action: {client.tab = .topLegions})
            }
            .buttonStyle(SectionButton())
            if let tab = client.tab {
                switch tab {
                case .topPilots:
                    TopPilots()
                case .topDeaths:
                    TopDeaths()
                case .topLegions:
                    TopLegions()
                default:
                    EmptyView()
                }
            }
        }
    }
}
