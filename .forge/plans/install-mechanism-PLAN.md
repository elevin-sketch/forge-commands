# Plan: Install Mechanism
## Status: DRAFT
## Created: 2026-02-22
## Estimated sections: 2

### Overview
Create install.sh and uninstall.sh scripts that manage a directory-level symlink from `~/.claude/commands/forge` to the repo's `commands/forge/`. Install also copies a forge-learnings.md template if one doesn't exist. Scripts use `#!/usr/bin/env bash`, auto-detect repo location via `dirname $0`, and abort if `~/.claude/` is missing.

### Prerequisites
- Component #1 (command-files) must be built — `commands/forge/` must exist with 11 .md files
- Templates directory will be created in this component

---

### Section 1: Install script and forge-learnings template ✅ 2026-02-22
**Goal:** A working install.sh that symlinks commands and copies the learnings template
**Files to create:**
- `install.sh` — the install script (executable)
- `templates/forge-learnings.md` — the global learnings inbox template (copied during install)
**Tests to write:**
- Verify install.sh is executable
- Verify install.sh contains the expected flow: check ~/.claude/ exists, handle conflicts, create symlink, copy template
- Verify templates/forge-learnings.md exists with the expected header
**Acceptance check:** `test -x install.sh && grep -q 'ln -s' install.sh && grep -q '.claude' install.sh && test -f templates/forge-learnings.md && echo PASS`
**Estimated size:** small (~80 lines for install.sh, ~10 lines for template)

---

### Section 2: Uninstall script ✅ 2026-02-22
**Goal:** A working uninstall.sh that removes the symlink safely
**Files to create:**
- `uninstall.sh` — the uninstall script (executable)
**Tests to write:**
- Verify uninstall.sh is executable
- Verify it checks for symlink (not real directory) before removing
- Verify it asks about forge-learnings.md removal with default preserve
**Acceptance check:** `test -x uninstall.sh && grep -q 'readlink\|symlink\|-L' uninstall.sh && echo PASS`
**Estimated size:** small (~40 lines)

---

### Verification checklist
When all sections are complete, these conditions must be true:
- [ ] install.sh creates a directory-level symlink from ~/.claude/commands/forge to <repo>/commands/forge
- [ ] install.sh handles existing directory (backup), existing symlink (ask to replace), and missing ~/.claude/ (abort)
- [ ] install.sh copies templates/forge-learnings.md to ~/.claude/forge-learnings.md if not present
- [ ] install.sh prints success message with verification instructions
- [ ] uninstall.sh removes the symlink, optionally removes forge-learnings.md (default: preserve)
- [ ] uninstall.sh refuses to delete a real directory
- [ ] Both scripts are executable
