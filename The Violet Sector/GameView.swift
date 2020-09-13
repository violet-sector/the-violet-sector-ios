// Created by João Santos for project The Violet Sector.

import SwiftUI

struct GameView: View {
    var body: some View {
        TabView() {
            VStack() {
                MainView()
                StatusView()
            }
            .tabItem({Image(systemName: "doc.text.fill"); Text(verbatim: "Main").bold()})
            VStack() {
ScannersView()
                StatusView()
            }
            .tabItem({Image(systemName: "dot.radiowaves.left.and.right"); Text(verbatim: "Scanners").bold()})
            VStack() {
                Text(verbatim: "Placeholder")
                StatusView()
            }
            .tabItem({Image(systemName: "envelope.fill"); Text(verbatim: "Comms").bold()})
            VStack() {
                NavComView()
                StatusView()
            }
            .tabItem({Image(systemName: "map.fill"); Text(verbatim: "Navigation").bold()})
            VStack() {
                RankingsView()
                StatusView()
            }
            .tabItem({Image(systemName: "person.fill"); Text(verbatim: "Rankings").bold()})
        }
    }
}
