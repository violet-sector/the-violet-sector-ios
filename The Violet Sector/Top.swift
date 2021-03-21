// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Top: View {
    @ObservedObject private var client = Client.shared

    var body: some View {
        VStack(spacing: 10.0) {
            HStack(spacing: 5.0) {
                Button("Pilots", action: {client.tab = .topPilots})
                    .frame(width: 60.0)
                Button("Deaths", action: {client.tab = .topDeaths})
                    .frame(width: 60.0)
                Button("Legions", action: {client.tab = .topLegions})
            }
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
