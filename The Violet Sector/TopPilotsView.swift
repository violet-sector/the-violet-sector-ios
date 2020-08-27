//
//  TopPilotsView.swift
//  The Violet Sector
//
//  Created by João Santos on 21/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import SwiftUI

struct TopPilotsView: View {
    @ObservedObject var model = TopPilotsModel.shared
    @State private var pattern = ""

    var body: some View {
        VStack() {
            Text(verbatim: "Top Pilots")
                .bold()
            if model.matches != nil {
                TextField("Search", text: $pattern, onCommit: {self.model.search(for: self.pattern)})
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
