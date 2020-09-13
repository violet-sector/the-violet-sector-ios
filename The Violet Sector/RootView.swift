// Created by João Santos for project The Violet Sector.

import SwiftUI

struct RootView: View {
    @ObservedObject var client = Client.shared
    @State private var hasEntered = false

    var body: some View {
        Group() {
            if client.settings != nil {
                if hasEntered {
                    GameView()
                } else {
                    EntryView(hasEntered: $hasEntered)
                }
            } else if client.error != nil {
                ErrorView(error: client.error!)
            } else {
                LoadingView()
            }
        }
    }
}
