import SwiftUI

public struct FormTextField: View {
    // MARK: - Properties

    let label: LocalizedStringResource
    let placeholder: LocalizedStringResource
    let kind: Kind
    let error: LocalizedStringResource?
    @Binding var text: String
    @FocusState private var focusedField: FormTextFieldContent.Field?
    @State private var isRevealed = false

    // MARK: - Init

    public init(
        label: LocalizedStringResource,
        text: Binding<String>,
        placeholder: LocalizedStringResource,
        kind: Kind = .text,
        error: LocalizedStringResource? = nil
    ) {
        self.label = label
        _text = text
        self.placeholder = placeholder
        self.kind = kind
        self.error = error
    }

    // MARK: - UI

    public var body: some View {
        FormTextFieldContent(
            label: label,
            placeholder: placeholder,
            kind: kind,
            error: error,
            isFocused: focusedField != nil,
            text: $text,
            isRevealed: $isRevealed,
            focus: $focusedField
        )
    }
}

// MARK: - Nested types

public extension FormTextField {
    enum Kind {
        case text
        case password
    }
}
