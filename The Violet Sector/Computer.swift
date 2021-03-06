// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Computer: View {
    var body: some View {
        Page(title: "Computer", resource: "main.php") {(_ data: Data) in
            GeometryReader() {(geometry) in
                ScrollView() {
                    VStack(spacing: 10.0) {
                        let details = [
                            (name: "Pilot Name", value: Text(verbatim: data.status.name)),
                            (name: "Score", value: Text(verbatim: String(data.status.score))),
                            (name: "Hitpoints", value: Text(health: data.status.currentHealth, maxHealth: data.status.maxHealth, asPercentage: false)),
                            (name: "Sector", value: Text(verbatim: makeSectorString(status: data.status))),
                            (name: "Scrap in Sector", value: data.scrap != nil ? Text(verbatim: String(data.scrap!)) : nil),
                            (name: "Base Hitpoints", value: Text(health: data.base.currentHealth, maxHealth: data.base.maxHealth, asPercentage: false)),
                            (name: "Council", value: Text(verbatim: makeCouncilString(council: data.council)))
                        ]
                        Details(details: details, geometry: geometry)
                        Text(verbatim: makeNewsString(news: data.news))
                            .multilineTextAlignment(.leading)
                            .padding(5.0)
                            .border(Color.primary)
                            .frame(width: geometry.size.width - 10.0)
                    }
                }
            }
        }
    }

    private func makeSectorString(status: Status.Data) -> String {
        var sector = status.currentSector.description
        if status.destinationSector != .none {
            sector = "Hypering to " + status.destinationSector.description
        }
        if status.isSleeping {
            sector += " (zZzZ)"
        }
        if status.isCloaked {
            sector += " (Cloaked)"
        }
        if status.isInvulnerable {
            sector += " (Invulnerable)"
        }
        return sector
    }

    private func makeCouncilString(council: [Data.Commander]) -> String {
        var councilString = ""
        for commander in council {
            if !councilString.isEmpty {
                councilString += "\n"
            }
            councilString += commander.name
            if commander.isOnline {
                councilString += "*"
            }
            if commander.responsibility == 3 {
                councilString += " (LC)"
            } else {
                councilString += " (VC)"
            }
        }
        return councilString
    }

    private func makeNewsString(news: Data.News) -> String {
        var newsString = "Set by " + news.author
        newsString += " on turn " + String(news.turn) + " (" + DateFormatter.localizedString(from: Date(timeIntervalSince1970: TimeInterval(news.time)), dateStyle: .short, timeStyle: .short) + ")"
        newsString += "\n\n" + news.text
        return newsString
    }

    private struct Data: Decodable {
        let news: News
        let scrap: UInt?
        let base: Base
        let council: [Commander]
        let status: Status.Data

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            news = try container.decode(News.self, forKey: .news)
            scrap = try container.decodeIfPresent(UInt.self, forKey: .scrap)
            base = try container.decode(Base.self, forKey: .base)
            council = try container.decode([Commander].self, forKey: .council)
            status = try container.decode(Status.Data.self, forKey: .status)
        }
        private enum CodingKeys: String, CodingKey {
            case news = "legion_news"
            case scrap = "scrap"
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
            let currentHealth: UInt
            let maxHealth: UInt

            private enum CodingKeys: String, CodingKey {
                case currentHealth = "hp"
                case maxHealth = "maxhp"
            }
        }

        struct Commander: Decodable {
            let name: String
            let responsibility: UInt
            let isOnline: Bool

            enum CodingKeys: String, CodingKey {
                case name = "tvs_username"
                case responsibility = "lc"
                case isOnline = "online"
            }
        }
    }
}
