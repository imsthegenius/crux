import SwiftUI
import WidgetKit

@main
struct CRUXApp: App {
    @State private var store = SharedDefaults.shared
    @State private var allQuotes: [Quote] = []
    @State private var showOnboarding: Bool = false

    var body: some Scene {
        WindowGroup {
            Group {
                if showOnboarding {
                    OnboardingView(store: store, onComplete: {
                        withAnimation {
                            showOnboarding = false
                        }
                    })
                } else {
                    ContentView(store: store, allQuotes: allQuotes)
                }
            }
            .preferredColorScheme(.dark)
            .onAppear {
                allQuotes = QuoteService.loadAllQuotes()
                showOnboarding = !store.hasCompletedOnboarding
                if let daily = QuoteService.dailyQuote(allQuotes: allQuotes, store: store) {
                    store.writeDailyQuote(daily)
                }
            }
        }
    }
}
