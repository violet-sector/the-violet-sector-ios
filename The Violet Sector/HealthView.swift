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
    let showLabel: Bool

    var body: some View {
        var text = Text(verbatim: showLabel ? "Hitpoints: " : "")
        if current > max * 2 / 3 {
            text = text + Text(verbatim: "\(current)").bold().foregroundColor(Color(.sRGB, red: 0.0, green: 0.5, blue: 0.0, opacity: 1.0))
        } else if current > max / 3 {
            text = text + Text(verbatim: "\(current)").bold().foregroundColor(.orange)
        } else {
            text = text + Text(verbatim: "\(current)").bold().foregroundColor(.red)
        }
        return text + Text(verbatim: "/\(max)")
    }

    init(current: UInt, max: UInt, showLabel: Bool = false) {
        self.current = current
        self.max = max
        self.showLabel = showLabel
    }
}
