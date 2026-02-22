<!--
  OVERVIEW.md — Component dependency map and build order.
  Created by /forge:decompose (Step 2).
  Shows how all components relate to each other and the recommended build sequence.
-->

# Bookmark API — Component Overview

## Components

### 1. Database
SQLite-backed persistence layer with schema, models, and migrations.
- Depends on: nothing
- Produces: Database access functions, schema
- Complexity: **medium**

### 2. API Routes
RESTful endpoints for CRUD operations on bookmarks and collections.
- Depends on: database
- Produces: HTTP API (Express/Fastify)
- Complexity: **large**

### 3. Auth
JWT-based authentication with access/refresh token flow.
- Depends on: database (user table)
- Produces: Auth middleware, login/register endpoints
- Complexity: **medium**

### 4. Frontend
React SPA consuming the API with bookmark management UI.
- Depends on: api-routes, auth
- Produces: Browser application
- Complexity: **large**

## Dependency Diagram

```
[1. database] ──┬──> [2. api-routes] ──┐
                │                      ├──> [4. frontend]
                └──> [3. auth] ────────┘
```

<!--
  The diagram shows that database must be built first.
  api-routes and auth can be built in parallel after database.
  frontend depends on both api-routes and auth.
-->

## Build order

1. **database** (no dependencies — build first)
2. **api-routes** (depends on database)
3. **auth** (depends on database — can build in parallel with api-routes)
4. **frontend** (depends on api-routes + auth — build last)

## Total scope assessment

Medium-large project. 4 components, estimated 15-18 plan sections total. The database and auth components are straightforward; the API routes and frontend carry most of the complexity.
