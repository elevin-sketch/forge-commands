# /forge:build — Execute a plan with adaptive autonomy

You are running the BUILD phase of the Forge workflow. Your job is to implement a plan section-by-section, producing working code with tests at each step.

## Input

$ARGUMENTS

Parse the arguments to determine:
- **Component**: Which plan to execute (look in `.forge/plans/[component]-PLAN.md`)
- **Section** (optional): Which section to start from (default: first incomplete section)
- **Mode** (optional): One of `interactive`, `cruise`, or `loop` (default: `interactive`)

Examples:
- `auth` → Execute the auth plan, interactive mode, from first incomplete section
- `auth section 3` → Start from section 3
- `auth cruise` → Execute in cruise mode
- `auth loop` → Execute in Ralph-style loop mode

## Pre-flight: Dependency check

**Before starting any build work**, read `.forge/STATE.md` and check whether all dependencies for this component have been built. Cross-reference with the component's spec (`.forge/specs/NN-[name].md`) for its dependency list.

- If all dependencies are `built`, `verified`, or further along → proceed normally
- If any dependency is `planned` or `spec-ready` → **STOP** and tell the user:
  > "[component] depends on [X] which is still [status]. Build that first with `/forge:build [X]`, or confirm you want to proceed anyway (interfaces will be assumed)."
- If the user confirms they want to proceed despite unbuilt dependencies, note this in the build log and proceed with assumed interfaces.

## Pre-flight: Setup commit

If this is the **first build of the first component** and `.forge/` artifacts have not yet been committed to git, create a setup commit first:
```
forge(setup): initialize project specs and plans
```
This keeps project scaffolding separate from implementation code in the git history. Include `.forge/`, `.gitignore`, and any other project config files.

## Mode behaviors

### Interactive mode (default — Deep Trilogy style)
For each section:
1. Present what you're about to implement (files, approach, tests)
2. **Wait for user approval** before writing any code
3. Implement the section: skeleton → tests → implementation → verify tests pass
4. Present a summary of what was built and any issues encountered
5. **Wait for user to confirm** before marking section complete
6. Commit and move to next section

### Cruise mode (GSD style)
For each section:
1. Briefly announce what you're implementing (one line)
2. Implement the section: skeleton → tests → implementation → verify tests pass
3. If tests pass: commit, log result, move to next section automatically
4. If tests fail: **stop and present the failure to the user** with diagnosis
5. For plans with 4+ sections: pause at the midpoint to present a progress summary. For smaller plans (3 or fewer sections), skip mid-build summaries — just present a final summary at the end.

### Loop mode (Ralph style)
Execute ALL remaining sections without stopping:
1. Read the plan and identify next incomplete section
2. Implement: skeleton → tests → implementation → verify tests pass
3. If tests pass: commit, update progress, continue to next section
4. If tests fail: attempt ONE fix. If fix works, continue. If not, log the failure in `.forge/AGENTS.md` and **skip to next section** (mark as `blocked`)
5. After all sections attempted: present full summary of what succeeded and what's blocked

## Implementation pattern (all modes)

For each section, follow this sequence:

### 1. Read context
- Read the plan section carefully
- Read `.forge/AGENTS.md` for relevant learnings
- Read any files that this section modifies or depends on
- If previous sections produced code, read it to understand current state

### 2. Write skeleton
Create the files with function signatures, class definitions, and docstrings, but no implementation bodies (use `pass` or `raise NotImplementedError`). This ensures tests can import the code before the real implementation exists.

Log: `[Section N] Skeleton created: path/to/file.py`

### 3. Write tests
- Create test files based on the plan's test descriptions
- Tests should be runnable but failing (they test skeleton code with no implementation)
- Log: `[Section N] Tests written: path/to/test_file.py`

### 4. Implement code
- Fill in the skeleton with real implementation
- Follow existing project conventions discovered during planning (see RESEARCH.md)
- Log: `[Section N] Implementation: path/to/file.py (X lines)`

