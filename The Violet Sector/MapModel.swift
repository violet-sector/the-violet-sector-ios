// Created by João Santos for project The Violet Sector.

import Combine

final class MapModel: ObservableObject, Refreshable, Fetchable {
    @Published var error: Error?
    @Published var response: Response? {didSet {update()}}
    var request: Cancellable?

    static let shared = MapModel()
    static let resource = "navcom_map.php"

    private init() {}

    private func update() {
        request = nil
        guard let response = response else {
            return
        }
        StatusModel.shared.refresh(data: response.status)
    }

    struct Response: Decodable {
        let domination: [Sectors: Set<Legions>]
        let gates: Set<Sectors>
        let status: Status

        private enum CodingKeys: String, CodingKey {
            case domination = "domination_info"
            case gates = "destinations"
            case status = "player"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let decodedDomination = try container.decode([String: Set<Legions>].self, forKey: .domination)
            var domination = [Sectors: Set<Legions>]()
            domination.reserveCapacity(domination.count)
            for (key: key, value: value) in decodedDomination {
                guard let convertedKey = UInt(key) else {
                    continue
                }
                guard let sector = Sectors(rawValue: convertedKey) else {
                    continue
                }
                domination[sector] = value
            }
            self.domination = domination
            gates = try container.decode(Set<Sectors>.self, forKey: .gates)
            status = try container.decode(Status.self, forKey: .status)
        }
    }
}
