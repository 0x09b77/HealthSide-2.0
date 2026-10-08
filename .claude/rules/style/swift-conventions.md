---
paths:
  - "**/*.swift"
---

# Swift Conventions

Language-level rules: how Swift is written here, independent of what is being built. On questions of syntax and expression this file takes precedence — `architecture/` owns structure (what a type is for, where it lives, what it exposes) and defers to this one on how its body is written. How a type's declaration and extensions are laid out is [type-layout.md](type-layout.md); how a value is produced is [value-expressions.md](value-expressions.md).

## Comments and documentation

- The code must be self-explanatory. If a name or shape needs a comment to be understood, fix the name or shape — no code comments of any kind; `// MARK: -` separators are the only exception. Reasoning goes in the PR/chat, not the source.
- Doc comments follow the same bar: add one only when the signature alone leaves the caller unable to know what to expect (a surprising contract, a non-obvious unit, an out-of-bounds behavior). Never document what the name already says, and never document implementation on a protocol or client — `signOut()` must not carry "clears data".
- Where documentation is appropriate: general-purpose extensions and building blocks in the `Core` module — library-like code used far from where it's declared, whose edge-case behavior (timeout, out of bounds, empty input) is exactly the "unclear without it" case. Feature code is read next to its context and gets none.
- **A value bound by something outside the code carries one line naming that bound.** A timeout that must outlast an animation in an asset, a size that must match a server cap: one line states the bound and its source — `/// Must exceed the longest transition in `intro.json` (≈0.43 s).` — and nothing about why this value was picked. A value that only has to be sensible (a padding, a debounce) gets none.
- Comment species that count as spam — never write these. Nearly all are a commit message or a review reply written into the source:
  - narration: `// Fetch the sessions` above `fetchSessions()`
  - restating the name: `/// The user's name` on `let userName`
  - change journal: `// Added to fix IOS-1234`, `// Now uses the new API`
  - reviewer-directed: `// This is safe because we checked above`
  - section headers that aren't `// MARK: -`
  - commented-out code
  - restating the body: `/// Zero when the face is already taller` above `max(.zero, lineHeight - fontLineHeight)`. For a one-line computed property or a two-line function the body is as visible as the signature. Say what the body cannot: what the value *means*, where it applies, what unit it is in.
  - **rationale essays** — prose defending a design decision, the most common agent failure. Length is not the test: one line defending a choice is the same spam as a paragraph. Whenever a comment reaches for **deliberately**, **intentionally**, **on purpose**, **rather than**, **instead of**, **not X but Y**, or **we chose**, it is addressed to a reviewer — move it to the PR.
  - The test: does it change what a **caller does** (a surprising contract, a unit, an out-of-bounds behavior)? If it instead *justifies* the code, it is the commit message trying to live in the source.
- A doc comment describes **the declaration it is attached to**, and nothing else — not the caller's remaining obligations, not a sibling property, not what the type does *not* do.

## Expressions and values

- Values are produced at the point of declaration, in steps small enough for the type checker — see [value-expressions.md](value-expressions.md).
- Never prefer an index subscript where `first`/`last` (or another existing property) expresses the access; a bare `[i]` needs a visible guard justifying it.
- Where a single bound stands alone, `min`/`max` arguments are ordered ascending — the smaller value on the left — so the call reads like a range: a floor reads `max(lowerBound, x)`, a cap reads `min(x, upperBound)`. A two-sided clamp is a `clamped(to:)` extension in the `Core` module's `Extensions/` (create it on first need) — never hand-nested `min(max(…))`.
- Work deferred once goes through a `Task.delayed(for:)` helper in the `Core` module's `Extensions/` (create it on first need) that sleeps, checks cancellation and drops quietly when cancelled — never a `Task { }` that opens with `try await Task.sleep(…)` and a `catch { return }`. `Task.sleep` stays where the pause is one step of a sequence — a loop that waits between iterations, a `.task(id:)` animation script, a poll.

## Optionality

- A property is optional only when a real flow produces nil. Before writing `?`, name the call site that passes nothing — if the only ones are a `#Preview`, a mock, or a debug entry, it is not optional: give those call sites a literal value instead. A false optional charges every reader a `guard let` whose else-branch cannot happen.
- Two habits manufacture false optionals:
  - **Borrowed from a dependency.** An SDK signature that accepts nil says what that SDK tolerates, not what this app produces. Model the state from our own call sites.
  - **Left over from a refactor.** Collapsing a two-case enum into `T?` is correct while the "none" case is reachable; when its last producer goes away, the optional goes with it.

## Branching on enum values

- A branch that chooses behavior per case of an enum is a `switch` listing every case. No `default`, and no `if value == .a { … } else { … }` chains: both compile silently when a case is added, and the new state falls into whichever branch happened to be `else`. The exhaustive switch turns the added case into a compile error at every decision point.

```swift
// no — .granted rides the else, and a fourth case would too
if status == .notDetermined {
    status = await permissions.requestAuthorization()
} else if status == .denied {
    openSystemSettings()
}

// yes
switch status {
case .notDetermined:
    status = await permissions.requestAuthorization()

case .denied:
    openSystemSettings()

case .granted:
    break
}
```

- `==` or `guard case` against a single case stays fine where the code genuinely filters one case and treats all others uniformly, or derives one `Bool`. If two or more cases each get behavior of their own, it is a switch.

## Enum payloads

