// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Scanners: View {
    @State private var tab = Tabs.incoming
    
    var body: some View {
        NavigationView() {
            VStack(spacing: 10.0) {
                HStack() {
                    Button("Incoming", action: {self.tab = .incoming})
                    Button("Outgoing", action: {self.tab = .outgoing})
                }
                switch tab {
                case .incoming:
                    Targets(title: "Incoming", resource: "scans_incoming.php")
                case .outgoing:
                    Targets(title: "Outgoing", resource: "scans_outgoing.php")
                }
            }
            .navigationBarTitle("Scanners")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {Refresh()})
        }
    }
    
    private enum Tabs {
        case incoming
        case outgoing
    }
}
