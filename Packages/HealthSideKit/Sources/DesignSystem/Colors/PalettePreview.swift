import SwiftUI

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 20) {
            SwatchSection(title: "bg", tokens: [
                ("base", .bg.base), ("surface", .bg.surface), ("surfaceAlt", .bg.surfaceAlt),
                ("inverse", .bg.inverse), ("inverseEnd", .bg.inverseEnd),
            ])
            SwatchSection(title: "border", tokens: [
                ("default", .border.default), ("subtle", .border.subtle), ("hairline", .border.hairline),
            ])
            SwatchSection(title: "text", tokens: [
                ("primary", .text.primary), ("secondary", .text.secondary), ("disabled", .text.disabled),
                ("placeholder", .text.placeholder), ("onAccent", .text.onAccent),
            ])
            SwatchSection(title: "accent", tokens: [
                ("primary", .accent.primary), ("pressed", .accent.pressed),
                ("gradientStart", .accent.gradientStart), ("gradientEnd", .accent.gradientEnd),
                ("soft", .accent.soft), ("track", .accent.track),
            ])
            SwatchSection(title: "status", tokens: [
                ("green", .status.green), ("greenText", .status.greenText), ("greenSoft", .status.greenSoft),
                ("amber", .status.amber), ("amberText", .status.amberText), ("amberSoft", .status.amberSoft),
                ("critical", .status.critical), ("criticalSoft", .status.criticalSoft),
                ("criticalMuted", .status.criticalMuted),
            ])
            SwatchSection(title: "neutral", tokens: [
                ("iconBg", .neutral.iconBg), ("tabInactive", .neutral.tabInactive),
                ("dotInactive", .neutral.dotInactive), ("ringTrack", .neutral.ringTrack),
            ])
            GradientSection()
        }
        .padding(16)
    }
    .background(.bg.base)
}

private struct SwatchSection: View {
    let title: String
    let tokens: [(name: String, color: Color)]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.text.primary)
            ForEach(tokens, id: \.name) { token in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(token.color)
                        .frame(width: 44, height: 32)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.border.default))
                    Text(verbatim: "\(title).\(token.name)")
                        .font(.footnote)
                        .foregroundStyle(.text.secondary)
                }
            }
        }
    }
}

private struct GradientSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(verbatim: "gradient")
                .font(.headline)
                .foregroundStyle(.text.primary)
            RoundedRectangle(cornerRadius: 12)
                .fill(.gradient.brand)
                .frame(height: 80)
            Color.clear
                .frame(height: 80)
                .background(.gradient.inverse, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}
