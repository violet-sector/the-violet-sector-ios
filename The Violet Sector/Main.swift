// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Main: View {
    var body: some View {
        NavigationView() {
            LegionNews()
                .navigationBarTitle("Main")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {Refresh()})
        }
    }
}
