# /forge:reset — Reset a component to a previous phase

You are running the RESET command. This allows a user to undo planning or build progress for a component and start fresh from an earlier phase.

## Input

$ARGUMENTS

Parse to determine:
- **Component**: Which component to reset (required)
- **Target phase** (optional): One of `spec-ready`, `planned` (default: `spec-ready`)

Examples:
- `auth` → Reset auth back to spec-ready (removes plan and build artifacts)
- `auth planned` → Reset auth back to planned (removes build artifacts but keeps plan)
- `database spec-ready` → Reset database back to spec-ready

## Process

### Step 1: Read current state

Read `.forge/STATE.md` to determine the component's current status. Read the component's spec to confirm it exists.

If the component doesn't exist in STATE.md, say so and stop.

### Step 2: Confirm with the user

Present what will happen:

```
Resetting [component] from [current-status] → [target-phase]

This will archive:
- [list of files that will be moved]

The following will be preserved:
- [list of files that remain — spec, AGENTS.md learnings, etc.]

Proceed? (This does NOT revert git commits — your code changes remain in the repo.)
```

Wait for user confirmation before proceeding.

### Step 3: Archive old artifacts

Create `.forge/archive/[component]-[timestamp]/` and move the relevant files:

**Reset to `spec-ready`** (removes plan + build artifacts):
- Move `.forge/plans/[component]-RESEARCH.md` → archive
- Move `.forge/plans/[component]-PLAN.md` → archive
- Move `.forge/plans/[component]-BUILD-LOG.md` → archive (if exists)
- Move `.forge/plans/[component]-VERIFY.md` → archive (if exists)

**Reset to `planned`** (removes build artifacts only):
- Move `.forge/plans/[component]-BUILD-LOG.md` → archive (if exists)
- Move `.forge/plans/[component]-VERIFY.md` → archive (if exists)
- Un-mark all ✅ sections in the PLAN.md (reset checkmarks)

### Step 4: Update state

Update `.forge/STATE.md`:
- Set the component's status to the target phase
- Clear the plan reference if resetting to spec-ready
- Add a note: `reset from [old-status] on [timestamp]`

### Step 5: Confirm

Present what was done:
- Files archived to `.forge/archive/[component]-[timestamp]/`
- Component status in STATE.md
- Suggested next action (e.g., `/forge:plan [component]` or `/forge:build [component]`)

## Rules
- **Never delete files.** Always archive them. The user may want to reference old plans or build logs.
- **Never revert git commits.** Reset only affects `.forge/` state files. The code in the repo is untouched. If the user wants to undo code changes, they should use `git revert` separately.
- **Always confirm before proceeding.** Resetting loses progress tracking — make sure the user means it.
- **Preserve AGENTS.md learnings.** Learnings from building the component are still valuable even after a reset. Never archive or modify AGENTS.md during a reset.

## Meta
This command is iteratively improved. After executing it, briefly note any friction, ambiguity, or edge cases encountered, and suggest improvements at the end of your response.
