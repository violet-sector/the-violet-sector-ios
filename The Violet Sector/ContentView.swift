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
            .tabItem({Image(systemName: "desktopcomputer"); Text(verbatim: "Computer").bold()})
            VStack() {
                TimerView()
                GeometryReader() {(geometry) in
                    VStack() {
                        HStack() {
                            Button(action: {}, label: {Text("Enemies").bold()})
                                .frame(width: geometry.size.width / 3.0)
                            Button(action: {}, label: {Text("Friendlies").bold()})
                                .frame(width: geometry.size.width / 3.0)
                            Button(action: {}, label: {Text("Pickups").bold()})
                                .frame(width: geometry.size.width / 3.0)
                        }
                        HStack() {
                            Button(action: {}, label: {Text("Incoming").bold()})
                                .frame(width: geometry.size.width / 3.0)
                            Button(action: {}, label: {Text("Outgoing").bold()})
                                .frame(width: geometry.size.width / 3.0)
                        }
                    }
                }
                Spacer()
                Text(verbatim: "Placeholder")
                Spacer()
                StatusView()
            }
            .tabItem({Image(systemName: "antenna.radiowaves.left.and.right"); Text(verbatim: "Scanners").bold()})
            VStack() {
                TimerView()
                Spacer()
                Text(verbatim: "Placeholder")
                Spacer()
                StatusView()
            }
            .tabItem({Image(systemName: "map"); Text(verbatim: "Navigation").bold()})
            VStack() {
                TimerView()
                Spacer()
                Text(verbatim: "Placeholder")
                Spacer()
                StatusView()
            }
            .tabItem({Image(systemName: "envelope"); Text(verbatim: "Comms").bold()})
            VStack() {
                TimerView()
                RankingsView()
                StatusView()
            }
            .tabItem({Image(systemName: "person"); Text(verbatim: "Rankings").bold()})
        }
        .alert(isPresented: $client.showingError, content: {Alert(title: Text("Error Fetching Data"), message: Text(client.error!))})
        .preferredColorScheme(.dark)
        .accentColor(Color(.sRGB, red: 0.4, green: 0.5, blue: 1.0, opacity: 1.0))
    }
}
