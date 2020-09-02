//
//  Fetchable.swift
//  The Violet Sector
//
//  Created by João Santos on 01/09/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

import Foundation
import Combine

protocol Fetchable: AnyObject {
    associatedtype Response: Decodable

    var error: String? {get set}
    var response: Response? {get set}

    static var resource: String {get}

    func handleError(_: Error)
}

extension Fetchable {
    func handleError(_ error: Error) {
        var message = String()
        switch error {
        case _ as DecodingError:
            message = "Error decoding information from the server."
        case let error as LocalizedError:
            message = error.errorDescription ?? "Unknown error."
        case let error as NSError:
            message = error.localizedDescription
        default:
            message = "Unknown error."
        }
        self.error = message
    }
}
