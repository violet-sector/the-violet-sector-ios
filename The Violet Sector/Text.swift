// Created by João Santos for project The Violet Sector.

import SwiftUI

extension Text {
    init(health: Int, maxHealth: Int, asPercentage: Bool) {
        var color = Color(.sRGB, red: 0.0, green: 1.0, blue: 1.0, opacity: 1.0)
        switch health {
        case ...0:
            color = Color(.sRGB, red: 0.25, green: 0.25, blue: 0.25, opacity: 1.0)
        case 1...(maxHealth / 2):
            color = Color(.sRGB, red: 1.0, green: Double(health - 1) / Double(maxHealth / 2 - 1), blue: 0.0, opacity: 1.0)
        case (maxHealth / 2 + 1)...maxHealth:
            color = Color(.sRGB, red: 1.0 - Double(health - maxHealth / 2 - 1) / Double(maxHealth / 2 - 1), green: 1.0, blue: 0.0, opacity: 1.0)
        default:
            break
        }
        if health <= 0 {
            self = Text(verbatim: "Destroyed").bold().foregroundColor(color)
            return
        }
        if asPercentage {
            self = Text(verbatim: String(health * 100 / maxHealth)).bold().foregroundColor(color)
            self = self + Text(verbatim: "%")
            return
        }
        self = Text(verbatim: String(health)).bold().foregroundColor(color)
        self = self + Text(verbatim: "/\(maxHealth)")
        self = self.font(.system(.body, design: .monospaced))
    }
}
