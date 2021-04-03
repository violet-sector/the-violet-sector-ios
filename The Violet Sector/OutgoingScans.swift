// Created by João Santos for project The Violet Sector.

import SwiftUI

struct OutgoingScans: View {
    @StateObject private var model = Model(resource: "scans_outgoing.php", responseType: Response.self)

    var body: some View {
        Page(model: model) {(response) in
            Targets(data: response.content)
        }
    }

    private struct Response: Decodable {
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
