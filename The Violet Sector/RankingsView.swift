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
    @State private var pattern = ""

    var body: some View {
        VStack {
            Text(verbatim: "Rankings")
                .font(.title)
                .accessibility(addTraits: .isHeader)
            if rankings.response != nil {
                TextField("Search", text: $pattern, onCommit: {self.rankings.search(for: self.pattern)})
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                List(rankings.matches!, id: \.offset) {(rank) in
                    HStack {
                        Text(verbatim: "\(rank.offset + 1)")
                            .frame(width: 50.0, alignment: .leading)
                        PilotView(pilot: rank.element)
                    }
                    .accessibilityElement(children: .combine)
                }
                StatusView(status: rankings.response!.status)
            } else {
                Text(verbatim: "Fetching rankings...")
            }
        }
    }
}
