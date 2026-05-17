# Synthesis Summary

Entry point for downstream consumers (`gsd-roadmapper`, `/gsd-discuss-phase`, etc.). Single source of truth for what was extracted from the ingest set.

## Mode

- MODE: `new`
- EXISTING_CONTEXT: none (no PROJECT.md, REQUIREMENTS.md, ROADMAP.md, or CONTEXT.md existed before this ingest; `.planning/codebase/` is read-only codebase intel from `/gsd-map-codebase` and is NOT merged context)
- PRECEDENCE: `["ADR", "SPEC", "PRD", "DOC"]` (default; no per-doc override applied)

## Doc counts by type

- ADR: 0
- SPEC: 0
- PRD: 1
- DOC: 0
- UNKNOWN: 0
- **Total: 1**

Breakdown by source:

- `plan.md` — PRD, confidence=medium, locked=false, precedence=default. Title: "Plan: Rebrand + Multi-Client Theming".

## Decisions locked

- **Count: 6** (sourced from PRD-embedded "Locked decisions" section, surfaced as `kind: locked-constraint` requirements per classifier-flagged notes; no formal ADRs in ingest set)
- Source: `plan.md`
- IDs:
  - REQ-single-file-no-build
  - REQ-no-dark-backgrounds
  - REQ-theme-contract-css-vars
  - REQ-tailwind-points-at-vars
  - REQ-structure-skin-separation
  - REQ-theming-visual-only

## Requirements extracted

- **Total: 9** (6 locked-constraint + 3 in-scope)
- In-scope IDs:
  - REQ-build-theming-architecture
  - REQ-overdrive-default-theme
  - REQ-stub-second-theme
- Locked-constraint IDs: (see "Decisions locked" above)
- Scope exclusions (not counted as requirements): 3
  - EXCL-real-client-themes
  - EXCL-per-client-copy
  - EXCL-scoring-or-flow-changes

See: `.planning/intel/requirements.md`

## Constraints

- **Count: 0**
- Type breakdown: n/a (no SPECs in ingest set)

See: `.planning/intel/constraints.md`

## Context topics

- **Count: 5**
  - Why the rebrand exists
  - Goal statement (project north star)
  - Open questions for /gsd-discuss-phase (5 questions for downstream resolution)
  - Current-state reference
  - Cross-references declared by the source PRD

See: `.planning/intel/context.md`

## Conflicts

- BLOCKERS: 0
- WARNINGS (competing-variants): 0
- INFO (auto-resolved): 2

See: `.planning/INGEST-CONFLICTS.md`

## Cycle detection

- Cross-ref graph nodes (ingest set): 1
- Cross-ref graph edges (outbound from plan.md): 4 (all to docs outside the ingest set)
- Cycles detected: 0
- Max depth traversed: 1 (well under cap of 50)

## Status

**READY** — no blockers, no competing variants requiring user resolution. Safe to route to `gsd-roadmapper` / `/gsd-discuss-phase`. Note: the 5 open questions captured in `context.md` are intentionally NOT requirements; they are queued for resolution during `/gsd-discuss-phase`.

## Pointers

- Per-type intel: `.planning/intel/requirements.md`, `.planning/intel/decisions.md`, `.planning/intel/constraints.md`, `.planning/intel/context.md`
- Conflicts report: `.planning/INGEST-CONFLICTS.md`
- Source classifications: `.planning/intel/classifications/plan-a7f3c2e1.json`
- Source documents: `plan.md`
