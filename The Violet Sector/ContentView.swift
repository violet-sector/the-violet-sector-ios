//
//  ContentView.swift
//  The Violet Sector
//
//  Created by João Santos on 01/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var client = Client.shared

    var body: some View {
        VStack() {
            TimerView()
                .alert(isPresented: $client.showingError, content: {Alert(title: Text("Error Fetching Data"), message: Text(client.error!))})
            LegionNewsView()
        }
    }
}