### 5. Run acceptance check
- Execute the section's acceptance check command
- If tests pass → section is DONE
- If tests fail → diagnose and fix (behavior depends on mode — see above)
- Log: `[Section N] Tests: PASS/FAIL — [details]`

### 6. Update artifacts

**File update note:** STATE.md, AGENTS.md, and BUILD-LOG.md are living documents. Update them in place (using str_replace or bash overwrite) rather than trying to create new files. Create BUILD-LOG.md on the first section if it doesn't exist.

Update `.forge/plans/[component]-PLAN.md`:
- Mark the completed section with ✅ and timestamp
- Note any deviations from the plan (different approach, extra files, skipped items)

Update `.forge/STATE.md`:
- Update component status to `building (N/M sections complete)`

Update `.forge/AGENTS.md` if you discovered something worth remembering:
- A gotcha that future sections should know about
- A convention you established that should be consistent
- A dependency version or config detail

**AGENTS.md hygiene:** If AGENTS.md exceeds ~50 lines or ~8 entries, review older entries during builds. For entries that appear genuinely irrelevant going forward (one-time migration gotchas for completed work, resolved compatibility issues), present them to the user with reasoning for why they can be archived:

> "AGENTS.md has grown to [N] entries. These appear safe to archive to `.forge/AGENTS-archive.md`:
> - Entry [title] — [reason it's no longer relevant]
>
> Approve, keep, or skip?"

**Never archive without explicit user approval.** Entries about active conventions, patterns, or interface contracts that affect ongoing development must be preserved.

Append to `.forge/plans/[component]-BUILD-LOG.md`:
```markdown
### Section N: [name] — ✅ DONE [timestamp]
**Files created:** [list]
**Files modified:** [list]
**Tests:** [X passing, Y total]
**Deviations from plan:** [none / description]
**Commit:** [short hash]
```

### 7. Commit
Create an atomic git commit with message format:
`forge([component]): section N — [section name]`

Include only the files created/modified in this section plus updated `.forge/` state files.

Log the commit hash in BUILD-LOG.md for easy rollback reference.

Ensure `.gitignore` excludes language-appropriate build artifacts before committing (e.g., `__pycache__/` for Python, `node_modules/` for Node, `target/` for Rust).

## Rollback guidance

If a section needs to be fully reverted:
1. Use `git revert [commit-hash]` (the hash is logged in BUILD-LOG.md)
2. Update the plan to un-mark the section (remove ✅)
3. Update STATE.md to reflect the rollback
4. Note the rollback in BUILD-LOG.md: `### Section N: [name] — ⏪ REVERTED [timestamp] — [reason]`
5. Never use `git reset --hard` or force-push — always use revert for safe, traceable rollback

## State recovery

If you're resuming an interrupted build:
1. Read `.forge/plans/[component]-BUILD-LOG.md` to see what's been completed
2. Read `.forge/STATE.md` for overall progress
3. Start from the first section not marked ✅ in the plan
4. Announce: "Resuming [component] build from section N: [name]"

## Rules
- **Never skip tests.** Every section must have at least one runnable test. If the plan doesn't specify tests for a section, write basic smoke tests yourself.
- **Respect the plan.** If you realize the plan needs changes, note the deviation in the build log. Don't silently do something different.
- **Commit atomically.** One commit per section. Never commit broken code.
- **Log everything.** The build log is the user's record of what happened. Be thorough.
- If a section is much larger than expected (>500 lines of new code), pause and suggest splitting it regardless of mode.
- If you encounter a bug in a previously-completed section, fix it in the current section's commit and note it in the build log as a cross-section fix.
- **Forge is for application code, not self-modification.** If a plan involves editing forge command definitions (`~/.claude/commands/forge/*.md`), don't use `/forge:build` to execute it — write the changes directly. Using forge to build forge is circular.

## Meta
This command is iteratively improved. After executing it, briefly note any friction, ambiguity, or edge cases encountered, and suggest improvements at the end of your response.
