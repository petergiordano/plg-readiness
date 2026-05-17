# ROADMAP — PLG Readiness Diagnostic

## Milestones

- ✅ **v1.0 Rebrand + Multi-Client Theming** — Phases 1–3 (shipped 2026-05-17). Full detail: [`milestones/v1.0-ROADMAP.md`](milestones/v1.0-ROADMAP.md).
- 📋 **v1.1** — to be scoped via `/gsd-new-milestone`.

## Phases

<details>
<summary>✅ v1.0 Rebrand + Multi-Client Theming (Phases 1–3) — SHIPPED 2026-05-17</summary>

- [x] Phase 1: Theming Architecture Foundation (1/1 plans) — completed 2026-05-15
- [x] Phase 2: Overdrive Default Theme Migration (6/6 plans) — verified 2026-05-16
- [x] Phase 3: Second Theme Stub & Pluggability Proof (2/2 plans) — verified 2026-05-17

Full phase details and success criteria in [`milestones/v1.0-ROADMAP.md`](milestones/v1.0-ROADMAP.md).

</details>

_No active or planned phases yet. Run `/gsd-new-milestone` to scope v1.1._

## Progress

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 1. Theming Architecture Foundation | v1.0 | 1/1 | Complete | 2026-05-15 |
| 2. Overdrive Default Theme Migration | v1.0 | 6/6 | Verified | 2026-05-16 |
| 3. Second Theme Stub & Pluggability Proof | v1.0 | 2/2 | Verified | 2026-05-17 |

## Project-Wide Constraints

Architectural rules that govern every phase. Full text in `PROJECT.md` under "Constraints":

- REQ-single-file-no-build — stay single-file, no build step
- REQ-no-dark-backgrounds — no dark backgrounds, orange-as-structure on warm off-white
- REQ-theme-contract-css-vars — theme contract = CSS custom properties
- REQ-tailwind-points-at-vars — Tailwind utilities resolve through CSS vars
- REQ-structure-skin-separation — all brand tokens at top of file, in one place
- REQ-theming-visual-only — scoring logic and copy are shared, not themed

## Out of Scope (carried from `PROJECT.md`)

- EXCL-real-client-themes — building real themes for every client (needs brand specs as separate data tasks)
- EXCL-per-client-copy — per-client copy / content variation; theming is visual only
- EXCL-scoring-or-flow-changes — no changes to `calculateScore()`, slide structure, or answer model
