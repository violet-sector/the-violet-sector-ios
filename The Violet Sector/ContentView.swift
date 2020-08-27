//
//  ContentView.swift
//  The Violet Sector
//
//  Created by João Santos on 01/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var client = Client.shared

    var body: some View {
        TabView() {
            VStack() {
                MainView()
                StatusView()
            }
            .tabItem({Image(systemName: "doc.text.fill"); Text(verbatim: "Main").bold()})
            VStack() {
                Text(verbatim: "Placeholder")
                StatusView()
            }
            .tabItem({Image(systemName: "dot.radiowaves.left.and.right"); Text(verbatim: "Scanners").bold()})
            VStack() {
                Text(verbatim: "Placeholder")
                StatusView()
            }
            .tabItem({Image(systemName: "envelope.fill"); Text(verbatim: "Comms").bold()})
            VStack() {
                Text(verbatim: "Placeholder")
                StatusView()
            }
            .tabItem({Image(systemName: "map.fill"); Text(verbatim: "Navigation").bold()})
            VStack() {
                RankingsView()
                StatusView()
            }
            .tabItem({Image(systemName: "person.fill"); Text(verbatim: "Rankings").bold()})
        }
        .alert(isPresented: $client.showingError, content: {Alert(title: Text("Error Fetching Data"), message: Text(client.error!))})
        .preferredColorScheme(.dark)
        .accentColor(Color(.sRGB, red: 0.4, green: 0.5, blue: 1.0, opacity: 1.0))
    }
}
