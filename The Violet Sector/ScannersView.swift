// Created by João Santos for project The Violet Sector.

import SwiftUI

struct ScannersView: View {
    @State private var tab = Tabs.incoming

    var body: some View {
        NavigationView() {
            VStack() {
                HStack() {
                    Button("Incoming", action: {self.tab = .incoming})
                    Button("Outgoing", action: {self.tab = .outgoing})
                }
                if tab == .incoming {
                    TargetsView(model: TargetsModel.Incoming.shared)
                } else if tab == .outgoing {
                    TargetsView(model: TargetsModel.Outgoing.shared)
                }
            }
            .navigationBarTitle("Scanners", displayMode: .inline)
            .navigationBarItems(trailing: RefreshButtonView())
        }
    }

    private enum Tabs {
        case incoming
        case outgoing
    }
}
