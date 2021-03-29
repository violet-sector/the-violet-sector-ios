// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Comms: View {
    @ObservedObject private var client = Client.shared

    var body: some View {
        VStack(spacing: 10.0) {
            HStack(spacing: 5.0) {
                Button("News", action: {client.tab = .news})
            }
            .buttonStyle(SectionButton())
            switch client.tab {
            case .news:
                News()
            default:
                EmptyView()
            }
        }
    }
}
