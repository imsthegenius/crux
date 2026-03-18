import SwiftUI

struct OnboardingView: View {
    @State private var currentPage: Int = 0
    let store: SharedDefaults
    let onComplete: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            CRUXColor.background.ignoresSafeArea()

            TabView(selection: $currentPage) {
                OnboardingPage1()
                    .tag(0)
                OnboardingPage2()
                    .tag(1)
                OnboardingPage3(onComplete: {
                    store.hasCompletedOnboarding = true
                    onComplete()
                })
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? CRUXColor.primaryText : CRUXColor.ghostText)
                        .frame(width: 5, height: 5)
                }
            }
            .padding(.bottom, 32)
        }
        .preferredColorScheme(.dark)
    }
}

private struct OnboardingPage1: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()

            Text("Before your brain\ncan negotiate.")
                .font(.georgia(36))
                .foregroundStyle(CRUXColor.primaryText)
                .lineSpacing(4)

            Spacer().frame(height: 24)

            Group {
                Text("The alarm is on the phone.")
                + Text("\n")
                + Text("Your hand is on it before you're conscious. The day begins without you.")
            }
            .font(.sfLight(17))
            .foregroundStyle(CRUXColor.secondaryText)
            .lineSpacing(6)

            Spacer()
            Spacer()
        }
        .padding(.horizontal, 28)
    }
}

private struct OnboardingPage2: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()

            Text("One line.\nEvery time.")
                .font(.georgia(36))
                .foregroundStyle(CRUXColor.primaryText)
                .lineSpacing(4)

            Spacer().frame(height: 24)

            Text("A passage from Marcus Aurelius, Seneca, or Epictetus. Under the clock. Before you scroll.")
                .font(.sfLight(17))
                .foregroundStyle(CRUXColor.secondaryText)
                .lineSpacing(6)

            Spacer().frame(height: 40)

            MockLockScreen()

            Spacer()
            Spacer()
        }
        .padding(.horizontal, 28)
    }
}

private struct MockLockScreen: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 32)

            Text("12:41")
                .font(.system(size: 48, weight: .thin))
                .foregroundStyle(CRUXColor.primaryText)

            Spacer().frame(height: 20)

            VStack(alignment: .leading, spacing: 4) {
                Text("The impediment to action advances action. What stands in the way becomes the way.")
                    .font(.georgia(13))
                    .foregroundStyle(CRUXColor.primaryText)
                    .lineSpacing(3)

                Text("— Marcus Aurelius")
                    .font(.sfLight(11))
                    .foregroundStyle(CRUXColor.secondaryText)
            }
            .padding(.horizontal, 16)

            Spacer().frame(height: 32)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "#1A1A1A"))
        )
    }
}

private struct OnboardingPage3: View {
    let onComplete: () -> Void

    private let steps: [(icon: String, text: String)] = [
        ("lock.fill", "Lock your phone"),
        ("hand.point.up.left.fill", "Hold the lock screen"),
        ("plus.circle.fill", "Tap Customize"),
        ("square.grid.2x2.fill", "Choose Widgets \u{2192} CRUX"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()

            Text("Add it to your\nlock screen.")
                .font(.georgia(36))
                .foregroundStyle(CRUXColor.primaryText)
                .lineSpacing(4)

            Spacer().frame(height: 40)

            VStack(alignment: .leading, spacing: 24) {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
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

            Button(action: onComplete) {
                Text("Done")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(CRUXColor.background)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(CRUXColor.primaryText)
                    .clipShape(.rect(cornerRadius: 12))
            }

            Spacer().frame(height: 60)
        }
        .padding(.horizontal, 28)
    }
}
