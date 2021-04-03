// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Journal: View {
    @StateObject private var model = Model(resource: "journal.php", responseType: ModelResponse.self)
    @StateObject private var saveAction = Action(resource: "journal_save.php", responseType: SaveResponse.self)
    @State private var text = ""

    var body: some View {
        Page(model: model) {(response) in
            GeometryReader() {(geometry) in
                TextEditor(text: $text)
                    .multilineTextAlignment(.leading)
                    .padding(5.0)
                    .frame(width: geometry.size.width - 20.0, height: geometry.size.height)
                    .background(RoundedRectangle(cornerRadius: 8.0).stroke(Color.accentColor, lineWidth: 2.0))
                    .padding([.leading, .trailing], 10.0)
                    .onAppear(perform: {text = response.content})
            }
        }
        .toolbar(content: {if text != model.response?.content ?? "" {Button("Done", action: {save()}).disabled(saveAction.isLoading)} else {Refresh()}})
        .alert(item: $saveAction.alert, content: {Alert(title: Text(verbatim: "Error Saving Journal"), message: Text(verbatim: $0))})
    }

    private func save() {
        saveAction.perform(query: ["entry": text]) {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            if saveAction.response?.success ?? false {
                Client.shared.activeModel.refresh()
            }
        }
    }

    private struct ModelResponse: Decodable {
        let content: String

        private enum CodingKeys: String, CodingKey {
            case content = "journal"
        }
    }

    private struct SaveResponse: Decodable {
        let success: Bool

        private enum CodingKeys: String, CodingKey {
            case success = "entry_saved"
        }
    }
}
