<!--
  STATE.md — The project status tracker.
  Created by /forge:decompose, updated by every subsequent forge command.
  This is the single source of truth for where each component stands.
-->

# Forge State
## Project: bookmark-api
## Last updated: 2026-02-20
## Phase: BUILDING

<!--
  Status values follow the lifecycle:
  spec-ready → planned → building (N/M sections) → built → verified

  The "Plan" column links to the plan file once /forge:plan has run.
  "Notes" captures anything useful at a glance.
-->

### Components
| # | Component | Status | Plan | Notes |
|---|-----------|--------|------|-------|
| 01 | database | verified | database-PLAN.md | 4/4 sections, all checks pass |
| 02 | api-routes | building (3/5 sections complete) | api-routes-PLAN.md | Paused at section 4 (pagination) |
| 03 | auth | planned | auth-PLAN.md | JWT approach, depends on database |
| 04 | frontend | spec-ready | — | React SPA, depends on api-routes + auth |

<!--
  Build order respects dependencies.
  Components earlier in the list must be built before those that depend on them.
-->

### Build order
1. database (no dependencies)
2. api-routes (depends on #1)
3. auth (depends on #1)
4. frontend (depends on #2, #3)
