//
//  StatusModel.swift
//  The Violet Sector
//
//  Created by João Santos on 23/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import Combine

final class StatusModel: ObservableObject {
    @Published private(set) var data: Status?

    static let shared = StatusModel()

    private init() {}

    func refresh(data: Status) {
        self.data = data
    }
}