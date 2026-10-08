---
paths:
  - "**/*View.swift"
---

# Feature Views

How feature SwiftUI views and their animations are written. What the view may do at all is [mvvm.md](../architecture/mvvm.md).

## View structure

- Sections in this order: `// MARK: - Properties`, `// MARK: - Init`, `// MARK: - UI` (the `body`), then the subview extensions, and the file ends with `// MARK: - Preview` and the `#Preview`.
- `body` is a flat composition of named subviews. Padding and other layout modifiers are applied at the call site in `body`, never inside the subview.
- Every subview is a computed `var` or `func` in a `private extension` of the view. The first extension is `// MARK: - Subviews` (chrome: navigation bar, titles, texts); each major block gets its own extension named after the property (`// MARK: - filtersListView`).
- A subview reused inside the feature becomes its own `View` in `Features/<Feature>/Components/`; reused across features, in the `DesignSystem` module of `HealthSideKit`.
- `body` ends with `.task { await viewModel.onAppear() }` when the screen loads anything.
- A view logs nothing. What is worth recording happens in the ViewModel or a client.

```swift
struct PhotoEditorView: View {
    // MARK: - Properties

    @State private var viewModel: PhotoEditorViewModel

    // MARK: - Init

    init(photoID: Photo.ID) {
        _viewModel = State(initialValue: PhotoEditorViewModel(photoID: photoID))
    }

    // MARK: - UI

    var body: some View {
        VStack(spacing: 16) {
            previewView
            filtersListView
                .padding(.horizontal, 20)
        }
        .task { await viewModel.onAppear() }
    }
}

// MARK: - Subviews

private extension PhotoEditorView {
    var previewView: some View { … }
}

// MARK: - filtersListView

private extension PhotoEditorView {
    var filtersListView: some View { … }
}

// MARK: - Preview

#Preview {
    PhotoEditorView(photoID: Photo.ID("preview"))
}
```

## Animation vocabulary

Prefer this narrow set. `matchedGeometryEffect`, `KeyframeAnimator` and `PhaseAnimator` are not forbidden — reach for them when the effect genuinely calls for it:

- State-driven swaps: `ZStack` + `switch` + `.transition(.blurReplace)` per branch + one `.animation(.default, value:)` on the container, animating on a payload-free value.
- Text swaps: `.id(value)` + `.transition(.blurReplace)`.
- The ViewModel does not drive animations (no `withAnimation` in it). The view owns the animation by declaring `.animation(_:value:)` on the affected container, keyed to the state that changed.
- View-local scripted sequences: a private `enum Phase`, derived values via `switch` at the top of `body`, `.task(id:)` with `withAnimation` + `Task.sleep` steps.
- Insert/remove in lists: `.transition(.asymmetric(insertion:removal:))`; give re-inserted rows a fresh identity when the move must not read as a move.
