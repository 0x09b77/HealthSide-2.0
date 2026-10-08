---
name: build-and-test
description: Build the app and run tests with compact output via scripts/build.sh and scripts/test.sh. Use after any code change, or when asked to build, test, or check that the project compiles.
argument-hint: [build | build -kit | test | test -only Suite | test -ui | test -kit]
---

Never call `xcodebuild` directly — the scripts keep logs out of context and kill hung runs. The project uses buildable folders: new files need no project edits.

## Commands
| Goal | Command |
|---|---|
| Build the app | `scripts/build.sh` |
| All unit tests | `scripts/test.sh` |
| One suite / one test | `scripts/test.sh -only RouterTests` / `-only RouterTests/popToRootClearsPath()` |
| UI tests | `scripts/test.sh -ui` |
| Build only the `HealthSideKit` package | `scripts/build.sh -kit` |
| All package tests / one package test target | `scripts/test.sh -kit` / `scripts/test.sh -kit -only CoreTests` (or `CoreTests/Suite`) |
| Clean build (wipes `build/` and Xcode's DerivedData for this project, re-resolves packages, builds) | `scripts/clean-build.sh` |

Env overrides: `SIM="iPhone 17"` (simulator), `TIMEOUT=600` (seconds, default 300).

## Output
```
--- errors ---            file:line: error: ...        (compiler errors)
--- warnings ... ---      own sources only, top 10
--- failures ---          Suite/test(): failure message (tests only)
--- build|tests: SUCCESS | FAILED | TIMEOUT after Ns ... ---
```
Exit code is xcodebuild's. Full logs: `build/logs/build.log`, `build/logs/test.log` — grep them, never cat them.

## How to use
- After each meaningful code step: `scripts/build.sh`. It compiles the app target and the package modules it links — test files are compiled by `scripts/test.sh`. Changing only `Packages/HealthSideKit`: `scripts/build.sh -kit` is faster.
- Before finishing: `scripts/test.sh` (app unit tests) and, if the package changed, `scripts/test.sh -kit`. While iterating on one area, use `-only <Suite>` — it's faster.
- Runs take 1–3 min; run them in the background when possible and say what's running.
- `FAILED` with no errors/failures listed → grep the log: `grep -nE "error|failed" build/logs/test.log | head`.
- `TIMEOUT` → usually the simulator hung. Report it; don't retry more than once.
