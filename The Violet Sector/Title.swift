// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Title: View {
    var text: String

    var body: some View {
        Text(verbatim: text)
            .bold()
            .accessibilityAddTraits(.isHeader)
    }

    init(_ text: String) {
        self.text = text
    }
}
