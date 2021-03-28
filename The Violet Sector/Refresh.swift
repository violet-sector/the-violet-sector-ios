// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Refresh: View {
    var body: some View {
        Button(action: {Client.shared.activeModel.refresh()}) {
            Image(systemName: "arrow.clockwise")
        }
        .accessibilityLabel("Refresh")
    }
}
