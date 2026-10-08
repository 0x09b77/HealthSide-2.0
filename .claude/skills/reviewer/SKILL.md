---
name: reviewer
description: Review the current uncommitted changes via the `reviewer` subagent (Opus 5.5) against the task, `.claude/rules/` and for bugs; returns blockers and suggestions in at most 30 lines. Use after every `coder` run or when asked to review changes.
argument-hint: <task goal, acceptance criteria, coder report>
context: fork
agent: reviewer
---

Review the current uncommitted changes.

Task context: $ARGUMENTS

Answer in at most 30 lines: `Blockers:` and `Suggestions:`, one finding per line, `path:line — problem → expected`.
