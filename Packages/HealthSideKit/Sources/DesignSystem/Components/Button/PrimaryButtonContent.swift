import SwiftUI

struct PrimaryButtonContent<Label: View>: View {
    // MARK: - Properties

    let label: Label
    let isPressed: Bool
    let isLoading: Bool

    @Environment(\.isEnabled)
    private var isEnabled

    // MARK: - UI

    var body: some View {
        HStack(spacing: 10) {
            if isLoading {
                spinnerView
            }
            label
                .typography(.buttonL)
                .foregroundStyle(.text.onAccent)
        }
        .frame(maxWidth: .infinity)
        .padding(.spacing.md)
        .background(backgroundView)
        .opacity(isEnabled ? 1 : 0.5)
    }
}

// MARK: - Subviews

private extension PrimaryButtonContent {
    var spinnerView: some View {
        ProgressView()
            .tint(.text.onAccent)
            .scaleEffect(0.9)
            .frame(width: 18, height: 18)
    }

    var backgroundView: some View {
        RoundedRectangle(cornerRadius: .radius.md)
            .fill(backgroundColor)
            .shadow(.cta)
    }

    var backgroundColor: Color {
        isPressed && !isLoading ? .accent.pressed : .accent.primary
    }
}
