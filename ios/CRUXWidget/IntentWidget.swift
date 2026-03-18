import WidgetKit
import SwiftUI

nonisolated struct IntentEntry: TimelineEntry {
    let date: Date
    let intentText: String
}

nonisolated struct IntentProvider: TimelineProvider {
    private let dataProvider = WidgetDataProvider()

    func placeholder(in context: Context) -> IntentEntry {
        IntentEntry(date: .now, intentText: "Finish what I start.")
    }

    func getSnapshot(in context: Context, completion: @escaping (IntentEntry) -> Void) {
        completion(makeEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<IntentEntry>) -> Void) {
        let entry = makeEntry()
        let midnight = Calendar.current.startOfDay(for: Date()).addingTimeInterval(86400)
        completion(Timeline(entries: [entry], policy: .after(midnight)))
    }

    private func makeEntry() -> IntentEntry {
        let text = dataProvider.loadIntentText()
        return IntentEntry(
            date: .now,
            intentText: text.isEmpty ? "Set your intent in CRUX" : text
        )
    }
}

struct IntentInlineWidget: Widget {
    let kind = "IntentInline"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: IntentProvider()) { entry in
            Text(entry.intentText)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("Intent")
        .description("Your personal north star.")
        .supportedFamilies([.accessoryInline])
    }
}
