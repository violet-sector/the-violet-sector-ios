// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Journal: View {
    var body: some View {
        Page(dataType: Data.self) {(data) in
            GeometryReader() {(geometry) in
                ScrollView() {
                    Text(verbatim: data.content)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .padding(5.0)
                .frame(width: geometry.size.width - 20.0, height: geometry.size.height)
                .border(Color.primary)
                .padding([.leading, .trailing], 10.0)
            }
        }
    }

    struct Data: Decodable {
        let content: String

        private enum CodingKeys: String, CodingKey {
            case content = "journal"
        }
    }
}
