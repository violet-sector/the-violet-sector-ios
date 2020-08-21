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
        var statusView: StatusView?
        if let response = legionNews.response {
            news = "Set by \(response.content.author) on turn \(response.content.turn) (\(DateFormatter.localizedString(from: Date(timeIntervalSince1970: TimeInterval(response.content.time)), dateStyle: .short, timeStyle: .short)))\n\n\(response.content.text)"
            statusView = StatusView(status: response.status)
        }
        return VStack() {
            Text(verbatim: "Legion News")
                .font(.title)
                .accessibility(addTraits: .isHeader)
            GeometryReader() {(geometry) in
                ScrollView() {
                    Text(verbatim: news)
                        .frame(maxWidth: geometry.size.width * 0.9, maxHeight: .infinity, alignment: .topLeading)
                }
                .padding(1.0)
                .border(Color(.black))
                .frame(width: geometry.size.width * 0.9, height: geometry.size.height - 5.0)
            }
            statusView
        }
    }
}
