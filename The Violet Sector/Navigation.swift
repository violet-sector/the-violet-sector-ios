// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Navigation: View {
    @StateObject private var model = Model<Map.Data>(resource: "navcom_map.php")
    
    var body: some View {
        NavigationView() {
            Map(model: model)
                .navigationBarTitle("Navigation")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {Refresh()})
        }
    }
}
