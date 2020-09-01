//
//  RefreshButtonView.swift
//  The Violet Sector
//
//  Created by João Santos on 01/09/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

import SwiftUI

struct RefreshButtonView: View {
    @ObservedObject var client = Client.shared

    var body: some View {
        Button(action: {if let refreshable = self.client.refreshable {refreshable.refresh()}}) {
            Image(systemName: "arrow.clockwise")
            }
        .accessibility(label: Text(verbatim: "Refresh"))
    }
}
