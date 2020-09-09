// Created by João Santos for project The Violet Sector.

import SwiftUI

struct HealthView: View {
    let current: UInt
    let max: UInt
    private let asPercentage: Bool
    private let color: Color

    var body: some View {
        guard current > 0 else {
            return Text("Destroyed").bold().foregroundColor(color)
        }
        if !asPercentage {
            return Text(verbatim: "\(current)").bold().foregroundColor(color).bold() + Text("/\(max)")
        }
        return Text("\(current * 100 / max)%").foregroundColor(color)
    }

    init(current: UInt, max: UInt) {
        self.current = current
        self.max = max
        asPercentage = false
        switch current {
        case 0:
            color = Color(.sRGB, red: 0.25, green: 0.25, blue: 0.25, opacity: 1.0)
        case 1...(max / 2):
            color = Color(.sRGB, red: 1.0, green: Double(current - 1) / Double(max / 2 - 1), blue: 0.0, opacity: 1.0)
        case (max / 2 + 1)...max:
            color = Color(.sRGB, red: 1.0 - Double(current - max / 2 - 1) / Double(max / 2 - 1), green: 1.0, blue: 0.0, opacity: 1.0)
        default:
            color = Color(.sRGB, red: 0.0, green: 1.0, blue: 1.0, opacity: 1.0)
        }
    }

    private init(original: HealthView, asPercentage: Bool) {
        current = original.current
        max = original.max
        self.asPercentage = asPercentage
        color = original.color
    }

    func percentage() -> HealthView {
        return HealthView(original: self, asPercentage: true)
    }
}
