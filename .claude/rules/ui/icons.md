---
paths:
  - "**/*.swift"
---

# Icons

Part of the design system — [design-system.md](design-system.md).

- Every icon comes from `DesignSystem`: `Image.icons.home`, `Image.icons.chevronRight`. No `Image(systemName:)` or `Image("…")` by name in feature code; system controls that bring their own symbols (`ShareLink`, menus) are the exception.
- Names mirror the Figma page «Icons» 1:1: `Icon/Document check` → `.documentCheck`.
- Assets are the SVGs exported from Figma, in `Sources/DesignSystem/Resources/Icons.xcassets` with vector data preserved. Monochrome icons are template images and take their color from a token at the call site (`.foregroundStyle(.text.secondary)`); multicolor icons (`mailVerified`, `clear`) render their original colors.
- Default size is the 24pt grid; other sizes from the design (16, 19, 20, 22) are `.resizable().frame(width:height:)` at the call site — the stroke scales with the icon.
- An icon the design doesn't have yet is added to Figma first, then to the catalog and the API.
