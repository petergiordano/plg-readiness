# PLG Readiness Diagnostic

## What This Is

An interactive single-file web diagnostic (`index.html`, no build step) that helps B2B SaaS founders pick the right go-to-market motion — Pure PLG, Product-Led Sales, Sales-Led, or Wedge. Six questions, one recommendation, reasoning shown. As of v1.0 the visual identity is **swappable per client** via a CSS-variable theme contract: changing one override block re-skins the whole app, no markup edits.

## Core Value

The premise: founders treat product-led growth as a strategic choice, but it isn't. The shape of a sales model is downstream of the problem the founder chose to solve. A problem an individual practitioner can feel, evaluate, and adopt on their own pulls toward PLG. A problem that only a C-suite committee can recognize, with enterprise-wide scope, pulls toward sales — no matter how elegant the product. The tool stops the guessing and replaces "we want to be product-led" with a clear-eyed read of whether the problem they picked will let them.

## Target Users

- B2B SaaS founders evaluating GTM motion for an early-stage product
- Operators and advisors helping founders pick a motion (advisors, accelerator program leaders, accelerator faculty)
- Pete's advisory + workshop clientele across Overdrive, Alchemist, UC Berkeley SkyDeck / L2L, Scale VP

## Current State

**Shipped:** v1.0 Rebrand + Multi-Client Theming (2026-05-17). 3 phases, 9 plans, 17 tasks, +11,528 / −102 LOC. `index.html` diff: +190 / −68. Default identity is Overdrive (orange-on-warm-off-white, Space Grotesk + Plus Jakarta Sans + JetBrains Mono); a working Alchemist stub theme demonstrates the override mechanism via `?client=alchemist`.

**Tech stack:** single `index.html`, Tailwind CSS (CDN, configured via inline JS to consume CSS vars), Google Fonts (single combined `<link>`), inline JS for FOUC theme application + quiz state + scoring. No build step, no package manager.

**Known carry-forward:** Overdrive-internal contrast/cosmetic warnings WR-02..06 logged in `.planning/milestones/v1.0-phases/`-equivalent Phase-2 `02-REVIEW.md` — deferred as not-D-02-violations + not-second-theme-frankenstein-risks. Candidates for a future polish phase.

## Next Milestone Goals

To be scoped via `/gsd-new-milestone`. Likely candidates pulled from carry-forward and natural extensions:

- Real client theme(s) — Alchemist beyond stub, UC Berkeley SkyDeck, Scale VP — sourced from each client's brand specs (requires brand spec ingestion as a separate data task per EXCL-real-client-themes)
- WR-02..06 polish pass (Overdrive-internal contrast/cosmetic)
- Theme-switch UX surface — runtime toggle vs URL-only (currently URL-only per Phase 3 D-04)
- Theme registry / docs surface so non-engineers can add a client theme without touching `index.html` directly

## Requirements

### Validated (shipped)

- ✓ REQ-build-theming-architecture — v1.0 Phase 1. Single `:root` block with 23 brandable tokens, FOUC `<script>`, Tailwind utilities resolving through CSS vars, zero raw hex in markup.
- ✓ REQ-overdrive-default-theme — v1.0 Phase 2. Default identity is Overdrive end-to-end across 6 slides + results + reference matrix; dark hero retired; Space Grotesk replaces Fraunces; `calculateScore()` byte-identical (V-9 scoring regression PASS).
- ✓ REQ-stub-second-theme — v1.0 Phase 3. `[data-theme="alchemist"]` override block + IBM Plex Serif via combined Google Fonts `<link>`; three D-04 VALIDATION rigs PASS via Chrome MCP + prime UAT + coach D-NN audit.

### Active

_None yet. Run `/gsd-new-milestone` to scope v1.1._

## Constraints

Project-wide architectural rules. These govern how this product is built from now on, not just any single milestone. Any future work — features, themes, content — must respect them.

### Single-file, no build step

The app stays a single `index.html` served as a static file. Theming and feature work must operate inside `index.html` + CDN dependencies only. No bundler, no package manager, no compilation. (Source: REQ-single-file-no-build)

### No dark backgrounds

The dark results hero (`#0F172A`) is dropped. Contrast is carried by orange-as-structure (divider bars, orange-backed callouts) on warm off-white. Deliberate deviation from Overdrive's "dark sections for rhythm" guidance — applies to all future client themes too. (Source: REQ-no-dark-backgrounds)

