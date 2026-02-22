# Forge Commands — Component Overview

## Components

### 1. Command Files (the product)
Copy and scrub the 11 forge command markdown files for distribution. Remove project-specific references, generalize language-specific assumptions.

- Depends on: nothing
- Produces: `commands/forge/*.md` (11 files)
- Complexity: **small** (copy + targeted edits)

### 2. Install Mechanism
Shell scripts for installing (symlink) and uninstalling commands, plus the forge-learnings.md template.

- Depends on: #1 (needs command files in place to link)
- Produces: `install.sh`, `uninstall.sh`, `templates/forge-learnings.md`
- Complexity: **small**

### 3. Sample Artifacts
Annotated example `.forge/` directory showing what every forge command produces. Realistic project ("task manager API") at various lifecycle stages.

- Depends on: #1 (must match current command output formats)
- Produces: `templates/sample-forge/` (STATE.md, AGENTS.md, specs, plans, build log, verify report)
- Complexity: **medium** (needs realistic, consistent, well-annotated content)

### 4. Documentation
README, workflow guide, command reference, concepts guide, customization guide, CHANGELOG.

- Depends on: #1, #2, #3 (references all of them)
- Produces: `README.md`, `docs/WORKFLOW.md`, `docs/COMMANDS.md`, `docs/CONCEPTS.md`, `docs/CUSTOMIZING.md`, `CHANGELOG.md`
- Complexity: **large** (most content creation effort)

## Dependency Diagram

```
[1. Command Files] ──┬──> [2. Install Mechanism]
                     │
                     ├──> [3. Sample Artifacts]
                     │
                     └──> [4. Documentation] <── depends on #1, #2, #3
```

## Build Order

1. **Command Files** (no dependencies — foundational)
2. **Install Mechanism** (depends on #1)
3. **Sample Artifacts** (depends on #1)
4. **Documentation** (depends on all above)

Note: #2 and #3 can be built in parallel after #1 is done.

## Total Scope Assessment

This is a **medium-sized** project overall. The command files are a quick copy-and-scrub. The install scripts are straightforward shell. The real work is in the sample artifacts (needs consistent, realistic content) and especially the documentation (4 guide files + README + CHANGELOG).

Estimated: 4 components, ~15-20 plan sections total across all components.
