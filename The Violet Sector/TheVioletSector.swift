// Created by João Santos for project The Violet Sector.

import SwiftUI

@main struct TheVioletSector: App {
    @ObservedObject private var client = Client.shared
    private static let dashboardModel = Model(resource: "main.php", dataType: Dashboard.Data.self)
    private static let journalModel = Model(resource: "journal.php", dataType: Journal.Data.self)
    private static let friendlyScansModel = Model(resource: "scans_friendlies.php", dataType: FriendlyScans.Data.self)
    private static let incomingScansModel = Model(resource: "scans_incoming.php", dataType: IncomingScans.Data.self)
    private static let outgoingScansModel = Model(resource: "scans_outgoing.php", dataType: OutgoingScans.Data.self)
    private static var newsModel = Model(resource: "legion_news.php", dataType: News.Data.self)
    private static let mapModel = Model(resource: "navcom_map.php", dataType: Map.Data.self)
    private static let topPilotsModel = Model(resource: "rankings_pilots.php", dataType: TopPilots.Data.self)
    private static let topDeathsModel = Model(resource: "rankings_att.php", dataType: TopDeaths.Data.self)
    private static let topLegionsModel = Model(resource: "rankings_legions.php", dataType: TopLegions.Data.self)

    var body: some Scene {
        WindowGroup() {
            if let settings = client.settings {
                VStack(spacing: 10.0) {
                    Timer()
                    if client.tab == nil {
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
                        .border(Color.primary)
                        Button("Enter", action: {client.tab = .dashboard})
                        Spacer()
                    } else {
                        NavigationView() {
                            selectView()
                                .environmentObject(Self.dashboardModel)
                                .environmentObject(Self.journalModel)
                                .environmentObject(Self.friendlyScansModel)
                                .environmentObject(Self.incomingScansModel)
                                .environmentObject(Self.outgoingScansModel)
                                .environmentObject(Self.newsModel)
                                .environmentObject(Self.mapModel)
                                .environmentObject(Self.topPilotsModel)
                                .environmentObject(Self.topDeathsModel)
                                .environmentObject(Self.topLegionsModel)
                                .navigationBarTitleDisplayMode(.inline)
                        }
                        Status()
                        HStack(spacing: 5.0) {
                            Button("Main", action: {client.tab = .dashboard})
                                .frame(width: 60.0)
                            Button("Scans", action: {client.tab = .friendlyScans})
                                .frame(width: 60.0)
                            Button("Comms", action: {client.tab = .news})
                                .frame(width: 60.0)
                            Button("Map", action: {client.tab = .map})
                                .frame(width: 60.0)
                            Button("Top", action: {client.tab = .topPilots})
                                .frame(width: 60.0)
                        }
                    }
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .accentColor(Color("Colors/Accent"))
                .onChange(of: client.tab, perform: {setActiveModel($0)})
                .alert(item: $client.errorResponse, content: {Alert(title: Text(verbatim: "Error Sending Data"), message: Text(verbatim: $0.message), dismissButton: .cancel())})
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
        case .dashboard, .journal:
            return AnyView(Main())
        case .friendlyScans, .incomingScans, .outgoingScans:
            return AnyView(Scans())
        case .news:
            return AnyView(Comms())
        case .map:
            return AnyView(Map())
        case .topPilots, .topDeaths, .topLegions:
            return AnyView(Top())
        }
    }

    private func setActiveModel(_ tab: Client.Tabs?) {
        guard let tab = tab else {
            client.activeModel = nil
            return
        }
        switch tab {
        case .dashboard:
            client.activeModel = Self.dashboardModel
        case .journal:
            client.activeModel = Self.journalModel
        case .friendlyScans:
            client.activeModel = Self.friendlyScansModel
        case .incomingScans:
            client.activeModel = Self.incomingScansModel
        case .outgoingScans:
            client.activeModel = Self.outgoingScansModel
        case .news:
            client.activeModel = Self.newsModel
        case .map:
            client.activeModel = Self.mapModel
        case .topPilots:
            client.activeModel = Self.topPilotsModel
        case .topDeaths:
            client.activeModel = Self.topDeathsModel
        case .topLegions:
            client.activeModel = Self.topLegionsModel
        }
        client.activeModel.refresh()
    }
}
