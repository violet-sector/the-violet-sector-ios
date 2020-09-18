// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Scanners: View {
    @State private var tab = Tabs.incoming

    var body: some View {
        NavigationView() {
            VStack() {
                HStack() {
                    Button("Incoming", action: {self.tab = .incoming})
                    Button("Outgoing", action: {self.tab = .outgoing})
                }
                if tab == .incoming {
                    Targets(resource: "scans_incoming.php", title: "Incoming")
                } else if tab == .outgoing {
                    Targets(resource: "scans_outgoing.php", title: "Outgoing")
                }
            }
            .navigationBarTitle("Scanners", displayMode: .inline)
            .navigationBarItems(trailing: Refresh())
        }
    }

    private enum Tabs {
        case incoming
        case outgoing
    }
}
