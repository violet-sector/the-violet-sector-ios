// Created by João Santos for project The Violet Sector.

import SwiftUI

struct TopDeathsView: View {
    @ObservedObject var model = TopDeathsModel.shared

    var body: some View {
        VStack() {
            Text(verbatim: "Top Deaths")
                .bold()
                .accessibility(addTraits: .isHeader)
            if model.matches != nil {
                TextField("Search", text: $model.term, onCommit: {self.model.search()})
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                if !model.matches!.isEmpty {
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
