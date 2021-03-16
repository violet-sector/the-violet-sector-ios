// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Scanners: View {
    @Binding var tabIndex: Int
    let thisTabIndex: Int
    @StateObject private var friendliesModel = Model<Targets.Data>(resource: "scans_friendlies.php")
    @StateObject private var incomingModel = Model<Targets.Data>(resource: "scans_incoming.php")
    @StateObject private var outgoingModel = Model<Targets.Data>(resource: "scans_outgoing.php")
    @State private var tab = Tabs.friendlies

    var body: some View {
        NavigationView() {
            VStack(spacing: 10.0) {
                HStack() {
                    Button("Friendlies", action: {tab = .friendlies; friendliesModel.refresh()})
                }
                HStack() {
                    Button("Incoming", action: {tab = .incoming; incomingModel.refresh()})
                    Button("Outgoing", action: {tab = .outgoing; outgoingModel.refresh()})
                }
                switch tab {
                case .friendlies:
                    Targets(title: "Friendlies", model: friendliesModel)
                case .incoming:
                    Targets(title: "Incoming", model: incomingModel)
                case .outgoing:
                    Targets(title: "Outgoing", model: outgoingModel)
                }
            }
            .navigationTitle("Scanners")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {Refresh(action: {refreshModel()})})
            .onChange(of: tabIndex, perform: {if $0 == thisTabIndex {refreshModel()}})
        }
    }

    init(tabIndex: Binding<Int>, thisTabIndex: Int) {
        _tabIndex = tabIndex
        self.thisTabIndex = thisTabIndex
    }

    private func refreshModel() {
        switch tab {
        case .friendlies:
            friendliesModel.refresh()
        case .incoming:
            incomingModel.refresh()
        case .outgoing:
            outgoingModel.refresh()
        }
    }

    private enum Tabs {
        case friendlies
        case incoming
        case outgoing
    }
}
