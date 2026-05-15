# Requirements

Synthesized from `.planning/intel/requirements.md` (single PRD ingest: `plan.md`). Each requirement carries a stable ID for traceability.

This file contains in-scope v1 requirements that map to roadmap phases. Project-wide architectural constraints (formerly REQ-single-file-no-build, REQ-no-dark-backgrounds, REQ-theme-contract-css-vars, REQ-tailwind-points-at-vars, REQ-structure-skin-separation, REQ-theming-visual-only) are NOT phase requirements — they govern how the project is built going forward and live in `PROJECT.md` under "Constraints."

## v1 Requirements (in-scope for this milestone)

### REQ-build-theming-architecture

- **Category:** Theming Architecture
- **Source:** `plan.md` → "Scope for this milestone"
- **Description:** Build the theming architecture: CSS-variable contract + Tailwind wiring + theme switch mechanism.
- **Acceptance criteria:**
  - A single `:root` block in `index.html` defines every brandable token (`--accent`, `--accent-hover`, `--surface`, `--text`, `--font-display`, `--font-body`, plus whatever minimum-viable set is settled in discuss-phase).
  - The inline Tailwind config resolves utility classes through those CSS vars (e.g. `accent: 'var(--accent)'`).
  - A theme switch mechanism exists and is documented (`data-theme="<client>"` and/or `?client=` URL param — exact form settled in discuss-phase).
  - No raw hex values remain in markup; only token references.

### REQ-overdrive-default-theme

- **Category:** Default Theme Migration
- **Source:** `plan.md` → "Scope for this milestone"
- **Description:** Convert the existing app to the theming architecture with Overdrive as the default theme. Replaces the current indigo / slate + Fraunces identity.
- **Acceptance criteria:**
  - Default token values (the `:root` block, no `data-theme` set) produce the Overdrive visual identity per `docs/design/design-system-alpha-overdrive.md`.
  - Display font changes from Fraunces to Space Grotesk. Body (Plus Jakarta Sans) and mono (JetBrains Mono) stay.
  - Dark results hero is removed; contrast is carried by orange-as-structure on warm off-white.
  - All six quiz slides, the results page, and reference matrix render coherently in Overdrive — no half-old / half-new state.
  - Scoring logic, slide flow, and copy are unchanged.

### REQ-stub-second-theme

- **Category:** Theme-System Proof
- **Source:** `plan.md` → "Scope for this milestone"
- **Description:** Add one stub second theme (e.g. Alchemist) to prove the theme system works end-to-end. Placeholder token values are acceptable; sourcing real client brand specs is a separate data task.
- **Acceptance criteria:**
  - A second theme block exists (override on `data-theme="<client>"`) with placeholder token values.
  - Switching the theme produces a visibly distinct, internally coherent rendering across all six slides + results + reference matrix.
  - No markup changes are required to switch — only the theme attribute / URL param.
  - Switching back to default restores Overdrive cleanly (no residual state).

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| REQ-build-theming-architecture | Phase 1 | Not started |
| REQ-overdrive-default-theme | Phase 2 | Not started |
| REQ-stub-second-theme | Phase 3 | Not started |

**Coverage:** 3/3 v1 requirements mapped ✓

## Scope Exclusions

Captured in `PROJECT.md` under "Out of scope." Re-stated here for traceability:

- **EXCL-real-client-themes** — building real themes for every client (needs brand specs as separate data tasks).
- **EXCL-per-client-copy** — per-client copy / content variation; theming is visual only.
- **EXCL-scoring-or-flow-changes** — any change to scoring logic or quiz flow.
