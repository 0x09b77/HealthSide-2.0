import SwiftUI

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: .spacing.xl) {
            PrimaryButtonSection()
            DestructiveTextButtonSection()
        }
        .padding(.horizontal, .layout.marginMain)
        .padding(.vertical, .spacing.md)
    }
    .background(.bg.base)
}

private struct PrimaryButtonSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing.lg) {
            Text(verbatim: "Primary")
                .typography(.titleS)
                .foregroundStyle(.text.primary)
            Button { } label: { Text(verbatim: "Get started") }
                .buttonStyle(.primary)
            PrimaryButtonContent(label: Text(verbatim: "Get started"), isPressed: true, isLoading: false)
            PrimaryButtonContent(label: Text(verbatim: "Creating account…"), isPressed: false, isLoading: true)
            Button { } label: { Text(verbatim: "Get started") }
                .buttonStyle(.primary)
                .disabled(true)
        }
    }
}

private struct DestructiveTextButtonSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing.lg) {
            Text(verbatim: "Destructive text")
                .typography(.titleS)
                .foregroundStyle(.text.primary)
            Button { } label: { Text(verbatim: "Log out") }
                .buttonStyle(.destructiveText)
            DestructiveTextButtonContent(label: Text(verbatim: "Log out"), isPressed: true)
            Button { } label: { Text(verbatim: "Log out") }
                .buttonStyle(.destructiveText)
                .disabled(true)
        }
    }
}
