//
//  Legions.swift
//  The Violet Sector
//
//  Created by João Santos on 20/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

enum Legions: UInt, Decodable, CustomStringConvertible {
    case none
    case ajaxian
    case boraxian
    case krilgorian
    case tibran
    case rogue

    var description: String {
        switch self {
        case .none:
            return "Earthling"
        case .ajaxian:
            return "Ajaxian"
        case .boraxian:
            return "Boraxian"
        case .krilgorian:
            return "Krilgorian"
        case .tibran:
            return "Tibran"
        case .rogue:
            return "Rogue"
        }
    }

    var color: (red: Double, green: Double, blue: Double) {
        switch self {
        case .none:
            return (red: 1.0, green: 1.0, blue: 1.0)
        case .ajaxian:
            return (red:0.0, green: 0.0, blue: 3.0 / 4.0)
        case .boraxian:
            return (red: 1.0, green: 1.0, blue: 1.0 / 4.0)
        case .krilgorian:
            return (red: 3.0 / 4.0, green: 0.0, blue: 0.0)
        case .tibran:
            return (red: 0.0, green: 3.0 / 8.0, blue: 0.0)
        case .rogue:
            return (red: 3.0 / 4.0, green: 3.0 / 4.0, blue: 3.0 / 4.0)
        }
    }
}
