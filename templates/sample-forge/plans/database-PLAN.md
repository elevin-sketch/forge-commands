<!--
  PLAN.md — Produced by /forge:plan (Step 3).
  The section-by-section implementation plan executed by /forge:build.
  Sections marked with ✅ have been completed.
  This is a living document — it may be updated during builds.
-->

# Plan: Database
## Status: BUILDING
## Created: 2026-02-14
## Estimated sections: 4

### Overview
Implement a SQLite persistence layer using raw SQL with a thin Python wrapper. Database file stored in `data/`. Migrations are manual SQL files applied in order. Each entity (users, bookmarks, collections) gets its own data access module.

### Prerequisites
- Python 3.11+ installed
- pytest available for testing

---

### Section 1: Schema and connection wrapper ✅ 2026-02-15
**Goal:** Database connection management and initial schema
**Files to create:**
- `src/db/connection.py` — connection wrapper with `execute()`, `fetch_one()`, `fetch_all()`
- `migrations/001_initial_schema.sql` — users, bookmarks, collections tables with foreign keys
- `src/db/migrate.py` — applies migration files in order, tracks schema_version
**Tests to write:**
- Connection wrapper opens and closes cleanly
- Migration creates all three tables
- schema_version table tracks applied migrations
**Acceptance check:** `python -m pytest tests/test_db_connection.py tests/test_migrations.py -v`
**Estimated size:** medium

---

### Section 2: User data access
**Goal:** CRUD operations for the users table
**Files to create:**
- `src/db/users.py` — create_user, get_user, update_user, delete_user
- `tests/test_users.py` — unit tests for all CRUD operations
**Tests to write:**
- Create user with valid data succeeds
- Duplicate email raises DuplicateUser error
- Delete user cascades to their bookmarks
**Acceptance check:** `python -m pytest tests/test_users.py -v`
**Estimated size:** medium

---

### Section 3: Bookmark data access
**Goal:** CRUD operations for the bookmarks table plus search
**Files to create:**
- `src/db/bookmarks.py` — create, read, update, delete, search_by_title
- `tests/test_bookmarks.py` — unit tests including search
**Tests to write:**
- Bookmark CRUD operations work
- Search is case-insensitive (uses LOWER())
- Bookmark with non-existent user_id is rejected (foreign key)
**Acceptance check:** `python -m pytest tests/test_bookmarks.py -v`
**Estimated size:** medium

---

### Section 4: Collection data access
**Goal:** CRUD for collections plus bookmark-collection membership
**Files to create:**
- `src/db/collections.py` — create, read, update, delete, add/remove bookmark
- `tests/test_collections.py` — unit tests including membership operations
**Tests to write:**
- Collection CRUD operations work
- Adding a bookmark to a collection creates the association
- Removing a collection doesn't delete the bookmarks in it
**Acceptance check:** `python -m pytest tests/test_collections.py -v`
**Estimated size:** medium

---

### Verification checklist
When all sections are complete, these conditions must be true:
- [ ] Schema creates users, bookmarks, and collections tables with proper foreign keys
- [ ] CRUD functions exist for all three entities
- [ ] Foreign key constraints are enforced
- [ ] Bookmark search by title works (case-insensitive)
- [ ] All data access functions have unit tests
- [ ] Migration system can apply schema changes incrementally
