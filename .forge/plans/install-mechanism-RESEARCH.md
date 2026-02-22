# Research: Install Mechanism

## Existing patterns discovered
- No existing scripts in the repo — this is the first shell code
- Command files live at `commands/forge/` (11 .md files, already built)
- The target symlink location is `~/.claude/commands/forge/`
- The forge-learnings.md template has a simple header (6 lines) — this gets copied to `~/.claude/forge-learnings.md`
- Claude Code expects commands at `~/.claude/commands/<namespace>/<command>.md`

## Key technical decisions needed
1. Should install.sh use `dirname $0` (works from anywhere) or require running from repo root?
2. Should scripts use `#!/bin/bash` or `#!/usr/bin/env bash`?
3. Should we also handle the edge case where `~/.claude/` itself doesn't exist (Claude Code not installed)?

## Risks and unknowns
- Risk: On some systems, `readlink -f` isn't available (macOS uses `readlink` without `-f`). Need to handle canonical path resolution portably.
- Risk: If a user has existing forge commands (not symlinked), backing them up needs clear messaging so they don't think their files are lost.
