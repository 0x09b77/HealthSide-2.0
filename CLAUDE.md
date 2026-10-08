# Healthside iOS App

App to save, analys and other features (iOS 18+, SPM), built with an AI agent. stack: Swift 6, SwiftUI + UIKit, Structured Concurrency.

Rules: `.claude/rules/` — start at `architecture/overview.md` (index) and `precedence.md`; `style/` and `architecture/` files load when Swift files are touched.

## Agents
| Agent | When to call |
| --- | --- |
| `coder` (Sonnet 5.5) | Any code change (features, screens, ViewModels, dependencies, tests) — only after requirements are clear. Pass goal, constraints and acceptance criteria; review its report. |
| `scout` (Haiku 5.5) | Locating anything in the project (definition, usages, which file handles X, config/build setting) — instead of grepping/reading yourself. Also via `/scout <what>`; answer ≤10 lines. |
| `reviewer` (Opus 5.5) | Always right after every `coder` run, and whenever the user asks for a review. Pass task goal, acceptance criteria and the coder's report (or `/reviewer <context>`); it reads the uncommitted diff and returns blockers and suggestions. Read-only. |
| `tester` (Haiku 5.5) | Only when the user asks to check a flow in the simulator. Via `/verify <steps + expected result of each>`; it builds and launches via `scripts/run.sh`, taps through the flow with the Xcode MCP device-interaction tools (Xcode must be running) and returns a per-step PASS/FAIL report with screenshots in `build/screenshots/`. Never edits code. |

## Decisions belong to the user
- Never decide for the user. Anything not fixed by the request or by `.claude/rules/` — architecture, naming, file placement, libraries, scope, trade-offs, what to do next — is a question, not an assumption. Ask, then wait for the answer.
- Do exactly what was asked, nothing more. No unrequested features, refactors, "improvements", extra files, extra rules or cleanup of nearby code. If something seems worth doing, propose it in one line and let the user decide.
- When asking: short options, your recommendation first with a one-line reason, then stop. Don't start the work "in the meantime".
- If you had to make a call on your own (e.g. a compiler forced it), say so explicitly in the report — never bury it.
- Subagents can't ask the user: they stop and report the question back; the main agent relays it.

## Workflow
1. Clarify ambiguous requirements before coding; don't proceed on assumptions.
2. Plan: break work into small steps.
3. Implement step by step; build after each step.
4. Add unit tests for logic (Swift Testing: `import Testing`, `@Test`).
5. Review: run `reviewer` after `coder`. Blockers go back to `coder` to fix, then one more review; blockers still left after that and all suggestions go to the user.
6. Done = build green, tests green, verified in simulator, format clean.
## Token economy
- To locate anything in the project, delegate to the `scout` subagent (Haiku 5.5, ≤10-line answer) or `/scout <what>`; don't grep/read around yourself.
- Build/test only via `scripts/build.sh` / `scripts/test.sh` (`build-and-test` skill); never dump full logs, grep `build/logs`.
- In the simulator, read the Xcode MCP UI hierarchy (small text) first; open a screenshot only for visual checks. Read only the files you need.

## MCP
Official Xcode MCP and Figma MCP (needs OAuth on first use) are configured in `.mcp.json` (`xcrun mcpbridge`, requires Xcode open with this project). Use it for previews, doc search and project navigation.
