import Foundation
import WidgetKit

@Observable
@MainActor
class SharedDefaults {
    static let shared = SharedDefaults()

    private let defaults: UserDefaults

    var hiddenQuoteIDs: [String] {
        didSet { save(hiddenQuoteIDs, forKey: "hiddenQuoteIDs"); reloadWidgets() }
    }
    var favoriteQuoteIDs: [String] {
        didSet { save(favoriteQuoteIDs, forKey: "favoriteQuoteIDs") }
    }
    var activeCollectionIDs: [String] {
        didSet { save(activeCollectionIDs, forKey: "activeCollectionIDs"); reloadWidgets() }
    }
    var hasCompletedOnboarding: Bool {
        didSet { defaults.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding") }
    }
    var intentText: String {
        didSet { defaults.set(intentText, forKey: "intentText"); reloadWidgets() }
    }

    private init() {
        let suite = UserDefaults(suiteName: "group.com.crux.shared") ?? .standard
        self.defaults = suite
        self.hiddenQuoteIDs = (try? Self.load([String].self, from: suite, key: "hiddenQuoteIDs")) ?? []
        self.favoriteQuoteIDs = (try? Self.load([String].self, from: suite, key: "favoriteQuoteIDs")) ?? []
        self.activeCollectionIDs = (try? Self.load([String].self, from: suite, key: "activeCollectionIDs")) ?? ["marcus"]
        self.hasCompletedOnboarding = suite.bool(forKey: "hasCompletedOnboarding")
        self.intentText = suite.string(forKey: "intentText") ?? ""
    }

    func writeDailyQuote(_ quote: Quote) {
        if let data = try? JSONEncoder().encode(quote) {
            defaults.set(data, forKey: "dailyQuote")
            reloadWidgets()
        }
    }

    func isFavorite(_ id: String) -> Bool {
        favoriteQuoteIDs.contains(id)
    }

    func toggleFavorite(_ id: String) {
        if let index = favoriteQuoteIDs.firstIndex(of: id) {
            favoriteQuoteIDs.remove(at: index)
        } else {
            favoriteQuoteIDs.append(id)
        }
    }

    func isHidden(_ id: String) -> Bool {
        hiddenQuoteIDs.contains(id)
    }

    func toggleHidden(_ id: String) {
        if let index = hiddenQuoteIDs.firstIndex(of: id) {
            hiddenQuoteIDs.remove(at: index)
        } else {
            hiddenQuoteIDs.append(id)
        }
    }

    func isCollectionActive(_ id: String) -> Bool {
        activeCollectionIDs.contains(id)
    }

    func toggleCollection(_ id: String) {
        if let index = activeCollectionIDs.firstIndex(of: id) {
            if activeCollectionIDs.count > 1 {
                activeCollectionIDs.remove(at: index)
            }
        } else {
            activeCollectionIDs.append(id)
        }
    }

    private func save<T: Encodable>(_ value: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(value) {
            defaults.set(data, forKey: key)
        }
    }

    nonisolated private static func load<T: Decodable>(_ type: T.Type, from defaults: UserDefaults, key: String) throws -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }

    private func reloadWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}
