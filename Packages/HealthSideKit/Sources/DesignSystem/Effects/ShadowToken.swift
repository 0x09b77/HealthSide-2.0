import SwiftUI

public struct ShadowToken {
    let color: Color
    let radius: CGFloat
    let offsetY: CGFloat

    init(color: Color, offsetY: CGFloat, blur: CGFloat) {
        self.color = color
        self.offsetY = offsetY
        radius = blur / 2
    }
}

// MARK: - Tokens

public extension ShadowToken {
    static var card: ShadowToken { ShadowToken(color: Color(.shadowWarm).opacity(0.06), offsetY: 8, blur: 22) }
    static var listItem: ShadowToken { ShadowToken(color: Color(.shadowWarm).opacity(0.05), offsetY: 6, blur: 16) }
    static var cta: ShadowToken { ShadowToken(color: Color.accent.primary.opacity(0.32), offsetY: 10, blur: 22) }
    static var ctaS: ShadowToken { ShadowToken(color: Color.accent.primary.opacity(0.30), offsetY: 6, blur: 14) }
    static var fab: ShadowToken { ShadowToken(color: Color.accent.primary.opacity(0.40), offsetY: 10, blur: 20) }
    static var brand: ShadowToken { ShadowToken(color: Color(.shadowBrand).opacity(0.30), offsetY: 10, blur: 22) }
    static var avatar: ShadowToken { ShadowToken(color: Color(.shadowBrand).opacity(0.28), offsetY: 8, blur: 18) }
    static var knob: ShadowToken { ShadowToken(color: Color.black.opacity(0.20), offsetY: 1, blur: 3) }
}

// MARK: - View

public extension View {
    func shadow(_ token: ShadowToken) -> some View {
        shadow(color: token.color, radius: token.radius, x: 0, y: token.offsetY)
    }
}
