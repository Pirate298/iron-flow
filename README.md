# iron-flow

A skill pack for Claude Code: a **5-phase dev pipeline** (`/flow-*`), **rewritten and merged** from the best
parts of [gstack](https://github.com/garrytan/gstack),
[mattpocock/skills](https://github.com/mattpocock/skills) and
[superpowers](https://github.com/obra/superpowers-marketplace). The skills are **self-contained** (no `bun`, no
calls into gstack's `bin/`, no plugin dependencies) → reinstallable on any machine or project with one script.

## Install

```bash
git clone git@github.com:Pirate298/iron-flow.git ~/.iron-flow
~/.iron-flow/install.sh                 # → user config: ${CLAUDE_CONFIG_DIR:-~/.claude}/skills
# or install into a single project (BMAD-style):
~/.iron-flow/install.sh --project /path/to/project     # → <project>/.claude/skills
```
Open a new Claude Code session to load them. To reinstall / update: `git pull && ~/.iron-flow/install.sh`.

## Pipeline

| Command | Phase | What it does |
|---|---|---|
| `/flow` | master | Orchestrates the whole chain with gates; re-entry for new features; shortcut for small fixes |
| `/flow-intake` | Intake | Vague requirement + UI/UX → locked scope (6 forcing questions, alternatives, approval gate) |
| `/flow-design` | Design | Requirement → FE↔BE system design, contracts, domain model (CONTEXT.md/ADR), sliced plan |
| `/flow-build` | Code+Test | Worktree + TDD (red first), tracer bullet, vitest/jest, Maestro E2E |
| `/flow-debug` | Debug | Feedback loop → root cause → regression test (Iron Law: no fix without a root cause) |
| `/flow-ship` | Ship | Two-axis review + checklist → verify against the design (fresh evidence) → merge/PR → build |

**The 4 Iron Laws:** no implementation before the design is approved · no code before a failing test · no fix
before the root cause is found · no "done" before fresh verification.

## Customizing

- Enable/disable or add a skill: edit [manifest.txt](manifest.txt) (each `[area]` becomes an `<area>-<skill>`
  prefix), then re-run `install.sh`.
- Add a new area: open an `[area-name]` section and list the skill directories under `skills/`.

## Syncing from upstream

The skills are a merged rewrite (a fork) — they do not auto-pull. To resync: `dev/resync.sh` pulls the 3
sources into `.sources/` (gitignored) and prints the commits landed since the SHAs recorded in
[SOURCES.md](SOURCES.md); read those, then hand-edit the matching phase (the `<!-- sources: ... -->` footer in
each SKILL.md says which upstream skill it descends from).

See [NOTICE.md](NOTICE.md) for attribution.
