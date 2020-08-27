//
//  RankingsView.swift
//  The Violet Sector
//
//  Created by João Santos on 27/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import SwiftUI

struct RankingsView: View {
    var body: some View {
        NavigationView() {
            TopPilotsView()
                .navigationBarTitle("Rankings", displayMode: .inline)
        }
    }
}
