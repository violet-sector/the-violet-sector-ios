// Created by João Santos for project The Violet Sector.

import Combine

final class Action<Response: Decodable>: ObservableObject {
    @Published var alert: String?
    @Published private(set) var response: Response?
    @Published private(set) var isLoading = false
    private let resource: String
    private var subscriber: Cancellable?

    init(resource: String, responseType _: Response.Type) {
        self.resource = resource
    }

    func perform(query: [String: String], completionHandler: @escaping () -> Void) {
        guard !isLoading else {
            return
        }
        isLoading = true
        subscriber = Client.shared.fetch(resource, post: query, setResponse: \.response, setWarning: \.alert, setError: \.alert, on: self, completionHandler: {[unowned self] in isLoading = false; completionHandler()})
    }
}
