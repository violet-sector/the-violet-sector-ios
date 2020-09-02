//
//  ErrorView.swift
//  The Violet Sector
//
//  Created by João Santos on 02/09/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

import SwiftUI

struct ErrorView: View {
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
