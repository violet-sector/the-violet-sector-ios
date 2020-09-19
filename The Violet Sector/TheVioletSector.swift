// Created by João Santos for project The Violet Sector.

import SwiftUI

@main struct TheVioletSector: App {
    @ObservedObject var client = Client.shared
    @State private var isAuthenticated = false

    var body: some Scene {
        WindowGroup() {
            if let settings = client.settings {
                if isAuthenticated {
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
                } else {
                    VStack(spacing: 10.0) {
                        Spacer()
                        Title("News")
                        ScrollView() {
                            Text(verbatim: settings.news)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(5.0)
                        .border(Color.primary)
                        .frame(width: 240.0, height: 100.0, alignment: .topLeading)
                        Button("Enter", action: {isAuthenticated = true})
                        Spacer()
                        Timer()
                    }
                }
            } else if let error = client.error {
                FriendlyError(error: error)
            } else {
                Loading()
            }
        }
    }
}
