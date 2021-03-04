// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Hyper: ToolbarContent {
    let canHyper: Bool
    let action: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            Button("Hyper", action: action)
                .disabled(!canHyper)
        }
    }
}
