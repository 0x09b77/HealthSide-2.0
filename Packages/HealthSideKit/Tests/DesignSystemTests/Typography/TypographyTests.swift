@testable import DesignSystem
import SwiftUI
import Testing
import UIKit

@MainActor
struct TypographyTests {
    @Test func `title XL tracking is minus two percent of size`() {
        let tracking = Typography.titleXL.tracking(scaledSize: Typography.titleXL.spec.size)
        #expect(abs(tracking - -0.52) < 0.0001)
    }

    @Test func `overline tracking is plus four percent and uppercase`() {
        let tracking = Typography.overline.tracking(scaledSize: Typography.overline.spec.size)
        #expect(abs(tracking - 0.5) < 0.0001)
        #expect(Typography.overline.spec.isUppercase)
        #expect(!Typography.titleXL.spec.isUppercase)
    }

    @Test func `tracking scales with size`() {
        #expect(Typography.titleXL.tracking(scaledSize: 52) == Typography.titleXL.tracking(scaledSize: 26) * 2)
    }

    @Test func `body M line spacing fills line height multiple`() {
        let size = Typography.bodyM.spec.size
        let fontLineHeight = UIFont.systemFont(ofSize: size, weight: .regular).lineHeight
        let spacing = Typography.bodyM.lineSpacing(scaledSize: size)
        #expect(spacing > 0)
        #expect(abs(spacing - (size * 1.4 - fontLineHeight)) < 0.0001)
    }

    @Test func `auto line height styles have no line spacing`() {
        let autoStyles: [Typography] = [.titleXL, .bodyL, .buttonL, .overline, .tabInactive]
        for style in autoStyles {
            #expect(style.lineSpacing(scaledSize: style.spec.size) == 0)
        }
    }

    @Test func `line spacing is never negative`() {
        for style in Typography.allCases {
            #expect(style.lineSpacing(scaledSize: style.spec.size) >= 0)
        }
    }

    @Test func `scaling text style picks the larger style on a tie`() {
        #expect(Typography.headlineL.scalingTextStyle == .callout)
        #expect(Typography.labelSemibold.scalingTextStyle == .footnote)
        #expect(Typography.overlineS.scalingTextStyle == .caption)
    }

    @Test func `scaling text style is nearest by size`() {
        #expect(Typography.titleXL.scalingTextStyle == .title)
        #expect(Typography.numericCode.scalingTextStyle == .title2)
        #expect(Typography.titleS.scalingTextStyle == .body)
        #expect(Typography.bodyM.scalingTextStyle == .subheadline)
        #expect(Typography.footnote.scalingTextStyle == .footnote)
        #expect(Typography.badge.scalingTextStyle == .caption2)
    }
}
