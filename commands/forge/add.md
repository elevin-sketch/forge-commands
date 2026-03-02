# /forge:add — Add a component to an existing project

You are running the ADD command. Your job is to insert a new component into an already-decomposed project — creating its spec and updating STATE.md. This is a single-component decompose, not a planning or build step. After adding, the user should run `/forge:plan` on the new component.

## When to use

- A new component is discovered mid-build that wasn't in the original decomposition
- A sub-component needs to be broken out (e.g., C25.1 from C25)
- A follow-up or fix warrants its own tracked component rather than ad-hoc edits
- The user says "add this to the planning docs" or "track this as a component"

Do NOT use this for work that fits in `/forge:quick` (single-file, < 30 min, no dependencies). Use this when the work needs sections, a build log, and potentially verification.

## Input

$ARGUMENTS

Parse to determine:
- **What**: Description of the new component
- **After** (optional): Which component it follows in build order (e.g., "after 25" → creates 25.1)
- **Depends on** (optional): Explicit dependencies

## Process

### Step 1: Context check

Read `.forge/STATE.md` to understand:
- Current component numbering
- Build order and dependencies
- Which components are in progress or completed

### Step 2: Determine numbering

- If "after N" is specified → use N.1 (or N.2 if N.1 exists)
- If no position specified → assign the next sequential number
- Present the proposed number and position to the user for confirmation

### Step 3: Write the spec

Create `.forge/specs/NN-[component-name].md` using the standard format:

```markdown
# Component: [Name]
## Status: DRAFT
## Dependencies: [list]
## Complexity: [small/medium/large]

### What this component does
[2-3 sentences]

### Acceptance criteria
[Numbered list of testable conditions]

### Key decisions to make during planning
[Questions for /forge:plan]

### Integration points
[How this connects to existing components]
```

### Step 4: Update STATE.md

- Add the new component row to the components table
- Insert it into the build order at the correct position
- Update dependency references if other components should depend on or be unblocked by this one

### Step 5: Confirm

Present:
- The new spec (summary)
- Its position in build order
- Any dependency implications
- Suggest next step: `/forge:plan [component]`

## Rules
- Never renumber existing components. Use decimal numbering (25.1, 25.2) for insertions.
- Always read STATE.md before writing — never create a component that duplicates an existing one.
- If the new component would change dependencies of in-progress or completed components, flag this to the user before proceeding.
- Keep specs concise. This is a lightweight addition, not a full decompose cycle.

## Meta
This command is iteratively improved. After executing it, briefly note any friction, ambiguity, or edge cases encountered, and suggest improvements at the end of your response.
