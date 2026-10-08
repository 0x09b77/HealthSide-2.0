import SwiftUI

struct RootView: View {
    // MARK: - UI

    var body: some View {
        titleView
    }
}

// MARK: - Subviews

private extension RootView {
    var titleView: some View {
        Text(.healthside)
    }
}

// MARK: - Preview

#Preview {
    RootView()
}
