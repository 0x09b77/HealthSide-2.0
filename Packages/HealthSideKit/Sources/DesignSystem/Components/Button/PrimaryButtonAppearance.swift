import SwiftUI

struct PrimaryButtonAppearance: ButtonStyle {
    let isLoading: Bool

    func makeBody(configuration: Configuration) -> some View {
        PrimaryButtonContent(label: configuration.label, isPressed: configuration.isPressed, isLoading: isLoading)
    }
}
