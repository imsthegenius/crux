import Foundation

struct QuoteCollection: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let isLocked: Bool

    static let all: [QuoteCollection] = [
        QuoteCollection(id: "marcus", name: "Marcus Aurelius", description: "Meditations", isLocked: false),
        QuoteCollection(id: "seneca", name: "Seneca", description: "Letters to Lucilius \u{00B7} On the Shortness of Life", isLocked: true),
        QuoteCollection(id: "epictetus", name: "Epictetus", description: "Enchiridion \u{00B7} Discourses", isLocked: true),
        QuoteCollection(id: "musonius", name: "Musonius Rufus", description: "Lectures \u{00B7} Sayings", isLocked: true),
    ]
}
