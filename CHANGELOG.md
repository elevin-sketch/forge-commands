# Changelog

All notable changes to Forge Commands will be documented in this file.

## [1.0.0] — 2026-02-22

### Added

**Core workflow commands:**
- `/forge:decompose` — Break a project into plannable components
- `/forge:plan` — Create a detailed implementation plan for a component
- `/forge:build` — Execute a plan section-by-section with tests and commits
- `/forge:verify` — Goal-backward verification of completed work

**Efficiency commands:**
- `/forge:quick` — Fast execution for small, well-understood tasks
- `/forge:loop` — Autonomous iteration for mechanical/repetitive tasks

**Project management:**
- `/forge:status` — Check project progress and suggest next actions
- `/forge:reset` — Reset a component to an earlier phase

**Learning system:**
- `/forge:learn` — Record a learning to project memory
- `/forge:reflect` — Collect and classify meta learnings from usage
- `/forge:evolve` — Act on staged learnings, update command definitions

**Infrastructure:**
- `install.sh` / `uninstall.sh` — Symlink-based installation
- `templates/forge-learnings.md` — Global learnings inbox template
- `templates/sample-forge/` — Annotated example artifacts (Bookmark API project)

**Documentation:**
- `docs/CONCEPTS.md` — Mental model and terminology
- `docs/COMMANDS.md` — Structured reference for all 11 commands
- `docs/WORKFLOW.md` — Pipeline walkthrough with ASCII diagram
- `docs/CUSTOMIZING.md` — Guide for forking and extending commands
- `README.md` — Quick start and installation guide
