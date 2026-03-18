import SwiftUI

struct ContentView: View {
    let store: SharedDefaults
    let allQuotes: [Quote]
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: 0) {
                TodayView(store: store, allQuotes: allQuotes)
            } label: {
                Image(systemName: "sun.horizon")
            }

            Tab(value: 1) {
                CollectionsView(store: store, allQuotes: allQuotes)
            } label: {
                Image(systemName: "books.vertical")
            }

            Tab(value: 2) {
                SettingsView(store: store, allQuotes: allQuotes)
            } label: {
                Image(systemName: "gearshape")
            }
        }
        .tint(CRUXColor.primaryText)
        .toolbarBackground(CRUXColor.background, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarColorScheme(.dark, for: .tabBar)
    }
}
