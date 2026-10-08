---
paths:
  - "**/*.swift"
---

# Design System

The `DesignSystem` module of `HealthSideKit` owns the visual tokens. Source of truth: the Figma file `HealthSide`, page «Foundations» (semantic tokens, collection «Color»).

## Colors

- Every color on screen comes from a `DesignSystem` token: `.foregroundStyle(.text.primary)`, `.background(.bg.surface)`, `.fill(.accent.primary)`, `.background(.gradient.brand)`. No `Color(red:green:blue:)`, hex initializers, `Color("…")` by name, `UIColor(red:…)` or system colors (`.red`, `.gray`, `.secondary`, `.accentColor`) in feature code. `.clear` is fine.
- Token names mirror Figma 1:1: the Figma group becomes the namespace, the token name the member — `text/primary` → `.text.primary`, `status/greenSoft` → `.status.greenSoft`, `Gradient/Brand` → `.gradient.brand`. Never invent a name that has no Figma counterpart.
- Only semantic tokens are public; Figma primitives (`red/500`, `warm/900`) never appear in code.
- Values live in `Sources/DesignSystem/Resources/Colors.xcassets`, one colorset per token; Swift code never repeats a hex value.
- A color the design doesn't have yet is added to Figma first, then to the catalog and the API — never improvised in a feature.
- The app is light-only (`UIUserInterfaceStyle = Light`); a colorset carries the light value only until the design gets a dark mode.

## Typography

- Every text gets its style from `DesignSystem`: `Text("…").typography(.titleXL)`. No `.font(.system(size:))`, `.font(.body)`/`.headline`, `.bold()`, `.fontWeight`, `.tracking` or `.lineSpacing` in feature code — the style sets font, weight, tracking, line spacing and letter case together.
- Names mirror the Figma text styles 1:1 without slashes and spaces: `Title/XL` → `.titleXL`, `Body/L Bold` → `.bodyLBold`, `Overline/S` → `.overlineS`.
- The font is the system font (SF Pro); Inter exists only in Figma. Sizes are the Figma values at the default Dynamic Type size and scale with the user's text size setting — layouts must tolerate larger text.
- A text style the design doesn't have yet is added to Figma first, then to `Typography`.

## Icons

- Every icon comes from `DesignSystem`: `Image.icons.home`, `Image.icons.chevronRight`. No `Image(systemName:)` or `Image("…")` by name in feature code; system controls that bring their own symbols (`ShareLink`, menus) are the exception.
- Names mirror the Figma page «Icons» 1:1: `Icon/Document check` → `.documentCheck`.
- Assets are the SVGs exported from Figma, in `Sources/DesignSystem/Resources/Icons.xcassets` with vector data preserved. Monochrome icons are template images and take their color from a token at the call site (`.foregroundStyle(.text.secondary)`); multicolor icons (`mailVerified`, `clear`) render their original colors.
- Default size is the 24pt grid; other sizes from the design (16, 19, 20, 22) are `.resizable().frame(width:height:)` at the call site — the stroke scales with the icon.
- An icon the design doesn't have yet is added to Figma first, then to the catalog and the API.
