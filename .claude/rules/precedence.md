# Rule Precedence

These rules are the authority on this codebase. Existing code that breaks one is **legacy, not precedent**.

"I matched the file I was editing" is not a justification. The neighbouring declaration is evidence of what was written once, never of what should be written now. Before copying the shape of an adjacent declaration, check whether a rule covers it. When the two disagree, follow the rule.

## The ones that get copied most

- **Comments.** [style/swift-conventions.md](style/swift-conventions.md#comments-and-documentation): no comments except `// MARK: -`, doc comments only on library-like building blocks. This holds even when every other declaration in the file carries a paragraph. Reasoning worth keeping goes in the PR/chat, or in the rule file that governs the area.
- **ViewModel method names.** [architecture/mvvm.md](architecture/mvvm.md): methods are named after the event (`saveTapped()`, `onAppear()`), not the effect (`saveToDatabase()`). A neighbour named otherwise is a violation to leave alone, not a pattern to extend.
- **Logic in views.** [architecture/mvvm.md](architecture/mvvm.md), [architecture/navigation.md](architecture/navigation.md): a view never decides, navigates or reads `@Dependency` (the flow's root view is the only exception). An existing view that does is legacy.

## Leave legacy alone

Following the rule applies to what you write. Do not churn pre-existing violations in code you are not otherwise changing — a diff that renames twenty untouched declarations buries the change it came for. When a file needs both, make the mechanical pass its own commit.
