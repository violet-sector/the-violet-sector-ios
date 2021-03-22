// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Description<Content: View>: View {
    let name: String
    let content: () -> Content

    var body: some View {
        Text(verbatim: name)
            .bold()
            .multilineTextAlignment(.trailing)
            .frame(idealWidth: .infinity, alignment: .trailing)
        content()
            .multilineTextAlignment(.leading)
            .frame(idealWidth: .infinity, alignment: .leading)
    }
}
