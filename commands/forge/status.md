# /forge:status — Check project progress and suggest next actions

You are running the STATUS command. Read all state files and present a clear picture of where things stand.

## Process

### Read state files

1. `.forge/STATE.md` — Overall project status
2. `.forge/specs/OVERVIEW.md` — Component dependency map
3. `.forge/specs/*.md` — Individual component specs (check status field)
4. `.forge/plans/*-PLAN.md` — Plans (check which sections are ✅)
5. `.forge/plans/*-BUILD-LOG.md` — Build logs (check completion)
6. `.forge/plans/*-VERIFY.md` — Verification reports
7. `.forge/AGENTS.md` — Learnings accumulated

If `.forge/` doesn't exist or is empty, say: "No Forge project initialized. Run `/forge:decompose [your requirement]` to get started."

### Present status

Format as a clear summary:

```
📊 Forge Status: [Project Name]
Last updated: [timestamp]

Components: [N total] — [X complete] / [Y in progress] / [Z not started]

| # | Component | Phase | Progress | Next action |
|---|-----------|-------|----------|-------------|
| 01 | auth | ✅ verified | 5/5 sections | — |
| 02 | database | 🔨 building | 3/5 sections | /forge:build database |
| 03 | api | 📋 planned | 0/4 sections | /forge:build api |
| 04 | frontend | 📝 spec-ready | — | /forge:plan frontend |

Learnings recorded: [N entries in AGENTS.md]

Suggested next action: /forge:build database (resume from section 4)
```

### Suggest next action

Based on the state, recommend the most logical next step:
- If components have specs but no plans → suggest `/forge:plan`
- If components have plans but aren't built → suggest `/forge:build` (respecting dependency order)
- If components are built but not verified → suggest `/forge:verify`
- If all components are verified → suggest final integration testing
- If there are blocked sections → highlight them and suggest unblocking strategies

## Rules
- Status must be derived from files, not memory. Read the actual files every time.
- If state files are inconsistent (e.g., STATE.md says "building" but no build log exists), flag the inconsistency.
- Keep the output concise. The user wants a quick picture, not a novel.

## Meta
This command is iteratively improved. After executing it, briefly note any friction, ambiguity, or edge cases encountered, and suggest improvements at the end of your response.
