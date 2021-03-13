// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Main: View {
    @Binding var tabIndex: Int
    let thisTabIndex: Int
    @StateObject private var model = Model<Computer.Data>(resource: "main.php")

    var body: some View {
        NavigationView() {
            Computer(model: model)
                .navigationBarTitle("Main")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {Refresh(action: {model.refresh(force: true)})})
                .onChange(of: tabIndex, perform: {if $0 == thisTabIndex {model.refresh(force: true)}})
        }
    }
}
