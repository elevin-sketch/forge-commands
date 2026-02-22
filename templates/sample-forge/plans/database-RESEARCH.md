<!--
  RESEARCH.md — Produced by /forge:plan (Step 1).
  Documents what was discovered about the codebase before writing the plan.
  In auto mode, also records decisions made and their rationale.
-->

# Research: Database

## Existing patterns discovered
- Test framework: pytest with fixtures in conftest.py
- Import convention: absolute imports (`from bookmark_api.db import ...`)
- Error handling: custom exceptions (BookmarkNotFound, DuplicateUser)
- Relevant existing code: None — this is the first component to be built

## Key technical decisions needed
- Use SQLAlchemy ORM or raw SQL with a thin wrapper?
- Store SQLite file in project root or data/ directory?
- Use Alembic for migrations or a simpler custom approach?

## Decisions made
- **Raw SQL with thin wrapper** — rationale: project is small, ORM adds complexity without clear benefit. Wrapper provides `execute()`, `fetch_one()`, `fetch_all()` with automatic connection management.
- **data/ directory** — rationale: keeps database file out of project root clutter, easy to .gitignore.
- **Manual SQL migration files** — rationale: Alembic is overkill for 3 tables. Numbered SQL files in `migrations/` applied in order. A `schema_version` table tracks which have been applied.
