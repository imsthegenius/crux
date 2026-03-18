import SwiftUI

struct CollectionDetailView: View {
    let collection: QuoteCollection
    let store: SharedDefaults
    let allQuotes: [Quote]
    @State private var selectedQuote: Quote?

    private var collectionQuotes: [Quote] {
        allQuotes.filter { $0.collectionID == collection.id }
    }

    var body: some View {
        ZStack {
            CRUXColor.background.ignoresSafeArea()

            if collection.isLocked {
                lockedView
            } else {
                unlockedView
            }
        }
        .navigationTitle(collection.name)
        .navigationBarTitleDisplayMode(.inline)
        .cruxNavigation()
        .sheet(item: $selectedQuote) { quote in
            QuoteDetailView(quote: quote, store: store)
        }
    }

    private var unlockedView: some View {
        List {
            ForEach(collectionQuotes) { quote in
                Button {
                    selectedQuote = quote
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(quote.short)
                                .font(.sfLight(14))
                                .foregroundStyle(store.isHidden(quote.id) ? CRUXColor.ghostText : CRUXColor.collectionQuoteText)
                                .lineLimit(2)

                            Text(quote.reference)
                                .font(.sfLight(11))
                                .foregroundStyle(CRUXColor.tertiaryText)
                        }

                        Spacer()

                        if store.isHidden(quote.id) {
                            Image(systemName: "eye.slash")
                                .font(.system(size: 12))
                                .foregroundStyle(CRUXColor.tertiaryText)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listRowBackground(CRUXColor.background)
                .listRowSeparatorTint(CRUXColor.separator)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private var lockedView: some View {
        ZStack {
            List {
                ForEach(collectionQuotes.prefix(5)) { quote in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(quote.short)
                            .font(.sfLight(14))
                            .foregroundStyle(CRUXColor.collectionQuoteText)
                            .lineLimit(2)
                        Text(quote.reference)
                            .font(.sfLight(11))
                            .foregroundStyle(CRUXColor.tertiaryText)
                    }
                    .padding(.vertical, 4)
                    .listRowBackground(CRUXColor.background)
                    .listRowSeparatorTint(CRUXColor.separator)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .blur(radius: 8)
            .allowsHitTesting(false)

            VStack(spacing: 16) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(CRUXColor.primaryText)

                Text(collection.name)
                    .font(.georgia(22))
                    .foregroundStyle(CRUXColor.primaryText)

                Text("\(collectionQuotes.count > 0 ? "\(collectionQuotes.count)" : "60") passages from \(collection.name).")
                    .font(.sfLight(15))
                    .foregroundStyle(CRUXColor.secondaryText)

                Button {
                    // TODO: StoreKit purchase
                } label: {
                    Text("Unlock All Collections \u{00B7} $7.99")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(CRUXColor.background)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(CRUXColor.primaryText)
                        .clipShape(.rect(cornerRadius: 10))
                }

                Text("One-time. No subscription.")
                    .font(.sfLight(12))
                    .foregroundStyle(CRUXColor.tertiaryText)
            }
        }
    }
}
