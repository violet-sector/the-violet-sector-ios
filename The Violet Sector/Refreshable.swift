//
//  Refreshable.swift
//  The Violet Sector
//
//  Created by João Santos on 01/09/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

import Combine

protocol Refreshable: AnyObject {
    var request: Cancellable? {get set}

    func refresh()
}

extension Refreshable where Self: Fetchable {
    func refresh() {
        response = nil
        error = nil
        request = Client.shared.fetch(self)
    }
}
