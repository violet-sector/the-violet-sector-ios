// Created by João Santos for project The Violet Sector.

import SwiftUI

struct SectorDescription: View {
    let status: Client.StatusResponse
    let sector: Sectors
    let legions: Set<Legions>
    let isOpenGate: Bool
    let onHyper: () -> Void
    @ObservedObject private var client = Client.shared
    @ObservedObject private var timerModel = Timer.Model.shared
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack(spacing: 10.0) {
            ScrollView() {
                VStack() {
                    if sector != .uncharted {
                        Image("Sectors/Images/\(sector)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250.0, height: 250.0)
                            .accessibilityLabel(sector.description)
                    }
                    if isOpenGate {
                        Button("Hyper", action: {presentationMode.wrappedValue.dismiss(); client.post("navcom_hyper.php", query: ["destination": String(sector.rawValue)], completionHandler: onHyper)})
                    }
                    Description(sector: sector, legions: legions)
                }
            }
            Status()
        }
        .navigationBarTitle(Text(verbatim: "\(sector)"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private struct Description: View {
        let sector: Sectors
        private let paragraphs: [ArraySlice<Substring>]

        var body: some View {
            VStack(alignment: .leading, spacing: 10.0) {
                ForEach(paragraphs.indices, id: \.self) {(paragraphIndex) in
                    VStack(alignment: .leading, spacing: 0.0) {
                        ForEach(paragraphs[paragraphIndex].indices, id: \.self) {(statementIndex) in
                            Group() {
                                if paragraphs[paragraphIndex][statementIndex].first! == "#" {
                                    Text(verbatim: "\(paragraphs[paragraphIndex][statementIndex].drop(while: {$0 == "#" || $0 == " "}))")
                                        .bold()
                                        .multilineTextAlignment(.leading)
                                        .accessibility(addTraits: .isHeader)
                                } else if paragraphs[paragraphIndex][statementIndex].first! == "*" {
                                    HStack(alignment: .top, spacing: 0.0) {
                                        Text(verbatim: " • ")
                                        Text(verbatim: "\(paragraphs[paragraphIndex][statementIndex].drop(while: {$0 == "*" || $0 == " "}))")
                                            .multilineTextAlignment(.leading)
                                    }
                                    .accessibilityElement(children: .combine)
                                } else {
                                    Text(verbatim: "\(paragraphs[paragraphIndex][statementIndex])")
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        }
                    }
                }
            }
        }

        init(sector: Sectors, legions: Set<Legions>) {
            self.sector = sector
            let legions = legions.sorted(by: {$0.rawValue < $1.rawValue})
            var domination: String?
            if legions.count == 1 {
                domination = "Dominated by \(legions.first!)s"
            } else if legions.count == 2 {
                domination = "Contested by \(legions.first!)s and \(legions.last!)s"
            } else if legions.count > 2 {
                domination = "Contested by "
                for legion in legions {
                    if legion != legions.last! {
                        domination! += "\(legion)s, "
                    } else {
                        domination! += "and \(legion)s"
                    }
                }
            }
            let asset = NSDataAsset(name: "Sectors/Descriptions/\(sector)")!
            let data = asset.data
            let text = domination != nil ? "# Domination\n\n\(domination!)\n\n" + String(data: data, encoding: .utf8)! : String(data: data, encoding: .utf8)!
            let statements = text.split(separator: "\n", omittingEmptySubsequences: false)
            paragraphs = statements.split(separator: "")
        }
    }
}
