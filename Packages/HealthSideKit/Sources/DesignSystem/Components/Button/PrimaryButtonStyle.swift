import SwiftUI

public struct PrimaryButtonStyle: PrimitiveButtonStyle {
    let isLoading: Bool

    public func makeBody(configuration: Configuration) -> some View {
        Button(role: configuration.role) {
            guard !isLoading else { return }
            configuration.trigger()
        } label: {
            configuration.label
        }
        .buttonStyle(PrimaryButtonAppearance(isLoading: isLoading))
    }
}

// MARK: - Style

public extension PrimitiveButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle(isLoading: false) }

    static func primary(isLoading: Bool) -> PrimaryButtonStyle {
        PrimaryButtonStyle(isLoading: isLoading)
    }
}
