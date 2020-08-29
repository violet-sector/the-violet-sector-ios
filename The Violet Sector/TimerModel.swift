//
//  TimerModel.swift
//  The Violet Sector
//
//  Created by João Santos on 01/08/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

import Foundation
import Combine

final class TimerModel: ObservableObject {
    @Published private(set) var turn: Int64 = 0
    @Published private(set) var hours: Int64 = 0
    @Published private(set) var minutes: Int64 = 0
    @Published private(set) var seconds: Int64 = 0
    private var response: Response! {didSet {setup()}}
    private var referenceTime: Int64 = 0
    private var lastUpdate: Int64 = 0
    private var timer: Cancellable?
    private var request: Cancellable?
    
    static let shared = TimerModel()
    private static let resource = "timer.php"
    
    private init() {
        request = Client.shared.fetch(resource: TimerModel.resource, assignTo: \.response, on: self)
    }
    
    private func setup() {
        let currentTime = Int64(Date().timeIntervalSince1970)
        let elapsedTime = response.turnDuration - response.remainingTime
        referenceTime = currentTime - elapsedTime
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink() {[unowned self] (date) in
                let currentTime = Int64(date.timeIntervalSince1970)
                self.turn = self.response.referenceTurn + (currentTime - self.referenceTime) / self.response.turnDuration
                var remainingTime = self.response.turnDuration - (currentTime - self.referenceTime) % self.response.turnDuration
                self.hours = remainingTime / 60 / 60
                remainingTime -= self.hours * 60 * 60
                self.minutes = remainingTime / 60
                remainingTime -= self.minutes * 60
                self.seconds = remainingTime
                if self.lastUpdate < currentTime - currentTime % (60 * 60) {
                    self.lastUpdate = currentTime
                    self.request = Client.shared.fetch(resource: TimerModel.resource, assignTo: \.response, on: self)
                }
        }
    }
    
    struct Response: Decodable {
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
