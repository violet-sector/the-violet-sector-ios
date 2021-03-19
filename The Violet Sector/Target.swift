// Created by João Santos for project The Violet Sector.

struct Target: Decodable, Identifiable, Equatable {
    let id: Identifier
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
    let canDock: Bool?
    let canRepair: Bool?
    let isOnline: Bool

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        name = try container.decode(String.self, forKey: .name)
        if id > 0 {
            self.id = .intValue(id)
        } else {
            self.id = .stringValue(name)
        }
        legion = try container.decode(Legions.self, forKey: .legion)
        level = try container.decode(Int.self, forKey: .level)
        currentHealth = try container.decode(Int.self, forKey: .currentHealth)
        maxHealth = try container.decode(Int.self, forKey: .maxHealth)
        ship = try container.decode(Ships.self, forKey: .ship)
        score = try container.decode(Int.self, forKey: .score)
        isCloaked = try container.decodeIfPresent(Bool.self, forKey: .isCloaked)
        kills = try container.decodeIfPresent(Int.self, forKey: .kills)
        deaths = try container.decodeIfPresent(Int.self, forKey: .deaths)
        canDock = try container.decodeIfPresent(Bool.self, forKey: .canDock)
        canRepair = try container.decodeIfPresent(Bool.self, forKey: .canRepair)
        isOnline = try container.decode(Bool.self, forKey: .isOnline)
    }

    static func ==(_ left: Self, _ right: Self) -> Bool {
        return left.id == right.id
    }

    enum CodingKeys: String, CodingKey {
        case id
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
        case canDock = "can_enter"
        case canRepair = "can_repair"
        case isOnline = "online"
    }

    enum Identifier: Hashable {
        case intValue(Int)
        case stringValue(String)

        func hash(into hasher: inout Hasher) {
            switch self {
            case let .intValue(value):
                hasher.combine(value)
            case let .stringValue(value):
                hasher.combine(value)
            }
        }
    }
}
