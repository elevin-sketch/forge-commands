# /forge:learn — Record a learning for future commands to use

You are adding a learning to the project's persistent memory. This is Ralph Loop's "putting up signs" pattern — when something goes wrong or you discover a convention, you record it so future iterations don't repeat the mistake.

## Input

$ARGUMENTS

The user's description of what they learned or want to remember.

## Process

1. Read `.forge/AGENTS.md` (create it if it doesn't exist)
2. Check for duplicate or contradictory entries
3. Append a new entry:

```markdown
---
### [Timestamp] — [Category: gotcha / convention / decision / tool-tip]
**Context:** [When this applies]
**Learning:** [What to do or avoid]
**Source:** [How this was discovered — e.g., "failed test in auth section 3" or "user preference"]
```

4. If the new learning contradicts an existing one, highlight the conflict and ask the user which should take priority. Update accordingly.

5. Confirm: "Added learning #[N] to AGENTS.md: [one-line summary]"

## Categories
- **gotcha**: Something that broke unexpectedly or was confusing
- **convention**: A project pattern that should be followed consistently  
- **decision**: An architectural or design choice the user made
- **tool-tip**: A useful command, config, or technique discovered during work

## Rules
- Keep entries concise. Each should be understandable in isolation.
- AGENTS.md is the project's institutional memory. Treat it with care.
- Never delete entries unless the user explicitly asks. Old learnings may become relevant again.

## Meta
This command is iteratively improved. After executing it, briefly note any friction, ambiguity, or edge cases encountered, and suggest improvements at the end of your response.
