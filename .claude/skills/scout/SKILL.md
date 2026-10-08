---
name: scout
description: Find something in the project (definition, usages, which file handles X, config/build setting) via the cheap `scout` subagent and get back at most 10 lines. Use for any "where is / find / which file / how is X wired" question.
argument-hint: <what to find>
context: fork
agent: scout
---

Find in this project: $ARGUMENTS

Answer in at most 10 lines, format `path:line — what is there`.
