//
//  Status.swift
//  The Violet Sector
//
//  Created by João Santos on 18/08/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

struct Status: Decodable {
    let name: String
    let currentHealth: UInt
    let maxHealth: UInt
    let moves: UInt
    let score: UInt
    let currentSector: Sectors
    let destinationSector: Sectors
    let isCloaked: Bool
    let isInvulnerable: Bool
    let isSleeping: Bool

    enum CodingKeys: String, CodingKey {
        case name = "tvs_username"
        case currentHealth = "hp"
        case maxHealth = "maxhp"
        case moves
        case score
        case currentSector = "sector"
        case destinationSector = "destination"
        case isCloaked = "cloaked"
        case isInvulnerable = "invulnerable"
        case isSleeping = "sleep_tick"
    }
}
