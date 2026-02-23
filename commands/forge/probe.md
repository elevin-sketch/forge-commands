# /forge:probe — Hypothesis-driven exploration with structured discovery reporting

You are running a PROBE — an exploratory task where the goal is to understand something by doing. Unlike forge:quick (small, well-understood tasks) or the main pipeline (planned features), a probe is for when you don't know what you'll find. The output is a structured discovery report, not a delivered feature.

Use this for:
- Feature spikes ("Can we make X work with Y?")
- Architecture exploration ("How does the data pipeline actually work?")
- Integration testing ("Wire up this feature and see what breaks")
- Bug investigation with unknown scope ("Why does this metric never update?")

## Input

$ARGUMENTS

Parse for:
- **Topic**: What to explore (required)
- **Hypothesis** (optional): What you expect to find or achieve

If no hypothesis is provided, formulate one from the topic during Step 1.

## Process

### Step 1: Frame the probe

Read `.forge/AGENTS.md` if it exists. Then state:
- **Goal**: What you're trying to learn or achieve (one sentence)
- **Hypothesis**: What you expect to find (testable prediction)
- **Starting point**: Which files/systems you'll begin exploring
- **Scope boundary**: What's OUT of scope — to prevent unbounded exploration

Ask: "Does this framing look right? Should I adjust the scope?"

### Step 2: Explore

Work toward the goal. As you go:

1. **Number each discovery** as it happens:
   - `Discovery #1: fetchRecords() returns a single result — batch queries silently drop after the first`
   - `Discovery #2: No retryWithBackoff() exists — failed requests are never retried`

2. **For discoveries that require code fixes**, commit each fix:
   - Commit message: `probe([topic]): fix #N — [description]`
   - Example: `probe(batch-processing): fix #1 — fetchRecords returns array for batch queries`

3. **For discoveries that are observations only** (no fix needed or fix deferred), just log them.

4. **Track exploration signals** (these are the same signals that trigger auto-escalation from forge:quick):
   - Files modified outside original scope
   - Debug cycles (run → fail → diagnose → fix)
   - Root-cause chains (fixing A reveals B is broken)

There is no fixed structure to the exploration phase. Follow the thread wherever it leads. The numbered discovery log IS the structure.

### Step 3: Produce the probe report

When exploration is complete (goal achieved, hypothesis confirmed/refuted, or scope boundary reached), produce `.forge/probes/[topic]-REPORT.md`:

```markdown
# Probe Report: [Topic]
## Date: [timestamp]
## Hypothesis: [what you expected]
## Verdict: [CONFIRMED / REFUTED / PARTIALLY CONFIRMED / INCONCLUSIVE]

### Goal
[What you set out to learn or achieve]

### Discoveries
#### Discovery #1: [title]
**Context:** [what you were doing when you found this]
**Finding:** [what you discovered]
**Fix:** [commit hash + description, or "deferred" / "observation only"]
**Impact:** [what this means for the system]

#### Discovery #2: [title]
...

### What worked
- [Things that functioned as expected]

### What required fixes
| # | Issue | Fix | Commit |
|---|-------|-----|--------|
| 1 | [issue] | [what you did] | [hash] |

### What's still broken
- [Known issues not fixed, with rationale for deferring]

### Architectural issues surfaced
- [Systemic concerns revealed during exploration]

### Recommendations
- [New specs to write]
- [Follow-up probes]
- [Quick fixes]
```

**The probe report IS the verification artifact.** No separate forge:verify pass is needed for probes. The report documents what was found, what was fixed, and what remains — that's verification.

### Step 3.5: Reconcile affected planning docs

If `.forge/` exists and the probe modified files that belong to tracked components:
1. Check which component specs (`.forge/specs/`) and plans (`.forge/plans/`) reference the modified files
2. Update those docs to reflect the current state:
   - Amend acceptance criteria in specs if the probe changed what "done" looks like for that component
   - Add notes to plan sections whose described implementation no longer matches reality
   - Update BUILD-LOG.md or VERIFY.md with a cross-reference to the probe report
3. Note in the probe report which planning docs were updated and why

If no planning docs are affected (e.g., pure research probe with no code changes), skip this step.

### Step 4: Update state

If `.forge/AGENTS.md` exists, append relevant learnings (things future work should know).

If `.forge/STATE.md` exists, add a probe entry:
```
| probe: [topic] | probed | [date] | `.forge/probes/[topic]-REPORT.md` |
```

Probes are tracked separately from pipeline components — they're exploratory, not deliverables.

### Step 5: Present summary

Summarize:
- Hypothesis verdict
- N discoveries (N fixes committed, N observations)
- Key recommendations
- Link to probe report

## Rules
- **Discoveries are numbered sequentially.** This creates a narrative thread through the exploration.
- **Every code fix gets its own commit** with the `probe([topic]):` prefix. This makes probe work easy to identify and revert if needed.
- **The probe report replaces forge:verify.** Don't suggest running verify after a probe — the report IS verification.
- **Respect the scope boundary.** When you hit the boundary, stop exploring and note remaining questions in the report. The user can start a new probe for those.
- **No new planning overhead.** Probes don't produce new specs, plans, or build logs. But when probe work modifies files that belong to tracked components, update those components' existing planning docs so downstream verifies stay accurate.
- **Log learnings aggressively.** Probes are where you learn the most about a codebase. Every discovery that would help future work goes in AGENTS.md.

## Meta
This command is iteratively improved. After executing it, briefly note any friction, ambiguity, or edge cases encountered, and suggest improvements at the end of your response.
