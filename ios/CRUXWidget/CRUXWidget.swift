import WidgetKit
import SwiftUI

nonisolated struct QuoteEntry: TimelineEntry {
    let date: Date
    let quoteShort: String
    let quoteAuthor: String
    let quoteFull: String
}

nonisolated struct QuoteProvider: TimelineProvider {
    private let dataProvider = WidgetDataProvider()

    func placeholder(in context: Context) -> QuoteEntry {
        QuoteEntry(
            date: .now,
            quoteShort: "The impediment to action advances action.",
            quoteAuthor: "Marcus Aurelius",
            quoteFull: "The impediment to action advances action. What stands in the way becomes the way."
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> Void) {
        completion(makeEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> Void) {
        let entry = makeEntry()
        let midnight = Calendar.current.startOfDay(for: Date()).addingTimeInterval(86400)
        completion(Timeline(entries: [entry], policy: .after(midnight)))
    }

    private func makeEntry() -> QuoteEntry {
        if let quote = dataProvider.loadDailyQuote() {
            return QuoteEntry(
                date: .now,
                quoteShort: quote.short,
                quoteAuthor: quote.author,
                quoteFull: quote.text
            )
        }
        return QuoteEntry(
            date: .now,
            quoteShort: "Open CRUX to load today's passage.",
            quoteAuthor: "",
            quoteFull: "Open CRUX to load today's passage."
        )
    }
}

struct RectangularWidgetView: View {
    var entry: QuoteEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(entry.quoteShort)
                .font(.system(.caption, design: .default))
                .lineLimit(3)
                .widgetAccentable()

            if !entry.quoteAuthor.isEmpty {
                Text("— \(entry.quoteAuthor)")
                    .font(.system(.caption2, design: .default))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .containerBackground(.clear, for: .widget)
    }
}

struct DailyPassageWidget: Widget {
    let kind = "DailyPassage"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuoteProvider()) { entry in
            RectangularWidgetView(entry: entry)
        }
        .configurationDisplayName("Daily Passage")
        .description("One line. Before you scroll.")
        .supportedFamilies([.accessoryRectangular])
    }
}

struct QuoteInlineWidget: Widget {
    let kind = "QuoteInline"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuoteProvider()) { entry in
            let truncated = entry.quoteShort.count > 50
                ? String(entry.quoteShort.prefix(47)) + "..."
                : entry.quoteShort
            Text(truncated)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("Quick Passage")
        .description("A Stoic passage in one line.")
        .supportedFamilies([.accessoryInline])
    }
}

struct SmallWidgetView: View {
    var entry: QuoteEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.quoteShort)
                .font(.caption)
                .foregroundStyle(.primary)
                .lineLimit(5)

            if !entry.quoteAuthor.isEmpty {
                Text("— \(entry.quoteAuthor)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(.clear, for: .widget)
    }
}

struct HomeWidget: Widget {
    let kind = "HomeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuoteProvider()) { entry in
            SmallWidgetView(entry: entry)
        }
        .configurationDisplayName("CRUX")
        .description("Today's Stoic passage.")
        .supportedFamilies([.systemSmall])
    }
}
