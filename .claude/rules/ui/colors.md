---
paths:
  - "**/*.swift"
---

# Colors

Part of the design system — [design-system.md](design-system.md).

- Every color on screen comes from a `DesignSystem` token: `.foregroundStyle(.text.primary)`, `.background(.bg.surface)`, `.fill(.accent.primary)`, `.background(.gradient.brand)`. No `Color(red:green:blue:)`, hex initializers, `Color("…")` by name, `UIColor(red:…)` or system colors (`.red`, `.gray`, `.secondary`, `.accentColor`) in feature code. `.clear` is fine.
- Token names mirror Figma 1:1: the Figma group becomes the namespace, the token name the member — `text/primary` → `.text.primary`, `status/greenSoft` → `.status.greenSoft`, `Gradient/Brand` → `.gradient.brand`. Never invent a name that has no Figma counterpart.
- Only semantic tokens are public; Figma primitives (`red/500`, `warm/900`) never appear in code.
- Values live in `Sources/DesignSystem/Resources/Colors.xcassets`, one colorset per token; Swift code never repeats a hex value.
- A color the design doesn't have yet is added to Figma first, then to the catalog and the API — never improvised in a feature.
- The app is light-only (`UIUserInterfaceStyle = Light`); a colorset carries the light value only until the design gets a dark mode.
