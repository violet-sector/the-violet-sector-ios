//
//  Ships.swift
//  The Violet Sector
//
//  Created by João Santos on 20/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

enum Ships: UInt, Decodable, CustomStringConvertible {
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
        case .ajaxianRepairer, .boraxianRepairer, .krilgorianRepairer, .tibranRepairer:
            return "Repair Ship"
        case .ajaxianCarrier, .boraxianCarrier, .krilgorianCarrier, .tibranCarrier:
            return "Carrier"
        case .ajaxianCruiser, .boraxianCruiser, .krilgorianCruiser, .tibranCruiser:
            return "Cruiser"
        }
    }
}
