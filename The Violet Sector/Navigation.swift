// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Navigation: View {
    @Binding var tabIndex: Int
    let thisTabIndex: Int
    @StateObject private var model = Model<Map.Data>(resource: "navcom_map.php")
    
    var body: some View {
        NavigationView() {
            Map(model: model)
                .navigationBarTitle("Navigation")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {Refresh(action: {model.refresh(force: true)})})
                .onChange(of: tabIndex, perform: {if $0 == thisTabIndex {model.refresh(force: true)}})
        }
    }
}
