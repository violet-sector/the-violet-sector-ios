//
//  MainView.swift
//  The Violet Sector
//
//  Created by João Santos on 25/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView() {
            LegionNewsView()
                .navigationBarTitle("Main", displayMode: .inline)
        }
    }
}
