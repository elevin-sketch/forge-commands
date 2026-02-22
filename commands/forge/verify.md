# /forge:verify — Goal-backward verification of completed work

You are running the VERIFY phase of the Forge workflow. Instead of checking what tasks were completed (forward verification), you check what conditions must be TRUE for the feature to actually work (backward verification). This catches gaps that task-completion tracking misses.

## Input

$ARGUMENTS

Parse to determine which component to verify. Look for the plan at `.forge/plans/[component]-PLAN.md` and the build log at `.forge/plans/[component]-BUILD-LOG.md`.

## Process

### Step 1: Build the truth table

Read the component spec (`.forge/specs/NN-[component].md`) and the plan. For each acceptance criterion, determine what must be literally true in the codebase right now. Produce a truth table:

```markdown
# Verification: [Component]
## Generated: [timestamp]

### Required truths
| # | Condition | Check command | Result |
|---|-----------|---------------|--------|
| 1 | [e.g., "User can create account with email/password"] | [e.g., `pytest tests/test_auth.py::test_create_account`] | ⏳ |
| 2 | [e.g., "Invalid email returns 422 error"] | [e.g., `pytest tests/test_auth.py::test_invalid_email`] | ⏳ |
...
```

**Prefer running actual tests over grep-based checks.** Tests prove behavior; grep only proves text exists. Use grep checks only for configuration or static properties that aren't covered by tests.

### Step 2: Execute checks

Run each check command and record the result (✅ PASS, ❌ FAIL, ⚠️ PARTIAL, ❓ CANNOT VERIFY).

For items that fail or partially pass, diagnose the issue:
- Is it a missing implementation?
- Is it a bug in existing code?
- Is it a test gap (the feature works but isn't tested)?
- Is it an integration issue (works in isolation, fails when connected)?

### Step 2.5: Visual smoke test (if UI-facing)

If the component touches anything user-facing (pages, components, layouts, interactive controls), run a visual smoke test:

1. Check if a dev server is running; if not, start one
2. Using your project's browser testing tool (Playwright, Cypress, Puppeteer, or manual inspection):
   - Navigate to affected pages/views
   - Verify the UI renders without blank screens or layout breakage
   - Check the browser console for errors (`pageerror`, `console.error`)
   - Take screenshots if automated tooling is available
3. Include results in the verification report under a "Visual Smoke Test" section
4. If the component is pure backend/library logic with no UI impact, skip this step and note "N/A — no UI impact"

If your project has specific UI conventions (coordinate systems, enum values, color constants), add them to `.forge/AGENTS.md` so future verifications check them automatically.

### Step 3: Check for gaps the plan missed

Beyond the spec's acceptance criteria, check:
- **Error handling**: What happens with invalid inputs, network failures, empty states?
- **Edge cases**: Boundary values, concurrent access, resource limits
- **Integration seams**: Do the interfaces between this component and others actually match?
- **Regressions**: Run the full test suite, not just this component's tests

### Step 4: Present findings

Produce `.forge/plans/[component]-VERIFY.md`:

```markdown
# Verification Report: [Component]
## Date: [timestamp]
## Overall: [PASS / PASS WITH NOTES / FAIL]

### Results
| # | Condition | Result | Notes |
|---|-----------|--------|-------|
| 1 | ... | ✅ | — |
| 2 | ... | ❌ | [diagnosis] |

### Issues found
#### Critical (must fix)
- [Issue description + suggested fix]

#### Non-critical (should fix)
- [Issue description]

### Gaps discovered
- [Things the plan didn't cover that should be addressed]

### Auto-fixed during verification
- [List of trivial fixes applied, if any — see rules below]

### Recommendation
[SHIP IT / FIX AND RE-VERIFY / NEEDS MORE WORK — with specific next steps]
```

Present the summary to the user. If there are critical issues, suggest either:
- Running `/forge:build [component] section N` to fix specific sections
- Creating a new plan section for gap-filling work

### Step 5: Update state

Update `.forge/STATE.md`:
- Component status to `verified` (if passed) or `needs-fixes` (if failed)
- Link to verification report

Update `.forge/AGENTS.md` with any lessons learned during verification that would help future components.

### Step 6: Reconcile planning docs

With the full verification results in hand, update the component's spec and plan to reflect reality:
1. If auto-fixes were applied, update the relevant plan sections to describe what the code actually does now
2. If gaps were discovered, amend the spec's acceptance criteria to cover them (or note them as known gaps)
3. If verification revealed that acceptance criteria were wrong or incomplete, revise them to match actual behavior
4. Note in the verification summary which planning docs were updated and why

This step ensures planning docs remain an accurate record of the component, not a stale snapshot from before verification.

## Rules
- Verification must be evidence-based. Run actual commands, read actual files. Never say "this should work" — prove it works.
- **Prefer test-based checks over grep-based checks.** Running `pytest tests/test_auth.py::test_token_expiry` is better than `grep -r "expires_in.*86400" src/`. Tests prove behavior; grep proves text presence.
- Be honest about what you cannot verify. Some things (like performance, security, UX) require human judgment — flag them for manual review.
- **Trivial fixes allowed:** For issues that are clearly trivial (< 5 lines, obvious correctness — e.g., typos, missing imports, off-by-one in a format string), fix them inline during verification. Commit as `forge([component]): verify fix — [description]` and note them in the "Auto-fixed during verification" section of the report. For anything non-trivial, flag it and defer to `/forge:build`.
- If verification reveals that the spec itself was wrong (the acceptance criteria don't actually capture what the user needs), say so.

## Meta
This command is iteratively improved. After executing it, briefly note any friction, ambiguity, or edge cases encountered, and suggest improvements at the end of your response.
