// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Page<Data: Decodable, Content: View>: View {
    private let content: (_: Data) -> Content
    @EnvironmentObject private var model: Model<Data>
    @ObservedObject private var client = Client.shared
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack() {
            VStack(spacing: 10.0) {
                if let data = model.data {
                    if let warning = model.warning {
                        Text(verbatim: warning)
                    }
                    content(data)
                } else if let error = model.error {
                    Spacer()
                    Text(verbatim: "Error Fetching Data")
                        .font(.title)
                        .accessibilityAddTraits(.isHeader)
                    Text(verbatim: error)
                    Spacer()
                } else {
                    Spacer()
                }
            }
            .accessibilityElement(children: !model.isLoading ? .contain : .ignore)
            if model.isLoading {
                Spacer()
                    .background(Color.black.opacity(0.5))
                ProgressView()
            }
        }
        .navigationTitle(client.tab?.title ?? "The Violet Sector")
        .toolbar(content: {Refresh()})
        .onChange(of: scenePhase, perform: {if $0 == .active {model.refresh()}})
    }

    init(@ViewBuilder content: @escaping (_: Data) -> Content) {
        self.content = content
    }
}
