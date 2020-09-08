//
//  NavComView.swift
//  The Violet Sector
//
//  Created by João Santos on 04/09/2020.
//  Copyright © 2020 João Santos. Check out the LICENSE document for details.
//

import SwiftUI

struct NavComView: View {
    var body: some View {
        NavigationView() {
            MapView()
                .navigationBarTitle("Navigation")
                .navigationBarItems(trailing: RefreshButtonView())
        }
    }
}
