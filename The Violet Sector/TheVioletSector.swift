// Created by João Santos for project The Violet Sector.

import SwiftUI

@main struct TheVioletSector: App {
    @ObservedObject private var client = Client.shared

    var body: some Scene {
        WindowGroup() {
            if let settings = client.settings {
                VStack(spacing: 10.0) {
                    Timer()
                    if client.tab == nil {
                        Group() {
                            Spacer()
                            Text(verbatim: "News")
                                .font(.title)
                                .accessibilityAddTraits(.isHeader)
                            ScrollView() {
                                Text(verbatim: settings.news)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                            .padding(5.0)
                            .frame(width: 240.0, height: 120.0)
                            .background(RoundedRectangle(cornerRadius: 8.0).stroke(Color.accentColor, lineWidth: 2.0))
                            Button("Enter", action: {client.tab = .computer})
                            Spacer()
                        }
                        .onAppear(perform: {client.activeModel = nil})
                    } else {
                        NavigationView() {
                            selectView()
                                .navigationBarTitleDisplayMode(.inline)
                        }
                        Status()
                        HStack(spacing: 5.0) {
                            Button("Main", action: {client.tab = .computer})
                            Button("Scans", action: {client.tab = .friendlyScans})
                            Button("Comms", action: {client.tab = .news})
                            Button("Map", action: {client.tab = .map})
                            Button("Top", action: {client.tab = .topPilots})
                        }
                        .buttonStyle(TabButton())
                    }
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .accentColor(Color("Colors/Accent"))
            } else if let error = client.error {
                Spacer()
                Text(verbatim: "Error Fetching Data")
                    .font(.title)
                    .accessibilityAddTraits(.isHeader)
                Text(verbatim: error)
                Spacer()
            } else {
                ProgressView()
            }
        }
    }

    private func selectView() -> AnyView {
        guard let tab = client.tab else {
            return AnyView(EmptyView())
        }
        switch tab {
        case .computer, .journal:
            return AnyView(Main())
        case .friendlyScans, .pickupScans, .incomingScans, .outgoingScans:
            return AnyView(Scans())
        case .news:
            return AnyView(Comms())
        case .map:
            return AnyView(Map())
        case .topPilots, .topDeaths, .topLegions:
            return AnyView(Top())
        }
    }
}
