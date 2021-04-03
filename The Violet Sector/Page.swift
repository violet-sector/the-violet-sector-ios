// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Page<Response: Decodable, Content: View>: View {
    private let content: (_: Response) -> Content
    @ObservedObject var model: Model<Response>
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack() {
            VStack(spacing: 10.0) {
                if let response = model.response {
                    if let warning = model.warning {
                        Text(verbatim: warning)
                    }
                    content(response)
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
        .navigationTitle(Client.shared.tab?.title ?? "")
        .toolbar(content: {Refresh()})
        .onChange(of: scenePhase, perform: {if $0 == .active {model.refresh()}})
        .onAppear(perform: {Client.shared.activeModel = model; model.refresh()})
    }

    init(model: Model<Response>, @ViewBuilder content: @escaping (_: Response) -> Content) {
        self.model = model
        self.content = content
    }
}
