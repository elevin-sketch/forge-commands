# /forge:quick — Fast execution for small, well-understood tasks

You are running a QUICK task — a lightweight path for work that doesn't need the full decompose → plan → build pipeline. Use this for bug fixes, small features, config changes, and anything that can be described and completed in a single conversation.

## Input

$ARGUMENTS

## Process

### Step 0: Bootstrap (if needed)

If `.forge/` doesn't exist, this is a project without forge state. That's fine — quick tasks don't require the full pipeline. Create minimal state only if useful:
- Skip creating `.forge/` entirely if this is a one-off fix to an existing project
- If the project would benefit from tracking (e.g., it already has `.forge/` but is missing AGENTS.md), create only what's missing

### Step 1: Assess and confirm

**Read the existing code first.** Before proposing changes, read the files you expect to modify to understand current patterns, conventions, and context.

Read `.forge/AGENTS.md` if it exists (for relevant learnings). Then briefly state:
- What you understand the task to be
- What files you expect to touch (and confirm they exist)
- How you'll verify it works

Ask: "Does this look right? Should I proceed?"

### Step 2: Implement

1. Write or update tests for the change
2. Make the change
3. Run tests
4. If tests pass → commit with message: `forge(quick): [brief description]`
5. If tests fail → diagnose, fix, retry (up to 2 attempts, then stop and explain)

### Step 3: Log and update

Append to `.forge/AGENTS.md` if you learned something useful (and the file exists).

Update `.forge/STATE.md` if the quick task affects a tracked component (and the file exists).

Present: what you did, what files changed, test results.

### Step 4: Reconcile planning docs

If `.forge/` exists and the quick task modified files that belong to a tracked component:
1. Check which component specs (`.forge/specs/`) and plans (`.forge/plans/`) reference the modified files
2. With the full picture of what changed, update those docs to reflect the current state:
   - Amend acceptance criteria in specs if "done" now looks different
   - Add notes to plan sections whose described implementation no longer matches reality
   - Update BUILD-LOG.md with an entry if the change is significant enough to track
3. Note in your summary which planning docs were updated and why

If no planning docs are affected, skip this step.

## Rules
- **Read before you write.** Always read existing files before modifying them to understand current patterns.
- If the task turns out to be larger than expected (>3 files or >200 lines), stop and suggest the user run `/forge:plan` instead.
- Always test. Even quick tasks get tests.
- Always commit. Even quick tasks get atomic commits.

## Meta
This command is iteratively improved. After executing it, briefly note any friction, ambiguity, or edge cases encountered, and suggest improvements at the end of your response.
