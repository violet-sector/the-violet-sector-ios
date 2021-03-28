// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Journal: View {
    @State private var text = ""
    @State private var hasChanges = false

    var body: some View {
        Page(dataType: Data.self) {(data) in
            GeometryReader() {(geometry) in
                TextEditor(text: $text)
                    .multilineTextAlignment(.leading)
                    .padding(5.0)
                    .frame(width: geometry.size.width - 20.0, height: geometry.size.height)
                    .border(Color.primary)
                    .padding([.leading, .trailing], 10.0)
                    .onAppear(perform: {text = data.content})
                    .onChange(of: text, perform: {hasChanges = $0 != data.content})
            }
        }
        .toolbar(content: {if hasChanges {Button("Done", action: {save()})} else {Refresh()}})
    }

    private func save() {
        Client.shared.post("journal_save.php", query: ["entry": text]) {
            dismissKeyboard()
            hasChanges = false
            Client.shared.activeModel.refresh()
        }
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    struct Data: Decodable {
        let content: String

        private enum CodingKeys: String, CodingKey {
            case content = "journal"
        }
    }
}
