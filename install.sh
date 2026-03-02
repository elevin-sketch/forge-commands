#!/usr/bin/env bash
set -euo pipefail

# Forge Commands Installer
# Creates a symlink from ~/.claude/commands/forge to this repo's commands/forge/
# and copies the forge-learnings.md template if one doesn't exist.

# Resolve the repo's absolute path (works even when called from another directory)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMANDS_SOURCE="$SCRIPT_DIR/commands/forge"
TEMPLATE_SOURCE="$SCRIPT_DIR/templates/forge-learnings.md"

CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"
TARGET="$COMMANDS_DIR/forge"
LEARNINGS_TARGET="$CLAUDE_DIR/forge-learnings.md"

# --- Pre-flight checks ---

# Check Claude Code is installed
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "Error: ~/.claude/ not found."
    echo "Claude Code doesn't appear to be installed. Install it first, then re-run this script."
    exit 1
fi

# Check source commands exist
if [ ! -d "$COMMANDS_SOURCE" ]; then
    echo "Error: commands/forge/ not found in the repo."
    echo "Expected at: $COMMANDS_SOURCE"
    exit 1
fi

# --- Handle existing forge commands ---

if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
    if [ -L "$TARGET" ]; then
        EXISTING_LINK="$(readlink "$TARGET")"
        if [ "$EXISTING_LINK" = "$COMMANDS_SOURCE" ]; then
            echo "Forge commands are already installed (symlinked to this repo)."
            echo "Nothing to do."
            exit 0
        fi
        echo "Found existing symlink at $TARGET"
        echo "  Currently points to: $EXISTING_LINK"
        echo "  Will be replaced with: $COMMANDS_SOURCE"
        read -rp "Replace? [y/N] " reply
        if [[ ! "$reply" =~ ^[Yy]$ ]]; then
            echo "Aborted."
            exit 0
        fi
        rm "$TARGET"
    else
        # It's a real directory — check for local customizations
        echo "Found existing forge commands directory (not a symlink)."
        echo ""

        # Diff each file to find customizations
        HAS_DIFFS=false
        for installed_file in "$TARGET"/*.md; do
            [ -f "$installed_file" ] || continue
            filename="$(basename "$installed_file")"
            repo_file="$COMMANDS_SOURCE/$filename"

            if [ ! -f "$repo_file" ]; then
                echo "  LOCAL ONLY: $filename (not in repo)"
                HAS_DIFFS=true
            elif ! diff -q "$installed_file" "$repo_file" > /dev/null 2>&1; then
                echo "  MODIFIED:   $filename"
                HAS_DIFFS=true
            fi
        done

        if [ "$HAS_DIFFS" = true ]; then
            echo ""
            echo "You have local customizations that differ from the repo."
            echo "Options:"
            echo "  [d] Show diffs for each modified file"
            echo "  [b] Back up and proceed (customizations saved, not merged)"
            echo "  [a] Abort (keep current setup, don't install)"
            read -rp "Choose [d/b/a]: " reply

            if [[ "$reply" =~ ^[Dd]$ ]]; then
                for installed_file in "$TARGET"/*.md; do
                    [ -f "$installed_file" ] || continue
                    filename="$(basename "$installed_file")"
                    repo_file="$COMMANDS_SOURCE/$filename"

                    if [ ! -f "$repo_file" ]; then
                        echo ""
                        echo "=== $filename (LOCAL ONLY — not in repo) ==="
                        echo "This file exists in your install but not in the repo."
                        read -rp "  Copy into repo? [y/N] " copy_reply
                        if [[ "$copy_reply" =~ ^[Yy]$ ]]; then
                            cp "$installed_file" "$repo_file"
                            echo "  Copied to repo."
                        fi
                    elif ! diff -q "$installed_file" "$repo_file" > /dev/null 2>&1; then
                        echo ""
                        echo "=== $filename ==="
                        diff -u "$repo_file" "$installed_file" || true
                        echo ""
                        echo "  These are YOUR customizations (right side) vs the repo (left side)."
                        echo "  [k] Keep repo version (discard customizations)"
                        echo "  [f] Fold customizations into repo"
                        echo "  [s] Skip (deal with later)"
                        read -rp "  Choose [k/f/s]: " file_reply
                        if [[ "$file_reply" =~ ^[Ff]$ ]]; then
                            cp "$installed_file" "$repo_file"
                            echo "  Folded into repo."
                        elif [[ "$file_reply" =~ ^[Kk]$ ]]; then
                            echo "  Will use repo version."
                        else
                            echo "  Skipped."
                        fi
                    fi
                done
                echo ""
                read -rp "Proceed with install (symlink to repo)? [y/N] " proceed_reply
                if [[ ! "$proceed_reply" =~ ^[Yy]$ ]]; then
                    echo "Aborted."
                    exit 0
                fi
            elif [[ "$reply" =~ ^[Aa]$ ]]; then
                echo "Aborted."
                exit 0
            fi
        fi

        # Back up the existing directory
        BACKUP="$TARGET.backup.$(date +%Y%m%d%H%M%S)"
        echo "  Backing up to: $BACKUP"
        mv "$TARGET" "$BACKUP"
        echo "  Backup created."
    fi
fi

# --- Install ---

# Create commands directory if needed
mkdir -p "$COMMANDS_DIR"

# Create the symlink
ln -s "$COMMANDS_SOURCE" "$TARGET"
echo "Installed: $TARGET -> $COMMANDS_SOURCE"

# Copy forge-learnings template if it doesn't exist
if [ ! -f "$LEARNINGS_TARGET" ]; then
    cp "$TEMPLATE_SOURCE" "$LEARNINGS_TARGET"
    echo "Created: $LEARNINGS_TARGET (from template)"
else
    echo "Skipped: $LEARNINGS_TARGET already exists"
fi

# --- Success ---

echo ""
echo "Forge commands installed successfully!"
echo ""
echo "Verify by opening Claude Code and running: /forge:status"
echo "Update by running: git pull (symlink picks up changes automatically)"
echo "Uninstall by running: $SCRIPT_DIR/uninstall.sh"
