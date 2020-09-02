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
                .accessibility(addTraits: .isHeader)
            if model.matches != nil {
                TextField("Search", text: $model.term, onCommit: {self.model.search()})
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                if !model.matches!.isEmpty {
                    List(model.matches!, id: \.pilot.name) {(element) in
                        NavigationLink(destination: TargetView(rank: element.rank, data: element.pilot)) {
                            HStack() {
                                Text(verbatim: "\(element.rank)")
                                    .frame(width: 16.0)
                                GeometryReader() {(geometry) in
                                    HStack(spacing: 0.0) {
                                        (Text(verbatim: "\(element.pilot.name)\(element.pilot.isOnline ? "*" : "") [") + Text(verbatim: "\(element.pilot.legion.description.first!)").bold().foregroundColor(Color(.sRGB, red: element.pilot.legion.color.red, green: element.pilot.legion.color.green, blue: element.pilot.legion.color.blue, opacity: 1.0)) + Text(verbatim: "]"))
                                            .frame(width: geometry.size.width * 0.5, alignment: .leading)
                                        HealthView(current: element.pilot.currentHealth, max: element.pilot.maxHealth)
                                            .percentage()
                                            .frame(width: geometry.size.width * 0.2, alignment: .trailing)
                                        Text(verbatim: "\(element.pilot.score >= 10000 ? "\(element.pilot.score / 1000)k" : "\(element.pilot.score)") (\(element.pilot.level)")
                                            .frame(width: geometry.size.width * 0.3, alignment: .trailing)
                                    }
                                }
                            }
                        }
                        .accessibilityElement(children: .combine)
                    }
                } else {
                    Spacer()
                    Text(verbatim: "Nothing to show.")
                    Spacer()
                }
            } else if model.error != nil {
                ErrorView(error: model.error!)
            } else {
                LoadingView()
            }
        }
        .onAppear(perform: {Client.shared.refreshable = self.model})
    }
}
