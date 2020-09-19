// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Loading: View {
    var body: some View {
        VStack() {
            Spacer()
            ProgressView()
                .scaleEffect(10.0)
            Spacer()
        }
    }
}
