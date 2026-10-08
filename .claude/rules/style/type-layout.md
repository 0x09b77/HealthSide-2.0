---
paths:
  - "**/*.swift"
---

# Type Layout

How a type's declaration and its extensions are laid out: blank lines, the order of properties, where properties and nested types sit, and how conformances are written. Where a file lives is [../architecture/folder-structure.md](../architecture/folder-structure.md); how a view's body is split is [../ui/feature-views.md](../ui/feature-views.md); how expressions are written is [swift-conventions.md](swift-conventions.md).

## Blank lines

- Declarations that each fit on one line are written as a run, with no blank lines between them — a `DependencyKey`'s `liveValue`/`testValue`/`previewValue`, a run of typealiases, stored properties, an enum's cases. A blank line separates one *group* from the next (stored properties from computeds, properties from methods) or sets apart a declaration whose body spans lines, on both sides; it is never punctuation between neighbours of the same kind. The formatter doesn't enforce this — it is on the author. A computed property whose body is one expression behind an implicit getter (`var isEmpty: Bool { items.isEmpty }`) is a one-liner and joins the run.
- **A short body after a `guard` is one block.** When a body is a `guard` followed by at most two statements, nothing is separated by a blank line. The blank line after a `guard` earns its place only once the continuation is three statements or more, or one that spans several lines. A `Bool` whose `guard` only returns `false` is a conjunction (`isEnabled && kind == .primary`); an optional unwrapped only to build a value from it is a `map`.

  ```swift
  // no
  Task { [weak self] in
      guard let self, !isAnyFieldFocused else { return }

      onFocusLoss?()
  }

  // yes
  Task { [weak self] in
      guard let self, !isAnyFieldFocused else { return }
      onFocusLoss?()
  }
  ```

## Property order

A type body declares its properties in one order, then `init`: what the type shows, what it is given, what it keeps, what it derives.

1. Non-private stored properties — the type's own surface, e.g. a ViewModel's `private(set) var` state, a view's callbacks.
2. Injected dependencies — `@ObservationIgnored @Dependency(...)`, and values passed through `init`.
3. Private stored `let`s.
4. Private stored `var`s, with `lazy var`s last, since they read what is above them.
5. Computed properties that several topics read. One read by a single topic opens that topic's extension instead, so this group is usually empty.

Each group is a run of its own, and one blank line separates a group from the next. A declaration that spans more than one line — a multi-line initializer, an attribute on the line above (every injected dependency) — stands apart, with a blank line on both sides.

```swift
@Observable
final class PhotoEditorViewModel {
    private(set) var preview: UIImage?
    private(set) var isApplying = false

    @ObservationIgnored
    @Dependency(\.filterClient)
    private var filterClient

    @ObservationIgnored
    @Dependency(\.appRouter)
    private var router

    private let photoID: Photo.ID

    private var appliedFilters: [Filter] = []

    init(photoID: Photo.ID) {
        self.photoID = photoID
    }
}
```

Everything past the body is grouped by topic in `// MARK: -` extensions, not by access level.

## Where properties and nested types sit

- **A nested type sits with the code that uses it.** One read across topics or from outside the type goes in a single `// MARK: - Nested types` extension at the end of the file: readers meet the behaviour first, and the vocabulary is a lookup. One used by a single topic opens that topic's `private extension`. `CodingKeys` stays in the body. Depth is bounded by [Nesting depth](swift-conventions.md#nesting-depth).
- **A property opens the scope that owns it, and never sits between methods.** Stored properties, and computed ones that several parts of the type read, go at the top of the type's declaration. A computed property only one topic uses opens that topic's `private extension`, under its `// MARK: - <Topic>`, ahead of the methods that read it. When no topic extension fits, create one rather than appending the property to `// MARK: - Private methods`.

  ```swift
  // no — properties wedged between methods of different topics
  private extension SomeFormView {
      func setupView() { … }
      var fields: [Field] { … }
      func setupGestures() { … }
  }

  // yes — the topic extension opens with what it holds
  // MARK: - Fields

  private extension SomeFormView {
      var fields: [Field] { … }
      var isAnyFieldFocused: Bool { … }

      func field(kind: Field.Kind) -> Field { … }
  }
  ```

## Conformances

- **A conformance is one extension.** Every witness of a protocol — properties first, then methods — goes in a single `extension Type: Protocol`. A witness is never split off into the type body or a second extension, and nothing that is not a requirement joins it: helpers live in the type's private topic extensions.
- **A behavioural requirement is never satisfied by a stored property.** In a type conforming to a behavioural protocol (a service, provider, store or delegate contract) the storage is `private` in the type body, named as its witness with a leading underscore — `_status` behind `status` — and the conformance exposes it through a computed witness, with a setter only where the requirement has one. Storage the witness maps from (a persisted model) is named for what it holds. Value types meeting data protocols (`Identifiable`, a model's fields) keep their stored properties as the witness. An `@Observable` type never declares an underscored property of its own — the macro already synthesizes `_name` storage.

  ```swift
  // no
  final class SomeService {
      var status: Status = .idle
  }

  extension SomeService: StatusProviding {
      func refreshStatus() async { … }
  }

  // yes
  final class SomeService {
      private var _status: Status = .idle
  }

  extension SomeService: StatusProviding {
      var status: Status { _status }

      func refreshStatus() async { … }
  }
  ```
