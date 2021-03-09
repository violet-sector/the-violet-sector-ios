// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Description<Content: View>: View {
    let content: Content

    var body: some View {
        VStack() {
            content
        }
    }

    init(@DescriptionBuilder content: () -> Content) {
        self.content = content()
    }
}
