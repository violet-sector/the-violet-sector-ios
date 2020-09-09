// Created by João Santos for project The Violet Sector.

import Foundation
import Combine

protocol Fetchable: AnyObject {
    associatedtype Response: Decodable

    var error: Error? {get set}
    var response: Response? {get set}

    static var resource: String {get}
}
