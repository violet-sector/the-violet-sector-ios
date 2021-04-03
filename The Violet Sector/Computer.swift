// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Computer: View {
    @StateObject private var model = Model(resource: "main.php", responseType: ModelResponse.self)

    var body: some View {
        Page(model: model) {(response) in
            GeometryReader() {(geometry) in
                ScrollView() {
                    VStack(spacing: 10.0) {
                        if let isCapitalShipAvailable = response.isCapitalShipAvailable, isCapitalShipAvailable {
                            Text(verbatim: "Capital Ship Available")
                                .bold()
                                .accessibilityAddTraits(.isHeader)
                            if let capitalShipBlocker = response.capitalShipBlocker {
                                Text(verbatim: capitalShipBlocker)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        General(response: response, width: geometry.size.width)
                        Dashboard(response: response, width: geometry.size.width)
                        Base(response: response, width: geometry.size.width)
                    }
                }
            }
        }
    }

    private struct ModelResponse: Decodable {
        let scrap: Int?
        let canRetrieveScrap: Bool?
        let retrieveScrapCost: Int?
        let canDumpScrap: Bool?
        let dumpScrapCost: Int?
        let canRepair: Bool?
        let repairCost: Int?
        let repairAmount: Int?
        let canCloak: Bool?
        let cloakCost: Int?
        let canDecloak: Bool?
        let decloakCost: Int?
        let canUndock: Bool?
        let undockCost: Int?
        let canExit: Bool?
        let exitCost: Int?
        let killCount: Int
        let deathCount: Int
        let isCapitalShipAvailable: Bool?
        let capitalShipBlocker: String?
        let base: Base
        let council: [Commander]?
        let status: Client.StatusResponse

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            scrap = try container.decodeIfPresent(Int.self, forKey: .scrap)
            canRetrieveScrap = try container.decodeIfPresent(Bool.self, forKey: .canRetrieveScrap)
            retrieveScrapCost = try container.decodeIfPresent(Int.self, forKey: .retrieveScrapCost)
            canDumpScrap = try container.decodeIfPresent(Bool.self, forKey: .canDumpScrap)
            dumpScrapCost = try container.decodeIfPresent(Int.self, forKey: .dumpScrapCost)
            canRepair = try container.decodeIfPresent(Bool.self, forKey: .canRepair)
            repairCost = try container.decodeIfPresent(Int.self, forKey: .repairCost)
            repairAmount = try container.decodeIfPresent(Int.self, forKey: .repairAmount)
            canUndock = try container.decodeIfPresent(Bool.self, forKey: .canUndock)
            undockCost = try container.decodeIfPresent(Int.self, forKey: .undockCost)
            canExit = try container.decodeIfPresent(Bool.self, forKey: .canExit)
            exitCost = try container.decodeIfPresent(Int.self, forKey: .exitCost)
            canCloak = try container.decodeIfPresent(Bool.self, forKey: .canCloak)
            cloakCost = try container.decodeIfPresent(Int.self, forKey: .cloakCost)
            canDecloak = try container.decodeIfPresent(Bool.self, forKey: .canDecloak)
            decloakCost = try container.decodeIfPresent(Int.self, forKey: .decloakCost)
            killCount = try container.decode(Int.self, forKey: .killCount)
            deathCount = try container.decode(Int.self, forKey: .deathCount)
            isCapitalShipAvailable = try container.decodeIfPresent(Bool.self, forKey: .isCapitalShipAvailable)
            capitalShipBlocker = try container.decodeIfPresent(String.self, forKey: .capitalShipBlocker)
            base = try container.decode(Base.self, forKey: .base)
            council = try container.decodeIfPresent([Commander].self, forKey: .council)
            status = try container.decode(Client.StatusResponse.self, forKey: .status)
        }

        private enum CodingKeys: String, CodingKey {
            case scrap = "scrap_in_sector"
            case canRetrieveScrap = "can_scrap_retrieve"
            case retrieveScrapCost = "moves_scrap_retrieve"
            case canDumpScrap = "can_scrap_dump"
            case dumpScrapCost = "moves_scrap_dump"
            case canRepair = "can_self_repair"
            case repairCost = "moves_self_repair"
            case repairAmount = "amount_self_repair"
            case canExit = "can_carrier_exit"
            case exitCost = "moves_carrier_exit"
            case canUndock = "can_dock_exit"
            case undockCost = "moves_dock_exit"
            case canDecloak = "can_decloak"
            case decloakCost = "moves_decloak"
            case canCloak = "can_cloak"
            case cloakCost = "moves_cloak"
            case killCount = "kills"
            case deathCount = "deaths"
            case isCapitalShipAvailable = "capital_ship_available"
            case capitalShipBlocker = "capital_ship_message"
            case base = "base_status"
            case council = "council_info"
            case status = "player"
        }

        struct Base: Decodable {
            let currentHealth: Int
            let maxHealth: Int

            private enum CodingKeys: String, CodingKey {
                case currentHealth = "hp"
                case maxHealth = "maxhp"
            }
        }

        struct Commander: Decodable {
            let name: String
            let responsibility: Int
            let isOnline: Bool

            enum CodingKeys: String, CodingKey {
                case name = "tvs_username"
                case responsibility = "lc"
                case isOnline = "online"
            }
        }
    }

    private struct ActionResponse: Decodable {
        let success: Bool
    }

    private struct General: View {
        let response: ModelResponse
        let width: CGFloat

        var body: some View {
            VStack() {
                Text(verbatim: "General")
                    .bold()
                    .accessibilityAddTraits(.isHeader)
                LazyVGrid(columns: [GridItem(.fixed(width * 0.5 - 2.5), spacing: 5.0, alignment: .trailing), GridItem(.fixed(width * 0.5 - 2.5), spacing: 5.0, alignment: .leading)]) {
                    Description(name: "Name") {Text(verbatim: response.status.name)}
                    Description(name: "Legion") {Text(verbatim: response.status.legion.description)}
                    Description(name: "Score") {Text(String(response.status.score))}
                    Description(name: "Level") {Text(verbatim: String(response.status.level))}
                    Description(name: "Kills") {Text(verbatim: String(response.killCount))}
                    Description(name: "Deaths") {Text(verbatim: String(response.deathCount))}
                }
            }
        }
    }

    private struct Dashboard: View {
        let response: ModelResponse
        let width: CGFloat
        @StateObject private var cloakAction = Action(resource: "cloak_on.php", responseType: ActionResponse.self)
        @StateObject private var decloakAction = Action(resource: "cloak_off.php", responseType: ActionResponse.self)
        @StateObject private var undockAction = Action(resource: "dock_exit.php", responseType: ActionResponse.self)
        @StateObject private var repairAction = Action(resource: "self_rep.php", responseType: ActionResponse.self)

        var body: some View {
            VStack() {
                Text(verbatim: "Dashboard")
                    .bold()
                    .accessibilityAddTraits(.isHeader)
                LazyVGrid(columns: [GridItem(.fixed(width * 0.5 - 2.5), spacing: 5.0, alignment: .trailing), GridItem(.fixed(width * 0.5 - 2.5), spacing: 5.0, alignment: .leading)]) {
                    Description(name: "Hitpoints") {
                        VStack(alignment: .leading) {
                            Text(health: response.status.currentHealth, maxHealth: response.status.maxHealth, asPercentage: false) + Text(verbatim: response.status.isInvulnerable ? " (I)" : "") + Text(verbatim: response.status.isSleeping ? " (Z)" : "")
                            if let canRepair = response.canRepair, let repairAmount = response.repairAmount, let repairCost = response.repairCost, canRepair {
                                Button("Repair \(repairAmount)HP (\(repairCost))", action: {repairAction.perform(query: [:], completionHandler: {Client.shared.activeModel.refresh()})})
                                    .disabled(repairAction.isLoading)
                            }
                        }
                    }
                    if response.status.destinationSector == .none {
                        Description(name: "Location") {Text(verbatim: response.status.currentSector.description)}
                    } else {
                        Description(name: "Destination") {Text(verbatim: response.status.destinationSector.description)}
                    }
                    if let scrap = response.scrap {
                        Description(name: "Scrap in Sector") {
                            VStack(alignment: .leading) {
                                Text(verbatim: String(scrap))
                                if let canRetrieveScrap = response.canRetrieveScrap, let retrieveScrapCost = response.retrieveScrapCost, canRetrieveScrap {
                                    Button("Retrieve (\(retrieveScrapCost))", action: {})
                                }
                            }
                        }
                    }
                    if response.status.ship.isRepairer {
                        Description(name: "Scrap Carried") {
                            VStack() {
                                Text(verbatim: "??/\(Client.shared.settings != nil ? String(Client.shared.settings!.maxCarriedScrap) : "??")")
                                if let canDumpScrap = response.canDumpScrap, let dumpScrapCost = response.dumpScrapCost, canDumpScrap {
                                    Button("Dump (\(dumpScrapCost))", action: {})
                                }
                            }
                        }
                    }
                    if response.status.ship.isCloaker {
                        Description(name: "Cloaking Device") {
                            VStack() {
                                Text(verbatim: !response.status.isCloaked ? "Decloaked" : "Cloaked")
                                if let canCloak = response.canCloak, let cloakCost = response.cloakCost, canCloak {
                                    Button("Cloak (\(cloakCost))", action: {cloakAction.perform(query: [:], completionHandler: {Client.shared.activeModel.refresh()})})
                                        .disabled(cloakAction.isLoading)
                                }
                                if let canDecloak = response.canDecloak, let decloakCost = response.decloakCost, canDecloak {
                                    Button("Decloak (\(decloakCost))", action: {decloakAction.perform(query: [:], completionHandler: {Client.shared.activeModel.refresh()})})
                                        .disabled(decloakAction.isLoading)
                                }
                            }
                        }
                    }
                    if let name = response.status.carrier.name, let isOnline = response.status.carrier.isOnline {
                        Description(name: "Dock") {
                            VStack() {
                                Text(verbatim: name) + Text(verbatim: isOnline ? "*" : "").foregroundColor(Color("Colors/Online"))
                                if let canExit = response.canExit, let exitCost = response.exitCost, canExit {
                                    Button("Exit (\(exitCost))", action: {undockAction.perform(query: [:], completionHandler: {Client.shared.activeModel.refresh()})})
                                        .disabled(undockAction.isLoading)
                                }
                                if let canUndock = response.canUndock, let undockCost = response.undockCost, canUndock {
                                    Button("Undock (\(undockCost))", action: {undockAction.perform(query: [:], completionHandler: {Client.shared.activeModel.refresh()})})
                                        .disabled(undockAction.isLoading)
                                }
                            }
                        }
                    }
                }
            }
            .alert(item: $cloakAction.alert, content: {Alert(title: Text(verbatim: "Error Performing Cloak Action"), message: Text(verbatim: $0))})
            .alert(item: $decloakAction.alert, content: {Alert(title: Text(verbatim: "Error Performing Decloak Action"), message: Text(verbatim: $0))})
            .alert(item: $undockAction.alert, content: {Alert(title: Text(verbatim: "Error Performing Undock Action"), message: Text(verbatim: $0))})
            .alert(item: $repairAction.alert, content: {Alert(title: Text(verbatim: "Error Performing Self Repair Action"), message: Text(verbatim: $0))})
        }
    }

    private struct Base: View {
        let response: ModelResponse
        let width: CGFloat

        var body: some View {
            VStack() {
                Text(verbatim: "Base")
                    .bold()
                    .accessibilityAddTraits(.isHeader)
                LazyVGrid(columns: [GridItem(.fixed(width * 0.5 - 2.5), spacing: 5.0, alignment: .trailing), GridItem(.fixed(width * 0.5 - 2.5), spacing: 5.0, alignment: .leading)]) {
                    Description(name: "Location") {Text(verbatim: response.status.legion.base.description)}
                    Description(name: "Hitpoints") {Text(health: response.base.currentHealth, maxHealth: response.base.maxHealth, asPercentage: false)}
                    Description(name: "Council") {
                        VStack() {
                            if let council = response.council, !council.isEmpty {
                                ForEach(council, id: \.name) {(commander) in
                                    Text(verbatim: commander.name) + Text(verbatim: commander.isOnline ? "*" : "").foregroundColor(Color("Colors/Online")) + Text(verbatim: commander.responsibility > 1 ? " (LC)" : " (VC)")
                                }
                            } else {
                                Text(verbatim: "None")
                            }
                        }
                        .accessibilityElement(children: .combine)
                    }
                }
            }
        }
    }
}
