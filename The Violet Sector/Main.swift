// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Main: View {
    @ObservedObject private var client = Client.shared

    var body: some View {
        VStack(spacing: 10.0) {
            HStack(spacing: 5.0) {
                Button("Dashboard", action: {client.tab = .dashboard})
                    .frame(width: 80.0)
                Button("Journal", action: {client.tab = .journal})
                    .frame(width: 80.0)
            }
            switch client.tab {
            case .dashboard:
                Dashboard()
            case .journal:
                Journal()
            default:
                EmptyView()
            }
        }
    }
}
