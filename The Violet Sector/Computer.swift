// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Computer: View {
    @ObservedObject var model: Model<Data>
    @StateObject private var cloakOnAction = Action(resource: "cloak_on.php")
    @StateObject private var cloakOffAction = Action(resource: "cloak_off.php")
    @StateObject private var selfRepairAction = Action(resource: "self_rep.php")
    @ObservedObject private var client = Client.shared

    var body: some View {
        Page(title: "Computer", model: model) {(data) in
            GeometryReader() {(geometry) in
                ScrollView() {
                    VStack(spacing: 10.0) {
                        HStack() {
                            if data.status.currentHealth < data.status.maxHealth && data.status.currentHealth > 0 && client.settings != nil && data.status.moves >= client.settings!.movesToSelfRepair {
                                Button("Repair", action: {selfRepairAction.trigger(query: [:])})
                                    .frame(width: 80.0)
                            }
                            if !data.status.isCloaked && client.settings != nil && data.status.moves >= client.settings!.movesToCloak {
                                Button("Cloak", action: {cloakOnAction.trigger(query: [:])})
                                    .frame(width: 80.0)
                            }
                            if data.status.isCloaked && client.settings != nil && data.status.moves >= client.settings!.movesToDecloak {
                                Button("Decloak", action: {cloakOffAction.trigger(query: [:])})
                                    .frame(width: 80.0)
                            }
                        }
                        Description() {
                            DescriptionItem(name: "Pilot Name") {Text(verbatim: data.status.name)}
                            DescriptionItem(name: "Score") {Text(verbatim: String(data.status.score))}
                            DescriptionItem(name: "Hitpoints") {Text(health: data.status.currentHealth, maxHealth: data.status.maxHealth, asPercentage: false)}
                        }
                        Description() {
                            DescriptionItem(name: "Sector") {Text(verbatim: makeSectorString(data: data))}
                            if let scrap = data.scrap {
                                DescriptionItem(name: "Scrap in Sector") {Text(verbatim: String(scrap))}
                            }
                        }
                        Description() {
                            DescriptionItem(name: "Base Hitpoints") {Text(health: data.base.currentHealth, maxHealth: data.base.maxHealth, asPercentage: false)}
                            DescriptionItem(name: "Council") {Text(verbatim: makeCouncilString(data: data))}
                        }
                        Text(verbatim: makeNewsString(data: data))
                            .multilineTextAlignment(.leading)
                            .padding(5.0)
                            .border(Color.primary)
                            .frame(width: geometry.size.width - 10.0)
                    }
                }
            }
        }
    }

    private func makeSectorString(data: Data) -> String {
        var sector = data.status.currentSector.description
        if data.status.destinationSector != .none {
            sector = "Hypering to " + data.status.destinationSector.description
        }
        if data.status.isSleeping {
            sector += " (zZzZ)"
        }
        if data.status.isCloaked {
            sector += " (Cloaked)"
        }
        if data.status.isInvulnerable {
            sector += " (Invulnerable)"
        }
        return sector
    }

    private func makeCouncilString(data: Data) -> String {
        var council = ""
        for commander in data.council {
            if !council.isEmpty {
                council += "\n"
            }
            council += commander.name
            if commander.isOnline {
                council += "*"
            }
            if commander.responsibility == 3 {
                council += " (LC)"
            } else {
                council += " (VC)"
            }
        }
        return council
    }

    private func makeNewsString(data: Data) -> String {
        var newsString = "Legion News set by " + data.news.author
        newsString += " on turn " + String(data.news.turn) + " (" + DateFormatter.localizedString(from: Date(timeIntervalSince1970: TimeInterval(data.news.time)), dateStyle: .short, timeStyle: .short) + ")"
        newsString += "\n\n" + data.news.text
        return newsString
    }

    struct Data: Decodable {
        let news: News
        let scrap: Int?
        let base: Base
        let council: [Commander]
        let status: Status.Data

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            news = try container.decode(News.self, forKey: .news)
            scrap = try container.decodeIfPresent(Int.self, forKey: .scrap)
            base = try container.decode(Base.self, forKey: .base)
            council = try container.decode([Commander].self, forKey: .council)
            status = try container.decode(Status.Data.self, forKey: .status)
        }
        private enum CodingKeys: String, CodingKey {
            case news = "legion_news"
            case scrap = "scrap_in_sector"
            case base = "base_status"
            case council = "council_info"
            case status = "player"
        }

        struct News: Decodable {
            let author: String
            let time: Int64
            let turn: Int64
            let text: String

            private enum CodingKeys: String, CodingKey {
                case author
                case time = "news_time"
                case turn = "news_tick"
                case text = "news_text"
            }
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
}
