//
//  RefreshButtonView.swift
//  The Violet Sector
//
//  Created by João Santos on 01/09/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

import SwiftUI

struct RefreshButtonView: View {
    var body: some View {
        Button(action: {if let refreshable = Client.shared.refreshable {refreshable.refresh()}}) {
            Image(systemName: "arrow.clockwise")
            }
        .accessibility(label: Text(verbatim: "Refresh"))
    }
}
