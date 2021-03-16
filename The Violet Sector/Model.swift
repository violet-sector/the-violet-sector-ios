// Created by João Santos for project The Violet Sector.

import Combine

final class Model<Data: Decodable>: ObservableObject {
    @Published private(set) var data: Data?
    @Published private(set) var error: Error?
    @Published private(set) var isLoading = false
    private var request: Cancellable?
    private let resource: String

    init(resource: String) {
        self.resource = resource
        if resource == "main.php" {
            refresh()
        }
    }

    func refresh() {
        isLoading = true
        request = Client.shared.get(resource, setResponse: \.data, setFailure: \.error, on: self, completionHandler: {[unowned self] in isLoading = false; request = nil})
    }
}
