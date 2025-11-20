//
//  ViewExtensions.swift
//  BalanceTrackAI
//
//  Additional view helpers and extensions
//

import SwiftUI

// MARK: - Conditional Modifiers

extension View {
    /// Applies a modifier conditionally
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Applies one of two modifiers based on condition
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
}

// MARK: - Animations

extension View {
    /// Adds a spring animation with custom parameters
    func springAnimation(
        duration: Double = 0.6,
        bounce: Double = 0.3,
        delay: Double = 0
    ) -> some View {
        self.animation(
            .spring(duration: duration, bounce: bounce).delay(delay),
            value: UUID()
        )
    }

    /// Adds a smooth ease animation
    func smoothAnimation(duration: Double = 0.3, delay: Double = 0) -> some View {
        self.animation(
            .easeInOut(duration: duration).delay(delay),
            value: UUID()
        )
    }

    /// Shake effect for errors
    func shake(animatableData: CGFloat) -> some View {
        self.modifier(ShakeEffect(animatableData: animatableData))
    }
}

struct ShakeEffect: ViewModifier {
    var animatableData: CGFloat

    func body(content: Content) -> some View {
        content
            .offset(x: animatableData * 10)
    }
}

// MARK: - Keyboard

extension View {
    /// Dismisses keyboard when tapped
    func dismissKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
    }
}

// MARK: - Cards

extension View {
    /// Standard card style used throughout the app
    func cardStyle(padding: CGFloat = 16, cornerRadius: CGFloat = 20) -> some View {
        self
            .padding(padding)
            .liquidGlass(cornerRadius: cornerRadius, opacity: 0.12)
    }

    /// Elevated card with stronger shadow
    func elevatedCard(padding: CGFloat = 20, cornerRadius: CGFloat = 24) -> some View {
        self
            .padding(padding)
            .animatedGlassCard(cornerRadius: cornerRadius)
    }
}

// MARK: - Loading States

struct LoadingView: View {
    var message: String = "Loading..."

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.animeAccent1)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient.animeGradient
                )

            Text(title)
                .font(.title3)
                .fontWeight(.bold)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Error Handling

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.expenseRed)

            Text("Something went wrong")
                .font(.title2)
                .fontWeight(.bold)

            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: retryAction) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Retry")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(LinearGradient.animeGradient)
                .clipShape(Capsule())
            }
        }
        .padding()
    }
}

// MARK: - Number Formatting

extension Double {
    /// Formats as currency
    var asCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }

    /// Formats as percentage
    var asPercentage: String {
        String(format: "%.1f%%", self)
    }

    /// Formats with thousand separators
    var asFormattedNumber: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}

// MARK: - Date Formatting

extension Date {
    /// Returns a relative date string (e.g., "2 days ago")
    var relativeFormat: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    /// Returns a short date string (e.g., "Jan 15")
    var shortFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }

    /// Returns a medium date string (e.g., "Jan 15, 2024")
    var mediumFormat: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }

    /// Returns full date and time
    var fullFormat: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

// MARK: - Safe Area

struct SafeAreaInsetsKey: PreferenceKey {
    static var defaultValue: EdgeInsets = .init()

    static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {
        value = nextValue()
    }
}

extension View {
    func getSafeAreaInsets(_ safeInsets: Binding<EdgeInsets>) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(
                        key: SafeAreaInsetsKey.self,
                        value: geometry.safeAreaInsets
                    )
            }
        )
        .onPreferenceChange(SafeAreaInsetsKey.self) { insets in
            safeInsets.wrappedValue = insets
        }
    }
}

// MARK: - Haptics

struct HapticManager {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

extension View {
    func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.onTapGesture {
            HapticManager.impact(style)
        }
    }
}
