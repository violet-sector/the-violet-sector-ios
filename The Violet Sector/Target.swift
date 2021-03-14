// Created by João Santos for project The Violet Sector.

struct Target: Decodable {
    let name: String
    let legion: Legions
    let level: Int
    let currentHealth: Int
    let maxHealth: Int
    let ship: Ships
    let score: Int
    let isCloaked: Bool?
    let kills: Int?
    let deaths: Int?
    let dock: Int?
    let repair: Int?
    let isOnline: Bool

    enum CodingKeys: String, CodingKey {
        case name = "tvs_username"
        case legion
        case level
        case currentHealth = "hp"
        case maxHealth = "maxhp"
        case ship
        case score
        case isCloaked = "cloaked"
        case kills
        case deaths
        case dock = "can_enter"
        case repair = "can_repair"
        case isOnline = "online"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        legion = try container.decode(Legions.self, forKey: .legion)
        level = try container.decode(Int.self, forKey: .level)
        currentHealth = try container.decode(Int.self, forKey: .currentHealth)
        maxHealth = try container.decode(Int.self, forKey: .maxHealth)
        ship = try container.decode(Ships.self, forKey: .ship)
        score = try container.decode(Int.self, forKey: .score)
        isCloaked = try container.decodeIfPresent(Bool.self, forKey: .isCloaked)
        kills = try container.decodeIfPresent(Int.self, forKey: .kills)
        deaths = try container.decodeIfPresent(Int.self, forKey: .deaths)
        dock = try container.decodeIfPresent(Int.self, forKey: .dock)
        repair = try container.decodeIfPresent(Int.self, forKey: .repair)
        isOnline = try container.decode(Bool.self, forKey: .isOnline)
    }
}
