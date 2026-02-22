# Plan: Command Files
## Status: DRAFT
## Created: 2026-02-22
## Estimated sections: 2

### Overview
Copy all 11 forge command markdown files from `~/.claude/commands/forge/` into the repo at `commands/forge/`, then make targeted edits to scrub project-specific content and generalize language-specific assumptions. The Meta footer stays as-is. Pytest references used as illustrative examples stay as-is.

### Prerequisites
- Source files exist at `~/.claude/commands/forge/` (11 .md files)
- Repo directory exists at `the project root/`

---

### Section 1: Copy all command files
**Goal:** Get all 11 command files into the repo at `commands/forge/`
**Files to create:**
- `commands/forge/build.md` — copied from source
- `commands/forge/plan.md` — copied from source
- `commands/forge/decompose.md` — copied from source
- `commands/forge/loop.md` — copied from source
- `commands/forge/quick.md` — copied from source
- `commands/forge/verify.md` — copied from source
- `commands/forge/evolve.md` — copied from source
- `commands/forge/reflect.md` — copied from source
- `commands/forge/reset.md` — copied from source
- `commands/forge/status.md` — copied from source
- `commands/forge/learn.md` — copied from source
**Tests to write:**
- Verify all 11 files exist and are non-empty
- Verify each file has the expected structure markers: `## Input` or `## Process`, `## Rules`, `## Meta`
- Verify `$ARGUMENTS` is present in every file that uses it
**Acceptance check:** `ls commands/forge/*.md | wc -l` returns 11 AND `grep -l '## Meta' commands/forge/*.md | wc -l` returns 11
**Estimated size:** small (file copy, no edits)

---

### Section 2: Scrub and generalize
**Goal:** Remove project-specific content and generalize language assumptions across 3 files
**Files to modify:**
- `commands/forge/verify.md` — Replace Step 2.5 Playwright section (lines 41-60) with a generic UI smoke test pattern. Remove OpenLayers, SIDE_COLOR, timeCompression references. Keep the concept (visual verification for UI-facing components) but make it tool/framework agnostic.
- `commands/forge/build.md` — Generalize line 138 from Python-specific `.gitignore` to "Ensure `.gitignore` excludes language-appropriate build artifacts (e.g., `__pycache__/` for Python, `node_modules/` for Node, `target/` for Rust)."
- `commands/forge/decompose.md` — Replace the Python-only default `.gitignore` template (lines 103-108) with a multi-language example showing Python, Node, and general patterns with comments.
**Tests to write:**
- Verify no occurrences of "OpenLayers", "SIDE_COLOR", "timeCompression", "conda env", "npm run standalone" remain
- Verify "Playwright" only appears in generic context (not referencing a specific project setup)
- Verify Python-specific `.gitignore` content in build.md is generalized
- Verify decompose.md `.gitignore` template includes multiple language examples
**Acceptance check:** `grep -ri 'openlayers\|SIDE_COLOR\|timeCompression\|conda env\|npm run standalone' commands/forge/*.md` returns no results AND `grep -c 'language-appropriate\|node_modules\|target/' commands/forge/build.md` returns at least 1
**Estimated size:** small (targeted edits in 3 files)

---

### Verification checklist
When all sections are complete, these conditions must be true:
- [ ] All 11 command files exist in `commands/forge/` and are valid markdown
- [ ] No references to OpenLayers, Playwright (project-specific), SIDE_COLOR, or timeCompression remain
- [ ] No Python-specific assumptions — `.gitignore` entries generalized
- [ ] Every command file retains its full structure: title, Process, Rules, Meta sections
- [ ] `$ARGUMENTS` placeholder preserved in every command that uses it
- [ ] Meta footer unchanged across all 11 files
