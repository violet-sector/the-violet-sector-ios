// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Game: View {
    var body: some View {
        TabView() {
            Main()
                .tabItem({Image(systemName: "doc.text.fill"); Text(verbatim: "Main").bold()})
            Scanners()
                .tabItem({Image(systemName: "dot.radiowaves.left.and.right"); Text(verbatim: "Scanners").bold()})
            Text(verbatim: "Placeholder")
                .tabItem({Image(systemName: "envelope.fill"); Text(verbatim: "Comms").bold()})
            Navigation()
                .tabItem({Image(systemName: "map.fill"); Text(verbatim: "Navigation").bold()})
            Rankings()
                .tabItem({Image(systemName: "person.fill"); Text(verbatim: "Rankings").bold()})
        }
    }
}
