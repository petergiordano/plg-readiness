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

## Current Milestone: v1.1 Overdrive Light Reskin

**Goal:** Restyle the live six-question tool in Overdrive Light as the default identity, keep the v1.0 orange look as an opt-in theme, and fix the viral-question wording, with scoring unchanged.

**Target features:**
- Overdrive Light as the `:root` default: azure `#1F8EFF` as structure, `#F7F9FC` page, white surfaces, Instrument Sans body, Space Grotesk display, JetBrains Mono
- v1.0 Overdrive Alpha preserved as `?client=alpha`; Alchemist stub unchanged
- Viral question reworded: does usage create new **users** who can then be turned into customers
- Six-path scoring regression byte-identical; WCAG AA contrast on the Light tokens
- PROJECT.md, README, CLAUDE.md, and `docs/design/` updated for Light

**Source:** `docs/plans/v2-overhaul-plan.md` §10 Phase 1 and §11 decisions. The v2.0 overhaul (sales-model diagnostic, plan Phases 2–6) is the next milestone, not this one.

## Requirements

### Validated (shipped)

- ✓ REQ-build-theming-architecture — v1.0 Phase 1. Single `:root` block with 23 brandable tokens, FOUC `<script>`, Tailwind utilities resolving through CSS vars, zero raw hex in markup.
- ✓ REQ-overdrive-default-theme — v1.0 Phase 2. Default identity is Overdrive end-to-end across 6 slides + results + reference matrix; dark hero retired; Space Grotesk replaces Fraunces; `calculateScore()` byte-identical (V-9 scoring regression PASS).
- ✓ REQ-stub-second-theme — v1.0 Phase 3. `[data-theme="alchemist"]` override block + IBM Plex Serif via combined Google Fonts `<link>`; three D-04 VALIDATION rigs PASS via Chrome MCP + prime UAT + coach D-NN audit.

- ✓ v1.1 THEME-01..05, COPY-01, QA-01..03, DOCS-01 — Overdrive Light default, `?client=alpha` = v1.0 look, viral question reworded, scoring identical, AA contrast, 375px layout. Detail and verification record in `.planning/REQUIREMENTS.md`.

### Active

None until v1.1 is merged and closed; v2.0 scope lives in `docs/plans/v2-overhaul-plan.md`.

## Constraints

Project-wide architectural rules. These govern how this product is built from now on, not just any single milestone. Any future work — features, themes, content — must respect them.

### Single-file, no build step

The app stays a single `index.html` served as a static file. Theming and feature work must operate inside `index.html` + CDN dependencies only. No bundler, no package manager, no compilation. (Source: REQ-single-file-no-build)

_Scheduled change:_ from v2.0 this relaxes to a handful of static files (`index.html`, `app.js`, `questions.js`, `scoring.js`, `styles.css`), still with no build step, and Tailwind is dropped for the Overdrive Light kit CSS (`docs/plans/v2-overhaul-plan.md` §11, decisions 3–4). Both still hold for v1.1.

### No dark backgrounds

No dark section, card, footer, or hero in any theme. In the default Overdrive Light theme, contrast is carried by azure-as-structure (solid 2/4/8px rules, 4px accent rule across the top of cards, azure fills on primary actions) and the azure-tint band `#E8F2FF` on the `#F7F9FC` page. The `?client=alpha` theme keeps v1.0's orange-as-structure on warm off-white. (Source: REQ-no-dark-backgrounds; Overdrive Light guide "No dark surfaces")

### Theme contract = CSS custom properties

Every brandable token (`--accent`, `--accent-hover`, `--surface`, `--text`, `--font-display`, `--font-body`, etc.) is defined in a single `:root` block. A client theme is a small override block applied via `data-theme="<client>"` on `<html>` (URL `?client=` switch sets it before paint via the FOUC script). (Source: REQ-theme-contract-css-vars)

### Tailwind utilities resolve through CSS vars

The inline Tailwind config points at CSS vars (e.g. `accent: 'var(--accent)'`) so utility classes resolve per-theme. Markup references tokens only — never raw hex. (Source: REQ-tailwind-points-at-vars)

### Structure / skin separation

All brand tokens live in one place at the top of the file. This is the load-bearing rule that prevents a "frankenstein" half-old / half-new state on every future client theme. (Source: REQ-structure-skin-separation)

### Theming is visual only

The theming layer is visual. Scoring logic, quiz flow, and copy are shared across all clients. `calculateScore()`, the six-slide structure, and the answer model are off-limits to themes. (Source: REQ-theming-visual-only)

### Cascade-fallback for unknown themes

`:root` IS the default theme (Overdrive Light from v1.1; Overdrive Alpha before). There is no placeholder `[data-theme="overdrive"]` block. Unknown `?client=` slugs silently fall through to `:root` defaults. (Source: v1.0 Phase 1 D-15)

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
| Deferred WR-02..06 (Overdrive-internal contrast/cosmetic) | v1.0 Phase 3 context scout | ✓ Closed in v1.1 for Light (fixed or not applicable); alpha keeps v1.0 behaviour by design |
| Theme-specific layout goes through structure tokens; a `v1.0 STRUCTURE` block resets them for alpha + alchemist | v1.1 | ✓ Good — fingerprints prove both themes unchanged |
| Primary buttons fill with Azure Ink `#0C6FD1`, not Signal Azure (white on `#1F8EFF` is 3.3:1) | v1.1 | ✓ Good — AA; deviation recorded in `docs/design/README.md` |

## Out of Scope

Explicitly deferred. Do not pull into phase scope without an explicit re-scope decision.

- **Real per-client themes for every client** — needs each client's brand specs as separate data tasks. Only one stub second theme proved the system in v1.0. (EXCL-real-client-themes)
- **Per-client copy / content variation** — theming is visual only; copy stays shared across clients. (EXCL-per-client-copy)
- **Any change to scoring logic or quiz flow** — the rebrand is a skin change. `calculateScore()`, slide structure, the answer model, and result text are not in scope. One exception in v1.1: COPY-01 rewords the viral question and its option labels; answer values and scoring stay identical. The v2.0 overhaul lifts this exclusion by explicit re-scope. (EXCL-scoring-or-flow-changes)

## Reference

- Target design system (v1.1+): Overdrive Light, `~/.claude/identity/overdrive-light-design-system.md` (Drive master `@APG1-Identity Stack/overdrive-light-design-system.md`); kit `~/.claude/skills/overdrive-light-design-system/`
- v1.0 design system (now the `?client=alpha` theme): `docs/design/design-system-alpha-overdrive.md`
- v2 overhaul plan and locked decisions: `docs/plans/v2-overhaul-plan.md`
- Current architecture detail: `HOW_IT_WORKS.md`
- Source PRD for v1.0: `plan.md`
- Codebase intel (read-only): `.planning/codebase/`
- Shipped milestones: `.planning/milestones/`
- Project retrospective: `.planning/RETROSPECTIVE.md`

---

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

*Last updated: 2026-10-19 at v1.1 milestone start.*
