//
//  Fetchable.swift
//  The Violet Sector
//
//  Created by João Santos on 01/09/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

protocol Fetchable: AnyObject {
    associatedtype Response: Decodable

    var response: Response? {get set}

    static var resource: String {get}
}
