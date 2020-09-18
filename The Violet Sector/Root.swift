// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Root: View {
    @ObservedObject var client = Client.shared
    @State private var hasEntered = false

    var body: some View {
        Group() {
            if client.settings != nil {
                if hasEntered {
                    Game()
                } else {
                    Entry(hasEntered: $hasEntered)
                }
            } else if client.error != nil {
                FriendlyError(error: client.error!)
            } else {
                Loading()
            }
        }
    }
}
