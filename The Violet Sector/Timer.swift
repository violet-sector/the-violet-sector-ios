// Created by João Santos for project The Violet Sector.

import SwiftUI
import Combine
import Foundation

struct Timer: View {
    @ObservedObject private var model = Model.shared

    var body: some View {
        HStack(spacing: 20.0) {
            Text(verbatim: "Turn \(model.turn)")
            Text(verbatim: String(format: "%ld:%02ld:%02ld", model.hours, model.minutes, model.seconds))
        }
    }

    private final class Model: ObservableObject {
        @Published private(set) var turn: Int64 = 0
        @Published private(set) var hours: Int64 = 0
        @Published private(set) var minutes: Int64 = 0
        @Published private(set) var seconds: Int64 = 0
        private var data: Data? {didSet {setup()}}
        private var error: Error? {didSet {lastErrorTime = Int64(Date().timeIntervalSince1970)}}
        private var request: Cancellable?
        private var timer: Cancellable?
        private var referenceTime: Int64 = 0
        private var referenceTurn: Int64 = 0
        private var turnDuration: Int64 = 0
        private var lastErrorTime: Int64 = 0

        static let shared = Model()

        init() {
            refresh()
        }

        private func refresh() {
            error = nil
            request = Client.shared.fetch("timer.php", setResponse: \.data, setFailure: \.error, on: self)
        }

        private func setup() {
            guard let data = data else {
                return
            }
            guard data.turnDuration != 0 else {
                return
            }
            turnDuration = data.turnDuration
            referenceTurn = data.referenceTurn
            referenceTime = Int64(Date().timeIntervalSince1970) - (turnDuration - data.remainingTime)
            timer = Foundation.Timer.publish(every: 1.0, on: .main, in: .default)
                .autoconnect()
                .sink() {[unowned self] (date) in
                    let currentTime = Int64(date.timeIntervalSince1970)
                    var elapsedTime = currentTime - self.referenceTime
                    self.turn = self.referenceTurn + elapsedTime / self.turnDuration
                    elapsedTime %= self.turnDuration
                    var remainingTime = self.turnDuration - elapsedTime
                    self.hours = remainingTime / (60 * 60)
                    remainingTime %= 60 * 60
                    self.minutes = remainingTime / 60
                    remainingTime %= 60
                    self.seconds = remainingTime
                    if currentTime - self.referenceTime >= 60 * 60 && currentTime - self.lastErrorTime >= 5 {
                        self.refresh()
                    }
            }
        }

        struct Data: Decodable {
            let turnDuration: Int64
            let referenceTurn: Int64
            let remainingTime: Int64

            private enum CodingKeys: String, CodingKey {
                case turnDuration = "tick_length"
                case referenceTurn = "tick"
                case remainingTime = "secs_left"
            }
        }
    }
}
