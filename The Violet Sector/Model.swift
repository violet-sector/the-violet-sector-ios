// Created by João Santos for project The Violet Sector.

import Combine

final class Model<Response: Decodable>: ModelProtocol, ObservableObject {
    @Published private(set) var response: Response?
    @Published private(set) var warning: String?
    @Published private(set) var error: String?
    @Published private(set) var isLoading = false
    private let resource: String
    private var subscriber: Cancellable?

    init(resource: String, responseType _: Response.Type) {
        self.resource = resource
    }

    func refresh() {
        guard !isLoading else {
            return
        }
        isLoading = true
        subscriber = Client.shared.fetch(resource, setResponse: \.response, setWarning: \.warning, setError: \.error, on: self, completionHandler: {[unowned self] in isLoading = false})
    }
}
