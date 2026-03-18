import SwiftUI

struct QuoteDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let quote: Quote
    let store: SharedDefaults
    @State private var showHideConfirmation: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                CRUXColor.background.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(quote.text)
                            .font(.georgia(20))
                            .foregroundStyle(CRUXColor.primaryText)
                            .lineSpacing(8)
                            .padding(.top, 32)

                        Spacer().frame(height: 40)

                        Text(quote.author)
                            .font(.sfMedium(14))
                            .foregroundStyle(CRUXColor.primaryText)

                        Text("\(quote.source) \u{00B7} \(quote.reference)")
                            .font(.sfLight(13))
                            .foregroundStyle(CRUXColor.secondaryText)
                            .padding(.top, 2)

                        Text("Trans. \(quote.translator)")
                            .font(.sfLight(12))
                            .foregroundStyle(CRUXColor.tertiaryText)
                            .padding(.top, 2)

                        Spacer().frame(height: 56)

                        HStack(spacing: 0) {
                            Spacer()
                            actionButton(
                                icon: store.isFavorite(quote.id) ? "heart.fill" : "heart",
                                label: "Favourite",
                                action: { store.toggleFavorite(quote.id) }
                            )
                            Spacer()
                            actionButton(
                                icon: store.isHidden(quote.id) ? "eye.slash.fill" : "eye.slash",
                                label: store.isHidden(quote.id) ? "Unhide" : "Hide",
                                action: {
                                    if store.isHidden(quote.id) {
                                        store.toggleHidden(quote.id)
                                    } else {
                                        showHideConfirmation = true
                                    }
                                }
                            )
                            Spacer()
                            ShareLink(
                                item: "\u{201C}\(quote.text)\u{201D} \u{2014} \(quote.author), \(quote.source), \(quote.reference)"
                            ) {
                                VStack(spacing: 6) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 20, weight: .light))
                                        .foregroundStyle(CRUXColor.primaryText)
                                        .frame(width: 44, height: 44)
                                    Text("Share")
                                        .font(.sfLight(11))
                                        .foregroundStyle(CRUXColor.actionLabel)
                                }
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 28)
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(CRUXColor.secondaryText)
                }
            }
            .toolbarBackground(CRUXColor.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .confirmationDialog("Remove from rotation?", isPresented: $showHideConfirmation, titleVisibility: .visible) {
                Button("Hide", role: .destructive) {
                    store.toggleHidden(quote.id)
                }
                Button("Cancel", role: .cancel) {}
            }
        }
        .presentationBackground(CRUXColor.background)
    }

    private func actionButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .light))
                    .foregroundStyle(CRUXColor.primaryText)
                    .frame(width: 44, height: 44)
                Text(label)
                    .font(.sfLight(11))
                    .foregroundStyle(CRUXColor.actionLabel)
            }
        }
    }
}
