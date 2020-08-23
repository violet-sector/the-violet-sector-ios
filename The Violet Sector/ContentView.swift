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
                TimerView()
                LegionNewsView()
                StatusView()
            }
            .tabItem({Image(systemName: "desktopcomputer"); Text(verbatim: "Computer")})
            VStack() {
                TimerView()
                Spacer()
                Text(verbatim: "Placeholder")
                Spacer()
                StatusView()
            }
            .tabItem({Image(systemName: "antenna.radiowaves.left.and.right"); Text(verbatim: "Scanners")})
            VStack() {
                TimerView()
                Spacer()
                Text(verbatim: "Placeholder")
                Spacer()
                StatusView()
            }
            .tabItem({Image(systemName: "map"); Text(verbatim: "Navigation")})
            VStack() {
                TimerView()
                Spacer()
                Text(verbatim: "Placeholder")
                Spacer()
                StatusView()
            }
            .tabItem({Image(systemName: "envelope"); Text(verbatim: "Comms")})
            VStack() {
                TimerView()
                RankingsView()
                StatusView()
            }
            .tabItem({Image(systemName: "person"); Text(verbatim: "Rankings")})
        }
        .alert(isPresented: $client.showingError, content: {Alert(title: Text("Error Fetching Data"), message: Text(client.error!))})
    }
}
