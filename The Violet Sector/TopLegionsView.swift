//
//  TopLegionsView.swift
//  The Violet Sector
//
//  Created by João Santos on 28/08/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

import SwiftUI

struct TopLegionsView: View {
    @ObservedObject var model = TopLegionsModel.shared

    var body: some View {
        VStack() {
            Text(verbatim: "Top Legions")
            .bold()
            if model.rankedLegions != nil {
                List(model.rankedLegions!, id: \.legion.legion) {(rankedLegion) in
                    HStack() {
                        Text(verbatim: "\(rankedLegion.rank)")
                            .frame(width: 16.0, alignment: .trailing)
                        GeometryReader() {(geometry) in
                            HStack(spacing: 0.0) {
                                Text(verbatim: "\(rankedLegion.legion.legion)")
                                    .frame(width: geometry.size.width * 0.5, alignment: .leading)
                                Text(verbatim: "\(rankedLegion.legion.score)")
                                    .frame(width: geometry.size.width * 0.5, alignment: .trailing)
                            }
                        }
                    }
                    .accessibilityElement(children: .combine)
                }
            } else if model.error != nil {
                Spacer()
                Text(verbatim: model.error!)
                Spacer()
            } else {
                Spacer()
                Text(verbatim: "Loading...")
                Spacer()
            }
        }
        .onAppear(perform: {Client.shared.refreshable = self.model})
    }
}
