// Created by João Santos for project The Violet Sector.

import Combine

final class Model<Data: Decodable>: ObservableObject, Refreshable {
    @Published private(set) var data: Data? {didSet {if data != nil {request = nil}}}
    @Published private(set) var error: Error? {didSet {if error != nil {request = nil}}}
    private var request: Cancellable? {didSet {if request != nil {data = nil; error = nil}}}
    private let resource: String

    init(resource: String) {
        self.resource = resource
    }

    func refresh(force: Bool) {
        guard force || request == nil else {
            return
        }
        request = Client.shared.fetch(resource, setResponse: \.data, setFailure: \.error, on: self)
    }
}
