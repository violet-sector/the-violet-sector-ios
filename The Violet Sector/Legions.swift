// Created by João Santos for project The Violet Sector.

enum Legions: Int, Decodable, CustomStringConvertible {
    case none
    case ajaxian
    case boraxian
    case krilgorian
    case tibran
    case rogue

    var description: String {
        switch self {
        case .none:
            return "None"
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

    var base: Sectors {
        switch self {
        case .none:
            return .none
        case .ajaxian:
            return .home1
        case .boraxian:
            return .home2
        case .krilgorian:
            return .home3
        case .tibran:
            return .home4
        case .rogue:
            return .none
        }
    }
}
