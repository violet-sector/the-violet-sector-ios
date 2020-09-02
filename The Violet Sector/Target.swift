//
//  Target.swift
//  The Violet Sector
//
//  Created by João Santos on 20/08/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

struct Target: Decodable {
    let name: String
    let legion: Legions
    let level: UInt
    let currentHealth: UInt
    let maxHealth: UInt
    let ship: Ships
    let score: UInt
    let isCloaked: Bool?
    let kills: UInt?
    let deaths: UInt?
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
        case isOnline = "online"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        legion = try container.decode(Legions.self, forKey: .legion)
        level = try container.decode(UInt.self, forKey: .level)
        currentHealth = try container.decode(UInt.self, forKey: .currentHealth)
        maxHealth = try container.decode(UInt.self, forKey: .maxHealth)
        ship = try container.decode(Ships.self, forKey: .ship)
        score = try container.decode(UInt.self, forKey: .score)
        isCloaked = try container.decodeIfPresent(Bool.self, forKey: .isCloaked)
        kills = try container.decodeIfPresent(UInt.self, forKey: .kills)
        deaths = try container.decodeIfPresent(UInt.self, forKey: .deaths)
        isOnline = try container.decode(Bool.self, forKey: .isOnline)
}
}
