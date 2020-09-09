// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TimerView: View {
    @ObservedObject var model = TimerModel.shared

    var body: some View {
        Group () {
            if model.error == nil {
                HStack(spacing: 20.0) {
                    Text(verbatim: "Turn \(model.turn)")
                    Text(verbatim: String(format: "%ld:%02ld:%02ld", model.hours, model.minutes, model.seconds))
                }
            } else {
                Text(verbatim: "Timer Error")
            }
        }
    }
}
