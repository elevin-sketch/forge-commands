# Component: Install Mechanism
## Status: DRAFT
## Dependencies: 01-command-files
## Complexity: small

### What this component does
Provides an install script that symlinks the command files into Claude Code's expected location, an uninstall script that removes the symlink, and a forge-learnings.md template that gets copied (not symlinked) during install.

### Acceptance criteria
1. `install.sh` creates a directory-level symlink from `~/.claude/commands/forge` to `<repo>/commands/forge`
2. `install.sh` handles existing directory (backup with timestamp), existing symlink (ask to replace), and missing `~/.claude/commands/` (create it)
3. `install.sh` copies `templates/forge-learnings.md` to `~/.claude/forge-learnings.md` if it doesn't already exist
4. `install.sh` prints clear success message with verification instructions
5. `uninstall.sh` removes the symlink, optionally removes forge-learnings.md (default: preserve)
6. `uninstall.sh` refuses to delete a real directory (only removes symlinks it created)
7. Both scripts are executable (`chmod +x`)
8. Manual install instructions are documented (for README to reference)

### Key decisions to make during planning
- Should install.sh detect the repo's location via `dirname $0` or require the user to run it from the repo root?
- Should we support both bash and zsh, or just bash?

### Integration points
- Symlinks to `commands/forge/` directory (from component #1)
- Copies `templates/forge-learnings.md` (created in this component)
- README references both scripts and manual install steps
