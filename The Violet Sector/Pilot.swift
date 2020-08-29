//
//  Pilot.swift
//  The Violet Sector
//
//  Created by João Santos on 20/08/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

struct Pilot: Decodable {
    let name: String
    let legion: Legions
    let level: UInt
    let currentHealth: UInt
    let maxHealth: UInt
    let ship: Ships
    let score: UInt
    let kills: UInt
    let deaths: UInt
    let isOnline: Bool

    enum CodingKeys: String, CodingKey {
        case name = "tvs_username"
        case legion
        case level
        case currentHealth = "hp"
        case maxHealth = "maxhp"
        case ship
        case score
        case kills
        case deaths
        case isOnline = "online"
    }
}
