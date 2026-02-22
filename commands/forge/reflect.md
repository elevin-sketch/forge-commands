# /forge:reflect — Collect and classify meta learnings from forge usage

You are running the REFLECT phase of the Forge workflow. Your job is to harvest observations about how the forge commands performed, classify them by scope, and stage them for future action after user approval.

## When to run

- At the end of a session where forge commands were used
- When you notice friction, ambiguity, or missed edge cases during forge usage
- When the user says "let's reflect" or "what did we learn"

## Process

### Step 1: Gather raw learnings

Scan the current conversation for:
- Explicit "Meta" observations made at the end of forge command executions
- Friction points, workarounds, or surprises encountered during forge usage
- Deviations from plans that suggest the plan format needs improvement
- Patterns that worked well and should be reinforced
- User feedback or corrections about forge behavior

Also read:
- `.forge/AGENTS.md` (check if any entries are actually global, not project-specific)
- `~/.claude/forge-learnings.md` if it exists (avoid duplicates)

### Step 2: Classify and present

Present each learning in a review table:

```
## Forge Reflect — Session Learnings

| # | Learning | Bucket | Rationale | Destination |
|---|----------|--------|-----------|-------------|
| 1 | [observation] | Global | [why this applies everywhere] | ~/.claude/forge-learnings.md |
| 2 | [observation] | Project | [why this is repo-specific] | .forge/AGENTS.md |
| 3 | [observation] | Session | [why this has no future relevance] | discard |

**Review these carefully.** A learning misclassified as Global will affect all future projects.
Reclassify any by number, or approve all to proceed.
```

**Classification rules:**
- **Global**: About forge command design, workflow structure, or patterns that apply regardless of project. Examples: "build log commit hashes should be post-filled", "skeleton step is unnecessary for small sections."
- **Project**: About this specific codebase, its conventions, dependencies, or quirks. Examples: "this repo uses Python 3.11", "tests live alongside source files."
- **Session**: Relevant only to the work just completed, already handled, no future value. Examples: "had to add a None guard for backward compat" (already done, code is committed).

**When in doubt, classify as Project.** It's safer to under-promote than to pollute the global learnings with repo-specific noise.

### Step 3: Wait for user approval

Do NOT persist anything until the user explicitly approves. They may:
- Approve all placements as-is
- Reclassify specific items (e.g., "move #3 to Project")
- Edit the wording of a learning
- Discard items they don't find valuable
- Add learnings the scan missed

### Step 4: Persist approved learnings

For each approved learning:

**Global** → Append to `~/.claude/forge-learnings.md`. Create the file if it doesn't exist with this header:
```markdown
# Forge Global Learnings
Observations about forge command design collected via /forge:reflect.
Read by /forge:evolve when updating command definitions.
Items are removed from this file once acted on (promoted, adopted, or discarded).

---
```
Each entry format:
```markdown
### [date] — [short title]
[One-line actionable description]
Source: [project name or "general"]
Context: [brief context about when/how this was observed]
```

**Project** → Append to `.forge/AGENTS.md` using the existing format (### date: title + bullet points).

**Session** → Acknowledge and discard. No file write.

### Step 5: Summarize

Present what was persisted:
- N global learnings staged → `~/.claude/forge-learnings.md`
- N project learnings persisted → `.forge/AGENTS.md`
- N discarded

If global learnings were staged, note: "These are staged for future review. Run `/forge:evolve` when you're ready to act on them."

## Rules
- **Never persist without explicit approval.** The review step is mandatory.
- **When in doubt, classify as Project.** Global learnings affect all future work — the bar should be high.
- **Don't duplicate.** Check existing entries in both AGENTS.md and forge-learnings.md before adding.
- **Keep learnings actionable.** "The build command was slow" is not useful. "Build command should skip skeleton step for sections marked small" is.
- **One learning per row.** Don't combine multiple observations into a single entry.
- **Reflect does not modify commands.** It only stages learnings. `/forge:evolve` is where command changes happen.

## Meta
This command is iteratively improved. After executing it, briefly note any friction, ambiguity, or edge cases encountered, and suggest improvements at the end of your response.
