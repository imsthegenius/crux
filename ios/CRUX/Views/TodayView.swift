import SwiftUI

struct TodayView: View {
    let store: SharedDefaults
    let allQuotes: [Quote]
    @State private var showQuoteDetail: Bool = false
    @State private var showIntentEditor: Bool = false

    private var dailyQuote: Quote? {
        QuoteService.dailyQuote(allQuotes: allQuotes, store: store)
    }

    var body: some View {
        ZStack {
            CRUXColor.background.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Text("DAY \(QuoteService.dayOfYear())")
                    .font(.system(size: 11, weight: .light))
                    .tracking(2)
                    .foregroundStyle(CRUXColor.ghostText)
                    .padding(.top, 16)

                Spacer()

                if let quote = dailyQuote {
                    Button {
                        showQuoteDetail = true
                    } label: {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(quote.text)
                                .font(.georgia(22))
                                .foregroundStyle(CRUXColor.primaryText)
                                .lineSpacing(8)
                                .multilineTextAlignment(.leading)

                            Spacer().frame(height: 32)

                            Text("— \(quote.author)")
                                .font(.sfLight(13))
                                .foregroundStyle(CRUXColor.secondaryText)

                            Text("\(quote.source), \(quote.reference)")
                                .font(.sfLight(12))
                                .tracking(0.3)
                                .foregroundStyle(CRUXColor.tertiaryText)
                                .padding(.top, 2)
                        }
                    }
                    .buttonStyle(.plain)
                }

                Spacer()

                Button {
                    showIntentEditor = true
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("INTENT")
                            .font(.sfLight(10))
                            .tracking(1.5)
                            .foregroundStyle(CRUXColor.tertiaryText)

                        if store.intentText.isEmpty {
                            Text("Set your intent \u{2192}")
                                .font(.sfLight(15))
                                .foregroundStyle(CRUXColor.ghostText)
                        } else {
                            Text(store.intentText)
                                .font(.system(size: 15, weight: .light).italic())
                                .foregroundStyle(CRUXColor.intentText)
                        }
                    }
                }
                .buttonStyle(.plain)
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 28)
        }
        .sheet(isPresented: $showQuoteDetail) {
            if let quote = dailyQuote {
                QuoteDetailView(quote: quote, store: store)
            }
        }
        .fullScreenCover(isPresented: $showIntentEditor) {
            IntentEditorView(store: store)
        }
    }
}
