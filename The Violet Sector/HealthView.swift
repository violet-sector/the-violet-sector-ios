//
//  HealthView.swift
//  The Violet Sector
//
//  Created by João Santos on 20/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import SwiftUI

struct HealthView: View {
    let current: UInt
    let max: UInt

    var body: some View {
        if max > 0 {
            var currentView = Text("\(current)")
            if current > max * 2 / 3 {
                currentView = currentView.foregroundColor(Color(.sRGB, red: 0.0, green: 0.5, blue: 0.0, opacity: 1.0))
            } else if current > max / 3 {
                currentView = currentView.foregroundColor(.orange).fontWeight(.bold)
            } else {
                currentView = currentView.foregroundColor(.red).fontWeight(.bold)
            }
            return HStack(spacing: 0.0) {
                currentView
                Text("/\(max)")
            }
            .accessibilityElement(children: .combine)
            .accessibility(label: Text("\(current)/\(max)"))
        } else {
            return HStack(spacing: 0.0) {
                Text("-")
                Text("/-")
            }
            .accessibilityElement(children: .combine)
            .accessibility(label: Text("Unknown"))
        }
    }
}
