// Created by João Santos for project The Violet Sector.

import SwiftUI

struct NavComView: View {
    var body: some View {
        NavigationView() {
            MapView()
                .navigationBarTitle("Navigation")
                .navigationBarItems(trailing: RefreshButtonView())
        }
    }
}
