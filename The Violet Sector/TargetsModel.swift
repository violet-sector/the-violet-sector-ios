//
//  TargetsModel.swift
//  The Violet Sector
//
//  Created by João Santos on 02/09/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

import Foundation
import Combine

class TargetsModel: ObservableObject, Refreshable, Fetchable {
    var response: Response? {didSet {update()}}
    @Published var error: Error?
    @Published private(set) var targets: [Target]?
    var request: Cancellable?

    class var resource: String {"rankings_pilots.php"}

    private init() {}

    private func update() {
        request = nil
        guard let response = response else {
            targets = nil
            return
        }
        StatusModel.shared.refresh(data: response.status)
        targets = response.targets.sorted(by: {$0.score > $1.score})
    }

    struct Response: Decodable {
        let targets: [Target]
        let status: Status

        private enum CodingKeys: String, CodingKey {
            case incoming = "scans_incoming"
            case outgoing = "scans_outgoing"
            case status = "player"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if container.contains(.incoming) {
                targets = try container.decode([Target].self, forKey: .incoming)
            } else if container.contains(.outgoing) {
                targets = try container.decode([Target].self, forKey: .outgoing)
            } else {
                targets = []
            }
        status = try container.decode(Status.self, forKey: .status)
        }
    }

    final class Incoming: TargetsModel {
        typealias Response = TargetsModel.Response

        override class var resource: String {"scans_incoming.php"}
        static var shared = Incoming()

        override private init() {}
    }

    final class Outgoing: TargetsModel {
        typealias Response = TargetsModel.Response

        override class var resource: String {"scans_outgoing.php"}
        static var shared = Outgoing()

        override private init() {}
    }
}