### Theme contract = CSS custom properties

Every brandable token (`--accent`, `--accent-hover`, `--surface`, `--text`, `--font-display`, `--font-body`, etc.) is defined in a single `:root` block. A client theme is a small override block applied via `data-theme="<client>"` on `<html>` (URL `?client=` switch sets it before paint via the FOUC script). (Source: REQ-theme-contract-css-vars)

### Tailwind utilities resolve through CSS vars

The inline Tailwind config points at CSS vars (e.g. `accent: 'var(--accent)'`) so utility classes resolve per-theme. Markup references tokens only — never raw hex. (Source: REQ-tailwind-points-at-vars)

### Structure / skin separation

All brand tokens live in one place at the top of the file. This is the load-bearing rule that prevents a "frankenstein" half-old / half-new state on every future client theme. (Source: REQ-structure-skin-separation)

### Theming is visual only

The theming layer is visual. Scoring logic, quiz flow, and copy are shared across all clients. `calculateScore()`, the six-slide structure, and the answer model are off-limits to themes. (Source: REQ-theming-visual-only)

### Cascade-fallback for unknown themes

`:root` IS the default Overdrive theme. There is no placeholder `[data-theme="overdrive"]` block. Unknown `?client=` slugs silently fall through to `:root` defaults. (Source: v1.0 Phase 1 D-15)

### Single combined Google Fonts `<link>`

Every theme that adds a font extends the existing single combined `<link>` rather than adding a second `<link>` tag. (Source: v1.0 Phase 1 D-16)

## Key Decisions

Decisions made during milestone work that shape future phases. Outcomes: ✓ Good, ⚠️ Revisit, — Pending.

| Decision | Milestone | Outcome |
|----------|-----------|---------|
| `:root` IS the Overdrive default (no placeholder `[data-theme="overdrive"]` block) — unknown slugs fall through | v1.0 Phase 1 D-02 + D-15 | ✓ Good — clean fallback, no empty-rule-block bugs |
| Slate naming preserved in markup; semantic-neutral CSS-var slug (`--neutral-*-rgb`); translation in Tailwind config only | v1.0 Phase 1 D-07 | ✓ Good — ~80 markup `slate-*` usages untouched |
| `<head>` ordering: FOUC → token `<style>` → CDN → inline config → fonts → component `<style>` | v1.0 Phase 1 (corrected via 00a6b21 after V-4 catch) | ✓ Good — runtime-verified after V-4 ReferenceError caught |
| Single combined Google Fonts `<link>` per project, extended with `&family=` per theme | v1.0 Phase 1 D-16 | ✓ Good — kept through Phase 3 (IBM Plex Serif added cleanly) |
| Theme switch is URL-load only (`?client=<slug>` via FOUC script); runtime `setAttribute('data-theme', X)` toggle NOT validated | v1.0 Phase 3 D-04 | — Pending — adequate for v1.0 stub; revisit if runtime toggle becomes a real use case |
| Alchemist token values are deliberately placeholder/synthetic (no real brand specs sourced) | v1.0 Phase 3 D-01 | ✓ Good — honored EXCL-real-client-themes; real specs are a future data task |
| Deferred WR-02..06 (Overdrive-internal contrast/cosmetic) | v1.0 Phase 3 context scout | — Pending — candidates for a future polish phase |

## Out of Scope

Explicitly deferred. Do not pull into phase scope without an explicit re-scope decision.

- **Real per-client themes for every client** — needs each client's brand specs as separate data tasks. Only one stub second theme proved the system in v1.0. (EXCL-real-client-themes)
- **Per-client copy / content variation** — theming is visual only; copy stays shared across clients. (EXCL-per-client-copy)
- **Any change to scoring logic or quiz flow** — the rebrand is a skin change. `calculateScore()`, slide structure, the answer model, and result text are not in scope. (EXCL-scoring-or-flow-changes)

## Reference

- Target design system: `docs/design/design-system-alpha-overdrive.md`
- Current architecture detail: `HOW_IT_WORKS.md`
- Source PRD for v1.0: `plan.md`
- Codebase intel (read-only): `.planning/codebase/`
- Shipped milestones: `.planning/milestones/`
- Project retrospective: `.planning/RETROSPECTIVE.md`

---

*Last updated: 2026-05-17 after v1.0 milestone close.*
