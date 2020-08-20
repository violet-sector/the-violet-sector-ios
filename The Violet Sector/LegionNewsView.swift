//
//  LegionNewsView.swift
//  The Violet Sector
//
//  Created by João Santos on 15/08/2020.
//  Copyright © 2020 João Santos. All rights reserved.
//

import SwiftUI

struct LegionNewsView: View {
    @ObservedObject var legionNews = LegionNews.shared

    var body: some View {
        var news = "Fetching news..."
        if let content = legionNews.response?.content {
            news = "Set by \(content.author) on turn \(content.turn) (\(DateFormatter.localizedString(from: Date(timeIntervalSince1970: TimeInterval(content.time)), dateStyle: .short, timeStyle: .short)))\n\n\(content.text)"
        }
        return VStack() {
            Text("Legion News")
                .font(.title)
                .accessibility(addTraits: .isHeader)
            GeometryReader() {(geometry) in
                ScrollView() {
                    Text(news)
                        .frame(maxWidth: geometry.size.width * 0.9, maxHeight: .infinity, alignment: .topLeading)
                }
                .padding(1.0)
                .border(Color(.black))
                .frame(width: geometry.size.width * 0.9, height: geometry.size.height - 5.0)
            }
            StatusView(status: legionNews.response?.status)
        }
    }
}
