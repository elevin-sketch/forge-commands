# Component: Command Files
## Status: DRAFT
## Dependencies: none
## Complexity: small

### What this component does
Copies the 11 forge command markdown files from `~/.claude/commands/forge/` into the repo at `commands/forge/`, then scrubs project-specific content and generalizes language-specific assumptions so the commands work for any project.

### Acceptance criteria
1. All 11 command files exist in `commands/forge/` and are valid markdown
2. No references to OpenLayers, Playwright, SIDE_COLOR, or timeCompression remain
3. No Python-specific assumptions (`.gitignore` entries generalized to "language-appropriate build artifacts")
4. Every command file retains its full structure: Input, Process, Rules, Meta sections
5. `$ARGUMENTS` placeholder preserved in every command that uses it

### Key decisions to make during planning
- Should any other project-specific content be scrubbed beyond the known items (verify.md, build.md)?
- Should the `## Meta` footer be kept as-is, or should it be reworded for external users?

### Integration points
- Install mechanism symlinks `commands/forge/` to `~/.claude/commands/forge/`
- Sample artifacts must match the formats described in these commands
- Documentation references these files throughout
