import WidgetKit
import SwiftUI

@main
struct CRUXWidgetBundle: WidgetBundle {
    var body: some Widget {
        DailyPassageWidget()
        IntentInlineWidget()
        QuoteInlineWidget()
        HomeWidget()
    }
}
