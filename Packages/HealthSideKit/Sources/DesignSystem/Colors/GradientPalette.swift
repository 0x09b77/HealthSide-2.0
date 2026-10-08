import SwiftUI

public struct GradientPalette {
    public var brand: LinearGradient {
        LinearGradient(
            colors: [Color.accent.gradientStart, Color.accent.gradientEnd],
            angle: .degrees(155)
        )
    }

    public var inverse: LinearGradient {
        LinearGradient(
            colors: [Color.bg.inverse, Color.bg.inverseEnd],
            angle: .degrees(120)
        )
    }
}

// MARK: - CSS angle

private extension LinearGradient {
    init(colors: [Color], angle: Angle) {
        let direction = CGPoint(x: sin(angle.radians), y: -cos(angle.radians))
        let halfLength = (abs(direction.x) + abs(direction.y)) / 2
        let center = 0.5
        self.init(
            colors: colors,
            startPoint: UnitPoint(
                x: center - direction.x * halfLength,
                y: center - direction.y * halfLength
            ),
            endPoint: UnitPoint(
                x: center + direction.x * halfLength,
                y: center + direction.y * halfLength
            )
        )
    }
}
