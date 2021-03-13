// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Refresh: ToolbarContent {
    let action: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            Button(action: action) {
                Image(systemName: "arrow.clockwise")
            }
            .accessibilityLabel("Refresh")
        }
    }
}
