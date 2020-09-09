// Created by João Santos for project The Violet Sector.

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView() {
            LegionNewsView()
                .navigationBarTitle("Main", displayMode: .inline)
                .navigationBarItems(trailing: RefreshButtonView())
        }
    }
}
