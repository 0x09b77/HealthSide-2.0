---
paths:
  - "**/*.swift"
---

# Deprecated APIs

How to treat symbols marked `@available(*, deprecated, ...)` — ours and Apple's.

- When a deprecated symbol carries a `message:` (or `renamed:`), that message is the rule — follow its replacement and do **not** add new call sites.
- Remaining call sites are legacy awaiting migration, not a pattern to copy. When you touch code that still calls a deprecated symbol, prefer migrating it to the replacement.
- A deprecated symbol with no `message:` and no obvious replacement: leave it and surface it rather than guessing.
- Compiler deprecation warnings in code you write are errors in spirit: never introduce one.
- Bare `required init?(coder:)` overrides marked `@available(*, unavailable)` / deprecated with no message are UIKit boilerplate — nothing to migrate, don't flag or rewrite them.
