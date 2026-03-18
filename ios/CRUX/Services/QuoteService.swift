import Foundation

@MainActor
struct QuoteService {
    static func loadAllQuotes() -> [Quote] {
        guard let url = Bundle.main.url(forResource: "quotes", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let quotes = try? JSONDecoder().decode([Quote].self, from: data) else {
            return []
        }
        return quotes
    }

    static func dailyQuote(allQuotes: [Quote], store: SharedDefaults) -> Quote? {
        let activeQuotes = allQuotes.filter { quote in
            store.activeCollectionIDs.contains(quote.collectionID) && !store.hiddenQuoteIDs.contains(quote.id)
        }
        guard !activeQuotes.isEmpty else { return allQuotes.first }
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % activeQuotes.count
        return activeQuotes[index]
    }

    static func dayOfYear() -> Int {
        Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
    }
}
