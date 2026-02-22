# Forge State
## Project: forge-commands
## Last updated: 2026-02-22
## Phase: DECOMPOSED

### Components
| # | Component | Status | Plan | Notes |
|---|-----------|--------|------|-------|
| 01 | command-files | building (1/2 sections complete) | command-files-PLAN.md | 2 sections: copy + scrub |
| 02 | install-mechanism | spec-ready | — | install.sh, uninstall.sh, template |
| 03 | sample-artifacts | spec-ready | — | Annotated example .forge/ directory |
| 04 | documentation | spec-ready | — | README + 4 guides + CHANGELOG |

### Build order
1. command-files (no dependencies)
2. install-mechanism (depends on #1)
3. sample-artifacts (depends on #1) — can build in parallel with #2
4. documentation (depends on #1, #2, #3)
