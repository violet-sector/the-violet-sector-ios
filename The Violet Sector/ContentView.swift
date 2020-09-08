//
//  ContentView.swift
//  The Violet Sector
//
//  Created by João Santos on 01/08/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

import SwiftUI

struct ContentView: View {
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
        .preferredColorScheme(.dark)
        .accentColor(Color(.sRGB, red: 0.4, green: 0.5, blue: 1.0, opacity: 1.0))
    }
}
