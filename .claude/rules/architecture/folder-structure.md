---
paths:
  - "**/*.swift"
---

# Folder Structure

Two homes for code: the app target (features and flows) and the local package `Packages/HealthSideKit` (the shared foundation: core, networking, design system, models, dependency clients).

- **App project.** `HealthSide.xcodeproj` uses buildable folders: `HealthSide/`, `HealthSideTests/` and `HealthSideUITests/` belong to their targets whole, so just create files/folders — no project edits. Targets, build settings, package dependencies and entitlements change only through the Xcode MCP tools (`UpdateTargetBuildSetting`, `XcodeNewTarget`, `AddEntitlement`, `AddInfoPlist`, …) — never edit `project.pbxproj` by hand; if no tool covers the change (e.g. adding a package to the project), stop and ask the user.
- **Package.** Modules are targets in `Packages/HealthSideKit/Package.swift` — edit the manifest directly. A new module = a new target in the manifest + its folder under `Sources/` (and `Tests/` when it has logic) + its name added to the `HealthSideKit` library product. The app links only that one product, so a new module needs no project edit.

```
HealthSide/
  App/                       // @main entry point, root view, flows: AppRoute, router keys, route → View mapping
  Features/<Feature>/
    <Feature>View.swift
    <Feature>ViewModel.swift
    Components/              // subviews used only by this feature
    Models/                  // types used only by this feature
  Resources/                 // Assets.xcassets (AppIcon), Localizable.xcstrings of the app

HealthSideTests/
  Features/<Feature>/<Feature>ViewModelTests.swift   // mirrors the app layout
HealthSideUITests/

Packages/HealthSideKit/
  Package.swift
  Sources/
    Core/                    // Extensions/, Helpers/, Navigation/ (Router<Route>), other shared non-UI code
    Networking/              // HTTP layer: client, requests, errors, decoding
    DesignSystem/            // shared views and components, styles, colors, fonts; its Resources/
    Models/                  // shared domain types (Sendable structs/enums)
    <Name>Client/            // client interface — see dependencies.md
    <Name>ClientLive/        // its live implementation
  Tests/
    <Module>Tests/           // one test target per module with logic, mirrors Sources/<Module>/
```

## Module dependencies

The manifest declares them, so the compiler enforces them:

- `Core` — no modules of ours. `Models` — Foundation only.
- `Networking` → `Core`. `DesignSystem` → `Core`.
- `<Name>Client` → `Models` (and `Core` if needed). `<Name>ClientLive` → its `<Name>Client`, plus `Networking` or the system framework it wraps.
- No module depends on a `*Live` module or on the app.
- In the app, features import `Core`, `DesignSystem`, `Models` and client interfaces — never a `*Live` module. Only `App/` imports `*Live` modules (see dependencies.md). This one is held by review, not the compiler: the app links the whole `HealthSideKit` product, so every module is importable from any app file.

## Where code goes

- Dependency clients and networking always live in the package.
- Everything else lives inside its feature first; it moves to the package (`Models`, `DesignSystem`, `Core`) only when a second feature needs it.
- Features never import from each other; shared code goes to the package.
- One primary type per file; the file is named after the type.
- Create a folder — or a module — only when it gets its first file.

## Module boundaries

- A declaration other modules use is `public`; one only other modules of the package use is `package`; everything else stays internal or `private`. Nothing is `public` "just in case".
- A `public` struct that other modules construct declares its `public init` explicitly — the memberwise initializer is internal.
- A module's resources (assets, String Catalog) sit in `Sources/<Module>/Resources/` and are read through `Bundle.module`. The package's `defaultLocalization` is `en`, matching the app's catalog.
