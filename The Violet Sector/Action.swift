// Created by João Santos for project The Violet Sector.

import Combine

final class Action: ObservableObject {
    @Published private(set) var data: Response? {didSet {request = nil; Client.shared.refreshable!.refresh()}}
    @Published private(set) var error: Error? {didSet {request = nil}}
    private var request: Cancellable?
    private let resource: String

    init(resource: String) {
        self.resource = resource
    }

    func trigger(query: [String: String]) {
        var queryString = ""
        for (key: key, value: value) in query {
            if !queryString.isEmpty {
                queryString += "&"
            }
            queryString += key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            queryString += "="
            queryString += value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
        let postData = queryString.data(using: .ascii)!
        request = Client.shared.fetch(resource, postData: postData, setResponse: \.data, setFailure: \.error, on: self)
    }

    struct Response: Decodable {}
}
