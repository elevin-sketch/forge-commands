# Forge Workflow

How the forge commands connect into a complete development workflow.

## The Pipeline

```
Your idea ──> /forge:decompose ──> /forge:plan ──> /forge:build ──> /forge:verify
       │                                                    │
       │            Alternatives:                           │
       │            ├── /forge:quick (small tasks)          │
       │            └── /forge:loop (mechanical tasks)      │
       │                                                    │
       └── /forge:reflect ──> /forge:evolve ────────────────┘
                (learning loop)
```

Supporting commands used at any point:
- `/forge:status` — see where things stand
- `/forge:learn` — record a finding
- `/forge:reset` — go back and replan

## Phase by Phase

### 0. Start with an idea

Before running any forge commands, you need a requirement — even a rough one. This can be:
- A few sentences you wrote yourself ("I want a bookmark manager with user auth and collections")
- The output of Claude Code's built-in plan mode, which you then feed into decompose
- A design doc, spec, or conversation summary

Forge doesn't generate the initial idea — it structures and executes it. The input to `/forge:decompose` can range from a single sentence to a multi-page plan; decompose will ask clarifying questions either way.

### 1. Decompose — Break it down

**What it does:** Takes a broad requirement and produces focused component specifications.

**What it reads:** Existing codebase, any prior `.forge/` state.

**What it produces:**
- `.forge/DISCOVERY.md` — initial analysis and questions
- `.forge/specs/OVERVIEW.md` — component map with dependency diagram
- `.forge/specs/NN-component.md` — individual component specs
- `.forge/STATE.md` — status tracker
- `.forge/AGENTS.md` — empty learnings file

**When to skip:** If your project is small enough for a single component, skip directly to `/forge:plan`.

```
/forge:decompose a REST API for managing bookmarks with user auth
```

### 2. Plan — Design the approach

**What it does:** Takes a component spec and produces a section-by-section implementation plan.

**What it reads:** Component spec, STATE.md, AGENTS.md, existing codebase.

**What it produces:**
- `.forge/plans/component-RESEARCH.md` — codebase analysis, technical decisions
- `.forge/plans/component-PLAN.md` — numbered sections with goals, files, tests, acceptance checks

**When to skip:** Never — every component needs a plan, even small ones. The plan is what makes the build predictable.

```
/forge:plan database
```

### 3. Build — Execute the plan

**What it does:** Implements the plan section-by-section, writing code and tests, committing atomically.

**What it reads:** Plan file, AGENTS.md, existing code from prior sections.

**What it produces:**
- Implementation code and tests
- `.forge/plans/component-BUILD-LOG.md` — record of what happened
- Atomic git commits per section

**Three modes:**
| Mode | Best for | Behavior |
|------|----------|----------|
| `interactive` | First time, complex work | Pause for approval at each section |
| `cruise` | Confident in the plan | Auto-advance on test pass, stop on fail |
| `loop` | Well-defined plans | Fully autonomous, skip failures |

```
/forge:build database cruise
```

### 4. Verify — Prove it works

**What it does:** Goal-backward verification — checks that the spec's acceptance criteria are actually true in the codebase, not just that tasks were completed.

**What it reads:** Component spec, plan, build log, the actual code.

**What it produces:**
- `.forge/plans/component-VERIFY.md` — truth table with PASS/FAIL/PARTIAL results
- Trivial fixes applied inline (< 5 lines)

**Why it matters:** Task completion ("I built all 5 sections") doesn't prove the feature works. Verification asks "can a user actually create a bookmark?" and runs the test to prove it.

```
/forge:verify database
```

## The Alternatives

### /forge:quick — Skip the pipeline

For small tasks that don't need decompose → plan → build:
- Bug fixes
- Config changes
- Small features (< 3 files, < 200 lines)

Quick still writes tests and commits atomically. It just skips the planning overhead.

```
/forge:quick fix the off-by-one error in pagination
```

### /forge:loop — Mechanical repetition

For well-defined, repetitive tasks where the definition of "done" is objective:
- Adding type annotations across a codebase
- Migrating API routes to a new framework
- Expanding test coverage file by file

Loop creates a task list, processes each item, commits individually, and reports what succeeded and what's blocked.

```
/forge:loop add unit tests for every untested function in src/models/ --batch 10
```

## The Learning Loop

Forge has a built-in feedback system for improving the commands themselves:

```
Use forge commands
       │
       ▼
/forge:reflect ──> Classify observations
       │            ├── Global (about forge itself)  ──> ~/.claude/forge-learnings.md
       │            ├── Project (about this codebase) ──> .forge/AGENTS.md
       │            └── Session (no future value)     ──> discard
       ▼
/forge:evolve  ──> Review staged global learnings
                    ├── Promote ──> Update command definitions
                    ├── Adopt   ──> Add to project AGENTS.md
                    └── Discard ──> Remove from inbox
```

### When to reflect

- At the end of a session where forge commands were used
- When you noticed friction or ambiguity during a build
- When the user says "what did we learn?"

### When to evolve

- After reflect has staged global learnings
- When opening a repo whose `.forge/` artifacts may be outdated
- Periodically to drain the learnings inbox

## When NOT to Use Forge

Forge adds structure. Not every task needs structure.

| Situation | Use instead |
|-----------|------------|
| One-line fix, typo | Just make the change directly |
| Quick debugging | Normal conversation with Claude |
| Exploring/prototyping | No tools needed — just try things |
| Single small feature | `/forge:quick` (lightweight path) |
| Bulk mechanical edits | `/forge:loop` (skip the full pipeline) |

The full decompose → plan → build → verify pipeline is for **projects with multiple components, dependencies between them, and a need for structured progress tracking.** If your task doesn't have that complexity, use a lighter tool.

## Walkthrough: From Idea to Verified Build

Here's the abbreviated flow for building a "Bookmark API" project:

**Step 1: Decompose**
```
/forge:decompose a REST API for managing bookmarks with user auth
```
Forge asks clarifying questions, then produces 4 component specs: database, api-routes, auth, frontend.

Files created: `.forge/DISCOVERY.md`, `.forge/STATE.md`, `.forge/AGENTS.md`, `.forge/specs/OVERVIEW.md`, `.forge/specs/01-database.md` through `04-frontend.md`

**Step 2: Plan the first component**
```
/forge:plan database
```
Forge analyzes the codebase, asks technical questions (ORM or raw SQL? migration tool?), then produces a 4-section plan.

Files created: `.forge/plans/database-RESEARCH.md`, `.forge/plans/database-PLAN.md`

**Step 3: Build it**
```
/forge:build database cruise
```
Forge implements each section: writes skeleton → writes tests → implements code → runs tests → commits. In cruise mode, it auto-advances on success and stops if tests fail.

Files created: source code, tests, `.forge/plans/database-BUILD-LOG.md`

**Step 4: Verify it**
```
/forge:verify database
```
Forge builds a truth table from the spec's acceptance criteria and runs each check. Produces a report: 4 conditions pass, 1 partial (Unicode search edge case).

Files created: `.forge/plans/database-VERIFY.md`

**Step 5: Next component**
```
/forge:status
```
Shows database as verified, suggests `/forge:plan api-routes` as the next action.

See [`templates/sample-forge/`](../templates/sample-forge/) for the complete annotated output of this workflow.
