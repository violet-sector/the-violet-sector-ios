// Created by João Santos for project The Violet Sector.

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
