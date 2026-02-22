# Research: Command Files

## Existing patterns discovered
- No existing code in the repo (empty project)
- Source files are 11 markdown files in `~/.claude/commands/forge/` (~54KB total)
- All files follow a consistent structure: `# title`, `## Input`, `## Process` (numbered steps), `## Rules`, `## Meta`
- All files that accept arguments use `$ARGUMENTS` placeholder
- The `## Meta` footer is identical across all 11 files

## Content requiring scrubbing

### Project-specific (must replace)
- **verify.md lines 41-60**: Step 2.5 "Playwright visual smoke test" — references OpenLayers coordinate order, timeCompression values, SIDE_COLOR enum, conda env, `npm run standalone`, localhost:3000/3001, "scenarios, map layers, UI controls, unit rendering, toolbar changes." This entire section is specific to one project.

### Language-specific defaults (should generalize)
- **build.md line 138**: `Ensure .gitignore excludes __pycache__/, *.pyc, and *.egg-info/` — Python-specific. Should say "language-appropriate build artifacts."
- **decompose.md lines 103-108**: Default `.gitignore` template lists `__pycache__/`, `*.pyc`, `*.egg-info/`, `.pytest_cache/` — Python-only. Should be a multi-language example or generic.

### Examples using pytest (keep as-is)
- plan.md, verify.md, loop.md all use pytest as *example* commands in template text (e.g., `[e.g., pytest tests/test_auth.py]`). These are clearly illustrative, not assumptions. Keep them — they work regardless of what test framework the user actually uses.

## Key technical decisions needed
1. What to replace verify.md's Step 2.5 with — delete entirely, or replace with a generic visual testing pattern?
2. Whether the Meta footer should be reworded for external users who aren't the command author.
3. What the default .gitignore template in decompose.md should look like for a language-agnostic audience.

## Risks and unknowns
- Risk: scrubbing too aggressively could remove useful patterns (e.g., the Playwright section demonstrates a valuable verification technique)
- Risk: scrubbing too lightly could leave confusing references for users who don't use OpenLayers
