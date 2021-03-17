// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Computer: View {
    @ObservedObject var model: Model<Data>
    @ObservedObject private var client = Client.shared

    var body: some View {
        Page(title: "Computer", model: model) {(data) in
            GeometryReader() {(geometry) in
                ScrollView() {
                    VStack(spacing: 10.0) {
                        Image("Ships/\(data.status.ship)")
                            .accessibilityLabel(data.status.ship.description)
                        Text(health: data.status.currentHealth, maxHealth: data.status.maxHealth, asPercentage: false)
                        Text(verbatim: "\(data.status.ship)\nPiloted by level \(data.status.level) \(data.status.legion) \(data.status.name)\n\(makeSectorString(data: data))")
                        HStack() {
                            if data.status.currentHealth < data.status.maxHealth && data.status.currentHealth > 0 && data.status.moves >= client.settings?.movesToSelfRepair ?? 0 {
                                Button("Repair", action: {client.post("self_rep.php", query: [:], completionHandler: {model.refresh()})})
                                    .frame(width: 80.0)
                            }
                            if data.status.ship.isCloaker && !data.status.isCloaked && data.status.moves >= client.settings?.movesToCloak ?? 0 && data.status.carrier.name == nil {
                                Button("Cloak", action: {client.post("cloak_on.php", query: [:], completionHandler: {model.refresh()})})
                                    .frame(width: 80.0)
                            }
                            if data.status.isCloaked && data.status.moves >= client.settings?.movesToDecloak ?? 0 {
                                Button("Decloak", action: {client.post("cloak_off.php", query: [:], completionHandler: {model.refresh()})})
                                    .frame(width: 80.0)
                            }
                            if data.status.carrier.name != nil {
                                Button("Undock", action: {client.post("carrier_exit.php", query: [:], completionHandler: {model.refresh()})})
                                    .frame(width: 80.0)
                            }
                        }
                        Description() {
                            if let scrap = data.scrap {
                                DescriptionItem(name: "Scrap") {Text(verbatim: String(scrap))}
                            }
                            DescriptionItem(name: "Base Status") {Text(health: data.base.currentHealth, maxHealth: data.base.maxHealth, asPercentage: false)}
                            DescriptionItem(name: "Reputation") {Text(verbatim: String(data.status.score))}
                        }
                        Text("Legion News")
                            .bold()
                            .accessibilityAddTraits(.isHeader)
                        Text(verbatim: makeNewsString(data: data))
                            .multilineTextAlignment(.leading)
                            .padding(5.0)
                            .border(Color.primary)
                            .frame(width: geometry.size.width - 10.0)
                        Text(verbatim: "Council")
                            .bold()
                            .accessibilityAddTraits(.isHeader)
                        Text(verbatim: makeCouncilString(data: data))
                    }
                }
            }
        }
    }

    private func makeSectorString(data: Data) -> String {
        var sector = "In " + data.status.currentSector.description
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
        if let name = data.status.carrier.name, let isOnline = data.status.carrier.isOnline {
            sector += " (inside \(name + (isOnline ? "*" : "")))"
        }
        return sector
    }

    private func makeCouncilString(data: Data) -> String {
        guard let council = data.council else {
            return "None"
        }
        var councilString = ""
        for commander in council {
            if !councilString.isEmpty {
                councilString += ", "
            }
            councilString += commander.name.replacingOccurrences(of: " ", with: "\u{00a0}")
            if commander.isOnline {
                councilString += "*"
            }
            if commander.responsibility == 3 {
                councilString += "\u{00a0}(LC)"
            } else {
                councilString += "\u{00a0}(VC)"
            }
        }
        return councilString
    }

    private func makeNewsString(data: Data) -> String {
        var newsString = "Set by " + data.news.author
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
