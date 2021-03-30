// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Computer: View {
    var body: some View {
        Page(dataType: Data.self) {(data) in
            GeometryReader() {(geometry) in
                ScrollView() {
                    VStack(spacing: 10.0) {
                        if let isCapitalShipAvailable = data.isCapitalShipAvailable, isCapitalShipAvailable {
                            Text(verbatim: "Capital Ship Available")
                                .bold()
                                .accessibilityAddTraits(.isHeader)
                            if let capitalShipBlocker = data.capitalShipBlocker {
                                Text(verbatim: capitalShipBlocker)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        General(data: data, width: geometry.size.width)
                        Dashboard(data: data, width: geometry.size.width)
                        Base(data: data, width: geometry.size.width)
                    }
                }
            }
        }
    }

    struct Data: Decodable {
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

    private struct General: View {
        let data: Data
        let width: CGFloat

        var body: some View {
            VStack() {
                Text(verbatim: "General")
                    .bold()
                    .accessibilityAddTraits(.isHeader)
                LazyVGrid(columns: [GridItem(.fixed(width * 0.5 - 2.5), spacing: 5.0, alignment: .trailing), GridItem(.fixed(width * 0.5 - 2.5), spacing: 5.0, alignment: .leading)]) {
                    Description(name: "Name") {Text(verbatim: data.status.name)}
                    Description(name: "Legion") {Text(verbatim: data.status.legion.description)}
                    Description(name: "Score") {Text(String(data.status.score))}
                    Description(name: "Level") {Text(verbatim: String(data.status.level))}
                    Description(name: "Kills") {Text(verbatim: String(data.killCount))}
                    Description(name: "Deaths") {Text(verbatim: String(data.deathCount))}
                }
            }
        }
    }

    private struct Dashboard: View {
        let data: Data
        let width: CGFloat

        var body: some View {
            VStack() {
                Text(verbatim: "Dashboard")
                    .bold()
                    .accessibilityAddTraits(.isHeader)
                LazyVGrid(columns: [GridItem(.fixed(width * 0.5 - 2.5), spacing: 5.0, alignment: .trailing), GridItem(.fixed(width * 0.5 - 2.5), spacing: 5.0, alignment: .leading)]) {
                    Description(name: "Hitpoints") {
                        VStack(alignment: .leading) {
                            Text(health: data.status.currentHealth, maxHealth: data.status.maxHealth, asPercentage: false) + Text(verbatim: data.status.isInvulnerable ? " (I)" : "") + Text(verbatim: data.status.isSleeping ? " (Z)" : "")
                            if let canRepair = data.canRepair, let repairAmount = data.repairAmount, let repairCost = data.repairCost, canRepair {
                                Button("Repair \(repairAmount)HP (\(repairCost))", action: {Client.shared.post("self_rep.php", query: [:], completionHandler: {Client.shared.activeModel.refresh()})})
                            }
                        }
                    }
                    if data.status.destinationSector == .none {
                        Description(name: "Location") {Text(verbatim: data.status.currentSector.description)}
                    } else {
                        Description(name: "Destination") {Text(verbatim: data.status.destinationSector.description)}
                    }
                    if let scrap = data.scrap {
                        Description(name: "Scrap in Sector") {
                            VStack(alignment: .leading) {
                                Text(verbatim: String(scrap))
                                if let canRetrieveScrap = data.canRetrieveScrap, let retrieveScrapCost = data.retrieveScrapCost, canRetrieveScrap {
                                    Button("Retrieve (\(retrieveScrapCost))", action: {})
                                }
                            }
                        }
                    }
                    if data.status.ship.isRepairer {
                        Description(name: "Scrap Carried") {
                            VStack() {
                                Text(verbatim: "??/\(Client.shared.settings != nil ? String(Client.shared.settings!.maxCarriedScrap) : "??")")
                                if let canDumpScrap = data.canDumpScrap, let dumpScrapCost = data.dumpScrapCost, canDumpScrap {
                                    Button("Dump (\(dumpScrapCost))", action: {})
                                }
                            }
                        }
                    }
                    if data.status.ship.isCloaker {
                        Description(name: "Cloaking Device") {
                            VStack() {
                                Text(verbatim: !data.status.isCloaked ? "Decloaked" : "Cloaked")
                                if let canCloak = data.canCloak, let cloakCost = data.cloakCost, canCloak {
                                    Button("Cloak (\(cloakCost))", action: {Client.shared.post("cloak_on.php", query: [:], completionHandler: {Client.shared.activeModel.refresh()})})
                                }
                                if let canDecloak = data.canDecloak, let decloakCost = data.decloakCost, canDecloak {
                                    Button("Decloak (\(decloakCost))", action: {Client.shared.post("cloak_off.php", query: [:], completionHandler: {Client.shared.activeModel.refresh()})})
                                }
                            }
                        }
                    }
                    if let name = data.status.carrier.name, let isOnline = data.status.carrier.isOnline {
                        Description(name: "Dock") {
                            VStack() {
                                Text(verbatim: name) + Text(verbatim: isOnline ? "*" : "").foregroundColor(Color("Colors/Online"))
                                if let canExit = data.canExit, let exitCost = data.exitCost, canExit {
                                    Button("Exit (\(exitCost))", action: {Client.shared.post("carrier_exit.php", query: [:], completionHandler: {Client.shared.activeModel.refresh()})})
                                }
                                if let canUndock = data.canUndock, let undockCost = data.undockCost, canUndock {
                                    Button("Undock (\(undockCost))", action: {Client.shared.post("carrier_exit.php", query: [:], completionHandler: {Client.shared.activeModel.refresh()})})
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private struct Base: View {
        let data: Data
        let width: CGFloat

        var body: some View {
            VStack() {
                Text(verbatim: "Base")
                    .bold()
                    .accessibilityAddTraits(.isHeader)
                LazyVGrid(columns: [GridItem(.fixed(width * 0.5 - 2.5), spacing: 5.0, alignment: .trailing), GridItem(.fixed(width * 0.5 - 2.5), spacing: 5.0, alignment: .leading)]) {
                    Description(name: "Location") {Text(verbatim: data.status.legion.base.description)}
                    Description(name: "Hitpoints") {Text(health: data.base.currentHealth, maxHealth: data.base.maxHealth, asPercentage: false)}
                    Description(name: "Council") {
                        VStack() {
                            if let council = data.council, !council.isEmpty {
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
