// Created by João Santos for project The Violet Sector.

import Combine

final class Model<Data: Decodable>: ObservableObject, Refreshable {
    @Published private(set) var data: Data? {didSet {request = nil}}
    @Published private(set) var error: Error? {didSet {request = nil}}
    private var request: Cancellable?
    private let resource: String

    init(resource: String) {
        self.resource = resource
        refresh()
    }

    func refresh() {
        guard request == nil else {
            return
        }
        data = nil
        error = nil
        request = Client.shared.fetch(resource, setResponse: \.data, setFailure: \.error, on: self)
    }
}
