import DesignSystem
import SwiftUI

struct RootView: View {
    // MARK: - Properties

    @State private var viewModel = RootViewModel()

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing.lg) {
            titleView
            emailFieldView
            passwordFieldView
        }
        .padding(.horizontal, .layout.marginMain)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.bg.base)
    }
}

// MARK: - Subviews

private extension RootView {
    var titleView: some View {
        Text(.healthside)
    }
}

// MARK: - emailFieldView

private extension RootView {
    var emailFieldView: some View {
        FormTextField(
            label: .email,
            text: Binding(get: { viewModel.email }, set: { viewModel.emailChanged($0) }),
            placeholder: .youEmailCom
        )
        .keyboardType(.emailAddress)
        .textContentType(.emailAddress)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
    }
}

// MARK: - passwordFieldView

private extension RootView {
    var passwordFieldView: some View {
        FormTextField(
            label: .password,
            text: Binding(get: { viewModel.password }, set: { viewModel.passwordChanged($0) }),
            placeholder: .password,
            kind: .password
        )
        .textContentType(.password)
    }
}

// MARK: - Preview

#Preview {
    RootView()
}
