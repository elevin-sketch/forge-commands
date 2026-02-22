<!--
  AGENTS.md — Project-specific institutional memory.
  Created by /forge:decompose, appended to by /forge:build, /forge:learn, /forge:verify.
  Every forge command reads this file before starting work.

  Entries are categorized as: gotcha, convention, decision, or tool-tip.
  Each entry should be self-contained and actionable.
-->

# Forge Learnings
Discoveries, gotchas, and conventions recorded during this project.
Each entry helps future commands avoid repeating mistakes.

---

### 2026-02-15 — gotcha
**Context:** Building database migrations (section 2)
**Learning:** SQLite doesn't enforce foreign key constraints by default. Must run `PRAGMA foreign_keys = ON;` at connection time or tests will silently pass with broken references.
**Source:** Failed integration test — bookmarks with non-existent user_id were accepted.

---

### 2026-02-16 — convention
**Context:** Established during api-routes section 1
**Learning:** All API endpoints return `{ "data": ..., "error": null }` envelope format. Error responses use `{ "data": null, "error": { "code": "NOT_FOUND", "message": "..." } }`. Keep this consistent across all routes.
**Source:** User preference during /forge:plan interview.

---

### 2026-02-17 — decision
**Context:** Auth component planning
**Learning:** Using JWT with short-lived access tokens (15 min) and refresh tokens (7 days). Tokens stored in httpOnly cookies, not localStorage. This was chosen over session-based auth for API-first design.
**Source:** /forge:plan auth — user decision.

---

### 2026-02-18 — tool-tip
**Context:** Running acceptance checks
**Learning:** Use `python -m pytest --tb=short -q` for cleaner output during builds. The `--tb=short` flag shows just the relevant traceback line instead of the full stack, which is easier to scan when running section-by-section.
**Source:** Discovered during database build, section 3.

---

### 2026-02-19 — gotcha
**Context:** api-routes section 3 (search endpoint)
**Learning:** SQLite's `LIKE` operator is case-insensitive by default for ASCII but not for Unicode. For consistent search behavior, use `LOWER()` explicitly: `WHERE LOWER(title) LIKE LOWER(?)`.
**Source:** Test failure — search for "café" didn't match "Café".
