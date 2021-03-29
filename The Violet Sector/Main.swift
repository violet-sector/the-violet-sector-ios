// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Main: View {
    @ObservedObject private var client = Client.shared

    var body: some View {
        VStack(spacing: 10.0) {
            HStack(spacing: 5.0) {
                Button("Computer", action: {client.tab = .computer})
                Button("Journal", action: {client.tab = .journal})
            }
            .buttonStyle(SectionButton())
            switch client.tab {
            case .computer:
                Computer()
            case .journal:
                Journal()
            default:
                EmptyView()
            }
        }
    }
}
