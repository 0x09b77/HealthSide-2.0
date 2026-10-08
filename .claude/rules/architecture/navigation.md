---
paths:
  - "**/*.swift"
---

# Navigation

Step-by-step creation is in the `new-flow` and `new-feature` skills; this file is the rules.

- Router pattern: `Router<Route>` (`Core` module, `Sources/Core/Navigation/Router.swift`) holds `path` for one `NavigationStack`; API `push(_:)`, `pop()`, `popToRoot()`.
- One router per flow. The main flow: `AppRoute` + `AppRouterKey` / `\.appRouter` in `App/Navigation/`, hosted by `App/RootView.swift`. Other flows: `App/Navigation/<Flow>/` with `<Flow>Route`, `<Flow>RouterKey` / `\.<flow>Router`, `<Flow>FlowView`.
- A route enum, its `DependencyKey` and its `DependencyValues` extension are `nonisolated` (see [concurrency.md](concurrency.md)).
- New screen: add a case to the flow's route enum, map it to a view in the flow's `navigationDestination` with an exhaustive `switch`.
- ViewModels perform navigation: `@ObservationIgnored @Dependency(\.appRouter) private var router`, then `router.push(.x)` from an event method. Views never navigate on their own.
- The flow's root view is the only view that reads a router via `@Dependency` — to bind `NavigationStack(path:)`.
- Which flow is shown (e.g. auth vs main) is decided in a ViewModel, not in a view.
- A screen navigates only through its own flow's router.
- Tests assert navigation via `router.path` after overriding the router with `withDependencies`.
