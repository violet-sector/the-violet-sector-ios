// Created by João Santos for project The Violet Sector.

import SwiftUI

@main struct TheVioletSector: App {
    @ObservedObject private var client = Client.shared
    @State private var isAuthenticated = false
    @State private var tabIndex = 0

    var body: some Scene {
        WindowGroup() {
            if let settings = client.settings {
                if isAuthenticated {
                    TabView(selection: $tabIndex) {
                        VStack() {
                            Main(tabIndex: $tabIndex, thisTabIndex: 0)
                            Status()
                        }
                        .tabItem({Image(systemName: "doc.text.fill").accessibilityHidden(true); Text(verbatim: "Main").bold()})
                        .tag(0)
                        VStack() {
                            Scanners(tabIndex: $tabIndex, thisTabIndex: 1)
                            Status()
                        }
                        .tabItem({Image(systemName: "dot.radiowaves.left.and.right").accessibilityHidden(true); Text(verbatim: "Scanners").bold()})
                        .tag(1)
                        Text(verbatim: "Placeholder")
                            .tabItem({Image(systemName: "envelope.fill").accessibilityHidden(true); Text(verbatim: "Comms").bold()})
                            .tag(2)
                        VStack() {
                            Navigation(tabIndex: $tabIndex, thisTabIndex: 3)
                            Status()
                        }
                        .tabItem({Image(systemName: "map.fill").accessibilityHidden(true); Text(verbatim: "Navigation").bold()})
                        .tag(3)
                        VStack() {
                            Rankings(tabIndex: $tabIndex, thisTabIndex: 4)
                            Status()
                        }
                        .tabItem({Image(systemName: "person.fill").accessibilityHidden(true); Text(verbatim: "Rankings").bold()})
                        .tag(4)
                    }
                    .alert(item: $client.errorResponse, content: {Alert(title: Text(verbatim: "Error"), message: Text(verbatim: $0.message))})
                    .accentColor(Color(.sRGB, red: 0.5, green: 0.125, blue: 1.0))
                } else {
                    VStack(spacing: 10.0) {
                        Spacer()
                        Text(verbatim: "News")
                            .bold()
                            .accessibilityAddTraits(.isHeader)
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
                    .accentColor(Color(.sRGB, red: 0.5, green: 0.125, blue: 1.0))
                }
            } else if let error = client.error {
                VStack() {
                    Text(verbatim: "Error Fetching Data")
                        .bold()
                        .foregroundColor(.accentColor)
                        .accessibilityAddTraits(.isHeader)
                    Text(verbatim: error)
                }
                .accentColor(Color(.sRGB, red: 0.5, green: 0.125, blue: 1.0))
            } else {
                ProgressView()
                    .scaleEffect(10.0)
            }
        }
    }
}
