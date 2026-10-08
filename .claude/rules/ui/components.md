---
paths:
  - "**/*.swift"
---

# Components

Part of the design system — [design-system.md](design-system.md).

- Feature code uses `DesignSystem` components (Figma page «Components») instead of re-building a look-alike: `.buttonStyle(.primary(isLoading:))`, `FormTextField`, `.toggleStyle(.checkbox)`, `InlinePrompt`. A native control with a `DesignSystem` style beats a custom view.
- Component names, variants and states mirror Figma; each component's `#Preview` shows every variant × state the design has.
- System switches (`Toggle`) stay native, tinted by `.tint(.accent.primary)` set once on the app's root view.
