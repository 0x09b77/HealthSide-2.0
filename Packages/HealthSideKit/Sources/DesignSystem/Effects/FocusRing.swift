import SwiftUI

public enum FocusRing {
    case ring
    case ringActive
}

// MARK: - Appearance

extension FocusRing {
    var spread: CGFloat { 4 }

    var color: Color {
        switch self {
        case .ring:
            Color.accent.primary.opacity(0.12)

        case .ringActive:
            Color.accent.primary.opacity(0.14)
        }
    }
}

// MARK: - View

public extension View {
    func focusRing(_ ring: FocusRing = .ring, in shape: some InsettableShape) -> some View {
        overlay {
            shape
                .inset(by: -ring.spread / 2)
                .stroke(ring.color, lineWidth: ring.spread)
                .allowsHitTesting(false)
        }
    }
}
