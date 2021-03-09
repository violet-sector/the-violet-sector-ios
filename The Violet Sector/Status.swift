// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Status: View {
    var data: Data?
    private static var savedData: Data?
    
    var body: some View {
        VStack() {
            if let data = data {
                HStack() {
                    Text(verbatim: "\(data.moves) \(data.moves != 1 ? "Moves" : "Move")")
                    Text(health: data.currentHealth, maxHealth: data.maxHealth, asPercentage: true)
                    Text(verbatim: (data.destinationSector == .none ? "\(data.currentSector)" : "Hypering to \(data.destinationSector)") + (data.isSleeping ? " (zZzZ)" : "") + (data.isCloaked ? " (Cloaked)" : "") + (data.isInvulnerable ? " (Invulnerable)" : ""))
                }
                .accessibilityElement(children: .combine)
            }
            Timer()
        }
    }
    
    init(data: Data? = nil) {
        if let data = data {
            self.data = data
            Status.savedData = data
        } else {
            self.data = Status.savedData
        }
    }
    
    struct Data: Decodable {
        let name: String
        let currentHealth: Int
        let maxHealth: Int
        let moves: Int
        let score: Int
        let currentSector: Sectors
        let destinationSector: Sectors
        let isCloaked: Bool
        let isInvulnerable: Bool
        let isSleeping: Bool
        
        private enum CodingKeys: String, CodingKey {
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
}
