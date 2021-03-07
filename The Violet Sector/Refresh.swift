// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Refresh: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            Button(action: {Client.shared.refreshable!.refresh(force: true)}) {
                Image(systemName: "arrow.clockwise")
            }
            .accessibilityLabel("Refresh")
        }
    }
}
