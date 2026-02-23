# /forge:decompose — Break a project into plannable components

You are running the DECOMPOSE phase of the Forge workflow. Your job is to take a vague or broad requirement and produce a set of focused component specifications that can each be planned and built independently.

## Input

The user's requirement: $ARGUMENTS

## Auto mode

If the input contains `auto` or `--auto`, OR if the user has previously indicated they want minimal interaction (e.g., "your call", "just do it", "keep going"), run in **auto mode**:
- Skip the interactive question step — use your best judgment for all decisions
- Skip the "does this match your mental model?" review step
- Execute steps 1-5 straight through, then present the final result for review
- Document the decisions you made and why in DISCOVERY.md so the user can audit them

Otherwise, follow the interactive process below.

## Process

### Step 1: Understand the landscape (produce `.forge/DISCOVERY.md`)

Before asking questions, silently do the following:
- Read the project's existing codebase structure (if any) to understand what already exists
- Read `.forge/AGENTS.md` if it exists (lessons from prior work)
- Read `.forge/STATE.md` if it exists (current project status)

Then produce `.forge/DISCOVERY.md` containing:
- **What exists**: Summary of relevant existing code, patterns, conventions
- **What's requested**: Your interpretation of the user's requirement
- **Initial questions**: 5-8 clarifying questions organized by category (scope, constraints, dependencies, priorities)
- **Auto-resolved decisions** (auto mode only): Your answers to the questions above with brief rationale

In interactive mode: present the discovery document to the user and ask your questions. Wait for answers.
In auto mode: proceed directly to Step 2 using your best-judgment answers.

### Step 2: Identify components (produce `.forge/specs/OVERVIEW.md`)

Based on answers (user-provided or auto-resolved), identify 3-8 logical components. For each component, determine:
- What it does (one sentence)
- What it depends on (other components or existing code)
- What it produces (APIs, data, UI, etc.)
- Rough complexity (small / medium / large)

Write `.forge/specs/OVERVIEW.md` with:
- A dependency diagram (mermaid or ASCII)
- A recommended build order (respecting dependencies)
- An estimated total scope assessment

In interactive mode: present this to the user. Ask: "Does this decomposition match your mental model? Should any components be split further or merged?"
In auto mode: proceed directly to Step 3.

### Step 3: Write component specs (produce `.forge/specs/NN-component-name.md`)

For each component, create a numbered spec file. Each spec should contain:

```markdown
# Component: [Name]
## Status: DRAFT
## Dependencies: [list of other components or existing code]
## Complexity: [small/medium/large]

### What this component does
[2-3 sentences]

### Acceptance criteria
[Numbered list of testable conditions that define "done"]

### Key decisions to make during planning
[Questions that /forge:plan should resolve]

### Integration points
[How this component connects to others — APIs, shared state, events, etc.]
```

### Step 4: Update state (produce/update `.forge/STATE.md`)

**File update note:** If STATE.md or AGENTS.md already exist, update them in place (using str_replace or bash overwrite) rather than trying to create new files. These are living documents that grow across commands.

Create or update `.forge/STATE.md`:

```markdown
# Forge State
## Project: [name]
## Last updated: [timestamp]
## Phase: DECOMPOSED

### Components
| # | Component | Status | Plan | Notes |
|---|-----------|--------|------|-------|
| 01 | [name] | spec-ready | — | — |
| 02 | [name] | spec-ready | — | — |
...

### Build order
1. [component] (no dependencies)
2. [component] (depends on #1)
...
```

If the project doesn't have a `.gitignore`, create one with sensible defaults for the project's language:
```
# General
.env
*.log
.DS_Store

# Python
__pycache__/
*.pyc
*.egg-info/
.pytest_cache/

# Node
node_modules/
dist/

# Build output
build/
target/
```

Also create `.forge/AGENTS.md` if it doesn't exist:

```markdown
# Forge Learnings
Discoveries, gotchas, and conventions recorded during this project.
Each entry helps future commands avoid repeating mistakes.

---
(No entries yet)
```

### Step 5: Present the result

Summarize what you produced:
- Number of components identified
- Recommended build order
- Any risks or open questions
- Decisions made (especially in auto mode — list what you chose and why)
- Suggest the user run `/forge:plan [component-name]` on the first component in build order

## Rules
- Never write implementation code during decompose. This phase is ONLY about understanding and structuring.
- Every artifact must be a readable markdown file. The user should be able to open any file in `.forge/` and understand the project state.
- If the user's requirement is small enough for a single component, say so and suggest they skip to `/forge:plan` directly.
- Be honest about uncertainty. If you're unsure how to decompose something, say "I see two ways to split this" and present both options.
- **Artifact isolation:** Before writing DISCOVERY.md or OVERVIEW.md, check if they already exist. If so, warn the user — show what the existing file was created for (topic and date) and what the new one would cover. If the new topic is unrelated to the current repo, suggest working in a separate temporary directory instead of overwriting.
- **Known limitation — not additive.** Decompose assumes a fresh `.forge/` state. Running it again in a repo that already has components will overwrite STATE.md, OVERVIEW.md, and DISCOVERY.md, losing existing component tracking. For adding new components to an existing project, write specs manually and add them to STATE.md. For exploration, use `/forge:probe`. An "additive mode" for decompose is a future enhancement.

## Meta
This command is iteratively improved. After executing it, briefly note any friction, ambiguity, or edge cases encountered, and suggest improvements at the end of your response.
