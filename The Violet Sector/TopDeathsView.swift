//
//  TopDeathsView.swift
//  The Violet Sector
//
//  Created by João Santos on 27/08/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

import SwiftUI

struct TopDeathsView: View {
    @ObservedObject var model = TopDeathsModel.shared

    var body: some View {
        VStack() {
            Text(verbatim: "Top Deaths")
            .bold()
            if model.matches != nil {
                TextField("Search", text: $model.term, onCommit: {self.model.search()})
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                List(model.matches!, id: \.rank) {(rankedDeath) in
                    HStack() {
                        Text(verbatim: "\(rankedDeath.rank)")
                            .frame(width: 16.0, alignment: .trailing)
                        GeometryReader() {(geometry) in
                            HStack(spacing: 0.0) {
                                Text(verbatim: rankedDeath.death.name)
                                    .frame(width: geometry.size.width * 0.5, alignment: .leading)
                                Text(verbatim: "\(rankedDeath.death.score)")
                                    .frame(width: geometry.size.width * 0.3, alignment: .trailing)
                                Text(verbatim: "\(rankedDeath.death.turn)")
                                    .frame(width: geometry.size.width * 0.2, alignment: .trailing)
                            }
                        }
                    }
                    .accessibilityElement(children: .combine)
                }
            } else {
                Spacer()
                Text(verbatim: "Loading...")
                Spacer()
            }
        }
    }
}
