// Created by João Santos for project The Violet Sector.

enum Ships: Int, Decodable, CustomStringConvertible {
    case none
    case planet
    case ajaxianFighter1
    case ajaxianFighter2
    case boraxianFighter1
    case boraxianFighter2
    case krilgorianFighter1
    case krilgorianFighter2
    case krilgorianFighter3
    case tibranFighter1
    case tibranFighter2
    case tibranFighter3
    case ajaxianCloaker
    case boraxianCloaker
    case krilgorianCloaker
    case tibranCloaker
    case ajaxianBomber
    case boraxianBomber
    case ajaxianRegeneratingBomber
    case boraxianRegeneratingBomber
    case krilgorianRegeneratingBomber
    case tibranRegeneratingBomber
    case ajaxianRepairer
    case boraxianRepairer
    case krilgorianRepairer
    case tibranRepairer
    case ajaxianCarrier
    case boraxianCarrier
    case krilgorianCarrier
    case tibranCarrier
    case ajaxianCruiser
    case boraxianCruiser
    case krilgorianCruiser
    case tibranCruiser

    var description: String {
        switch self {
        case .none:
            return "Star"
        case .planet:
            return "Planet"
        case .ajaxianFighter1:
            return "Goliath Mark II"
        case .ajaxianFighter2:
            return "Flight Of Independence"
        case .boraxianFighter1:
            return "Fanged Fighter"
        case .boraxianFighter2:
            return "Golden Eagle"
        case .krilgorianFighter1:
            return "Microw Fighter"
        case .krilgorianFighter2:
            return "Demon Light Attacker"
        case .krilgorianFighter3:
            return "Black Knight"
        case .tibranFighter1:
            return "The Stinger"
        case .tibranFighter2:
            return "Starship Fighter"
        case .tibranFighter3:
            return "Sonic Speed Fighter"
        case .ajaxianCloaker:
            return "Eagle Of Tunardia"
        case .boraxianCloaker:
            return "Shadow"
        case .krilgorianCloaker:
            return "Cloud Of Death"
        case .tibranCloaker:
            return "Mirage Mk III"
        case .ajaxianBomber:
            return "Galactic Bomber Alpha"
        case .boraxianBomber:
            return "Hercules Bomber"
        case .ajaxianRegeneratingBomber:
            return "Blue Bird Bomber"
        case .boraxianRegeneratingBomber:
            return "Boraxian Bomber"
        case .krilgorianRegeneratingBomber:
            return "Dark Speed Bomber"
        case .tibranRegeneratingBomber:
            return "Single Seated Tibran Bomber"
        case .ajaxianRepairer:
            return "Ajaxian Repair Ship"
        case .boraxianRepairer:
            return "Boraxian Repair Ship"
        case .krilgorianRepairer:
            return "Krilgorian Repair Ship"
        case .tibranRepairer:
            return "Tibran Repair Ship"
        case .ajaxianCarrier:
            return "Ajaxian Carrier"
        case .boraxianCarrier:
            return "Boraxian Carrier"
        case .krilgorianCarrier:
            return "Krilgorian Carrier"
        case .tibranCarrier:
            return "Tibran Carrier"
        case .ajaxianCruiser:
            return "Ajaxian Cruiser"
        case .boraxianCruiser:
            return "Boraxian Cruiser"
        case .krilgorianCruiser:
            return "Krilgorian Cruiser"
        case .tibranCruiser:
            return "Tibran Cruiser"
        }
    }

    var isFighter: Bool {
        switch self {
        case .ajaxianFighter1, .ajaxianFighter2, .boraxianFighter1, .boraxianFighter2, .krilgorianFighter1, .krilgorianFighter2, .krilgorianFighter3, .tibranFighter1, .tibranFighter2, .tibranFighter3, .ajaxianCruiser, .boraxianCruiser, .krilgorianCruiser, .tibranCruiser:
            return true
        default:
            return false
        }
    }

    var isCloaker: Bool {
        switch self {
        case .ajaxianCloaker, .boraxianCloaker, .krilgorianCloaker, .tibranCloaker:
            return true
        default:
            return false
        }
    }

    var isBomber: Bool {
        switch self {
        case .ajaxianBomber, .boraxianBomber, .ajaxianRegeneratingBomber, .boraxianRegeneratingBomber, .krilgorianRegeneratingBomber, .tibranRegeneratingBomber, .ajaxianCruiser, .boraxianCruiser, .krilgorianCruiser, .tibranCruiser:
            return true
        default:
            return false
        }
    }

    var isRepairer: Bool {
        switch self {
        case .ajaxianRepairer, .boraxianRepairer, .krilgorianRepairer, .tibranRepairer, .ajaxianCarrier, .boraxianCarrier, .krilgorianCarrier, .tibranCarrier:
            return true
        default:
            return false
        }
    }

    var isCruiser: Bool {
        switch self {
        case .ajaxianCruiser, .boraxianCruiser, .krilgorianCruiser, .tibranCruiser:
            return true
        default:
            return false
        }
    }

    var isCarrier: Bool {
        switch self {
        case .ajaxianCarrier, .boraxianCarrier, .krilgorianCarrier, .tibranCarrier:
            return true
        default:
            return false
        }
    }

    var isCapital: Bool {return self.isCruiser || self.isCarrier}

    var type: String {
        if self.isCruiser {return "Fighter and Bomber (Capital)"}
        if self.isCarrier {return "Repairer and Carrier (Capital)"}
        if self.isFighter {return "Fighter"}
        if self.isCloaker {return "Cloaker"}
        if self.isBomber {return "Bomber"}
        if self.isRepairer {return "Repairer"}
        return "Planet"
    }
}
