// Created by João Santos for project The Violet Sector.

import SwiftUI

struct SectionButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let background = RoundedRectangle(cornerRadius: 8.0)
            .stroke(Color.accentColor, lineWidth: 2.0)
        return configuration.label
            .frame(width: 100.0, height: 40.0)
            .background(background)
            .foregroundColor(.accentColor)
    }
}
