// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Details: View {
    let details: [(name: String, value: Text?)]
    let geometry: GeometryProxy
    
    var body: some View {
        VStack() {
            ForEach(details.filter({$0.value != nil}), id: \.name) {(detail) in
                HStack(spacing: 20.0) {
                    Text(verbatim: detail.name)
                        .bold()
                        .multilineTextAlignment(.trailing)
                        .frame(width: geometry.size.width / 2.0 - 10.0, alignment: .trailing)
                    detail.value!
                        .multilineTextAlignment(.leading)
                        .frame(width: geometry.size.width / 2.0 - 10.0, alignment: .leading)
                }
                .accessibilityElement(children: .combine)
            }
        }
    }
}
