//
//  Timer.swift
//  The Violet Sector
//
//  Created by João Santos on 01/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import Foundation
import Combine

final class Timer: ObservableObject {
    @Published private(set) var turn = 0
    @Published private(set) var hours = 0
    @Published private(set) var minutes = 0
    @Published private(set) var seconds = 0
    private var referenceTime = 0
    private var referenceTurn = 0
    private var turnDuration = 0
    private var object: Any = [String: Any]() {didSet {do {try setup()} catch {Client.shared.showError(error)}}}
    private var timer: Cancellable?
    private var request: Cancellable?

    static let shared = Timer()
    private static let url = URL(string: "https://www.violetsector.com/json/timer.php")!

    private init() {
        request = Client.shared.fetch(url: Timer.url, assignTo: \.object, on: self)
    }

    private func setup() throws {
        guard let object = object as? [String: Any] else {
            throw Errors.unrecognizedJSONStructure
        }
        guard let turnDuration = object["tick_length"] as? Int else {
            throw Errors.missingOrInvalidProperty("tick_length")
        }
        guard let referenceTurn = object["tick"] as? Int else {
            throw Errors.missingOrInvalidProperty("tick")
        }
        guard let remainingTime = object["secs_left"] as? Int else {
            throw Errors.missingOrInvalidProperty("secs_left")
        }
        self.turnDuration = turnDuration
        self.referenceTurn = referenceTurn
        let currentTime = Int(Date().timeIntervalSince1970)
        let elapsedTime = turnDuration - remainingTime
        referenceTime = currentTime - elapsedTime
        timer = Foundation.Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink() {[unowned self] (date) in
                let currentTime = Int(date.timeIntervalSince1970)
                self.turn = self.referenceTurn + (currentTime - self.referenceTime) / self.turnDuration
                var remainingTime = turnDuration - (currentTime - self.referenceTime) % self.turnDuration
                self.hours = remainingTime / 3600
                remainingTime -= self.hours * 3600
                self.minutes = remainingTime / 60
                remainingTime -= self.minutes * 60
                self.seconds = remainingTime
        }
    }

    enum Errors: LocalizedError {
        case unrecognizedJSONStructure
        case missingOrInvalidProperty(String)

        var errorDescription: String? {
            switch self {
            case .unrecognizedJSONStructure:
                return "The timer JSON structure returned by the server is unrecognized."
            case let .missingOrInvalidProperty(property):
                return "Missing or invalid type or value for timer property \"\(property)\"."
            }
        }
    }
}
