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
        Text(String(format: "%d:%02d:%02d T%d", timer.hours, timer.minutes, timer.seconds, timer.turn))
    }
}
