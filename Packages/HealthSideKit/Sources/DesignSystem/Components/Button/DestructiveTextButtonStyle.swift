import SwiftUI

public struct DestructiveTextButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        DestructiveTextButtonContent(label: configuration.label, isPressed: configuration.isPressed)
    }
}

// MARK: - Style

public extension ButtonStyle where Self == DestructiveTextButtonStyle {
    static var destructiveText: DestructiveTextButtonStyle { DestructiveTextButtonStyle() }
}
