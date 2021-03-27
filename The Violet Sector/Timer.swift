// Created by João Santos for project The Violet Sector.

import Foundation
import Dispatch
import Combine
import SwiftUI

struct Timer: View {
    @StateObject private var model = Model()

    var body: some View {
        Text(verbatim: model.timer)
            .font(.system(.body, design: .monospaced))
    }

    private struct Data: Decodable {
        let turnDuration: Int64
        let referenceTurn: Int64
        let remainingTime: Int64
        let serverTime: Int64

        private enum CodingKeys: String, CodingKey {
            case turnDuration = "tick_length"
            case referenceTurn = "tick"
            case remainingTime = "secs_left"
            case serverTime = "now"
        }
    }

    private final class Model: ObservableObject {
        @Published private(set) var timer = "Loading..."
        private var responseSubscriber: Cancellable?
        private var timerSubscriber: Cancellable?
        private var data: Data?
        private var referenceTime: Int64 = 0
        private var referenceTurn: Int64 = 0
        private var turnDuration: Int64 = 0
        private var serverHour: Int64 = 0
        private var deltaTime: Int64 = 0

        private static let resource = "timer.php"
        private static let retryInterval = TimeInterval(5.0)

        init() {
            fetch()
        }

        private func fetch() {
            guard responseSubscriber == nil else {
                return
            }
            responseSubscriber = Client.shared.get(Self.resource, setResponse: \.data, on: self) {[unowned self] in
                responseSubscriber = nil
                if data == nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Self.retryInterval, execute: {fetch()})
                } else {
                    setup()
                }
            }
        }

        private func setup() {
            guard let data = data, data.turnDuration > 0 else {
                return
            }
            turnDuration = data.turnDuration
            referenceTurn = data.referenceTurn
            let currentTime = Int64(Date().timeIntervalSince1970)
            referenceTime = currentTime - (turnDuration - data.remainingTime)
            deltaTime = currentTime - data.serverTime
            serverHour = data.serverTime - data.serverTime % (60 * 60)
            timerSubscriber = Foundation.Timer.publish(every: 1.0, on: .main, in: .default)
                .autoconnect()
                .sink() {[unowned self] (date) in
                    let currentTime = Int64(date.timeIntervalSince1970)
                    var elapsedTime = currentTime - self.referenceTime
                    let turn = referenceTurn + elapsedTime / turnDuration
                    elapsedTime %= turnDuration
                    var remainingTime = turnDuration - elapsedTime
                    let hours = remainingTime / (60 * 60)
                    remainingTime %= 60 * 60
                    let minutes = remainingTime / 60
                    remainingTime %= 60
                    let seconds = remainingTime
                    timer = String(format: "T%ld %ld:%02ld:%02ld", turn, hours, minutes, seconds)
                    if currentTime - deltaTime - serverHour >= 60 * 60 && currentTime % 5 == 0 {
                        fetch()
                    }
                }
        }
    }
}
