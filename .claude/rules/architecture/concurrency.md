---
paths:
  - "**/*.swift"
---

# Concurrency

Isolation defaults, background work, and which instrument protects mutable state. Preview and test doubles are exempt from the thread-safety part — a mock that returns canned values does not carry a concurrency design.

## Defaults

- Swift 6, strict concurrency. The app target and every `HealthSideKit` module are `@MainActor` by default with approachable concurrency — the app via build settings (`SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`, `SWIFT_APPROACHABLE_CONCURRENCY = YES`), the package via the shared `swiftSettings` every target in `Package.swift` gets (`.defaultIsolation(MainActor.self)` plus the approachable-concurrency upcoming features). A new package module always takes those `swiftSettings`; a package test target takes `testSwiftSettings` — the same upcoming features without `.defaultIsolation`.
- Mark `nonisolated`: models, route enums, dependency keys and clients, and `DependencyValues` extensions. Otherwise their conformances (e.g. `Hashable`) become main-actor-isolated and fail generic `Sendable` constraints.
- Test targets — the app's and the package's — have no default isolation: suites that touch ViewModels, routers or other main-actor code are marked `@MainActor`.

## Getting off the main actor

- A plain `nonisolated async` func runs on the caller's actor (approachable concurrency) and does **not** leave the main thread.
- CPU-heavy work (image processing, parsing, encoding) goes to the cooperative pool via `@concurrent` functions or a dedicated `actor`.
- **Never block a cooperative-pool thread.** The pool has one thread per core and no backup: a task that *waits* on one — a synchronous SDK call, blocking disk or keychain I/O, a semaphore — takes that thread out for everyone, and a handful deadlocks the pool. Such work is bridged off the pool explicitly, wrapped once per client as a private helper so no call site repeats the bridge:

```swift
private func executeInBackground<T, E: Error>(
    _ operation: @Sendable @escaping () throws(E) -> T
) async throws(E) -> T {
    try await withCheckedContinuation { (continuation: CheckedContinuation<Result<T, E>, Never>) in
        DispatchQueue.global().async {
            continuation.resume(returning: Result(catching: operation))
        }
    }
    .get()
}
```

Resuming with a `Result` rather than a throwing continuation is what keeps the typed error: `withCheckedThrowingContinuation` erases `E` to `any Error`.

## Choosing the instrument

Pick by how the state is reached, not by taste:

- **`@MainActor`** — anything touching UIKit/SwiftUI or driving a view. It is *also* the cheapest way to make an ordinary object thread-safe when every mutation happens in an async context that can afford a hop: serialized access with no lock, no actor. It applies per member as well as per type, which rescues a class that cannot become an actor (an `NSObject` delegate). Only for small, non-blocking state — the main actor also draws the screen.
- **`actor`** — a client/service that owns mutable state and is reached only from async contexts. Wrapping a 3rd-party SDK that predates strict concurrency is an `actor` plus `@preconcurrency import <SDK>`, never a class guarded by a lock.
- **`Mutex` (`import Synchronization`)** — the escape from "an actor, except one property must be readable synchronously": a non-async requirement, a system callback, a `deinit`. Apply it per property, not per type — an actor holding one `Mutex`-guarded dictionary is a normal shape.

## Never hand-roll a lock

- No `NSLock`, no `OSAllocatedUnfairLock`, no serial `DispatchQueue` for state in feature or client code — `Mutex` is that pattern already packaged. A system API that hands you a queue and takes no alternative is the exception.
- **Never mix the two worlds.** An `actor` is already the synchronizer — a lock inside one guards state the actor has serialized anyway and can block the actor's executor. Isolation comes from exactly one mechanism per piece of state: the actor, the main actor, or `Mutex`.

## Ordering is not isolation

An `actor` serializes *access to state*, not the *order of operations*. It is reentrant: every `await` inside an actor method is a suspension point where another call can interleave, so two calls that start in order can finish out of order, and state read before an `await` may be stale after it. When order matters (a queue of writes, network calls that must not overtake each other), funnel the work through one consumer — an `AsyncStream` of jobs drained by a single `Task` — instead of calling the actor concurrently.

## Non-Sendable is a design, not an omission

A type that only ever lives inside an isolated context does not need to be `Sendable` and should not pretend to be. Leaving the conformance off makes the compiler enforce that every holder supplies the isolation itself. The shape is a non-Sendable core carrying the logic and mutable state, wrapped by thin isolated owners — an `actor` or `@MainActor` type whose single `private let` is that core. Marking the core `@unchecked Sendable` destroys the only property that made it safe.

## `@unchecked Sendable`

Not a way to make a type `Sendable` — a way to silence the compiler about one that is not. Make the type genuinely safe instead: `actor`, `@MainActor`, or `Mutex` so the plain `Sendable` conformance holds. The one admissible use is an immutable box carrying a non-Sendable system value across isolation (a sample buffer, a capture-session object): a `final class` whose single `let` holds the value — one generic `UncheckedSendableBox` in the `Core` module (create on first need).

## `nonisolated(unsafe)`

Two shapes earn it, and each states its reason at the site:

- Storage whose safety comes from a mechanism visible in the same file — the backing `var` of a lock-guarded wrapper, declared beside the lock that guards every access.
- A non-Sendable system value confined by construction — a `let` held inside an actor and only ever handed to the framework that owns it, alongside a `@preconcurrency import` of that framework.

Annotating a mutable `var` so a `nonisolated deinit` can touch it is the weakest form — prefer isolating the `deinit` or moving the cleanup somewhere isolated.
