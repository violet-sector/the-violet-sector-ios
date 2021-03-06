// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Page<Content: View, Data: Decodable>: View {
    private let title: String
    private let content: (_: Data) -> Content
    @ObservedObject private var model: Model<Data>
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        VStack(spacing: 10.0) {
            Text(verbatim: title)
                .bold()
                .accessibilityAddTraits(.isHeader)
            if let data = model.data {
                content(data)
            } else if let error = model.error {
                Spacer()
                Text(verbatim: "Error Fetching Data")
                    .bold()
                    .accessibilityAddTraits(.isHeader)
                Text(verbatim: Self.describeError(error))
                Spacer()
            } else {
                Spacer()
                ProgressView()
                    .scaleEffect(10.0)
                Spacer()
            }
            Spacer()
            Status(data: Mirror(reflecting: model.data as Any).descendant("some", "status") as? Status.Data)
        }
        .onAppear(perform: {Client.shared.refreshable = model})
        .onChange(of: scenePhase, perform: {if $0 == .active {Client.shared.refreshable = model}})
    }

    init(title: String, resource: String, @ViewBuilder content: @escaping (_ data: Data) -> Content) {
        self.title = title
        model = Model<Data>(resource: resource)
        self.content = content
    }

    static private func describeError(_ error: Error) -> String {
        switch error {
        case _ as DecodingError:
            return "Unable to decode resource."
        case let error as LocalizedError:
            return error.errorDescription ?? "Unknown error."
        case let error as NSError:
            return error.localizedDescription
        default:
            return "Unknown error."
        }
    }
}
