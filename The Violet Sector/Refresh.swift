// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Refresh: View {
    var body: some View {
        Button(action: {if let refreshable = Client.shared.refreshable {refreshable.refresh()}}) {
            Image(systemName: "arrow.clockwise")
            }
        .accessibility(label: Text(verbatim: "Refresh"))
    }
}
