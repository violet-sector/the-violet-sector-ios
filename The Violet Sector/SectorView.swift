// Created by João Santos for project The Violet Sector.

import SwiftUI

struct SectorView: View {
    let sector: Sectors
    private let paragraphs: [ArraySlice<Substring>]

    var body: some View {
        GeometryReader() {(geometry) in
            ScrollView() {
                VStack(alignment: .leading, spacing: 10.0) {
                    ForEach(self.paragraphs.indices, id: \.self) {(paragraphIndex) in
                        VStack(alignment: .leading, spacing: 0.0) {
                            ForEach(self.paragraphs[paragraphIndex].indices, id: \.self) {(statementIndex) in
                                Group() {
                                    if self.paragraphs[paragraphIndex][statementIndex].first! == "#" {
                                        Text(verbatim: "\(self.paragraphs[paragraphIndex][statementIndex].drop(while: {$0 == "#" || $0 == " "}))")
                                            .bold()
                                            .multilineTextAlignment(.leading)
                                            .accessibility(addTraits: .isHeader)
                                    } else if self.paragraphs[paragraphIndex][statementIndex].first! == "*" {
                                        HStack(alignment: .top, spacing: 0.0) {
                                            Text(verbatim: " • ")
                                            Text(verbatim: "\(self.paragraphs[paragraphIndex][statementIndex].drop(while: {$0 == "*" || $0 == " "}))")
                                                .multilineTextAlignment(.leading)
                                        }
                                        .accessibilityElement(children: .combine)
                                    } else {
                                        Text(verbatim: "\(self.paragraphs[paragraphIndex][statementIndex])")
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text(verbatim: "\(sector)"), displayMode: .inline)
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
        let asset = NSDataAsset(name: "\(sector)")!
        let data = asset.data
        let text = domination != nil ? "# Domination\n\n\(domination!)\n\n" + String(data: data, encoding: .utf8)! : String(data: data, encoding: .utf8)!
        let statements = text.split(separator: "\n", omittingEmptySubsequences: false)
        paragraphs = statements.split(separator: "")
    }
}
