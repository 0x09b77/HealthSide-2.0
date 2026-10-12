import SwiftUI

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: .spacing.xl) {
            FormTextFieldSection(kind: .text)
            FormTextFieldSection(kind: .password)
        }
        .padding(.horizontal, .layout.marginMain)
        .padding(.vertical, .spacing.md)
    }
    .background(.bg.base)
}

private struct FormTextFieldSection: View {
    let kind: FormTextField.Kind

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing.lg) {
            Text(verbatim: title)
                .typography(.titleS)
                .foregroundStyle(.text.primary)
            FormTextFieldPreviewCell(kind: kind, text: "", isFocused: false, error: nil)
            FormTextFieldPreviewCell(kind: kind, text: sampleText, isFocused: false, error: nil)
            FormTextFieldPreviewCell(kind: kind, text: sampleText, isFocused: true, error: nil)
            FormTextFieldPreviewCell(kind: kind, text: sampleText, isFocused: false, error: errorText)
            if kind == .password {
                FormTextFieldPreviewCell(kind: kind, text: sampleText, isFocused: false, error: nil, isRevealed: true)
            }
        }
    }

    private var title: String {
        switch kind {
        case .text: "Text"
        case .password: "Password"
        }
    }

    private var sampleText: String {
        switch kind {
        case .text: "you@email.com"
        case .password: "secret123"
        }
    }

    private var errorText: LocalizedStringResource {
        FormTextFieldPreviewCell.resource("Incorrect email or password")
    }
}

private struct FormTextFieldPreviewCell: View {
    let kind: FormTextField.Kind
    let isFocused: Bool
    let error: LocalizedStringResource?
    @State private var text: String
    @State private var isRevealed: Bool
    @FocusState private var focus: FormTextFieldContent.Field?

    init(
        kind: FormTextField.Kind,
        text: String,
        isFocused: Bool,
        error: LocalizedStringResource?,
        isRevealed: Bool = false
    ) {
        self.kind = kind
        self.isFocused = isFocused
        self.error = error
        _text = State(initialValue: text)
        _isRevealed = State(initialValue: isRevealed)
    }

    var body: some View {
        FormTextFieldContent(
            label: label,
            placeholder: placeholder,
            kind: kind,
            error: error,
            isFocused: isFocused,
            text: $text,
            isRevealed: $isRevealed,
            focus: $focus
        )
    }

    static func resource(_ sample: String) -> LocalizedStringResource {
        LocalizedStringResource(String.LocalizationValue(sample))
    }

    private var label: LocalizedStringResource {
        switch kind {
        case .text: Self.resource("Email")
        case .password: Self.resource("Password")
        }
    }

    private var placeholder: LocalizedStringResource {
        switch kind {
        case .text: Self.resource("you@email.com")
        case .password: Self.resource("Password")
        }
    }
}
