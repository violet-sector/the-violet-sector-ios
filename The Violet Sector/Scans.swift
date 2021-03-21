// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Scans: View {
    @ObservedObject private var client = Client.shared

    var body: some View {
        VStack(spacing: 10.0) {
            HStack(spacing: 5.0) {
                Button("Friendlies", action: {client.tab = .friendlyScans})
                    .frame(width: 80.0)
            }
            HStack(spacing: 5.0) {
                Button("Incoming", action: {client.tab = .incomingScans})
                    .frame(width: 80.0)
                Button("Outgoing", action: {client.tab = .outgoingScans})
                    .frame(width: 80.0)
            }
            if let tab = client.tab {
                switch tab {
                case .friendlyScans:
                    FriendlyScans()
                case .incomingScans:
                    IncomingScans()
                case .outgoingScans:
                    OutgoingScans()
                default:
                    EmptyView()
                }
            }
        }
    }
}
