// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Main: View {
    var body: some View {
        NavigationView() {
            Computer()
                .navigationBarTitle("Main")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {Refresh()})
        }
    }
}