A case's associated values become a struct named for the case — `case file(File)`, `case mark(Mark)` — when any of these holds:

- **Four or more values.** A positional pattern `case let .command(a, b, c, d)` is past reading, and neighbours of one type swap without a compiler error.
- **The payload is read partly.** A pattern that needs `_` to reach the value it wants says the values are not a unit where they are used.
- **The payload is rebuilt elsewhere.** A case unpacked only so its values can be stored side by side again is a struct taken apart and put back together.

```swift
// no — three positional values, read with wildcards
case glyph(Glyph, fill: [Gradient.Stop], ring: Color?)
guard case let .glyph(glyph, _, _) = overlay else { return nil }

// yes — the payload is a value, read by name
case mark(Mark)

struct Mark: Equatable, Sendable {
    let glyph: Glyph
    let fill: [Gradient.Stop]
    let ring: Color?
}
```

- The struct nests in the enum when only the enum uses it (`Overlay.Mark`), and sits beside it when other types do.
- One to three values, each clear on its own and read whole, stay inline: `.progress(tint:)`, `.moved(from:to:)`.

## Nesting depth

A type nests at most **two levels** below its top-level type. Level one holds the type's parts; level two holds only **leaves** — small enums or payloads with no types inside them.

```swift
// no — three levels
SomeItem.Row.Icon.Backdrop

// yes — the owned part is prefixed at level one, and only its leaf nests
SomeItem.RowIcon.Backdrop
```

- **A part owned by another part stays at level one and takes its owner's name as a prefix:** `RowIcon`, not `Row.Icon`.
- **A leaf that needs a type of its own moves up** with its owner's prefix (`RowIconBackdrop`).
- **A prefix that chains two owners means a sub-model has outgrown its host.** Extract it as a top-level type in its own file.
- Nesting the language requires (`CodingKeys`) does not count. Case-free `Constants` namespaces are exempt.

## UIKit events: closures, not selectors

A UIKit control event is wired with a closure, never with `@objc` + `#selector` target-action:

```swift
// no
button.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)

// yes
button.addAction(UIAction { [weak self] _ in self?.viewModel.saveTapped() }, for: .primaryActionTriggered)
```

- Capture `self` weakly: the control retains its actions, and the control is usually retained by `self`.
- Gesture recognizers have no system closure API: wire them through closure-based helpers in the `Core` module's `Extensions/` (create on first need) rather than selectors. A selector stays only where an API has no closure form — `CADisplayLink`, responder-chain `sendAction`.

## Declarations

- No leading-dot `.init(...)` — spell the type name. Bare method references (`map(Item.init)`) are fine.
- A local binding never shadows a property the same body still touches:

  ```swift
  // no — `transition` is the local on one line and the property on the next
  guard completed, let transition else { return }
  renderedPose = transition.destination
  self.transition = nil

  // yes
  guard completed, let finishedTransition = transition else { return }
  renderedPose = finishedTransition.destination
  transition = nil
  ```

  `guard let x` stays the default shorthand where the body only reads the unwrapped value. `self.` stays where the language needs it (an initializer assigning a parameter, a closure capturing `self`).
- No `*Strings` / `*Accessibility` constant enums. User-facing strings live in the String Catalog of the module that shows them (`Resources/Localizable.xcstrings` of the app, or of a package module such as `DesignSystem`) and are used through its generated symbols. Keys are snake_case derived from the value (~5 words max, cut at a word boundary; placeholders as `_x`). Non-user-facing literals and accessibility identifiers (only when asked) are inlined at the point of use.
- No `Constants` entry for a **presentation** value used once — a padding, a corner radius, an opacity, an animation duration: `.padding(20)` already says what the number does.
- **A value the code decides on takes a `Constants` entry even used once** — a threshold a ViewModel compares against, a cap, a retry count, a debounce a decision waits out. The name is the only place the intent can live, since these files get no comments. The test is who consumes the number: a view applying it to itself — inline; a branch, guard or comparison choosing behaviour from it — `Constants`.
- A dictionary is named `<key>To<value>` — `photoIdToThumbnail`, `filterToPreview`. The name reads as the subscript does: `photoIdToThumbnail[photoId]`. The `<value>By<key>` form (`thumbnailsById`) is not an alternative.
- No free functions — wrap in the owning type or an injectable client.
- A global function from a third-party package is called through its module name (`AsyncAlgorithms.merge(a, b)`), never bare. The standard library and system frameworks stay bare: `min`, `zip`, `withTaskGroup`.
- **A verb without its object is not a name.** `build(snapshot:)` leaves the reader asking *build what?* The object goes in the name: `buildRows(snapshot:)`, `resolveKeyMaterial()`. Test: read the call with the receiver struck out — if nothing says what happened, the object is missing. Not a licence to restate the type: `RowBuilder.buildRows(...)` says `build` twice — name the object, not the namespace.
- **A function is named with a verb; a bare noun name is reserved for a mapping of one type into another.** A noun earns its place only as a pure transformation of its arguments: `severity(level:)`, `name(level:)`. Anything that *assembles* — reaching for a dependency, composing several inputs — takes a verb even though it cannot fail: `buildDetailPath(photoId:)`. A mapper that reports absence as `nil` keeps its noun.
- **A throwing function must be named with a verb** — a noun name promises totality. `try parseFilterPreset(data:)` reads as an action that can fail; `try filterPreset(data:)` reads as a property access that inexplicably throws.
