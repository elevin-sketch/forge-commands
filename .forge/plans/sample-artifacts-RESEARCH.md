# Research: Sample Artifacts

## Existing patterns discovered
- Artifact format templates are embedded in the command files (decompose.md, plan.md, build.md, verify.md)
- `templates/` directory already exists with `forge-learnings.md` (from install-mechanism component)
- STATE.md format: table with #, Component, Status, Plan, Notes columns
- AGENTS.md format: header + `---` separator + entries as `### [date] — [category]` blocks
- Spec format: Status, Dependencies, Complexity headers + What/Acceptance/Decisions/Integration sections
- Plan format: Status, Created, Estimated sections + section blocks with Goal/Files/Tests/Acceptance check/Size
- Build log format: section entries with Files created/modified, Tests, Deviations, Commit
- Verify format: truth table + Results table + Issues found + Gaps discovered + Recommendation

## Decisions made (auto mode)
1. **Example project**: "Bookmark API" — simple enough to understand instantly, rich enough to show multiple components (database, API routes, auth, frontend). Rationale: more universal than "task manager" (overused in tutorials), more concrete than "blog engine."
2. **Annotation style**: Markdown comments using `<!-- ... -->` for format explanations, keeping the files readable as realistic examples when the comments are ignored. Rationale: plaintext annotations would break the illusion of a real project; HTML comments are invisible in rendered markdown but visible when reading the raw file.
3. **Lifecycle stages to show**: database (verified), api-routes (building 3/5), auth (planned), frontend (spec-ready). Rationale: covers all major statuses, shows a realistic mid-project snapshot.
4. **Number of files**: 8 total matching the spec's acceptance criteria exactly.
