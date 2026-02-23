# Forge Command Reference

Quick reference for all 12 forge commands. For the full process details, read the command files directly in `commands/forge/`.

---

## /forge:decompose

**Purpose:** Break a project into plannable components.
**Usage:** `/forge:decompose <requirement description>`
**Arguments:** A description of what you want to build. Add `auto` to skip interactive questions.
**Produces:** `.forge/DISCOVERY.md`, `.forge/specs/OVERVIEW.md`, `.forge/specs/NN-component.md`, `.forge/STATE.md`, `.forge/AGENTS.md`
**Reads:** Existing codebase, `.forge/STATE.md` (if exists)
**Modes:** Interactive (default), Auto
**Example:** `/forge:decompose a REST API for managing bookmarks with user auth`

---

## /forge:plan

**Purpose:** Create a detailed implementation plan for a component.
**Usage:** `/forge:plan <component-name> [auto]`
**Arguments:** Component name (matches spec file) or a description of new work.
**Produces:** `.forge/plans/component-RESEARCH.md`, `.forge/plans/component-PLAN.md`
**Reads:** `.forge/specs/NN-component.md`, `.forge/STATE.md`, `.forge/AGENTS.md`, existing codebase
**Modes:** Interactive (default), Auto
**Example:** `/forge:plan auth auto`

---

## /forge:build

**Purpose:** Execute a plan section-by-section, producing working code with tests.
**Usage:** `/forge:build <component> [section N] [interactive|cruise|loop]`
**Arguments:** Component name. Optionally specify starting section and mode.
**Produces:** Implementation code, tests, `.forge/plans/component-BUILD-LOG.md`
**Reads:** `.forge/plans/component-PLAN.md`, `.forge/AGENTS.md`, `.forge/STATE.md`
**Modes:** Interactive (pause for approval), Cruise (auto-advance on pass, stop on fail), Loop (fully autonomous)
**Example:** `/forge:build database cruise`

---

## /forge:verify

**Purpose:** Goal-backward verification — check that required conditions are actually true.
**Usage:** `/forge:verify <component>`
**Arguments:** Component name to verify.
**Produces:** `.forge/plans/component-VERIFY.md`
**Reads:** `.forge/specs/NN-component.md`, `.forge/plans/component-PLAN.md`, `.forge/plans/component-BUILD-LOG.md`
**Modes:** None (single mode)
**Example:** `/forge:verify database`

---

## /forge:quick

**Purpose:** Fast execution for small, well-understood tasks that skip the full pipeline.
**Usage:** `/forge:quick <task description>`
**Arguments:** Description of the task to perform.
**Produces:** Code changes, tests, atomic commit. Updates `.forge/` state if it exists.
**Reads:** `.forge/AGENTS.md` (if exists), relevant source files
**Modes:** None (single mode)
**Example:** `/forge:quick fix the off-by-one error in pagination`

---

## /forge:probe

**Purpose:** Hypothesis-driven exploration with structured discovery reporting.
**Usage:** `/forge:probe <topic> [hypothesis]`
**Arguments:** Topic to explore (required). Optionally include a hypothesis to test.
**Produces:** `.forge/probes/topic-REPORT.md`, numbered commits per fix
**Reads:** `.forge/AGENTS.md`, relevant source files
**Modes:** None (single mode)
**Example:** `/forge:probe why batch queries silently drop after the first result`

---

## /forge:loop

**Purpose:** Autonomous iteration for mechanical, repetitive tasks.
**Usage:** `/forge:loop <task description> [--batch N] [--auto]`
**Arguments:** Description of the mechanical task. `--batch N` limits to N items. `--auto` skips approval.
**Produces:** `.forge/loop-TASK.md`, `.forge/loop-LOG.md`, atomic commits per item
**Reads:** Codebase (scanned for task items), `.forge/AGENTS.md`
**Modes:** Interactive (approve task list first), Auto
**Example:** `/forge:loop add type annotations to all functions in src/utils/ --batch 10`

---

## /forge:status

**Purpose:** Check project progress and suggest the next action.
**Usage:** `/forge:status`
**Arguments:** None.
**Produces:** Status summary (displayed, not written to file)
**Reads:** All `.forge/` state files
**Modes:** None (single mode)
**Example:** `/forge:status`

---

## /forge:reset

**Purpose:** Reset a component to an earlier phase, archiving old artifacts.
**Usage:** `/forge:reset <component> [spec-ready|planned]`
**Arguments:** Component name and target phase (default: `spec-ready`).
**Produces:** Archived files in `.forge/archive/component-timestamp/`
**Reads:** `.forge/STATE.md`, component spec
**Modes:** None (single mode, always confirms)
**Example:** `/forge:reset auth planned`

---

## /forge:learn

**Purpose:** Record a learning to the project's persistent memory.
**Usage:** `/forge:learn <what you learned>`
**Arguments:** Description of the learning.
**Produces:** New entry in `.forge/AGENTS.md`
**Reads:** `.forge/AGENTS.md`
**Modes:** None (single mode)
**Example:** `/forge:learn SQLite LIKE is case-insensitive for ASCII but not Unicode`

---

## /forge:reflect

**Purpose:** Collect and classify meta learnings from forge usage.
**Usage:** `/forge:reflect`
**Arguments:** None.
**Produces:** Classified learnings persisted to `~/.claude/forge-learnings.md` (global) or `.forge/AGENTS.md` (project)
**Reads:** Current conversation, `.forge/AGENTS.md`, `~/.claude/forge-learnings.md`
**Modes:** None (single mode, always requires approval before persisting)
**Example:** `/forge:reflect`

---

## /forge:evolve

**Purpose:** Act on staged global learnings — promote into commands, adopt into projects, or discard.
**Usage:** `/forge:evolve`
**Arguments:** None.
**Produces:** Updated command definitions in `~/.claude/commands/forge/`, migrated `.forge/` artifacts
**Reads:** `~/.claude/forge-learnings.md`, command definitions, `.forge/STATE.md`
**Modes:** None (single mode, every action requires explicit approval)
**Example:** `/forge:evolve`
