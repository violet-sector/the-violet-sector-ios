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
