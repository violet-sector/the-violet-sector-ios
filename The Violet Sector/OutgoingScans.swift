// Created by João Santos for project The Violet Sector.

import SwiftUI

struct OutgoingScans: View {
    var body: some View {
        Page(dataType: Data.self) {(data) in
            Targets(data: data.content)
        }
    }

    struct Data: Decodable {
        let content: [Target]

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            content = try container.decodeIfPresent([Target].self, forKey: .content) ?? []
        }

        private enum CodingKeys: String, CodingKey {
            case content = "scans_outgoing"
        }
    }
}
