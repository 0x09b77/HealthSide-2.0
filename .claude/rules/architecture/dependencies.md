---
paths:
  - "**/*.swift"
---

# Dependencies

- [swift-dependencies](https://github.com/pointfreeco/swift-dependencies), SPM only, no CocoaPods. It is a package dependency of `HealthSideKit` (products `Dependencies`, `DependenciesMacros` for the client modules) and of `HealthSide.xcodeproj` (product `Dependencies`, linked to the app and unit-test targets).
- Clients are structs of closures with `@DependencyClient`, not protocols.
- Every client defines all three values:
  - `liveValue` — real implementation (network, disk, ...).
  - `testValue` — `Self()`; `@DependencyClient` makes every endpoint fail the test unless overridden.
  - `previewValue` — fake data for `#Preview`.
- Every client is two modules in the package (see [folder-structure.md](folder-structure.md)):
  ```
  Sources/<Name>Client/
    <Name>Client.swift          // public @DependencyClient struct, TestDependencyKey (testValue/previewValue), DependencyValues accessor
  Sources/<Name>ClientLive/
    <Name>Client+Live.swift     // nonisolated extension <Name>Client: DependencyKey { public static let liveValue = … }
  ```
  The interface module depends only on `Dependencies`/`DependenciesMacros`, `Models` and `Core`; the heavy dependencies (`Networking`, HealthKit, disk) belong to the live module. The interface stays light, and code that needs only the interface (other package modules, tests) never reaches live code.
- Every `*Live` module is listed in the `HealthSideKit` product — that is what links its `liveValue` into the app. `App/` also imports each `*Live` module once, in the `@main` file, so a live module missing from the product fails the build instead of silently falling back to `testValue`. Nothing else imports a `*Live` module.
- The client struct, its key and its `DependencyValues` extension are `nonisolated` (see [concurrency.md](concurrency.md)).
- ViewModels get clients via `@ObservationIgnored @Dependency(\.<name>Client)`; tests override with `withDependencies { ... }`.
- Views never read `@Dependency` (a flow's root view reading its router is the only exception).
