# /forge:loop — Ralph-style autonomous iteration for mechanical tasks

You are running a LOOP execution — the most autonomous mode. This is designed for well-defined, mechanical, testable tasks where the definition of "done" is objective. Use this for migrations, refactors, test coverage expansion, bulk file operations, and similar repetitive work.

## Input

$ARGUMENTS

This should describe the mechanical task, for example:
- "migrate all API routes from Express to Fastify"
- "add type annotations to all functions in src/utils/"
- "write unit tests for every function in src/models/ that lacks coverage"

Parse for optional flags:
- `batch N` or `--batch N` → Only execute the first N incomplete items, then stop with a progress summary. Useful for large task lists or managing API costs.
- `auto` or `--auto` → Skip the task list approval step and begin executing immediately.

## Process

### Step 1: Create the task list (produce `.forge/loop-TASK.md`)

Analyze the codebase and produce a concrete, checkable task list:

```markdown
# Loop Task: [description]
## Created: [timestamp]
## Total items: [N]
## Batch size: [N or "all"]

### Tasks
- [ ] [Specific file or function to process] — [what to do]
- [ ] [Specific file or function to process] — [what to do]
...
(one line per item — be exhaustive, scan the actual codebase)

### Rules for each iteration
- [Convention to follow, e.g., "preserve existing docstrings"]
- [Test command to run after each change]
- [Commit message format]

### Definition of done
[How to verify ALL items are complete — e.g., "grep -r 'def.*):$' src/ returns 0 results" or "pytest runs with 100% pass"]
```

In interactive mode: present the task list to the user. Ask: "I found [N] items. Should I proceed? Any items to skip?"
In auto mode: proceed directly to execution.

### Step 2: Execute the loop

Determine how many items to process:
- If `batch N` was specified, process at most N incomplete items then stop
- Otherwise, process all items

For each incomplete task (up to the batch limit):

1. Read the task description and the target file
2. Read `.forge/AGENTS.md` for applicable learnings
3. Make the change
4. Run the specified test command
5. If tests pass:
   - Mark task as ✅ in `.forge/loop-TASK.md`
   - Commit: `forge(loop): [brief description of this item]`
   - **Batching trivial commits:** If consecutive tasks are trivially identical mechanical edits (e.g., adding a docstring to 6 functions, renaming a variable across files), batch them into a single commit listing all items: `forge(loop): [description] (N items)`. Reserve one-per-commit for tasks that are substantively different.
   - Log result to `.forge/loop-LOG.md`
   - Continue to next task
6. If tests fail:
   - Attempt ONE fix
   - If fix works → continue as above
   - If fix doesn't work → mark task as ❌ BLOCKED, log the error, add a learning to `.forge/AGENTS.md`, skip to next task

After every 5 tasks, append a progress line to `.forge/loop-LOG.md`:
```
[timestamp] Progress: [X]/[N] complete, [Y] blocked
```

If batch limit is reached, append:
```
[timestamp] Batch limit reached: [X]/[N] complete. Run `/forge:loop` again to continue.
```

### Step 3: Present results

When all tasks are attempted (or batch limit / all blocked), produce a summary:

```markdown
# Loop Results: [description]
## Completed: [timestamp]

### Summary
- ✅ Completed: [X] / [N]
- ❌ Blocked: [Y] — see details below
- ⏭️ Skipped: [Z]
- ⏸️ Remaining (not yet attempted): [W]

### Blocked items (need human attention)
| Task | Error | Suggested fix |
|------|-------|---------------|
| [item] | [error] | [suggestion] |

### Learnings added to AGENTS.md
- [learning 1]
- [learning 2]
```

### Step 4: Update state

Update `.forge/STATE.md` with loop completion status.

## Rules
- **Always create the task list first and get approval** (unless `--auto` flag is set). Never start modifying files without the user seeing what will be changed.
- **One concern per commit.** Each task item gets its own commit.
- **Test after every change.** The test command is the backpressure mechanism that keeps quality high.
- **Don't get stuck.** If a task fails twice, log it and move on. The user can fix blocked items manually.
- **Record learnings.** If you discover a pattern that helps (or a gotcha that hurts), add it to AGENTS.md so the next loop iteration or the next `/forge:build` benefits.
- If the task list exceeds 50 items, warn the user about API costs and suggest using `batch 10` or similar to process in chunks.

## Meta
This command is iteratively improved. After executing it, briefly note any friction, ambiguity, or edge cases encountered, and suggest improvements at the end of your response.
