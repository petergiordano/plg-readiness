# Phase 1: Theming Architecture Foundation - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-15
**Phase:** 1-Theming Architecture Foundation
**Areas discussed:** Switch mechanism + selection, Brandable token scope, Slate-utility treatment, Client theme storage / DX, FOUC handling, Tailwind alpha-channel pattern, Missing-token fallback policy, Theme-specific font-loading

---

## Switch mechanism + selection

### Q1: Runtime mechanism

| Option | Description | Selected |
|--------|-------------|----------|
| `?client=` URL param | Inline JS reads `?client=` on load, sets `data-theme` on `<html>`. Same file URL, swap themes via link. | ✓ |
| `data-theme` attribute hardcoded | Edited per deployment; zero JS but requires file edit per client. | |
| Both — URL canonical, attribute is mechanism | URL is user-facing, attribute is the CSS contract. | |

### Q2: Default theme (no param)

| Option | Description | Selected |
|--------|-------------|----------|
| Overdrive | Bare URL = Overdrive. Aligns with PRD framing. | ✓ |
| Generic neutral house theme | Overdrive becomes `?client=overdrive`. | |
| Last-used (localStorage) | Stateful; surprising on shared links. | |

### Q3: Unknown `?client=` value

| Option | Description | Selected |
|--------|-------------|----------|
| Silent fallback to Overdrive | Unknown = render Overdrive. Safe by default. | ✓ |
| Silent fallback + console.warn | Logs missing theme name for developers. | |
| Visible banner | Renders Overdrive with dismissible banner. | |

**Notes:** Pete decisive across all three. URL param is the deploy/sharing story; Overdrive-as-default matches the PRD's brand framing; silent fallback preserves resilience for shared workshop links across cohorts.

---

## Brandable token scope

### Q1: Token category coverage

| Option | Description | Selected |
|--------|-------------|----------|
| Colors + typography | `--accent`, `--surface`, `--text`, `--font-display`, `--font-body`, etc. Radii/spacing/shadows shared. | ✓ |
| Colors only | Fonts stay Overdrive across all clients. | |
| Full visual surface | Colors + type + radii + spacing + shadows brandable. | |

### Q2: Token naming style

| Option | Description | Selected |
|--------|-------------|----------|
| Semantic only | Direct semantic vars (`--accent`, `--surface`). Single layer. | ✓ |
| Palette + semantic (two-layer) | Theme declares palette ramp, semantic vars map onto it. | |
| Semantic + escape hatch for unusual themes | Default semantic; clients may add palette vars if needed. | |

**Notes:** Single-layer semantic was preferred for non-engineer readability — "what color is this token?" should be answerable by reading one line. Radii/spacing classified as structural rhythm (shared invariant), not brand-variable.

---

## Slate-utility treatment

### Q1: Path for the ~101 existing `slate-*` Tailwind utility usages

| Option | Description | Selected |
|--------|-------------|----------|
| Tokenize as `--neutral-*` ramp + redirect Tailwind slate palette to it | No markup edits ever; neutrals become brandable. | ✓ |
| Leave raw, Phase 2 find/replace to warm-neutral utilities | One big rewrite at exactly the wrong moment. | |
| Hybrid: tokenize but keep some slate-* literals | Inconsistency in the contract. | |

**Notes:** This was the load-bearing fork for Phase 1's scope. Tokenize-and-redirect chosen because it (a) preserves the "no markup change in Phase 1" property, (b) makes the neutral scale brandable per client, and (c) avoids a high-risk 101-utility find/replace at the exact moment the visual identity is also flipping in Phase 2.

---

## Client theme storage / DX

### Q1: Where do client theme override blocks live in the file?

| Option | Description | Selected |
|--------|-------------|----------|
| Single `<style>` block at top with comment dividers | All themes co-located, grep-friendly. | ✓ |
| Separate `<style data-theme="client">` per client | Non-standard `<style>` attribute pattern. | |
| External `themes/<client>.css` via `<link>` | Breaks single-file constraint. | |

### Q2: How does a non-engineer find the "add a theme" recipe?

| Option | Description | Selected |
|--------|-------------|----------|
| Inline comment block at top of the `<style>` element | Lives where the work happens; can't drift. | ✓ |
| Separate `docs/THEMING.md` guide | Two sources of truth that drift. | |
| Both — inline pointer + external doc | Ceremony for a single-file app. | |

