---
name: new-flow
description: Create a new navigation flow (own NavigationStack + Router + route enum), e.g. auth or onboarding, or add routing to an existing flow. Use when a group of screens needs its own navigation stack.
argument-hint: <FlowName> [screens / how it is entered]
---

Create flow `$ARGUMENTS`. Rules live in `.claude/rules/architecture/navigation.md` and `concurrency.md` — follow them; this skill is the step-by-step.

## 1. Inputs (ask/report back if unclear)
- Flow name in PascalCase (`Auth`, `Onboarding`).
- Its first (root) screen and other screens.
- How the flow is entered and left: replaces the main flow at the root (e.g. logged out → `Auth`), or presented modally from a screen. If not specified — stop and ask.

## 2. Files
```
HealthSide/App/Navigation/<Flow>/
  <Flow>Route.swift
  <Flow>RouterKey.swift
  <Flow>FlowView.swift
```
(The main flow is the existing one: `App/Navigation/AppRoute.swift`, `AppRouterKey.swift`, `App/RootView.swift`.)

`<Flow>Route.swift`:
```swift
nonisolated enum <Flow>Route: Hashable, Sendable {
    case <screen>(/* input */)
}
```

`<Flow>RouterKey.swift`:
```swift
import Core
import Dependencies

nonisolated enum <Flow>RouterKey: DependencyKey {
    static let liveValue = Router<<Flow>Route>()
    static var testValue: Router<<Flow>Route> { Router() }
    static var previewValue: Router<<Flow>Route> { Router() }
}

nonisolated extension DependencyValues {
    var <flow>Router: Router<<Flow>Route> {
        get { self[<Flow>RouterKey.self] }
        set { self[<Flow>RouterKey.self] = newValue }
    }
}
```

`<Flow>FlowView.swift`:
```swift
import Dependencies
import SwiftUI

struct <Flow>FlowView: View {
    // MARK: - Properties

    @Dependency(\.<flow>Router)
    private var router

    // MARK: - UI

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.path) {
            <RootScreen>View()
                .navigationDestination(for: <Flow>Route.self) { route in
                    destinationView(route: route)
                }
        }
    }
}

// MARK: - Destinations

private extension <Flow>FlowView {
    @ViewBuilder
    func destinationView(route: <Flow>Route) -> some View {
        switch route {
        case .<screen>:
            <Screen>View()
        }
    }
}

// MARK: - Preview

#Preview {
    <Flow>FlowView()
}
```
- `nonisolated` on the route enum, the key and the `DependencyValues` extension is required (default `@MainActor` isolation breaks them otherwise).
- The flow view is the only view allowed to read a router via `@Dependency`.
- Layout per `ui/feature-views.md`; the `switch` over routes is exhaustive, no `default`.

## 3. Screens
Create each screen with the `new-feature` skill. Screens of this flow navigate via `@Dependency(\.<flow>Router)`, never via another flow's router.

## 4. Entering / leaving
Wire it as agreed in step 1 (e.g. `RootView` switches between `<Flow>FlowView` and the main stack based on ViewModel state). The decision of which flow is shown lives in a ViewModel, not in the view. Don't invent modal presentation in `Router` — report if it's needed.

## 5. Tests & done
- ViewModel tests override `\.<flow>Router` with `withDependencies` and assert `router.path` (see `new-feature`).
- Build green, tests green, preview renders. Report created files and how the flow is entered.
