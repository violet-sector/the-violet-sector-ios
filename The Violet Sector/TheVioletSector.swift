// Created by João Santos for project The Violet Sector.

import SwiftUI

@main struct TheVioletSector: App {
    @ObservedObject private var client = Client.shared
    private static let mainModel = Model<Main.Data>(resource: "main.php")
    private static let friendlyScansModel = Model<FriendlyScans.Data>(resource: "scans_friendlies.php")
    private static let incomingScansModel = Model<IncomingScans.Data>(resource: "scans_incoming.php")
    private static let outgoingScansModel = Model<OutgoingScans.Data>(resource: "scans_outgoing.php")
    private static let mapModel = Model<Map.Data>(resource: "navcom_map.php")
    private static let topPilotsModel = Model<TopPilots.Data>(resource: "rankings_pilots.php")
    private static let topDeathsModel = Model<TopDeaths.Data>(resource: "rankings_att.php")
    private static let topLegionsModel = Model<TopLegions.Data>(resource: "rankings_legions.php")

    var body: some Scene {
        WindowGroup() {
            if let settings = client.settings {
                VStack(spacing: 10.0) {
                    Text(verbatim: client.timer)
                        .font(.system(.body, design: .monospaced))
                    if client.tab == nil {
                        Spacer()
                        Text(verbatim: "News")
                            .font(.title)
                            .accessibilityAddTraits(.isHeader)
                        ScrollView() {
                            Text(verbatim: settings.news)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(5.0)
                        .border(Color.primary)
                        .frame(width: 240.0, height: 100.0, alignment: .topLeading)
                        Button("Enter", action: {client.tab = .main})
                        Spacer()
                    } else {
                        NavigationView() {
                            selectView()
                                .environmentObject(Self.mainModel)
                                .environmentObject(Self.friendlyScansModel)
                                .environmentObject(Self.incomingScansModel)
                                .environmentObject(Self.outgoingScansModel)
                                .environmentObject(Self.mapModel)
                                .environmentObject(Self.topPilotsModel)
                                .environmentObject(Self.topDeathsModel)
                                .environmentObject(Self.topLegionsModel)
                                .navigationBarTitleDisplayMode(.inline)
                        }
                        Status()
                        HStack(spacing: 5.0) {
                            Button("Main", action: {client.tab = .main})
                                .frame(width: 60.0)
                            Button("Scans", action: {client.tab = .friendlyScans})
                                .frame(width: 60.0)
                            Button("Map", action: {client.tab = .map})
                                .frame(width: 60.0)
                            Button("Top", action: {client.tab = .topPilots})
                                .frame(width: 60.0)
                        }
                    }
                }
                .accentColor(Color(.sRGB, red: 0.75, green: 0.25, blue: 1.0))
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
        case .main:
            return AnyView(Main())
        case .friendlyScans:
            return AnyView(Scans())
        case .incomingScans:
            return AnyView(Scans())
        case .outgoingScans:
            return AnyView(Scans())
        case .map:
            return AnyView(Map())
        case .topPilots:
            return AnyView(Top())
        case .topDeaths:
            return AnyView(Top())
        case .topLegions:
            return AnyView(Top())
        }
    }

    private func setActiveModel(_ tab: Client.Tabs?) {
        guard let tab = tab else {
            client.activeModel = nil
            return
        }
        switch tab {
        case .main:
            Self.mainModel.refresh()
            client.activeModel = Self.mainModel
        case .friendlyScans:
            Self.friendlyScansModel.refresh()
            client.activeModel = Self.friendlyScansModel
        case .incomingScans:
            Self.incomingScansModel.refresh()
            client.activeModel = Self.incomingScansModel
        case .outgoingScans:
            Self.outgoingScansModel.refresh()
            client.activeModel = Self.outgoingScansModel
        case .map:
            Self.mapModel.refresh()
            client.activeModel = Self.mapModel
        case .topPilots:
            Self.topPilotsModel.refresh()
            client.activeModel = Self.topPilotsModel
        case .topDeaths:
            Self.topDeathsModel.refresh()
            client.activeModel = Self.topDeathsModel
        case .topLegions:
            Self.topLegionsModel.refresh()
            client.activeModel = Self.topLegionsModel
        }
    }
}
