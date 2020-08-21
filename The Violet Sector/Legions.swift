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
}