**Notes:** Single source of truth bias throughout — the recipe lives literally adjacent to the blocks it explains. Cannot get out of sync with the code.

---

## FOUC handling

### Q1: How is `?client=` applied before first paint?

| Option | Description | Selected |
|--------|-------------|----------|
| Inline blocking `<script>` at top of `<head>` | First child of `<head>`, runs before Tailwind CDN. Zero flash. | ✓ |
| Accept brief flash, run on DOMContentLoaded | Simpler; visible flash on every client load. | |
| CSS-only with build-time injected attribute | Breaks single-file. | |

**Notes:** Polish matters — the milestone exists specifically to avoid the "frankenstein" / half-baked feel. A visible theme flash on every Alchemist / Berkeley / Scale VP demo would contradict that intent immediately.

---

## Tailwind alpha-channel pattern

### Q1: How are color tokens declared so opacity modifiers work?

| Option | Description | Selected |
|--------|-------------|----------|
| RGB-channel vars + `<alpha-value>` placeholder | `--accent-rgb: 243 94 31`; Tailwind config: `rgb(var(--accent-rgb) / <alpha-value>)`. | ✓ |
| Hex vars, no alpha modifier support | `bg-accent/10` silently breaks. Phase 2 landmine. | |
| Both — hex for humans + derived RGB | Needs build step. | |

**Notes:** Identified as the "most easily missed load-bearing detail" — without it, every existing opacity utility in the codebase silently breaks at Phase 2 migration. The trade-off (less-readable channel triplet vs. fully-working contract) is the right one.

---

## Missing-token fallback policy

### Q1: Behavior when a client theme omits a token

| Option | Description | Selected |
|--------|-------------|----------|
| Cascade from `:root` defaults, no validation | Forgiving by design; incomplete themes render coherently. | ✓ |
| Cascade + dev-mode console.warn | Catches typos but introduces JS-side source of truth that drifts. | |
| Strict: JS-enforced complete token coverage | Heavy ceremony; contradicts non-engineer-friendly goal. | |

**Notes:** Forgiving cascade is consistent with the non-engineer-ergonomics theme. CSS-var cascade is built-in browser behavior — zero implementation cost, zero drift risk.

---

## Theme-specific font-loading

### Q1: Pattern for loading theme-specific display fonts

| Option | Description | Selected |
|--------|-------------|----------|
| Preload all theme fonts in `<head>` | One Google Fonts `<link>` grows per client; zero FOUT. | ✓ |
| Lazy-load per active theme via JS | Brief FOUT per switch; more code. | |
| Defer to Phase 2 | Leaves an implicit decision; better to lock pattern now. | |

**Notes:** Preload chosen for simplicity and zero font-flash on switch. Trade-off (head grows ~few KB per client) accepted because client count is bounded (5-10 over the foreseeable timeline) and single-file ergonomics are the meta-goal.

---

## Claude's Discretion

- Exact 5-6 line contents of the inline FOUC `<script>` (param parse + `setAttribute`). Standard pattern, no Pete-facing decision.
- Slug-by-slug token list inside `:root` defaults — planner derives from `docs/design/design-system-alpha-overdrive.md` and the existing inline Tailwind slate palette in `index.html`. The categories and naming style are locked; the specific slugs are not.
- Ordering of theme blocks inside the `<style>` element (Overdrive first as default, then any others).
- Phase 3 stub theme naming (`alchemist` placeholder or otherwise) — Phase 3 detail, not Phase 1.

## Deferred Ideas

(Captured at length in `01-CONTEXT.md` `<deferred>` section. Summary here for log completeness.)

- localStorage-based persistence — rejected (stateful behavior on a static app)
- Per-theme dark-mode / media-query variants — out of scope per project-wide constraint
- Build-time per-client deploys — rejected (breaks single-file)
- Strict missing-token JS validation — rejected (ergonomics)
- Console.warn on missing tokens — rejected (drift risk)
- Lazy per-theme font-loading — rejected (premature optimization)
- Tailwind plugin / build-time theming — rejected (no build step)
- External `docs/THEMING.md` — rejected (single source of truth bias)
- Two-layer palette-plus-semantic token system — rejected (readability)
- Visible "theme not found" banner — rejected (shared-link resilience)
