# Forge Commands

A structured workflow system for [Claude Code](https://claude.ai/claude-code). Forge gives you 11 slash commands that turn vague requirements into decomposed components, detailed plans, tested implementations, and verified builds — with persistent project memory that learns from every session.

## Prerequisites

- [Claude Code](https://claude.ai/claude-code) installed and working

## Quick Install

```bash
git clone <repo-url> ~/forge-commands
cd ~/forge-commands
./install.sh
```

The install script creates a symlink from `~/.claude/commands/forge` to the repo's `commands/forge/` directory. Updates are automatic — just `git pull`.

## Manual Install

```bash
# Clone the repo
git clone <repo-url> ~/forge-commands

# Create the symlink
ln -s ~/forge-commands/commands/forge ~/.claude/commands/forge

# Copy the learnings template (optional, created automatically by /forge:reflect)
cp ~/forge-commands/templates/forge-learnings.md ~/.claude/forge-learnings.md
```

## Usage

The core workflow:

```
/forge:decompose build a bookmark manager with user auth and collections
/forge:plan database
/forge:build database cruise
/forge:verify database
```

This takes you from a vague idea to a verified, tested implementation with atomic git commits at every step.

For the full walkthrough, see [docs/WORKFLOW.md](docs/WORKFLOW.md).

## Commands

| Command | Purpose |
|---------|---------|
| `/forge:decompose` | Break a project into plannable components |
| `/forge:plan` | Create a detailed implementation plan for a component |
| `/forge:build` | Execute a plan section-by-section with tests and commits |
| `/forge:verify` | Goal-backward verification of completed work |
| `/forge:quick` | Fast execution for small tasks (skip the full pipeline) |
| `/forge:loop` | Autonomous iteration for mechanical/repetitive tasks |
| `/forge:status` | Check project progress and suggest next actions |
| `/forge:reset` | Reset a component to an earlier phase |
| `/forge:learn` | Record a learning to project memory |
| `/forge:reflect` | Collect and classify meta learnings from usage |
| `/forge:evolve` | Act on staged learnings, update command definitions |

For detailed reference with arguments, modes, and examples, see [docs/COMMANDS.md](docs/COMMANDS.md).

## How It Works

Forge creates a `.forge/` directory in your project that tracks:
- **Component specs** — what each piece does and when it's done
- **Implementation plans** — section-by-section build instructions
- **Build logs** — what was built, commit hashes for rollback
- **Verification reports** — proof that acceptance criteria are met
- **Project learnings** — gotchas, conventions, and decisions

For the mental model behind these concepts, see [docs/CONCEPTS.md](docs/CONCEPTS.md).

## Documentation

| Document | What it covers |
|----------|---------------|
| [WORKFLOW.md](docs/WORKFLOW.md) | How commands connect into a complete workflow |
| [COMMANDS.md](docs/COMMANDS.md) | Reference card for all 11 commands |
| [CONCEPTS.md](docs/CONCEPTS.md) | Mental model: .forge/ directory, STATE.md, AGENTS.md |
| [CUSTOMIZING.md](docs/CUSTOMIZING.md) | How to fork, modify, and extend commands |

## Sample Artifacts

The [`templates/sample-forge/`](templates/sample-forge/) directory contains annotated examples of every artifact Forge produces, using a fictional "Bookmark API" project. Open these files to see exactly what your `.forge/` directory will look like.

## Uninstall

```bash
./uninstall.sh
```

This removes the symlink. Your project `.forge/` directories are untouched — they're project data, not the commands.

## License

[MIT](LICENSE)
