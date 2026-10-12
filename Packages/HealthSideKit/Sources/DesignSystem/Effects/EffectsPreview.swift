import SwiftUI

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: .spacing.xl) {
            ShadowSection()
            FocusRingSection()
        }
        .padding(.horizontal, .layout.marginMain)
        .padding(.vertical, .spacing.md)
    }
    .background(.bg.base)
}

private struct ShadowSection: View {
    private let tokens: [(name: String, token: ShadowToken)] = [
        ("card", .card), ("listItem", .listItem), ("cta", .cta), ("ctaS", .ctaS),
        ("fab", .fab), ("brand", .brand), ("avatar", .avatar), ("knob", .knob),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing.lg) {
            Text(verbatim: "shadow")
                .typography(.titleS)
                .foregroundStyle(.text.primary)
            ForEach(tokens, id: \.name) { item in
                Text(verbatim: ".shadow(.\(item.name))")
                    .typography(.caption)
                    .foregroundStyle(.text.secondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .background(
                        RoundedRectangle(cornerRadius: .radius.lg)
                            .fill(.bg.surface)
                            .shadow(item.token)
                    )
            }
        }
    }
}

private struct FocusRingSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing.lg) {
            Text(verbatim: "focusRing")
                .typography(.titleS)
                .foregroundStyle(.text.primary)
            RoundedRectangle(cornerRadius: .radius.md)
                .fill(.bg.surface)
                .frame(height: 48)
                .overlay(Text(verbatim: "ring").typography(.caption).foregroundStyle(.text.secondary))
                .focusRing(in: RoundedRectangle(cornerRadius: .radius.md))
            RoundedRectangle(cornerRadius: .radius.md)
                .fill(.bg.surface)
                .frame(height: 48)
                .overlay(Text(verbatim: "ringActive").typography(.caption).foregroundStyle(.text.secondary))
                .focusRing(.ringActive, in: RoundedRectangle(cornerRadius: .radius.md))
        }
    }
}
