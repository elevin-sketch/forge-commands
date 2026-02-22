<!--
  VERIFY.md — Produced by /forge:verify.
  Goal-backward verification: instead of checking "did we complete tasks?",
  checks "are the required conditions actually true in the codebase?"

  Results use: ✅ PASS, ❌ FAIL, ⚠️ PARTIAL, ❓ CANNOT VERIFY
-->

# Verification Report: Database
## Date: 2026-02-20
## Overall: PASS WITH NOTES

### Results
| # | Condition | Check command | Result | Notes |
|---|-----------|---------------|--------|-------|
| 1 | Schema creates users, bookmarks, collections tables | `python -m pytest tests/test_migrations.py::test_tables_exist -v` | ✅ | All 3 tables + schema_version |
| 2 | CRUD functions exist for all entities | `python -m pytest tests/test_users.py tests/test_bookmarks.py tests/test_collections.py -v` | ✅ | 34 tests, all passing |
| 3 | FK constraints enforced | `python -m pytest tests/test_bookmarks.py::test_fk_constraint -v` | ✅ | Rejects invalid user_id |
| 4 | Bookmark search is case-insensitive | `python -m pytest tests/test_bookmarks.py::test_search_case_insensitive -v` | ⚠️ | Works for ASCII but fails for Unicode (café vs Café) |
| 5 | Delete user cascades to bookmarks | `python -m pytest tests/test_users.py::test_cascade_delete -v` | ✅ | Cascades correctly |

<!--
  Note condition #4: the test technically passes but with a known limitation.
  ⚠️ PARTIAL means "works in the common case but has a known edge case."
  This is an honest assessment, not a failure — it's flagged for future improvement.
-->

### Issues found

#### Critical (must fix)
- None

#### Non-critical (should fix)
- Unicode case-insensitive search: `LOWER()` doesn't handle non-ASCII characters in SQLite without the ICU extension. Workaround: normalize input before storage, or add ICU extension dependency.

### Gaps discovered
- No test for concurrent database access (multiple writers). Not critical for a single-user API but would matter if deployed with multiple workers.
- No index on `bookmarks.title` — search performance will degrade with large datasets.

### Auto-fixed during verification
- Fixed a missing `PRAGMA foreign_keys = ON` in the test fixture's connection setup (was only set in production code, not test helpers). Committed as `forge(database): verify fix — enable FK in test fixtures`.

### Recommendation
**SHIP IT** — All critical functionality works. The Unicode search limitation is a known edge case documented in AGENTS.md. The concurrency and indexing gaps are non-blocking for the current scope.
