// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TabButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .background(Spacer())
            .frame(width: 60.0, height: 32.0)
            .border(Color.accentColor)
            .foregroundColor(.accentColor)
    }
}
