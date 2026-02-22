# Plan: Documentation
## Status: DRAFT
## Created: 2026-02-22
## Estimated sections: 6

### Overview
Create 6 documentation files in dependency order: CONCEPTS (defines terms) → COMMANDS (reference card) → WORKFLOW (narrative walkthrough) → CUSTOMIZING (power users) → README + LICENSE (entry point, references everything) → CHANGELOG (stamps the version). All docs use headers, tables, and code blocks for scannability. Worked example in WORKFLOW is abbreviated with links to sample artifacts.

### Prerequisites
- All 3 dependency components built (command-files, install-mechanism, sample-artifacts)

---

### Section 1: CONCEPTS.md ✅ 2026-02-22
**Goal:** Define the mental model — all terms and structures used across other docs
**Files to create:**
- `docs/CONCEPTS.md` — .forge/ directory, STATE.md lifecycle, AGENTS.md, forge-learnings.md, specs/plans/build-logs chain, component dependency model
**Tests to write:**
- Contains sections for each core concept (at least 6 h2/h3 headers)
- References templates/sample-forge/ for concrete examples
- No absolute paths
**Acceptance check:** `grep -c '^##' docs/CONCEPTS.md | test $(cat) -ge 6 && grep -q 'sample-forge' docs/CONCEPTS.md && ! grep -q '/Users/' docs/CONCEPTS.md && echo PASS`
**Estimated size:** medium (~150 lines)

---

### Section 2: COMMANDS.md ✅ 2026-02-22
**Goal:** Structured reference card for all 11 commands
**Files to create:**
- `docs/COMMANDS.md` — consistent format per command: purpose, usage, arguments, produces, reads, modes, example
**Tests to write:**
- Contains exactly 11 command sections (one per command)
- Each section has at least Purpose and Usage fields
- No absolute paths
**Acceptance check:** `grep -c '^## /forge:' docs/COMMANDS.md | test $(cat) -eq 11 && ! grep -q '/Users/' docs/COMMANDS.md && echo PASS`
**Estimated size:** large (~300 lines)

---

### Section 3: WORKFLOW.md
**Goal:** Narrative guide showing how the commands connect into a complete workflow
**Files to create:**
- `docs/WORKFLOW.md` — ASCII pipeline diagram, each phase explained, abbreviated worked example, the learning loop, when NOT to use forge
**Tests to write:**
- Contains pipeline diagram (ASCII art with arrows)
- Contains worked example section
- References /forge: commands
- No absolute paths
**Acceptance check:** `grep -q '──>' docs/WORKFLOW.md && grep -q -i 'example\|walkthrough' docs/WORKFLOW.md && ! grep -q '/Users/' docs/WORKFLOW.md && echo PASS`
**Estimated size:** large (~250 lines)

---

### Section 4: CUSTOMIZING.md
**Goal:** Guide for power users who want to modify or extend the commands
**Files to create:**
- `docs/CUSTOMIZING.md` — forking, $ARGUMENTS variable, commit message format, section size thresholds, per-repo commands, Meta convention
**Tests to write:**
- Contains section about $ARGUMENTS
- Contains section about the Meta convention
- No absolute paths
**Acceptance check:** `grep -q 'ARGUMENTS' docs/CUSTOMIZING.md && grep -q 'Meta' docs/CUSTOMIZING.md && ! grep -q '/Users/' docs/CUSTOMIZING.md && echo PASS`
**Estimated size:** small (~100 lines)

---

### Section 5: README.md and LICENSE
**Goal:** The repo's front door — quick start, install, command overview, links to docs
**Files to create:**
- `README.md` — description, prerequisites, quick install, manual install, usage example, command table, docs links, uninstall, license note
- `LICENSE` — MIT license text
**Tests to write:**
- README contains install instructions referencing install.sh
- README contains a command table with all 11 commands
- README links to docs/ files
- LICENSE file exists
- No absolute paths in README
**Acceptance check:** `grep -q 'install.sh' README.md && grep -c '/forge:' README.md | test $(cat) -ge 11 && test -f LICENSE && ! grep -q '/Users/' README.md && echo PASS`
**Estimated size:** medium (README ~200 lines, LICENSE ~20 lines)

---

### Section 6: CHANGELOG.md
**Goal:** Version history starting at v1.0.0
**Files to create:**
- `CHANGELOG.md` — initial v1.0.0 entry listing all 11 commands and the install mechanism
**Tests to write:**
- Contains v1.0.0 header
- Lists all 11 command names
**Acceptance check:** `grep -q '1.0.0' CHANGELOG.md && grep -c 'forge:' CHANGELOG.md | test $(cat) -ge 11 && echo PASS`
**Estimated size:** small (~40 lines)

---

### Verification checklist
When all sections are complete, these conditions must be true:
- [ ] README.md has description, prerequisites, quick install, manual install, usage example, command table, docs links, uninstall, license
- [ ] docs/WORKFLOW.md has pipeline diagram, phase explanations, worked example, learning loop, when-not-to-use
- [ ] docs/COMMANDS.md has structured reference for all 11 commands
- [ ] docs/CONCEPTS.md has .forge/ directory, STATE.md lifecycle, AGENTS.md, forge-learnings.md, document chain, dependency model
- [ ] docs/CUSTOMIZING.md has forking guide, $ARGUMENTS, commit format, section thresholds, per-repo commands, Meta convention
- [ ] CHANGELOG.md has v1.0.0 entry with all 11 commands
- [ ] All internal links between docs resolve correctly
- [ ] No absolute paths or personal paths in any documentation
- [ ] All docs use headers, tables, and code blocks (scannable, not prose walls)
