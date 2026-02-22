# Discovery: forge-commands Repository

## What exists
- 11 forge command markdown files in `~/.claude/commands/forge/` (~54KB total)
- An empty `forge-learnings.md` global inbox in `~/.claude/`
- An empty project directory at `the project root/`
- A prior plan file at `~/.claude/plans/fluffy-wiggling-lovelace.md` (from an earlier session)

## What's requested
Package the 11 forge slash commands into a distributable git repo with documentation that explains both the technical details (what each command does) and the human-level workflow (why this system exists, how the pieces connect).

## Skeptical re-evaluation of the prior plan

The prior plan proposed:
- 5 documentation files (WORKFLOW, COMMANDS, CONCEPTS, CUSTOMIZING, FAQ)
- 8 annotated sample artifact files in templates/sample-forge/
- install.sh + uninstall.sh
- README.md

**What I'd challenge:**

1. **COMMANDS.md is redundant.** Each command file already documents its own purpose, arguments, process, and rules. A reference card duplicates this. A table in the README with one-liners is enough.

2. **CUSTOMIZING.md is premature.** The commands are markdown files. "Fork and edit" is the customization story. This doc can be added when users actually ask.

3. **FAQ.md is premature.** No users = no frequently asked questions. Ship without it, add from real issues.

4. **sample-forge/ directory is debatable.** Running `/forge:decompose` once shows you every artifact. Fake examples risk being misleading if they drift from command behavior. A walkthrough in WORKFLOW.md showing what gets created is better.

5. **Is this even multi-component?** This is a repo of markdown files with a README and an install script. It might be 2-3 components, not 6+.

## Revised interpretation
The core deliverable is:
1. The commands themselves (scrubbed of project-specific content)
2. A way to install them (script + manual instructions)
3. Documentation that helps someone understand the workflow (README + one guide)
4. A template for the global learnings file (with documentation)

## Resolved decisions

1. **Sample artifacts**: Yes, full sample-forge/ directory with annotated examples of every artifact type
2. **Documentation**: 4 docs — WORKFLOW, COMMANDS, CONCEPTS, CUSTOMIZING. No FAQ (premature).
3. **Content scrubbing**: Strip project-specific content and generalize (replace with generic patterns)
4. **Language assumptions**: Generalize Python-specific references
5. **Distribution**: Private/shareable repo (not public GitHub showcase)
6. **License**: MIT
7. **Priority**: Comprehensive at launch — this is a showcase, not a file dump
8. **Versioning**: CHANGELOG + git tags
