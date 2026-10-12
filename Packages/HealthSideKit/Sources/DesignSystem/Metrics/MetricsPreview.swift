import SwiftUI

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: .spacing.xl) {
            RadiusSection()
            SpacingSection()
            LayoutSection()
        }
        .padding(.horizontal, .layout.marginMain)
        .padding(.vertical, .spacing.md)
    }
    .background(.bg.base)
}

private struct RadiusSection: View {
    private let tokens: [(name: String, value: CGFloat)] = [
        ("xs", .radius.xs), ("sm", .radius.sm), ("md", .radius.md), ("lg", .radius.lg),
        ("xl", .radius.xl), ("xxl", .radius.xxl), ("sheet", .radius.sheet), ("full", .radius.full),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing.xs) {
            Text(verbatim: "radius")
                .typography(.titleS)
                .foregroundStyle(.text.primary)
            ForEach(tokens, id: \.name) { token in
                HStack(spacing: .spacing.sm) {
                    RoundedRectangle(cornerRadius: token.value)
                        .fill(.accent.soft)
                        .frame(width: 88, height: 44)
                        .overlay(RoundedRectangle(cornerRadius: token.value).stroke(.accent.primary))
                    Text(verbatim: "radius.\(token.name) \(Int(token.value))")
                        .typography(.caption)
                        .foregroundStyle(.text.secondary)
                }
            }
        }
    }
}

private struct SpacingSection: View {
    private let tokens: [(name: String, value: CGFloat)] = [
        ("xxs", .spacing.xxs), ("xs", .spacing.xs), ("sm", .spacing.sm), ("md", .spacing.md),
        ("lg", .spacing.lg), ("xl", .spacing.xl), ("xxl", .spacing.xxl),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing.xs) {
            Text(verbatim: "spacing")
                .typography(.titleS)
                .foregroundStyle(.text.primary)
            ForEach(tokens, id: \.name) { token in
                HStack(spacing: .spacing.sm) {
                    Rectangle()
                        .fill(.accent.primary)
                        .frame(width: token.value, height: 16)
                    Text(verbatim: "spacing.\(token.name) \(Int(token.value))")
                        .typography(.caption)
                        .foregroundStyle(.text.secondary)
                }
            }
        }
    }
}

private struct LayoutSection: View {
    private let tokens: [(name: String, value: CGFloat)] = [
        ("marginMain", .layout.marginMain), ("marginAuth", .layout.marginAuth),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing.xs) {
            Text(verbatim: "layout")
                .typography(.titleS)
                .foregroundStyle(.text.primary)
            ForEach(tokens, id: \.name) { token in
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(.accent.soft)
                        .frame(width: token.value, height: 32)
                    Rectangle()
                        .fill(.bg.surface)
                        .frame(height: 32)
                        .overlay(
                            Text(verbatim: "layout.\(token.name) \(Int(token.value))")
                                .typography(.caption)
                                .foregroundStyle(.text.secondary)
                                .padding(.spacing.xxs)
                        )
                }
                .clipShape(.rect(cornerRadius: .radius.md))
            }
        }
    }
}
