# /forge:evolve — Act on staged learnings and migrate repo artifacts

You are running the EVOLVE phase of the Forge workflow. This command reviews staged global learnings, validates they are still relevant, and for each one either promotes it into a command definition, adopts it into the current project, or discards it. It then migrates the current repo's `.forge/` artifacts if any command changes affected artifact format.

Either half can run independently — you may update commands without a repo, or migrate a repo without updating commands.

## When to run

- After `/forge:reflect` has staged global learnings and you're ready to act on them
- When opening a repo whose `.forge/` artifacts may be outdated relative to current commands
- Periodically to drain the learnings inbox

## Process

### Step 1: Read current state

Read these files:
- `~/.claude/forge-learnings.md` — staged global learnings (the inbox)
- The current forge command definitions in `~/.claude/commands/forge/` (decompose, plan, build, verify, status, quick, reflect, evolve, and any others)
- `.forge/STATE.md` if it exists (to understand current repo context)

Determine mode:
- **Inbox has items** → review learnings + migrate if needed
- **Inbox empty, `.forge/` exists** → migration check only
- **Inbox empty, no `.forge/`** → nothing to do, say so and exit

### Step 2: Validate staged learnings

**This step is critical when time has passed since reflect.**

For each staged learning, assess:
- **Still relevant?** Has the friction point been incidentally fixed by other changes? Read the current command definition to check.
- **Still accurate?** Does the learning reference command structure/behavior that still exists? Commands may have changed since the learning was staged.
- **Still actionable?** Can this be translated into a specific command change, or is it too vague?

Present the validation results:

```
## Forge Evolve — Staged Learnings Review

| # | Learning | Staged | Status | Recommendation |
|---|----------|--------|--------|----------------|
| 1 | [observation] | [date] | ✅ Current | Promote to /forge:build |
| 2 | [observation] | [date] | ⚠️ Stale | Context changed — recommend discard |
| 3 | [observation] | [date] | ✅ Current | Adopt into project AGENTS.md |
| 4 | [observation] | [date] | ❌ Already fixed | Discard — [explanation] |

### Detail: Learning #1
**Original context:** [from the Source/Context fields in forge-learnings.md]
**Current state:** [what the relevant command looks like now]
**Proposed change:** [specific edit to the command definition]
**Risk:** [what could go wrong — e.g., "may break repos that rely on skeleton step"]
```

**Staleness indicators:**
- Learning is >2 weeks old → flag for re-evaluation
- Learning references a command section that no longer exists → mark as stale
- Learning duplicates a rule already in the command → mark as already fixed
- Learning's source project no longer exists or is archived → note loss of context

### Step 3: User decision per learning

For each validated learning, the user chooses one of three actions:

- **Promote** → Edit the command definition to incorporate this learning. Remove from inbox.
- **Adopt** → Add to current project's `.forge/AGENTS.md` instead of changing the command globally. Remove from inbox.
- **Discard** → Not worth acting on. Remove from inbox.

Do NOT proceed until the user has decided on every item.

### Step 4: Apply promotions

For each learning marked "Promote":
1. Note the current command text (so the user can manually revert if needed)
2. Present the specific edit as a before/after diff
3. Wait for user confirmation on each diff
4. Apply the edit to the command definition
5. Remove the learning from `~/.claude/forge-learnings.md`

For each learning marked "Adopt":
1. Append to `.forge/AGENTS.md`
2. Remove from `~/.claude/forge-learnings.md`

For each learning marked "Discard":
1. Remove from `~/.claude/forge-learnings.md`

### Step 5: Migrate repo artifacts

If command changes were applied that affect artifact format, OR if `.forge/` artifacts appear to use outdated conventions, check for inconsistencies.

**Migration checks:**
- **STATE.md**: Expected columns present? Status values use current vocabulary?
- **AGENTS.md**: Entry format matches current conventions?
- **Plan files**: Section markers match current format (✅, timestamps)?
- **Build logs**: All expected fields present per section?
- **Verify reports**: Follow current template?
- **Spec files**: All required sections present?

Present findings:

```
## Migration Check

| # | File | Issue | Proposed fix |
|---|------|-------|-------------|
| 1 | STATE.md | Missing [column] | Add column with default values |
| 2 | — | No issues | — |

Apply migrations? Approve all, select by number, or skip.
```

**Do NOT modify files until the user approves.**

If migrations are applied, commit as:
`forge(evolve): migrate artifacts to current conventions`

### Step 6: Summarize

Present what was done:
- N learnings promoted → [list commands updated]
- N learnings adopted → `.forge/AGENTS.md`
- N learnings discarded
- N inbox items remaining (if any were deferred)
- N repo files migrated (if any)
- Inbox status: empty / N items remaining

## Rules
- **Every action requires explicit approval.** No silent writes to commands or repo files.
- **Validate before proposing.** Never propose a change based on a stale learning. Always check current command state first.
- **One diff at a time for promotions.** Don't batch command edits — the user needs to review each change in isolation.
- **Preserve git history.** Migration changes get their own commit, separate from any in-progress work.
- **Don't invent changes.** Every command update must trace to a specific learning from the inbox. No speculative improvements.
- **Migration is conservative.** Only fix format inconsistencies — don't rewrite content or reorganize structure.
- **Idempotent.** Running evolve with an empty inbox and up-to-date artifacts should produce no changes.
- **The inbox must drain.** Every item gets promoted, adopted, or discarded. No item should sit in the inbox indefinitely — flag items older than 30 days for forced decision.

## Meta
This command is iteratively improved. After executing it, briefly note any friction, ambiguity, or edge cases encountered, and suggest improvements at the end of your response.
