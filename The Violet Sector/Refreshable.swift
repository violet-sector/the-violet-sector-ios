// Created by João Santos for project The Violet Sector.

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
