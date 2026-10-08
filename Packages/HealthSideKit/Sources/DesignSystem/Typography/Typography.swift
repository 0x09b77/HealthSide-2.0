import SwiftUI

public enum Typography: CaseIterable {
    case titleXL
    case titleL
    case numericCode
    case titleM
    case titleS
    case buttonL
    case headlineL
    case bodyLHeavy
    case bodyLBold
    case bodyLSemibold
    case bodyL
    case bodyMBold
    case bodyM
    case bodyS
    case calloutSemibold
    case callout
    case footnoteBold
    case footnote
    case labelSemibold
    case labelBold
    case overline
    case captionBold
    case captionSemibold
    case caption
    case overlineS
    case captionS
    case badge
    case unit
    case tabActive
    case tabInactive
}

// MARK: - Spec

extension Typography {
    var spec: Spec {
        switch self {
        case .titleXL: Spec(size: 26, weight: .heavy, tracking: -0.02)
        case .titleL: Spec(size: 24, weight: .heavy, lineHeightMultiple: 1.25, tracking: -0.02)
        case .numericCode: Spec(size: 22, weight: .bold)
        case .titleM: Spec(size: 18, weight: .heavy)
        case .titleS: Spec(size: 17, weight: .heavy)
        case .buttonL: Spec(size: 16, weight: .bold)
        case .headlineL: Spec(size: 15.5, weight: .bold)
        case .bodyLHeavy: Spec(size: 15, weight: .heavy)
        case .bodyLBold: Spec(size: 15, weight: .bold)
        case .bodyLSemibold: Spec(size: 15, weight: .semibold)
        case .bodyL: Spec(size: 15, weight: .regular)
        case .bodyMBold: Spec(size: 14.5, weight: .bold)
        case .bodyM: Spec(size: 14.5, weight: .regular, lineHeightMultiple: 1.4)
        case .bodyS: Spec(size: 14, weight: .regular, lineHeightMultiple: 1.5)
        case .calloutSemibold: Spec(size: 13.5, weight: .semibold, lineHeightMultiple: 1.4)
        case .callout: Spec(size: 13.5, weight: .regular)
        case .footnoteBold: Spec(size: 13, weight: .bold)
        case .footnote: Spec(size: 13, weight: .regular, lineHeightMultiple: 1.4)
        case .labelSemibold: Spec(size: 12.5, weight: .semibold)
        case .labelBold: Spec(size: 12.5, weight: .bold)
        case .overline: Spec(size: 12.5, weight: .bold, tracking: 0.04, isUppercase: true)
        case .captionBold: Spec(size: 12, weight: .bold)
        case .captionSemibold: Spec(size: 12, weight: .semibold)
        case .caption: Spec(size: 12, weight: .regular)
        case .overlineS: Spec(size: 11.5, weight: .bold, tracking: 0.04, isUppercase: true)
        case .captionS: Spec(size: 11.5, weight: .regular, lineHeightMultiple: 1.5)
        case .badge: Spec(size: 11, weight: .bold)
        case .unit: Spec(size: 11, weight: .medium)
        case .tabActive: Spec(size: 11, weight: .bold)
        case .tabInactive: Spec(size: 11, weight: .regular)
        }
    }
}

// MARK: - Computations

extension Typography {
    var scalingTextStyle: Font.TextStyle {
        let nearest = Constants.textStyleSizes.min { first, second in
            abs(first.size - spec.size) < abs(second.size - spec.size)
        }
        return nearest?.style ?? .body
    }

    func tracking(scaledSize: CGFloat) -> CGFloat {
        scaledSize * spec.tracking
    }

    func lineSpacing(scaledSize: CGFloat) -> CGFloat {
        guard let multiple = spec.lineHeightMultiple else { return 0 }
        let fontLineHeight = UIFont.systemFont(ofSize: scaledSize, weight: spec.weight.uiFontWeight).lineHeight
        return max(0, scaledSize * multiple - fontLineHeight)
    }
}

// MARK: - Nested types

extension Typography {
    struct Spec {
        let size: CGFloat
        let weight: Weight
        var lineHeightMultiple: CGFloat?
        var tracking: CGFloat = 0
        var isUppercase = false
    }

    enum Weight {
        case regular
        case medium
        case semibold
        case bold
        case heavy

        var fontWeight: Font.Weight {
            switch self {
            case .regular: .regular
            case .medium: .medium
            case .semibold: .semibold
            case .bold: .bold
            case .heavy: .heavy
            }
        }

        var uiFontWeight: UIFont.Weight {
            switch self {
            case .regular: .regular
            case .medium: .medium
            case .semibold: .semibold
            case .bold: .bold
            case .heavy: .heavy
            }
        }
    }

    private enum Constants {
        static let textStyleSizes: [(size: CGFloat, style: Font.TextStyle)] = [
            (34, .largeTitle),
            (28, .title),
            (22, .title2),
            (20, .title3),
            (17, .body),
            (16, .callout),
            (15, .subheadline),
            (13, .footnote),
            (12, .caption),
            (11, .caption2),
        ]
    }
}
