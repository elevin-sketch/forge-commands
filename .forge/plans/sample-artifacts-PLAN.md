# Plan: Sample Artifacts
## Status: DRAFT
## Created: 2026-02-22
## Estimated sections: 3

### Overview
Create 8 annotated sample files in `templates/sample-forge/` using a "Bookmark API" example project. Files use HTML comments for format annotations so they read as realistic examples when rendered. The example shows 4 components at different lifecycle stages: database (verified), api-routes (building), auth (planned), frontend (spec-ready).

### Prerequisites
- Component #1 (command-files) must be built — artifact formats are defined there

---

### Section 1: State and learnings files ✅ 2026-02-22
**Goal:** Create the top-level project state files that establish the example project context
**Files to create:**
- `templates/sample-forge/STATE.md` — 4 components at different statuses with build order
- `templates/sample-forge/AGENTS.md` — 4-5 entries across gotcha, convention, decision, tool-tip categories
**Tests to write:**
- STATE.md contains a table with 4 components at different statuses
- AGENTS.md contains at least 4 entries with different category types
- Both files contain `<!-- ... -->` annotation comments
**Acceptance check:** `grep -c '|' templates/sample-forge/STATE.md | test $(cat) -ge 6 && grep -c '###' templates/sample-forge/AGENTS.md | test $(cat) -ge 4 && echo PASS`
**Estimated size:** small (~60 lines each)

---

### Section 2: Spec files ✅ 2026-02-22
**Goal:** Create the component overview and an example component spec
**Files to create:**
- `templates/sample-forge/specs/OVERVIEW.md` — dependency diagram (ASCII) + build order for the 4 Bookmark API components
- `templates/sample-forge/specs/01-database.md` — fully fleshed-out spec for the database component (the "verified" one, so it shows what a complete spec looks like)
**Tests to write:**
- OVERVIEW.md contains a diagram and build order section
- 01-database.md contains all required spec sections (Status, Dependencies, Complexity, What, Acceptance, Decisions, Integration)
- Component names match STATE.md
**Acceptance check:** `grep -q 'Build order\|build order' templates/sample-forge/specs/OVERVIEW.md && grep -q 'Acceptance criteria' templates/sample-forge/specs/01-database.md && echo PASS`
**Estimated size:** small (~40 lines each)

---

### Section 3: Plan artifacts (RESEARCH, PLAN, BUILD-LOG, VERIFY) ✅ 2026-02-22
**Goal:** Create the planning/build/verify artifacts for the database component
**Files to create:**
- `templates/sample-forge/plans/database-RESEARCH.md` — discovered patterns and technical decisions for the database component
- `templates/sample-forge/plans/database-PLAN.md` — 4 sections, section 1 marked ✅, sections 2-4 incomplete
- `templates/sample-forge/plans/database-BUILD-LOG.md` — 2 completed section entries with commit hashes, file lists, test results
- `templates/sample-forge/plans/database-VERIFY.md` — verification report with 5 conditions: 3 passing, 1 failing, 1 partial
**Tests to write:**
- PLAN.md contains at least 4 section headers and one ✅ marker
- BUILD-LOG.md contains at least 2 section entries
- VERIFY.md contains a results table with mixed ✅/❌/⚠️ results
- All files reference "database" component consistently
**Acceptance check:** `grep -c '### Section' templates/sample-forge/plans/database-PLAN.md | test $(cat) -ge 4 && grep -c '### Section' templates/sample-forge/plans/database-BUILD-LOG.md | test $(cat) -ge 2 && grep -q '❌\|⚠️' templates/sample-forge/plans/database-VERIFY.md && echo PASS`
**Estimated size:** medium (~200 lines total across 4 files)

---

### Verification checklist
When all sections are complete, these conditions must be true:
- [ ] STATE.md shows 4 components at different statuses (spec-ready, planned, building, verified)
- [ ] AGENTS.md shows 4-5 entries across category types
- [ ] OVERVIEW.md includes a dependency diagram and build order
- [ ] 01-database.md shows a fully fleshed-out component spec
- [ ] database-RESEARCH.md shows discovered patterns and technical decisions
- [ ] database-PLAN.md shows 4 sections with one marked complete
- [ ] database-BUILD-LOG.md shows 2 completed section entries
- [ ] database-VERIFY.md shows a verification report with mixed results
- [ ] All files are internally consistent (same component names, cross-references work)
- [ ] Each file includes annotation comments explaining the format
