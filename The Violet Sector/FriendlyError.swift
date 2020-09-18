// Created by João Santos for project The Violet Sector.

import SwiftUI

struct FriendlyError: View {
    private let description: String

    var body: some View {
        VStack() {
            Spacer()
            Text(verbatim: "Error Fetching Data")
                .bold()
                .accessibility(addTraits: .isHeader)
            Text(verbatim: description)
            Spacer()
        }
    }

    init(error: Error) {
        switch error {
        case _ as DecodingError:
            description = "Unable to decode resource."
        case let error as LocalizedError:
            description = error.errorDescription ?? "Unknown error."
        case let error as NSError:
            description = error.localizedDescription
        default:
            description = "Unknown error."
        }
    }
}
