// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Refresh: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            Button(action: {Client.shared.refreshable!.refresh()}) {
                Image(systemName: "arrow.clockwise")
            }
            .accessibilityLabel("Refresh")
        }
    }
}
