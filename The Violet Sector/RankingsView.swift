//
//  RankingsView.swift
//  The Violet Sector
//
//  Created by João Santos on 21/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import SwiftUI

struct RankingsView: View {
    @ObservedObject var rankings = Rankings.shared

    var body: some View {
        VStack {
            Text(verbatim: "Rankings")
                .font(.title)
                .accessibility(addTraits: .isHeader)
            if rankings.response != nil {
                List() {
                    ForEach(Range(uncheckedBounds: (0, rankings.response!.content.count))) {(index) in
                        HStack {
                            Text(verbatim: "\(index + 1)")
                                .frame(width: 50.0, alignment: .leading)
                            PilotView(pilot: self.rankings.response!.content[index])
                        }
                        .accessibilityElement(children: .combine)
                    }
                }
                StatusView(status: rankings.response!.status)
            } else {
                Text(verbatim: "Fetching rankings...")
            }
        }
    }
}
