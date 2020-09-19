// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Navigation: View {
    var body: some View {
        NavigationView() {
            Map()
                .navigationBarTitle("Navigation")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {Refresh()})
        }
    }
}
