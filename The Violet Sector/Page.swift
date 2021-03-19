// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Page<Content: View, Data: Decodable>: View {
    private let title: String
    private let content: (_: Data) -> Content
    @ObservedObject private var model: Model<Data>
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack() {
            VStack(spacing: 10.0) {
                Text(verbatim: title)
                    .bold()
                    .accessibilityAddTraits(.isHeader)
                if let data = model.data {
                    if let warning = model.warning {
                        Text(verbatim: warning)
                    }
                    content(data)
                } else if let error = model.error {
                    Spacer()
                    Text(verbatim: "Error Fetching Data")
                        .bold()
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
                    .scaleEffect(10.0)
            }
        }
        .onChange(of: scenePhase, perform: {if case .active = $0 {model.refresh()}})
    }

    init(title: String, model: Model<Data>, @ViewBuilder content: @escaping (_ data: Data) -> Content) {
        self.title = title
        self.model = model
        self.content = content
    }
}
