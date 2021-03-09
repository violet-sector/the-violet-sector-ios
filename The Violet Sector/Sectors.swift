// Created by João Santos for project The Violet Sector.

enum Sectors: Int, Decodable, CustomStringConvertible {
    case none
    case home1
    case home2
    case home3
    case home4
    case giant1
    case giant2
    case giant3
    case giant4
    case giant5
    case giant6
    case giant7
    case giant8
    case quadrant1
    case quadrant2
    case quadrant3
    case quadrant4
    case outer1
    case outer2
    case outer3
    case outer4
    case outer5
    case outer6
    case outer7
    case outer8
    case asteroids
    case violet
    case uncharted

    var description: String {
        switch self {
        case .none:
            return "No Sector"
        case .home1:
            return "Ajaxus Home"
        case .home2:
            return "Boraxus"
        case .home3:
            return "Planet Krilgore"
        case .home4:
            return "Tibrar"
        case .giant1:
            return "Apollo Sector"
        case .giant2:
            return "81103"
        case .giant3:
            return "Red Sky City"
        case .giant4:
            return "Dreadlar"
        case .giant5:
            return "Southern Sector"
        case .giant6:
            return "Moons of Kaarp"
        case .giant7:
            return "Canopus West"
        case .giant8:
            return "The Three Suns"
        case .quadrant1:
            return "Tripe"
        case .quadrant2:
            return "Orbital"
        case .quadrant3:
            return "Aquarious"
        case .quadrant4:
            return "Garen"
        case .outer1:
            return "Star City"
        case .outer2:
            return "Dragor"
        case .outer3:
            return "Durius Highlands"
        case .outer4:
            return "Perosis"
        case .outer5:
            return "Mattas Head"
        case .outer6:
            return "Acrador"
        case .outer7:
            return "The Tibran Mining Colony"
        case .outer8:
            return "C.T.6"
        case .asteroids:
            return "The Asteroid Fields"
        case .violet:
            return "New Sector Alpha"
        case .uncharted:
            return "The Uncharted Sector"
        }
    }
}
