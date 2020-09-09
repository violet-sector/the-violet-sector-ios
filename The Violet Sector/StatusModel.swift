// Created by João Santos for project The Violet Sector.

import Combine

final class StatusModel: ObservableObject {
    @Published private(set) var data: Status?

    static let shared = StatusModel()

    private init() {}

    func refresh(data: Status) {
        self.data = data
    }
}
