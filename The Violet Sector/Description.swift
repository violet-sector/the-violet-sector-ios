// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Description<Content: View>: View {
    private let name: String
    private let content: Content

    var body: some View {
        HStack(spacing: 10.0) {
            Text(verbatim: name)
                .bold()
                .multilineTextAlignment(.trailing)
                .frame(alignment: .trailing)
            content
                .multilineTextAlignment(.leading)
                .frame(alignment: .leading)
        }
        .accessibilityElement(children: .combine)
    }

    init(name: String, @ViewBuilder content: () -> Content) {
        self.name = name
        self.content = content()
    }
}
