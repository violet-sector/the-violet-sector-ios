//
//  TimerView.swift
//  The Violet Sector
//
//  Created by João Santos on 01/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var timer = Timer.shared

    var body: some View {
        HStack(spacing: 20.0) {
            Text("Turn \(timer.turn)")
            Text(String(format: "%ld:%02ld:%02ld", timer.hours, timer.minutes, timer.seconds))
        }
    }
}
