import Foundation

nonisolated struct SharedQuote: Codable, Sendable {
    let id: String
    let text: String
    let short: String
    let author: String
    let source: String
    let reference: String
    let translator: String
    let collectionID: String
}

nonisolated struct WidgetDataProvider: Sendable {
    private let defaults: UserDefaults?

    init() {
        self.defaults = UserDefaults(suiteName: "group.com.crux.shared")
    }

    func loadDailyQuote() -> SharedQuote? {
        if let data = defaults?.data(forKey: "dailyQuote"),
           let quote = try? JSONDecoder().decode(SharedQuote.self, from: data) {
            return quote
        }
        return loadDailyQuoteFromBundle()
    }

    func loadIntentText() -> String {
        defaults?.string(forKey: "intentText") ?? ""
    }

    private func loadDailyQuoteFromBundle() -> SharedQuote? {
        guard let url = Bundle.main.url(forResource: "quotes", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let quotes = try? JSONDecoder().decode([SharedQuote].self, from: data),
              !quotes.isEmpty else {
            return nil
        }

        let hiddenIDs: [String] = {
            guard let data = defaults?.data(forKey: "hiddenQuoteIDs"),
                  let ids = try? JSONDecoder().decode([String].self, from: data) else { return [] }
            return ids
        }()

        let activeIDs: [String] = {
            guard let data = defaults?.data(forKey: "activeCollectionIDs"),
                  let ids = try? JSONDecoder().decode([String].self, from: data) else { return ["marcus"] }
            return ids.isEmpty ? ["marcus"] : ids
        }()

        let activeQuotes = quotes.filter { activeIDs.contains($0.collectionID) && !hiddenIDs.contains($0.id) }
        guard !activeQuotes.isEmpty else { return quotes.first }

        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % activeQuotes.count
        return activeQuotes[index]
    }
}
