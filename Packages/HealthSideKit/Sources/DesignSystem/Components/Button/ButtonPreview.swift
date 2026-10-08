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
            Text("Primary")
                .typography(.titleS)
                .foregroundStyle(.text.primary)
            Button("Get started") {}
                .buttonStyle(.primary)
            PrimaryButtonContent(label: Text("Get started"), isPressed: true, isLoading: false)
            PrimaryButtonContent(label: Text("Creating account…"), isPressed: false, isLoading: true)
            Button("Get started") {}
                .buttonStyle(.primary)
                .disabled(true)
        }
    }
}

private struct DestructiveTextButtonSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing.lg) {
            Text("Destructive text")
                .typography(.titleS)
                .foregroundStyle(.text.primary)
            Button("Log out") {}
                .buttonStyle(.destructiveText)
            DestructiveTextButtonContent(label: Text("Log out"), isPressed: true)
            Button("Log out") {}
                .buttonStyle(.destructiveText)
                .disabled(true)
        }
    }
}
