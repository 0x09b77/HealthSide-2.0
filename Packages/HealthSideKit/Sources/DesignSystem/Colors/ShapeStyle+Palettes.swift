import SwiftUI

public extension ShapeStyle where Self == Color {
    static var bg: BgPalette { BgPalette() }
    static var border: BorderPalette { BorderPalette() }
    static var text: TextPalette { TextPalette() }
    static var accent: AccentPalette { AccentPalette() }
    static var status: StatusPalette { StatusPalette() }
    static var neutral: NeutralPalette { NeutralPalette() }
}

public extension ShapeStyle where Self == LinearGradient {
    static var gradient: GradientPalette { GradientPalette() }
}
