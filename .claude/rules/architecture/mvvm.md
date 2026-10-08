---
paths:
  - "**/*.swift"
---

# MVVM

How a ViewModel is written and how a view talks to it. How the view's body is laid out is [feature-views.md](feature-views.md); property order inside the ViewModel is [../style/type-layout.md](../style/type-layout.md).

## ViewModel

- `@Observable final class <Feature>ViewModel`, one per screen, in `Features/<Feature>/`.
- State is `private(set) var` — only the ViewModel mutates it.
- Dependencies come through `@ObservationIgnored @Dependency(...)` (see [dependencies.md](dependencies.md)); screen input comes through `init`.
- All decisions live here: what to load, what to show, where to navigate ([navigation.md](navigation.md)).
- The ViewModel never drives animations: no `withAnimation` inside it. It mutates state; the view declares `.animation(_:value:)`.

## View ↔ ViewModel

- The view owns its ViewModel: `@State private var viewModel: <Feature>ViewModel`, created in the view's `init` from the screen input.
- The view calls ViewModel methods directly: `Button("Save") { viewModel.saveTapped() }`, `.task { await viewModel.onAppear() }`.
- The view only reads state and calls methods; no logic, no `@Dependency`, no navigation in the view.
- Methods are named after the event, not the effect: `saveTapped()`, `onAppear()`, `filterSelected(_:)` — not `saveToDatabase()`.
