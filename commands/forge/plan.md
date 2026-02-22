# /forge:plan — Create a detailed implementation plan for a component

You are running the PLAN phase of the Forge workflow. Your job is to take a component specification and produce a detailed, section-by-section implementation plan that can be executed by `/forge:build`.

## Input

The component to plan: $ARGUMENTS

If the argument is a component name, look for its spec at `.forge/specs/NN-[name].md`.
If the argument is a description of new work (no matching spec), treat it as an ad-hoc planning request and create the spec inline.

## Auto mode

If the input contains `auto` or `--auto`, OR if the user has previously indicated they want minimal interaction (e.g., "your call", "just do it", "keep going", "continue"), run in **auto mode**:
- Skip the interview step — use your best judgment for all technical decisions
- Skip the user review step
- Execute steps 1-5 straight through, then present the final result
- Document the decisions you made and why in the RESEARCH.md so the user can audit them

Otherwise, follow the interactive process below.

## Process

### Step 1: Research (produce `.forge/plans/[component]-RESEARCH.md`)

Before planning, ensure the plans directory exists:
- Create `.forge/plans/` if it doesn't exist

Then gather context:

1. **Codebase analysis**: Read relevant existing files. Note patterns, conventions, test frameworks, import styles, error handling patterns. **If the component was previously built and reset**, check whether implementation files already exist. If they do, note this prominently — the plan may need fewer (or zero) implementation sections. However, if the user's intent appears to be a fresh rewrite (e.g., they mentioned wanting a different approach), plan as if starting from scratch.
2. **Spec review**: Read the component spec carefully. Note acceptance criteria and integration points.
3. **Dependency check**: If this component depends on others, check their status in `.forge/STATE.md`. Are they built? If not, note what interfaces you'll need to assume.
4. **AGENTS.md review**: Read `.forge/AGENTS.md` for lessons that apply to this component.

Produce `.forge/plans/[component]-RESEARCH.md`:
```markdown
# Research: [Component Name]

## Existing patterns discovered
- [Test framework: pytest/jest/etc.]
- [Import convention: absolute/relative]
- [Error handling: exceptions/result types/etc.]
- [Relevant existing code that this component will interact with]

## Key technical decisions needed
- [Decision 1: e.g., "Use SQLAlchemy ORM or raw SQL?"]
- [Decision 2: e.g., "WebSocket or SSE for real-time updates?"]

## Decisions made (auto mode) / Risks and unknowns
- [Decision/risk 1 with rationale]
- [Decision/risk 2 with rationale]
```

### Step 2: Interview (interactive only)

In interactive mode: present the research findings and ask the user 3-6 targeted questions about the technical decisions identified. These should be questions where the answer genuinely affects the plan, not obvious ones. Format as:

> **Decision needed:** [Brief description]
> **Option A:** [approach] — [tradeoff]
> **Option B:** [approach] — [tradeoff]
> **My recommendation:** [which and why]

Wait for the user's answers before proceeding.

In auto mode: skip this step entirely. Decisions were already documented in RESEARCH.md.

### Step 3: Write the plan (produce `.forge/plans/[component]-PLAN.md`)

Create a plan with these sections:

```markdown
# Plan: [Component Name]
## Status: DRAFT
## Created: [timestamp]
## Estimated sections: [N]

### Overview
[2-3 sentences summarizing the implementation approach based on research + user decisions]

### Prerequisites
[What must exist before this plan can execute — other components, env setup, etc.]

---

### Section 1: [Name — e.g., "Database schema and models"]
**Goal:** [What this section produces]
**Files to create/modify:**
- `path/to/file.py` — [what it contains]
**Tests to write:**
- [Test 1 description]
- [Test 2 description]
**Acceptance check:** [A command to run using RELATIVE paths from project root — e.g., `python -m pytest tests/test_models.py -v`]
**Estimated size:** [small/medium/large — where small < 100 lines, medium < 300, large < 500]

---

### Section 2: [Name]
...

---

### Section N: [Name — typically "Integration and wiring"]
...

---

### Verification checklist
When all sections are complete, these conditions must be true:
- [ ] [Acceptance criterion from spec]
- [ ] [Acceptance criterion from spec]
- [ ] All tests pass
- [ ] No regressions in existing tests
```

**Important: Acceptance checks must use relative paths or assume the working directory is the project root. Never hardcode absolute paths — they break portability across machines.**

**Section design rules (from GSD's atomic task pattern):**
- Each section should be completable in a single fresh context window (~50% utilization)
- Each section should produce a testable result — no "setup" sections that produce nothing runnable
- Sections should be ordered so each builds on the previous, but each is independently understandable
- Target 3-8 sections for a medium component, 1-3 for small, 5-12 for large

### Step 4: User review (interactive only)

In interactive mode: present the plan summary:
- Number of sections
- Estimated total complexity
- Any remaining risks or assumptions

Ask: "Should I adjust any sections before we proceed? You can also edit `.forge/plans/[component]-PLAN.md` directly and I'll pick up your changes."

In auto mode: skip this step. Present a brief summary at the end.

### Step 5: Update state

**File update note:** STATE.md and AGENTS.md are living documents. Update them in place (using str_replace or bash overwrite) rather than trying to create new files.

Update `.forge/STATE.md` to reflect:
- Component status changed from `spec-ready` to `planned`
- Plan file location

## Rules
- Never write implementation code during plan. This phase produces ONLY plan documents.
- Each section must have a concrete acceptance check — not "review the code" but "run `pytest tests/test_auth.py` and all pass."
- **Acceptance checks must use relative paths from the project root.** Never use absolute paths.
- If the component is too large for 8 sections, suggest splitting it further (send user back to `/forge:decompose` with a more focused scope).
- Plans are living documents. The user may edit them between sections during `/forge:build`. That's expected and good.
- If planning reveals that the spec is incomplete or wrong, say so clearly and suggest spec updates before proceeding.

## Meta
This command is iteratively improved. After executing it, briefly note any friction, ambiguity, or edge cases encountered, and suggest improvements at the end of your response.
