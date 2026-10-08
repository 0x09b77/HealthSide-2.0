---
name: verify
description: Walk a user flow in the iOS Simulator via the `tester` subagent (Haiku 5.5) and the Xcode MCP — build, launch, tap through the steps using the UI hierarchy — and get back a per-step PASS/FAIL report in at most 20 lines. Use only when the user asks to check something in the simulator.
argument-hint: <flow steps and expected result of each>
context: fork
agent: tester
---

Verify this flow in the simulator: $ARGUMENTS

Answer in at most 20 lines: `Result:`, one line per step (`N. <step> — OK` / `FAIL: expected …, got … (screenshot path)`), `Observations:`, `Questions:` if any.
