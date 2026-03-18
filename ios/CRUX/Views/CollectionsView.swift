import SwiftUI

struct CollectionsView: View {
    let store: SharedDefaults
    let allQuotes: [Quote]

    var body: some View {
        NavigationStack {
            ZStack {
                CRUXColor.background.ignoresSafeArea()

                List {
                    ForEach(QuoteCollection.all) { collection in
                        NavigationLink(value: collection) {
                            CollectionRow(collection: collection, store: store, allQuotes: allQuotes)
                        }
                        .listRowBackground(CRUXColor.background)
                        .listRowSeparatorTint(CRUXColor.separator)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .navigationDestination(for: QuoteCollection.self) { collection in
                    CollectionDetailView(collection: collection, store: store, allQuotes: allQuotes)
                }
            }
            .navigationTitle("Collections")
            .cruxNavigation()
        }
    }
}

private struct CollectionRow: View {
    let collection: QuoteCollection
    let store: SharedDefaults
    let allQuotes: [Quote]

    private var quoteCount: Int {
        allQuotes.filter { $0.collectionID == collection.id }.count
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(collection.name)
                    .font(.sfLight(16))
                    .foregroundStyle(CRUXColor.primaryText)

                Text(collection.description)
                    .font(.sfLight(13))
                    .foregroundStyle(CRUXColor.secondaryText)

                Text("\(quoteCount) passages")
                    .font(.sfLight(11))
                    .tracking(0.3)
                    .foregroundStyle(CRUXColor.tertiaryText)
            }

            Spacer()

            if collection.isLocked {
                HStack(spacing: 4) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(CRUXColor.primaryText)
                    Text("$7.99")
                        .font(.sfLight(13))
                        .foregroundStyle(CRUXColor.secondaryText)
                }
            } else {
                Toggle("", isOn: Binding(
                    get: { store.isCollectionActive(collection.id) },
                    set: { _ in store.toggleCollection(collection.id) }
                ))
                .tint(CRUXColor.primaryText)
                .labelsHidden()
            }
        }
        .padding(.vertical, 4)
    }
}
