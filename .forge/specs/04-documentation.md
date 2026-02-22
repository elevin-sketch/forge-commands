# Component: Documentation
## Status: DRAFT
## Dependencies: 01-command-files, 02-install-mechanism, 03-sample-artifacts
## Complexity: large

### What this component does
Creates the full documentation suite: README.md as the entry point, four guide documents in `docs/`, and a CHANGELOG.md for version tracking. Documentation provides progressive disclosure from quick-start (README) through workflow understanding (WORKFLOW) to deep reference (COMMANDS, CONCEPTS) to power-user modification (CUSTOMIZING).

### Acceptance criteria
1. `README.md` includes: one-paragraph description, prerequisites, quick install (3 lines), manual install, usage example showing the core pipeline, command table with one-liners, link to docs/, uninstall, license
2. `docs/WORKFLOW.md` includes: ASCII pipeline diagram, each phase explained (what/reads/produces/when-to-skip), complete worked example from idea to verified build, the learning loop (reflect/evolve), when NOT to use forge (use quick/loop instead)
3. `docs/COMMANDS.md` includes: structured reference for all 11 commands in consistent format (purpose, usage, arguments, produces, reads, modes, example)
4. `docs/CONCEPTS.md` includes: .forge/ directory explanation, STATE.md lifecycle, AGENTS.md purpose, forge-learnings.md and the reflect/evolve pipeline, specs/plans/build-logs document chain, component dependency model
5. `docs/CUSTOMIZING.md` includes: how to fork and modify commands, $ARGUMENTS variable, commit message format conventions, section size thresholds, per-repo commands, the Meta convention
6. `CHANGELOG.md` exists with an initial v1.0.0 entry listing all 11 commands
7. All internal links between docs resolve correctly
8. No absolute paths or personal paths appear in any documentation
9. All docs are scannable — use headers, tables, and code blocks over prose walls

### Key decisions to make during planning
- How long should the worked example in WORKFLOW.md be? Full end-to-end or abbreviated?
- Should COMMANDS.md include the full process for each command or just the synopsis?
- What version to start at — v1.0.0 or v0.1.0?

### Integration points
- README references install.sh and manual install from component #2
- WORKFLOW.md and CONCEPTS.md reference sample artifacts from component #3
- COMMANDS.md summarizes command files from component #1
- CHANGELOG tracks changes across all components
