//
//  RankingsView.swift
//  The Violet Sector
//
//  Created by João Santos on 21/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import SwiftUI

struct RankingsView: View {
    @ObservedObject var model = RankingsModel.shared
    @State private var pattern = ""

    var body: some View {
        VStack {
            Text(verbatim: "Rankings")
                .font(.title)
                .foregroundColor(.accentColor)
                .accessibility(addTraits: .isHeader)
            if model.isReady {
                TextField("Search", text: $pattern, onCommit: {self.model.search(for: self.pattern)})
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                List(model.matches!, id: \.offset) {(element) in
                    HStack {
                        Text(verbatim: "\(element.offset + 1)")
                            .frame(width: 30.0, alignment: .leading)
                        PilotView(pilot: element.element)
                    }
                    .accessibilityElement(children: .combine)
                    .frame(height: 150.0)
                }
            } else {
                Spacer()
                Text(verbatim: "Loading...")
                Spacer()
            }
        }
    }
}
