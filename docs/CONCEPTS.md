# Forge Concepts

This document explains the key concepts behind Forge — the data structures, files, and mental models that the commands operate on.

## The `.forge/` Directory

Every project using Forge gets a `.forge/` directory at its root. This is the project's memory — it tracks what has been decomposed, planned, built, and verified.

```
.forge/
├── DISCOVERY.md          # Initial analysis from /forge:decompose
├── STATE.md              # Current status of all components
├── AGENTS.md             # Project-specific learnings
├── specs/
│   ├── OVERVIEW.md       # Component map and build order
│   └── NN-component.md   # Individual component specs
├── plans/
│   ├── component-RESEARCH.md   # What was discovered before planning
│   ├── component-PLAN.md       # Section-by-section implementation plan
│   ├── component-BUILD-LOG.md  # Record of what was built
│   └── component-VERIFY.md     # Goal-backward verification report
└── archive/              # Old artifacts preserved by /forge:reset
```

The `.forge/` directory should be committed to git. It's part of the project's history, not temporary state.

See [`templates/sample-forge/`](../templates/sample-forge/) for a fully annotated example of what this looks like in practice.

## Component Lifecycle

Each component moves through a defined lifecycle. The status is tracked in `STATE.md`:

```
spec-ready → planned → building (N/M) → built → verified
```

| Status | Meaning | Set by |
|--------|---------|--------|
| `spec-ready` | Has a spec, ready to plan | `/forge:decompose` |
| `planned` | Has a plan with sections | `/forge:plan` |
| `building (N/M)` | Build in progress | `/forge:build` |
| `built` | All sections complete | `/forge:build` |
| `verified` | Passed goal-backward verification | `/forge:verify` |
| `needs-fixes` | Verification found issues | `/forge:verify` |

Use `/forge:reset` to move a component back to an earlier phase (archiving, not deleting, old artifacts).

## STATE.md

The project status tracker. Contains a table of all components with their current status, plan file reference, and notes. Also includes the build order with dependency information.

Created by `/forge:decompose`, updated by every subsequent command.

See [`templates/sample-forge/STATE.md`](../templates/sample-forge/STATE.md) for an annotated example.

## AGENTS.md — Project Memory

The project's institutional memory. A collection of learnings recorded during work — gotchas, conventions, decisions, and tool tips. Every forge command reads this file before starting work.

### Entry categories

| Category | What it captures | Example |
|----------|-----------------|---------|
| `gotcha` | Something that broke unexpectedly | "SQLite doesn't enforce FK by default" |
| `convention` | A pattern to follow consistently | "All API responses use envelope format" |
| `decision` | An architectural choice made | "JWT over sessions for API-first design" |
| `tool-tip` | A useful command or technique | "Use `pytest --tb=short` for cleaner output" |

Entries are added by `/forge:build` (when discoveries happen), `/forge:learn` (manual), and `/forge:verify` (when verification reveals insights).

See [`templates/sample-forge/AGENTS.md`](../templates/sample-forge/AGENTS.md) for an annotated example.

## forge-learnings.md — Global Memory

While `AGENTS.md` is per-project, `~/.claude/forge-learnings.md` is global — it captures observations about the forge commands themselves, not any specific project.

This file is the inbox for the **reflect → evolve** pipeline:
1. `/forge:reflect` classifies session observations and stages global ones here
2. `/forge:evolve` reviews staged learnings and promotes them into command definitions

Items are removed from this file once acted on (promoted, adopted into a project, or discarded).

## The Document Chain

Forge produces a chain of documents as a component moves through its lifecycle:

```
Spec → Research → Plan → Build Log → Verify Report
```

| Document | Created by | Purpose |
|----------|-----------|---------|
| `specs/NN-component.md` | `/forge:decompose` | What the component does, acceptance criteria |
| `plans/component-RESEARCH.md` | `/forge:plan` | Codebase analysis, technical decisions |
| `plans/component-PLAN.md` | `/forge:plan` | Section-by-section implementation plan |
| `plans/component-BUILD-LOG.md` | `/forge:build` | Record of what was built, commit hashes |
| `plans/component-VERIFY.md` | `/forge:verify` | Truth table verification results |

Each document references the previous ones. The plan references the spec's acceptance criteria. The build log references plan sections. The verify report checks the spec's criteria against reality.

## Component Dependencies

Components can depend on each other. Dependencies are declared in each component's spec and tracked in `specs/OVERVIEW.md`.

The build order respects dependencies — a component won't build until its dependencies are `built` or `verified`. If you try, `/forge:build` will warn you and ask for confirmation.

```
[database] ──┬──> [api-routes] ──┐
             │                   ├──> [frontend]
             └──> [auth] ────────┘
```

Components without dependency relationships can be built in parallel.

## Modes

Several commands support different autonomy levels:

| Mode | Used by | Behavior |
|------|---------|----------|
| `interactive` | build, decompose, plan | Pause for approval at each step |
| `cruise` | build | Auto-advance on success, stop on failure |
| `loop` | build, loop | Fully autonomous, skip failures |
| `auto` | decompose, plan | Skip interviews, use best judgment |
