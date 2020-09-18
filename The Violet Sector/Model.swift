// Created by João Santos for project The Violet Sector.

import Combine

final class Model<Data: Decodable>: ObservableObject, Refreshable {
    @Published private(set) var data: Data?
    @Published private(set) var error: Error?
    private var request: Cancellable?
    private let resource: String

    init(resource: String) {
        self.resource = resource
        Client.shared.refreshable = self
        refresh()
    }

    func refresh() {
        data = nil
        error = nil
        request = Client.shared.fetch(resource, setResponse: \.data, setFailure: \.error, on: self)
    }
}
