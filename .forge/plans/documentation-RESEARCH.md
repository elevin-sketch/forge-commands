# Research: Documentation

## Existing patterns discovered
- Repo contains: 11 command files in commands/forge/, install.sh, uninstall.sh, templates/forge-learnings.md, 8 sample artifact files in templates/sample-forge/
- No existing docs or README yet
- All command files follow consistent structure: title, Input ($ARGUMENTS), Process (numbered steps), Rules, Meta
- Commands that accept arguments: build, decompose, learn, loop, plan, quick, reset, verify (8 of 11)
- Commands without $ARGUMENTS: status, reflect, evolve (3 of 11)
- Sample artifacts use "Bookmark API" as the example project
- Install mechanism uses directory-level symlinks

## Decisions made (auto mode)

1. **Worked example length**: Abbreviated — show the command invocations and what files they create, not the full content of each artifact. Link to templates/sample-forge/ for "what the output looks like." Rationale: a full end-to-end example would be 500+ lines and nobody reads that. An abbreviated walkthrough with links is more scannable.

2. **COMMANDS.md depth**: Synopsis format — purpose, usage, arguments, produces, reads, modes, one example each. NOT the full process steps. Rationale: the full process is in the command files themselves; COMMANDS.md is a quick reference card, not a copy.

3. **Starting version**: v1.0.0 — Rationale: the commands are already battle-tested in the author's workflow. This isn't a beta; it's a release of proven tools.

4. **Section ordering**: Write foundation docs first (CONCEPTS, COMMANDS), then the narrative docs that build on them (WORKFLOW, CUSTOMIZING), then README last (it references everything), CHANGELOG last (stamps the version).

5. **LICENSE file**: MIT license — already decided during decompose. Create as part of the README section since they go together.
