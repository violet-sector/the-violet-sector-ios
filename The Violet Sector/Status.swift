// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Status: View {
    var data: Data?
    private static var savedData: Data?

    var body: some View {
        Group {
            if data != nil {
                VStack() {
                    HStack() {
                        Text(verbatim: "\(data!.moves) \(data!.moves != 1 ? "Moves" : "Move")")
                        Health(current: data!.currentHealth, max: data!.maxHealth)
                            .percentage()
                        Text(verbatim: (data!.destinationSector == .none ? "\(data!.currentSector)" : "Hypering to \(data!.destinationSector)") + (data!.isSleeping ? " (zZzZ)" : "") + (data!.isCloaked ? " (Cloaked)" : "") + (data!.isInvulnerable ? " (Invulnerable)" : ""))
                    }
                    .accessibilityElement(children: .combine)
                    Timer()
                }
            } else {
                Timer()
            }
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
        let currentHealth: UInt
        let maxHealth: UInt
        let moves: UInt
        let currentSector: Sectors
        let destinationSector: Sectors
        let isCloaked: Bool
        let isInvulnerable: Bool
        let isSleeping: Bool

        private enum CodingKeys: String, CodingKey {
            case currentHealth = "hp"
            case maxHealth = "maxhp"
            case moves
            case currentSector = "sector"
            case destinationSector = "destination"
            case isCloaked = "cloaked"
            case isInvulnerable = "invulnerable"
            case isSleeping = "sleep_tick"
        }
    }
}
