import SwiftUI

struct TypographyModifier: ViewModifier {
    private let typography: Typography

    @ScaledMetric private var scaledSize: CGFloat

    init(typography: Typography) {
        self.typography = typography
        _scaledSize = ScaledMetric(wrappedValue: typography.spec.size, relativeTo: typography.scalingTextStyle)
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: scaledSize, weight: typography.spec.weight.fontWeight))
            .tracking(typography.tracking(scaledSize: scaledSize))
            .lineSpacing(typography.lineSpacing(scaledSize: scaledSize))
            .textCase(typography.spec.isUppercase ? .uppercase : nil)
    }
}

// MARK: - View

public extension View {
    func typography(_ typography: Typography) -> some View {
        modifier(TypographyModifier(typography: typography))
    }
}
