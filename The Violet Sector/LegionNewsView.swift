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
                .font(.title)
                .accessibility(addTraits: .isHeader)
            if model.isReady {
                GeometryReader() {(geometry) in
                    ScrollView() {
                        Text(verbatim: "Set by \(self.model.author) on turn \(self.model.turn) (\(DateFormatter.localizedString(from: Date(timeIntervalSince1970: TimeInterval(self.model.time)), dateStyle: .short, timeStyle: .short)))\n\n\(self.model.text)")
                            .frame(maxWidth: geometry.size.width * 0.9, maxHeight: .infinity, alignment: .topLeading)
                    }
                    .padding(1.0)
                    .border(Color(.black))
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
