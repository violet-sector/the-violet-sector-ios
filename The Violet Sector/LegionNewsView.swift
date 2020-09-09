// Created by João Santos for project The Violet Sector.

import SwiftUI

struct LegionNewsView: View {
    @ObservedObject var model = LegionNewsModel.shared

    var body: some View {
        VStack() {
            Text(verbatim: "Legion News")
                .bold()
                .accessibility(addTraits: .isHeader)
            if model.response != nil {
                GeometryReader() {(geometry) in
                    ScrollView() {
                        Text(verbatim: "Set by \(self.model.response!.data.author) on turn \(self.model.response!.data.turn) (\(DateFormatter.localizedString(from: Date(timeIntervalSince1970: TimeInterval(self.model.response!.data.time)), dateStyle: .short, timeStyle: .short)))\n\n\(self.model.response!.data.text)")
                            .frame(maxWidth: geometry.size.width * 0.9, maxHeight: .infinity, alignment: .topLeading)
                    }
                    .padding(1.0)
                    .border(Color.primary)
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height - 5.0)
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
