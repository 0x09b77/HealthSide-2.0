---
paths:
  - "**/*.swift"
---

# Radius, spacing, effects

Part of the design system — [design-system.md](design-system.md).

- Corner radii, paddings/gaps and shadows come from `DesignSystem` tokens: `.padding(.spacing.md)`, `VStack(spacing: .spacing.sm)`, `RoundedRectangle(cornerRadius: .radius.md)`, `.padding(.horizontal, .layout.marginMain)`, `.shadow(.cta)`, `.focusRing(in: RoundedRectangle(cornerRadius: .radius.md))`. No raw `.shadow(color:radius:x:y:)` in feature code.
- Names mirror Figma «Radius & spacing» and «Effects»: `radius/md` → `.radius.md`, `spacing/lg` → `.spacing.lg`, `layout/marginMain` → `.layout.marginMain`, `Shadow/CTA S` → `.shadow(.ctaS)`. A leading digit becomes a doubled letter: `2xs` → `.xxs`, `2xl` → `.xxl`.
- A shadow belongs to the surface, not the content: apply `.shadow(...)` to the background shape (`.background(RoundedRectangle(cornerRadius: .radius.md).fill(.bg.surface).shadow(.card))`), never to a view whose text or icons would cast it too.
- A focus ring draws 4pt outside the shape: leave that room around a focusable control (no clipping container, no sibling closer than 4pt).
- A one-off layout number that has no token and only positions a view against itself (an icon offset, a fixed control size from the design) stays inline, per the Constants rule in [swift-conventions.md](../style/swift-conventions.md).
