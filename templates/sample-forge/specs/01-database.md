<!--
  Component spec — Created by /forge:decompose (Step 3).
  Each component gets a numbered spec file.
  The spec defines WHAT the component does and when it's DONE.
  HOW to build it is decided during /forge:plan.
-->

# Component: Database
## Status: VERIFIED
## Dependencies: none
## Complexity: medium

### What this component does
Provides a SQLite-backed persistence layer for the Bookmark API. Includes the database schema (users, bookmarks, collections tables), data access functions for CRUD operations, and a migration system for schema changes.

### Acceptance criteria
1. Schema creates users, bookmarks, and collections tables with proper foreign keys
2. CRUD functions exist for all three entities (create, read, update, delete)
3. Foreign key constraints are enforced (deleting a user cascades to their bookmarks)
4. Bookmark search by title works (case-insensitive)
5. All data access functions have unit tests with >90% coverage
6. Migration system can apply schema changes incrementally

<!--
  Acceptance criteria should be testable conditions, not vague goals.
  "All CRUD functions work" is too vague.
  "Deleting a user cascades to their bookmarks" is testable.
-->

### Key decisions to make during planning
- SQLite file location (project root vs. data/ directory)
- Whether to use an ORM (SQLAlchemy) or raw SQL with a thin wrapper
- Migration tool (Alembic, custom, or manual SQL files)

### Integration points
- API routes import data access functions from this component
- Auth component adds to the users table (password hashing, token fields)
- Schema must support future extension without breaking existing tables
