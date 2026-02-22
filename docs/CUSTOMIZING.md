# Customizing Forge

Forge commands are plain markdown files. You can fork, modify, and extend them to fit your workflow.

## Where Commands Live

Claude Code discovers slash commands by looking in `~/.claude/commands/<namespace>/<command>.md`. If you installed via the install script, `~/.claude/commands/forge/` is a symlink to this repo's `commands/forge/` directory.

To customize:
1. **Fork the repo** and clone your fork
2. Run `install.sh` to point the symlink at your fork
3. Edit any command file directly
4. Your changes take effect immediately (no restart needed)

## The `$ARGUMENTS` Variable

Every command that accepts input uses `$ARGUMENTS` in its markdown. Claude Code replaces this with whatever the user types after the command name:

```
/forge:build database cruise
```

In `build.md`, `$ARGUMENTS` becomes `database cruise`. The command's Input section parses this into structured parameters.

Commands that don't take arguments (`status`, `reflect`, `evolve`) don't use `$ARGUMENTS`.

## Commit Message Format

Forge uses a consistent commit format:

```
forge(<component>): section N — <section name>
forge(<component>): verify fix — <description>
forge(quick): <description>
forge(loop): <description>
forge(setup): initialize project specs and plans
forge(evolve): migrate artifacts to current conventions
```

To change this, edit the commit message instructions in `build.md` (section 7), `quick.md` (step 2), `loop.md` (step 2), and `verify.md` (rules).

## Section Size Thresholds

The plan command uses size estimates to guide section design:

| Size | Line count | Guidance |
|------|-----------|----------|
| small | < 100 lines | Fine as-is |
| medium | < 300 lines | Standard section |
| large | < 500 lines | Consider splitting |
| > 500 lines | — | Build will pause and suggest splitting |

These thresholds are defined in `plan.md` (section design rules) and `build.md` (rules). Adjust them based on your context window preferences.

## Per-Repo Commands

You can add project-specific commands alongside the global forge commands. Create a `.claude/commands/` directory in any repo:

```
your-project/
├── .claude/
│   └── commands/
│       └── project/
│           └── deploy.md    # /project:deploy
├── .forge/
└── src/
```

These coexist with forge commands — different namespaces, no conflicts.

## The Meta Convention

Every forge command ends with a `## Meta` section:

```markdown
## Meta
This command is iteratively improved. After executing it, briefly note any
friction, ambiguity, or edge cases encountered, and suggest improvements
at the end of your response.
```

This creates a feedback loop: every time a command runs, it generates observations. These observations feed into `/forge:reflect` and `/forge:evolve`, which can update the commands.

If you add new commands, include the Meta section to opt into this improvement cycle.

## Adding New Commands

To add a new command:

1. Create `commands/forge/mycommand.md`
2. Follow the existing structure:
   ```markdown
   # /forge:mycommand — One-line description

   You are running the MYCOMMAND phase...

   ## Input
   $ARGUMENTS

   ## Process
   ### Step 1: ...
   ### Step 2: ...

   ## Rules
   - Rule 1
   - Rule 2

   ## Meta
   This command is iteratively improved...
   ```
3. The command appears as `/forge:mycommand` immediately

## Common Modifications

| Want to... | Edit |
|-----------|------|
| Change the test-first approach | `build.md` — implementation pattern (steps 2-4) |
| Skip skeleton step for small sections | `build.md` — step 2 |
| Adjust the planning interview | `plan.md` — step 2 |
| Change the verification approach | `verify.md` — process section |
| Modify what AGENTS.md tracks | `learn.md` — categories section |
| Adjust the reflect/evolve pipeline | `reflect.md` and `evolve.md` |
