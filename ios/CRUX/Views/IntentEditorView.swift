import SwiftUI

struct IntentEditorView: View {
    @Environment(\.dismiss) private var dismiss
    let store: SharedDefaults
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    private let charLimit: Int = 80

    var body: some View {
        NavigationStack {
            ZStack {
                CRUXColor.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer().frame(height: 48)

                    TextField("What are you for?", text: $text, axis: .vertical)
                        .font(.georgia(20))
                        .foregroundStyle(CRUXColor.primaryText)
                        .lineSpacing(6)
                        .focused($isFocused)
                        .onChange(of: text) { _, newValue in
                            if newValue.count > charLimit {
                                text = String(newValue.prefix(charLimit))
                            }
                        }
                        .padding(.horizontal, 28)

                    Spacer()

                    HStack {
                        Spacer()
                        Text("\(text.count)/\(charLimit)")
                            .font(.sfLight(12))
                            .foregroundStyle(CRUXColor.tertiaryText)
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, 16)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(CRUXColor.secondaryText)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.intentText = text
                        dismiss()
                    }
                    .foregroundStyle(CRUXColor.primaryText)
                }
            }
            .toolbarBackground(CRUXColor.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .presentationBackground(CRUXColor.background)
        .onAppear {
            text = store.intentText
            isFocused = true
        }
    }
}
