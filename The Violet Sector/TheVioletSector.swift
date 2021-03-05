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
                            .tabItem({Image(systemName: "doc.text.fill").accessibilityHidden(true); Text(verbatim: "Main").bold()})
                        Scanners()
                            .tabItem({Image(systemName: "dot.radiowaves.left.and.right").accessibilityHidden(true); Text(verbatim: "Scanners").bold()})
                        Text(verbatim: "Placeholder")
                            .tabItem({Image(systemName: "envelope.fill").accessibilityHidden(true); Text(verbatim: "Comms").bold()})
                        Navigation()
                            .tabItem({Image(systemName: "map.fill").accessibilityHidden(true); Text(verbatim: "Navigation").bold()})
                        Rankings()
                            .tabItem({Image(systemName: "person.fill").accessibilityHidden(true); Text(verbatim: "Rankings").bold()})
                    }
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
                }
            } else if let error = client.error {
                Text(verbatim: "Error Fetching Data")
                    .bold()
                    .accessibilityAddTraits(.isHeader)
                Text(verbatim: Self.describeError(error))
            } else {
                ProgressView()
                    .scaleEffect(10.0)
            }
        }
    }

    static private func describeError(_ error: Error) -> String {
        switch error {
        case _ as DecodingError:
            return "Unable to decode resource."
        case let error as LocalizedError:
            return error.errorDescription ?? "Unknown error."
        case let error as NSError:
            return error.localizedDescription
        default:
            return "Unknown error."
        }
    }
}
