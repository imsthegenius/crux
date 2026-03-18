import SwiftUI

enum CRUXColor {
    static let background = Color(hex: "#0D0D0D")
    static let primaryText = Color(hex: "#F5F5F0")
    static let secondaryText = Color(hex: "#8A8A85")
    static let tertiaryText = Color(hex: "#4A4A48")
    static let ghostText = Color(hex: "#3A3A38")
    static let intentText = Color(hex: "#6A6A66")
    static let collectionQuoteText = Color(hex: "#D0CFC8")
    static let actionLabel = Color(hex: "#5A5A58")
    static let separator = Color(hex: "#1E1E1C")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}

extension Font {
    static func georgia(_ size: CGFloat) -> Font {
        .custom("Georgia", size: size)
    }

    static func sfLight(_ size: CGFloat) -> Font {
        .system(size: size, weight: .light)
    }

    static func sfMedium(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium)
    }
}

struct CRUXNavigationModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbarBackground(CRUXColor.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

extension View {
    func cruxNavigation() -> some View {
        modifier(CRUXNavigationModifier())
    }
}
