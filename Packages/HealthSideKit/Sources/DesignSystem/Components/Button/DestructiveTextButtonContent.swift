import SwiftUI

struct DestructiveTextButtonContent<Label: View>: View {
    // MARK: - Properties

    let label: Label
    let isPressed: Bool

    @Environment(\.isEnabled)
    private var isEnabled

    // MARK: - UI

    var body: some View {
        label
            .typography(.bodyLBold)
            .foregroundStyle(.status.critical)
            .opacity(isPressed ? 0.5 : 1)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, .spacing.md)
            .padding(.vertical, 13)
            .contentShape(Rectangle())
            .opacity(isEnabled ? 1 : 0.5)
    }
}
