//
//  TopPilotsView.swift
//  The Violet Sector
//
//  Created by João Santos on 21/08/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

import SwiftUI

struct TopPilotsView: View {
    @ObservedObject var model = TopPilotsModel.shared

    var body: some View {
        VStack() {
            Text(verbatim: "Top Pilots")
                .bold()
            if model.matches != nil {
                TextField("Search", text: $model.term, onCommit: {self.model.search()})
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                List(model.matches!, id: \.pilot.name) {(element) in
                    PilotView(rank: element.rank, data: element.pilot)
                }
            } else {
                Spacer()
                Text(verbatim: "Loading...")
                Spacer()
            }
        }
    }
}
