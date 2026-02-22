#!/usr/bin/env bash
set -euo pipefail

# Forge Commands Uninstaller
# Removes the symlink at ~/.claude/commands/forge and optionally removes forge-learnings.md

TARGET="$HOME/.claude/commands/forge"
LEARNINGS="$HOME/.claude/forge-learnings.md"

# --- Check the symlink ---

if [ ! -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
    echo "No forge commands found at $TARGET. Nothing to uninstall."
    exit 0
fi

if [ ! -L "$TARGET" ]; then
    echo "Error: $TARGET is a directory, not a symlink."
    echo "This doesn't look like a Forge installation created by install.sh."
    echo "If you want to remove it manually, run: rm -rf $TARGET"
    exit 1
fi

# --- Remove the symlink ---

LINK_TARGET="$(readlink "$TARGET")"
rm "$TARGET"
echo "Removed symlink: $TARGET -> $LINK_TARGET"

# --- Handle forge-learnings.md ---

if [ -f "$LEARNINGS" ]; then
    echo ""
    echo "Found $LEARNINGS"
    echo "This file contains your global forge learnings collected via /forge:reflect."
    read -rp "Remove it? (Your learnings will be lost) [y/N] " reply
    if [[ "$reply" =~ ^[Yy]$ ]]; then
        rm "$LEARNINGS"
        echo "Removed: $LEARNINGS"
    else
        echo "Kept: $LEARNINGS"
    fi
fi

echo ""
echo "Forge commands uninstalled."
echo "Note: .forge/ directories in your projects are untouched — they contain project data, not the commands."
