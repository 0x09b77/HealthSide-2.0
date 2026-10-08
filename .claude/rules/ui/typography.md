---
paths:
  - "**/*.swift"
---

# Typography

Part of the design system — [design-system.md](design-system.md).

- Every text gets its style from `DesignSystem`: `Text("…").typography(.titleXL)`. No `.font(.system(size:))`, `.font(.body)`/`.headline`, `.bold()`, `.fontWeight`, `.tracking` or `.lineSpacing` in feature code — the style sets font, weight, tracking, line spacing and letter case together.
- Names mirror the Figma text styles 1:1 without slashes and spaces: `Title/XL` → `.titleXL`, `Body/L Bold` → `.bodyLBold`, `Overline/S` → `.overlineS`.
- The font is the system font (SF Pro); Inter exists only in Figma. Sizes are the Figma values at the default Dynamic Type size and scale with the user's text size setting — layouts must tolerate larger text.
- A text style the design doesn't have yet is added to Figma first, then to `Typography`.
