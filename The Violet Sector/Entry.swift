// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Entry: View {
    @Binding var hasEntered: Bool
    @ObservedObject var client = Client.shared

    var body: some View {
        VStack() {
            Text(verbatim: "News")
                .font(.title)
                .accessibility(addTraits: .isHeader)
            ScrollView() {
                Text(verbatim: client.settings!.news)
                    .multilineTextAlignment(.leading)
            }
            .padding(5.0)
            .border(Color.primary)
            .frame(width: 240.0, height: 100.0, alignment: .topLeading)
            Button("Enter", action: {self.hasEntered = true})
        }
    }
}
