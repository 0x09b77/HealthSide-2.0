import SwiftUI

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(Typography.allCases, id: \.self) { style in
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(describing: style))
                        .typography(.caption)
                        .foregroundStyle(.text.secondary)
                    Text(style.sample)
                        .typography(style)
                        .foregroundStyle(.text.primary)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .background(.bg.base)
}

private extension Typography {
    var sample: String {
        switch self {
        case .titleXL: "Create your account"
        case .titleL: "Your health, understood. Every result explained in plain language."
        case .numericCode: "482 913"
        case .titleM: "Recent documents"
        case .titleS: "Blood test"
        case .buttonL: "Continue"
        case .headlineL: "Hemoglobin is within range"
        case .bodyLHeavy: "Cholesterol, total"
        case .bodyLBold: "Cholesterol, total"
        case .bodyLSemibold: "Cholesterol, total"
        case .bodyL: "Your results look good overall."
        case .bodyMBold: "Vitamin D"
        case .bodyM: "We found two values slightly outside the reference range. Talk to your doctor."
        case .bodyS: "Results are for information only and are not a medical diagnosis."
        case .calloutSemibold: "Slightly elevated"
        case .callout: "Reference range 4.0 - 5.6"
        case .footnoteBold: "Updated today"
        case .footnote: "Based on the laboratory report uploaded on 12 March."
        case .labelSemibold: "Email address"
        case .labelBold: "Email address"
        case .overline: "Summary"
        case .captionBold: "Normal"
        case .captionSemibold: "Normal"
        case .caption: "12 March 2026"
        case .overlineS: "Biomarkers"
        case .captionS: "Tap a value to see what it means and how it changed over time."
        case .badge: "New"
        case .unit: "mmol/L"
        case .tabActive: "Home"
        case .tabInactive: "Documents"
        }
    }
}
