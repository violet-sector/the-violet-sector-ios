// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Scanners: View {
    @Binding var tabIndex: Int
    let thisTabIndex: Int
    @StateObject private var incomingModel = Model<Targets.Data>(resource: "scans_incoming.php")
    @StateObject private var outgoingModel = Model<Targets.Data>(resource: "scans_outgoing.php")
    @State private var tab = Tabs.incoming

    var body: some View {
        NavigationView() {
            VStack(spacing: 10.0) {
                HStack() {
                    Button("Incoming", action: {self.tab = .incoming; incomingModel.refresh(force: true)})
                    Button("Outgoing", action: {self.tab = .outgoing; outgoingModel.refresh(force: true)})
                }
                switch tab {
                case .incoming:
                    Targets(title: "Incoming", model: incomingModel)
                case .outgoing:
                    Targets(title: "Outgoing", model: outgoingModel)
                }
            }
            .navigationBarTitle("Scanners")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {Refresh(action: {switch tab {case .incoming: incomingModel.refresh(force: true); case .outgoing: outgoingModel.refresh(force: true)}})})
            .onChange(of: tabIndex, perform: {if $0 == thisTabIndex {switch tab {case .incoming: incomingModel.refresh(force: true); case .outgoing: outgoingModel.refresh(force: true)}}})
        }
    }

    private enum Tabs {
        case incoming
        case outgoing
    }
}
