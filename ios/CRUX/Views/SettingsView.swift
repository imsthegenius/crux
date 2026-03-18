import SwiftUI

struct SettingsView: View {
    let store: SharedDefaults
    let allQuotes: [Quote]
    @State private var showWidgetGuide: Bool = false

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                CRUXColor.background.ignoresSafeArea()

                List {
                    Section {
                        Button {
                            showWidgetGuide = true
                        } label: {
                            HStack {
                                Text("How to add the widget")
                                    .font(.sfLight(16))
                                    .foregroundStyle(CRUXColor.primaryText)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .light))
                                    .foregroundStyle(CRUXColor.tertiaryText)
                            }
                        }
                        .listRowBackground(CRUXColor.background)
                        .listRowSeparatorTint(CRUXColor.separator)
                    } header: {
                        Text("Widget")
                            .font(.sfLight(12))
                            .foregroundStyle(CRUXColor.tertiaryText)
                    }

                    Section {
                        NavigationLink {
                            CollectionsView(store: store, allQuotes: allQuotes)
                                .navigationBarHidden(true)
                        } label: {
                            Text("Manage collections")
                                .font(.sfLight(16))
                                .foregroundStyle(CRUXColor.primaryText)
                        }
                        .listRowBackground(CRUXColor.background)
                        .listRowSeparatorTint(CRUXColor.separator)
                    } header: {
                        Text("Collections")
                            .font(.sfLight(12))
                            .foregroundStyle(CRUXColor.tertiaryText)
                    }

                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("CRUX v\(appVersion)")
                                .font(.sfLight(13))
                                .foregroundStyle(CRUXColor.secondaryText)

                            Text("No notifications. No streaks. No algorithms.")
                                .font(.sfLight(13))
                                .foregroundStyle(CRUXColor.secondaryText)

                            Text("No data collected. No account required.")
                                .font(.sfLight(12))
                                .foregroundStyle(CRUXColor.tertiaryText)
                        }
                        .listRowBackground(CRUXColor.background)
                        .listRowSeparatorTint(CRUXColor.separator)
                        .padding(.vertical, 4)
                    } header: {
                        Text("About")
                            .font(.sfLight(12))
                            .foregroundStyle(CRUXColor.tertiaryText)
                    }
                }
                .listStyle(.grouped)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .cruxNavigation()
            .sheet(isPresented: $showWidgetGuide) {
                WidgetGuideSheet()
            }
        }
    }
}

private struct WidgetGuideSheet: View {
    @Environment(\.dismiss) private var dismiss

    private let steps: [(icon: String, text: String)] = [
        ("lock.fill", "Lock your phone"),
        ("hand.point.up.left.fill", "Hold the lock screen"),
        ("plus.circle.fill", "Tap Customize"),
        ("square.grid.2x2.fill", "Choose Widgets \u{2192} CRUX"),
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                CRUXColor.background.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {
                    Text("Add it to your\nlock screen.")
                        .font(.georgia(36))
                        .foregroundStyle(CRUXColor.primaryText)
                        .lineSpacing(4)
                        .padding(.top, 40)

                    Spacer().frame(height: 40)

                    VStack(alignment: .leading, spacing: 24) {
                        ForEach(Array(steps.enumerated()), id: \.offset) { _, step in
                            HStack(spacing: 16) {
                                Image(systemName: step.icon)
                                    .font(.system(size: 16))
                                    .foregroundStyle(CRUXColor.primaryText)
                                    .frame(width: 24)

                                Text(step.text)
                                    .font(.sfLight(16))
                                    .foregroundStyle(CRUXColor.primaryText)
                            }
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 28)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(CRUXColor.secondaryText)
                }
            }
            .toolbarBackground(CRUXColor.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .presentationBackground(CRUXColor.background)
    }
}
