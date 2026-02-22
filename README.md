# Forge Commands

A structured workflow system for [Claude Code](https://claude.ai/claude-code).

```
┌───────────────────────────────────────────────────┐
│ CORE WORKFLOW                                     │
│ decompose ──▶ plan ──▶ build ──▶ verify           │
├────────────────────────┬──────────────────────────┤
│ EFFICIENCY             │ PROJECT MANAGEMENT        │
│ quick · loop           │ status · reset            │
├────────────────────────┴──────────────────────────┤
│ EVOLUTION                                         │
│ learn ──▶ reflect ──▶ evolve                      │
└───────────────────────────────────────────────────┘
```

Claude Code is powerful for single-session tasks, but complex projects spanning multiple sessions lose coherence. Context resets, decisions get re-made, and progress becomes difficult to track. Forge addresses this by providing a structured workflow — 11 slash commands that manage the full lifecycle of a multi-component project.

The core pipeline follows a deliberate sequence: decompose a requirement into components, plan each one with concrete acceptance criteria, build section by section with tests and atomic commits, then verify the result against the original spec. Every artifact — specs, plans, build logs, verification reports — is written to a `.forge/` directory in your project as readable markdown, committed to git alongside your code. This is what gives sessions continuity. When context resets or a new session starts, `/forge:status` reconstructs the full picture from these files.

Three execution modes let you calibrate autonomy to the task. Interactive mode pauses for approval at each step. Cruise mode auto-advances when tests pass and stops on failure. Loop mode runs fully unsupervised, skipping failures and reporting results at the end. Separate commands handle tasks outside the main pipeline: `/forge:quick` for small changes that don't need full planning, `/forge:loop` for mechanical bulk operations across a codebase.

A built-in learning system captures institutional knowledge. Project-level learnings (gotchas, conventions, architectural decisions) persist in `.forge/AGENTS.md` and are read by every subsequent command. Global observations about the forge workflow itself are collected by `/forge:reflect` and promoted into updated command definitions by `/forge:evolve` — the tools improve through use, and bend toward each user's preferences, skill level, and working style over time.

The design draws on three existing Claude Code workflow systems: [Deep Trilogy](https://github.com/casualjim/deep-trinity)'s decompose-plan-build pipeline and goal-backward verification, [GSD](https://github.com/coleam00/gsd)'s structured state tracking and cruise-mode execution, and [Ralph Loop](https://github.com/jasonmlong/ralph-loop)'s autonomous iteration and skip-on-failure resilience. Forge combines these into a unified command set with shared state that works across sessions and context windows.

## Prerequisites

- [Claude Code](https://claude.ai/claude-code) installed and working

## Quick Install

```bash
git clone https://github.com/elevin-sketch/forge-commands.git ~/forge-commands
cd ~/forge-commands
./install.sh
```

The install script creates a symlink from `~/.claude/commands/forge` to the repo's `commands/forge/` directory. Updates are automatic — just `git pull`.

## Manual Install

```bash
# Clone the repo
git clone https://github.com/elevin-sketch/forge-commands.git ~/forge-commands

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
