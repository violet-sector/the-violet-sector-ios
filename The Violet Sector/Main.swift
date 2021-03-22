// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Main: View {
    var body: some View {
        Page() {(_ data: Data) in
            GeometryReader() {(geometry) in
                ScrollView() {
                    VStack(spacing: 10.0) {
                        Text(verbatim: Self.makeNewsString(data: data))
                            .multilineTextAlignment(.leading)
                            .padding(5.0)
                            .border(Color.primary)
                            .frame(width: geometry.size.width - 10.0)
                        LazyVGrid(columns: [GridItem(.fixed(geometry.size.width * 0.5), alignment: .trailing), GridItem(.fixed(geometry.size.width * 0.5), alignment: .leading)]) {
                            Group() {
                                Description(name: "Pilot Name") {Text(verbatim: data.status.name)}
                                Description(name: "Score") {Text(verbatim: String(data.status.score))}
                                Description(name: "Level") {Text(verbatim: String(data.status.level))}
                                Description(name: "Kills") {Text(verbatim: "??")}
                                Description(name: "Deaths") {Text(verbatim: "??")}
                            }
                            Group() {
                                Description(name: "Ship Hitpoints") {
                                    VStack() {
                                        Text(health: data.status.currentHealth, maxHealth: data.status.maxHealth, asPercentage: false)
                                        if data.status.currentHealth < data.status.maxHealth && data.status.currentHealth > 0 && data.status.moves >= Client.shared.settings?.movesToSelfRepair ?? 0 {
                                            Button("Repair", action: {Client.shared.post("self_rep.php", query: [:], completionHandler: {Client.shared.activeModel.refresh()})})
                                                .frame(width: 80.0)
                                        }
                                    }
                                }
                                Description(name: "Sector") {Text(verbatim: data.status.destinationSector == .none ? data.status.currentSector.description : "Hypering to " + data.status.destinationSector.description)}
                                if let scrap = data.scrap {
                                    Description(name: "Scrap in Sector") {Text(verbatim: String(scrap))}
                                }
                                if data.status.ship.isRepairer {
                                    Description(name: "Scrap Carried") {Text(verbatim: "??/\(Client.shared.settings != nil ? String(Client.shared.settings!.maxCarriedScrap) : "??")")}
                                }
                                if data.status.ship.isCloaker {
                                    Description(name: "Cloaking Device") {
                                        VStack() {
                                            Text(verbatim: !data.status.isCloaked ? "Decloaked" : "Cloaked")
                                            if !data.status.isCloaked && data.status.moves >= Client.shared.settings?.movesToDecloak ?? 0 && data.status.carrier.name == nil {
                                                Button("Cloak", action: {Client.shared.post("cloak_on.php", query: [:], completionHandler: {Client.shared.activeModel.refresh()})})
                                                    .frame(width: 80.0)
                                            } else if data.status.isCloaked && data.status.moves >= Client.shared.settings?.movesToDecloak ?? 0 {
                                                Button("Decloak", action: {Client.shared.post("cloak_off.php", query: [:], completionHandler: {Client.shared.activeModel.refresh()})})
                                                    .frame(width: 80.0)
                                            }
                                        }
                                    }
                                }
                                if let name = data.status.carrier.name, let isOnline = data.status.carrier.isOnline {
                                    Description(name: "Carrier") {
                                        VStack() {
                                            Text(verbatim: name + (isOnline ? "*" : ""))
                                            if data.status.moves >= Client.shared.settings?.movesToUndock ?? 0 {
                                                Button("Undock", action: {Client.shared.post("carrier_exit.php", query: [:], completionHandler: {Client.shared.activeModel.refresh()})})
                                                    .frame(width: 80.0)
                                            }
                                        }
                                    }
                                }
                                Description(name: "Base sector") {Text(verbatim: "??")}
                                Description(name: "Base Hitpoints") {Text(health: data.base.currentHealth, maxHealth: data.base.maxHealth, asPercentage: false)}
                                Description(name: "Council") {Text(verbatim: Self.makeCouncilString(data: data))}
                            }
                        }
                    }
                }
            }
        }
    }

    private static func makeCouncilString(data: Data) -> String {
        guard let council = data.council else {
            return "None"
        }
        var councilString = ""
        for commander in council {
            if !councilString.isEmpty {
                councilString += "\n"
            }
            councilString += commander.name
            if commander.isOnline {
                councilString += "*"
            }
            if commander.responsibility > 1 {
                councilString += " (LC)"
            } else {
                councilString += " (VC)"
            }
        }
        return councilString
    }

    private static func makeNewsString(data: Data) -> String {
        var newsString = "Legion News set by " + data.news.author
        newsString += " on turn " + String(data.news.turn) + " (" + DateFormatter.localizedString(from: Date(timeIntervalSince1970: TimeInterval(data.news.time)), dateStyle: .short, timeStyle: .short) + ")"
        newsString += "\n\n" + data.news.text
        return newsString
    }

    struct Data: Decodable {
        let news: News
        let scrap: Int?
        let base: Base
        let council: [Commander]?
        let status: Client.StatusResponse

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            news = try container.decode(News.self, forKey: .news)
            scrap = try container.decodeIfPresent(Int.self, forKey: .scrap)
            base = try container.decode(Base.self, forKey: .base)
            council = try container.decodeIfPresent([Commander].self, forKey: .council)
            status = try container.decode(Client.StatusResponse.self, forKey: .status)
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
