---
name: new-feature
description: Create a new feature module (screen) in Features/<Name>/ following the project structure — View, @Observable ViewModel, optional route, tests. Use when adding any new screen/module.
argument-hint: <FeatureName> [what it does]
---

Create feature `$ARGUMENTS`. Rules live in `.claude/rules/architecture/` (`folder-structure`, `mvvm`, `feature-views`, `navigation`, `dependencies`) and `.claude/rules/style/` — follow them; this skill is the step-by-step.

## 1. Inputs (ask/report back if unclear)
- Name in PascalCase without suffix (`PhotoEditor`, not `PhotoEditorScreen`).
- Input data, if any (e.g. `photoID`).
- Which flow it belongs to and how it is opened (push from which screen) — or whether it is not navigable yet.
- Dependencies it needs (existing clients or new ones).

## 2. Files
```
HealthSide/Features/<Name>/
  <Name>View.swift
  <Name>ViewModel.swift
  Components/   // only if the feature has its own subviews
  Models/       // only if the feature has its own types
```

`<Name>ViewModel.swift`:
```swift
import Dependencies
import Observation

@Observable
final class <Name>ViewModel {
    private(set) var state = ...            // state is read-only for the view

    @ObservationIgnored
    @Dependency(\.appRouter)
    private var router                      // only if it navigates

    private let input: Input                // screen input, if any

    init(input: Input) {
        self.input = input
    }
}

// MARK: - Events

extension <Name>ViewModel {
    func onAppear() async {}                 // event-named methods: saveTapped(), closeTapped()
}
```

`<Name>View.swift`:
```swift
import SwiftUI

struct <Name>View: View {
    // MARK: - Properties

    @State private var viewModel: <Name>ViewModel

    // MARK: - Init

    init(input: Input) {
        _viewModel = State(initialValue: <Name>ViewModel(input: input))
    }

    // MARK: - UI

    var body: some View {
        VStack {
            headerView
            contentView
                .padding(.horizontal, 20)       // layout modifiers at the call site, not inside subviews
        }
        .task { await viewModel.onAppear() }
    }
}

// MARK: - Subviews

private extension <Name>View {
    var headerView: some View { ... }
}

// MARK: - contentView

private extension <Name>View {
    var contentView: some View { ... }
}

// MARK: - Preview

#Preview {
    <Name>View(input: ...)                  // sample input
}
```
- Layout per `architecture/feature-views.md`; property order per `style/type-layout.md`.
- Shared code comes from `HealthSideKit` modules: `import Core` (Router, extensions), `import DesignSystem` (shared components), `import Models`, `import <Name>Client` — never a `*Live` module.
- The view only reads `viewModel` state and calls its methods. No logic, no `@Dependency`, no navigation in the view.
- Previews get `previewValue` of every dependency automatically; override with `withDependencies` only if a specific state is needed.

## 3. Navigation (if the screen is navigable)
1. Add a case to the flow's route enum (`App/Navigation/AppRoute.swift` for the main flow): `case <name>(<input>)`.
2. Map it in the flow's `navigationDestination` (`App/RootView.swift` for the main flow). On the first case, replace the `EmptyView()` placeholder with `switch route { ... }`.
3. The ViewModel that opens it calls `router.push(.<name>(...))` from an event method.

## 4. Tests
`HealthSideTests/Features/<Name>/<Name>ViewModelTests.swift`:
```swift
@testable import HealthSide
import Core
import Dependencies
import Testing

@MainActor
struct <Name>ViewModelTests {
    @Test func saveTappedOpensNextScreen() {
        let router = Router<AppRoute>()
        let viewModel = withDependencies { $0.appRouter = router } operation: { <Name>ViewModel() }
        viewModel.saveTapped()
        #expect(router.path == [.next])
    }
}
```
- Test every ViewModel event method: state changes and navigation.
- If `import Dependencies` or a `HealthSideKit` module import (`import Core`, …) fails in tests, the package is not linked to the test target — report it, don't edit the project.

## 5. Done
Build green, tests green, `#Preview` renders. Report created files.
