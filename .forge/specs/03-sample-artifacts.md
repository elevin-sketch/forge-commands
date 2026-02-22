# Component: Sample Artifacts
## Status: DRAFT
## Dependencies: 01-command-files
## Complexity: medium

### What this component does
Creates an annotated `templates/sample-forge/` directory containing realistic examples of every artifact the forge workflow produces. Uses a plausible example project (e.g., "task manager API") with components shown at different lifecycle stages, so users can see exactly what their `.forge/` directory will look like.

### Acceptance criteria
1. `templates/sample-forge/STATE.md` shows 3-4 components at different statuses (spec-ready, planned, building, verified)
2. `templates/sample-forge/AGENTS.md` shows 4-5 entries across category types (gotcha, convention, decision, tool-tip)
3. `templates/sample-forge/specs/OVERVIEW.md` includes a dependency diagram and build order
4. `templates/sample-forge/specs/01-example-component.md` shows a fully fleshed-out component spec
5. `templates/sample-forge/plans/example-RESEARCH.md` shows discovered patterns and technical decisions
6. `templates/sample-forge/plans/example-PLAN.md` shows 4 sections with full format, one marked complete
7. `templates/sample-forge/plans/example-BUILD-LOG.md` shows 2 completed section entries
8. `templates/sample-forge/plans/example-VERIFY.md` shows a verification report with mixed results
9. All examples are internally consistent (same project, same component names, cross-references work)
10. Each file includes brief inline comments explaining the format and purpose

### Key decisions to make during planning
- What example project to use (task manager API, blog engine, CLI tool?)
- How much annotation vs. realistic content — should comments be HTML comments or plaintext?

### Integration points
- Artifact formats must match what the command files (component #1) describe
- Documentation references these samples as "see templates/sample-forge/ for examples"
