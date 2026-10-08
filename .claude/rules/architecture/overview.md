# Architecture Overview

- Deployment target: iOS 18.0.
- Swift 6, strict concurrency, `@MainActor` by default for the app target and every `HealthSideKit` module.
- MVVM: SwiftUI views + `@Observable` ViewModels.
- Modules: features in the app target; shared foundation (Core, Networking, DesignSystem, Models, dependency clients) in the local package `Packages/HealthSideKit` — see [folder-structure.md](folder-structure.md).
- DI: [swift-dependencies](https://github.com/pointfreeco/swift-dependencies).
- Navigation: one `Router` per flow, driven by ViewModels.
- Principles: SOLID, DRY.

Rules take precedence over existing code: [../precedence.md](../precedence.md).

## Rule files

| Area | File |
| --- | --- |
| Where files go | [folder-structure.md](folder-structure.md) |
| ViewModels, View ↔ ViewModel | [mvvm.md](mvvm.md) |
| How a feature view is written | [feature-views.md](feature-views.md) |
| Colors and other visual tokens | [design-system.md](design-system.md) |
| Routers, flows, screens | [navigation.md](navigation.md) |
| Dependency clients | [dependencies.md](dependencies.md) |
| Isolation, background work, thread safety | [concurrency.md](concurrency.md) |
| Deprecated APIs | [deprecated-apis.md](deprecated-apis.md) |
| How Swift is written | [../style/swift-conventions.md](../style/swift-conventions.md) |
| How a type is laid out | [../style/type-layout.md](../style/type-layout.md) |
| How a value is produced | [../style/value-expressions.md](../style/value-expressions.md) |

Files other than this one and `precedence.md` load when Swift files are touched. Read the matching file before planning or writing code in its area.
