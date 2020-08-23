//
//  StatusModel.swift
//  The Violet Sector
//
//  Created by João Santos on 23/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import Combine

final class StatusModel: ObservableObject {
    @Published private(set) var isReady = false
    @Published private(set) var moves: UInt = 0
    @Published private(set) var currentHealth: UInt = 0
    @Published private(set) var maxHealth: UInt = 0
    @Published private(set) var currentSector = Sectors.none
    @Published private(set) var destinationSector = Sectors.none
    @Published private(set) var isSleeping = false
    @Published private(set) var isCloaked = false
    @Published private(set) var isInvulnerable = false

    static let shared = StatusModel()

    private init() {}

    func update(status: Status) {
        moves = status.moves
        currentHealth = status.currentHealth
        maxHealth = status.maxHealth
        currentSector = status.currentSector
        destinationSector = status.destinationSector
        isSleeping = status.isSleeping
        isCloaked = status.isCloaked
        isInvulnerable = status.isInvulnerable
        isReady = true
    }
}
