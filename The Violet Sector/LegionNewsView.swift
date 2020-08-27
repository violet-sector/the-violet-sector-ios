//
//  LegionNewsView.swift
//  The Violet Sector
//
//  Created by João Santos on 15/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import SwiftUI

struct LegionNewsView: View {
    @ObservedObject var model = LegionNewsModel.shared

    var body: some View {
        VStack() {
            Text(verbatim: "Legion News")
                .bold()
            if model.response != nil {
                GeometryReader() {(geometry) in
                    ScrollView() {
                        Text(verbatim: "Set by \(self.model.response!.data.author) on turn \(self.model.response!.data.turn) (\(DateFormatter.localizedString(from: Date(timeIntervalSince1970: TimeInterval(self.model.response!.data.time)), dateStyle: .short, timeStyle: .short)))\n\n\(self.model.response!.data.text)")
                            .frame(maxWidth: geometry.size.width * 0.9, maxHeight: .infinity, alignment: .topLeading)
                    }
                    .padding(1.0)
                    .border(Color.primary)
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height - 5.0)
                }
            } else {
                Spacer()
                Text(verbatim: "Loading...")
                Spacer()
            }
        }
    }
}
