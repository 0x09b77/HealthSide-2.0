import SwiftUI

struct FormTextFieldContent: View {
    // MARK: - Properties

    let label: LocalizedStringResource
    let placeholder: LocalizedStringResource
    let kind: FormTextField.Kind
    let error: LocalizedStringResource?
    let isFocused: Bool
    @Binding var text: String
    @Binding var isRevealed: Bool
    var focus: FocusState<Field?>.Binding
    @Environment(\.autocorrectionDisabled) private var isAutocorrectionDisabled

    private var showsSecureInput: Bool {
        switch kind {
        case .text: false
        case .password: !isRevealed
        }
    }

    private var visibleField: Field {
        showsSecureInput ? .secure : .plain
    }

    private var hiddenField: Field {
        showsSecureInput ? .plain : .secure
    }

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .typography(.labelSemibold)
                .foregroundStyle(.text.secondary)
            fieldView
            if let error {
                Text(error)
                    .typography(.caption)
                    .foregroundStyle(.status.critical)
            }
        }
        .onChange(of: focus.wrappedValue) { _, newFocus in
            guard newFocus == hiddenField else { return }
            focus.wrappedValue = visibleField
        }
    }
}

// MARK: - Subviews

private extension FormTextFieldContent {
    var fieldView: some View {
        HStack(spacing: 10) {
            inputView
            trailingView
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity)
        .background(.bg.surface, in: fieldShape)
        .overlay { fieldShape.strokeBorder(borderColor, lineWidth: 1.5) }
        .background {
            if isFocused, error == nil {
                Color.clear.focusRing(in: fieldShape)
            }
        }
    }

    var fieldShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: .radius.md)
    }

    var borderColor: Color {
        if error != nil {
            .status.critical
        } else if isFocused {
            .accent.primary
        } else {
            .border.default
        }
    }
}

// MARK: - inputView

private extension FormTextFieldContent {
    var promptView: Text {
        Text(placeholder).foregroundStyle(.text.placeholder)
    }

    var inputView: some View {
        Text(verbatim: " ")
            .typography(.bodyL)
            .hidden()
            .frame(maxWidth: .infinity)
            .overlay { fieldsView }
    }

    var fieldsView: some View {
        ZStack {
            plainInputView
                .opacity(showsSecureInput ? 0 : 1)
                .allowsHitTesting(!showsSecureInput)
                .accessibilityHidden(showsSecureInput)
            if kind == .password {
                secureInputView
                    .opacity(showsSecureInput ? 1 : 0)
                    .allowsHitTesting(showsSecureInput)
                    .accessibilityHidden(!showsSecureInput)
            }
        }
    }

    var plainInputView: some View {
        TextField(text: $text, prompt: promptView) { Text(label) }
            .typography(.bodyL)
            .foregroundStyle(.text.primary)
            .focused(focus, equals: .plain)
            .autocorrectionDisabled(isAutocorrectionDisabled || kind == .password)
    }

    var secureInputView: some View {
        SecureField(text: $text, prompt: promptView) { Text(label) }
            .typography(.bodyL)
            .foregroundStyle(.text.primary)
            .focused(focus, equals: .secure)
    }
}

// MARK: - trailingView

private extension FormTextFieldContent {
    @ViewBuilder
    var trailingView: some View {
        switch kind {
        case .text:
            clearButton
                .opacity(showsClearButton ? 1 : 0)
                .allowsHitTesting(showsClearButton)
                .accessibilityHidden(!showsClearButton)

        case .password:
            revealButton
        }
    }

    var showsClearButton: Bool {
        isFocused && !text.isEmpty
    }

    var clearButton: some View {
        Button { text = "" } label: {
            Image.icons.clear
                .resizable()
                .frame(width: 18, height: 18)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
                .padding(-13)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(.clearText))
    }

    var revealButton: some View {
        Button { revealToggled() } label: {
            Image.icons.eye
                .resizable()
                .frame(width: 19, height: 19)
                .foregroundStyle(.text.secondary)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
                .padding(-12.5)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(isRevealed ? .hidePassword : .showPassword))
    }

    func revealToggled() {
        isRevealed.toggle()
        guard focus.wrappedValue != nil else { return }
        focus.wrappedValue = visibleField
    }
}

// MARK: - Nested types

extension FormTextFieldContent {
    enum Field: Hashable {
        case plain
        case secure
    }
}
