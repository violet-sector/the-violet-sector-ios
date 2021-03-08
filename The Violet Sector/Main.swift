// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Main: View {
    @StateObject private var model = Model<Computer.Data>(resource: "main.php")

    var body: some View {
        NavigationView() {
            Computer(model: model)
                .navigationBarTitle("Main")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {Refresh()})
        }
    }
}
