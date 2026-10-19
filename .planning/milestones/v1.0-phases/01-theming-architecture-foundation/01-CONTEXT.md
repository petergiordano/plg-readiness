# Phase 1: Theming Architecture Foundation - Context

**Gathered:** 2026-05-15
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 1 builds the theming contract inside `index.html` — a single `<style>` element near the top of `<head>` containing `:root` defaults + every client theme override block, a runtime switch driven by `?client=` URL param, and Tailwind config that resolves all utilities through CSS custom properties.

At the end of Phase 1, the app still renders its current indigo / slate / Fraunces identity with **no visual regressions** when no theme override is set. The contract is complete and proven; visual migration to Overdrive happens in Phase 2. This deliberate ordering is the load-bearing safety against the "frankenstein" state the milestone exists to prevent.

In scope: token contract structure, Tailwind→vars wiring, switch mechanism, FOUC handling, slate-utility tokenization, alpha-channel pattern, missing-token policy, font-loading pattern.

Out of scope: any change to the visible identity (Phase 2), real client themes beyond the stub (Phase 3 + ongoing milestones), scoring logic or quiz flow (REQ-theming-visual-only).

</domain>

<decisions>
## Implementation Decisions

### Theme switch mechanism
- **D-01:** Canonical runtime switch is `?client=<slug>` URL param. An inline blocking `<script>` at the top of `<head>` (before the Tailwind CDN `<script>`) reads `location.search`, parses the param, and synchronously sets `document.documentElement.setAttribute('data-theme', slug)`. CSS only ever keys on `[data-theme="..."]`.
- **D-02:** Default render (no `?client=` param) is **Overdrive**. Bare URL = Overdrive brand.
- **D-03:** Unknown `?client=` value (typo, deleted theme) silently falls back to Overdrive. No banner, no console warning. Safe-by-default for shared workshop links.

### Brandable token scope
- **D-04:** Brandable surface is **colors + typography only**. Radii, spacing, shadows stay shared across all clients (structural rhythm, not brand-variable).
- **D-05:** Tokens are **semantic, single-layer** — `--accent`, `--accent-hover`, `--surface`, `--surface-elev`, `--text`, `--text-muted`, `--border`, `--font-display`, `--font-body`, `--font-mono` (plus the `--neutral-*` scale from D-07). No two-layer palette-plus-semantic indirection.
- **D-06:** Exact slug-by-slug token list and Overdrive values to be derived by planner/researcher from `docs/design/design-system-alpha-overdrive.md`. Locked here: *naming style* (semantic) and *category scope* (colors + typography); NOT the specific slug list.

### Slate-utility treatment (load-bearing for Phase 1 scope)
- **D-07:** Tokenize the neutral scale as **`--neutral-50` through `--neutral-900`** CSS vars in `:root`. Inline Tailwind config remaps the `slate` palette to those vars (e.g. `slate: { 50: 'rgb(var(--neutral-50-rgb) / <alpha-value>)', 100: ..., ... }`). The ~101 existing `slate-*` utility usages in markup work unchanged — no markup edits in Phase 1.
- **D-08:** Phase 1's `--neutral-*` vars hold the **current slate hex values** (sourced from the existing inline Tailwind slate palette declaration). End-of-Phase-1 visual diff = zero. Phase 2 changes the values only.
- **D-09:** Neutrals are brandable per client — future client themes may ship cool, warm, or other neutral ramps via the same `--neutral-*` overrides.

### Client theme storage & DX
- **D-10:** All theme code lives in a **single `<style>` element near the top of `<head>`** (after the inline Tailwind config script, before the Tailwind CDN `<script>`). Contents in order: `:root` defaults block, then each `[data-theme="<client>"]` override block. Blocks are separated by comment dividers in the existing project style: `/* ========== <CLIENT> ========== */`.
- **D-11:** The `<style>` element opens with an **inline "how to add a client theme" comment header** — the canonical recipe for non-engineers (copy block → rename slug → edit hex/font values). No separate `docs/THEMING.md`; one source of truth that cannot drift from the code.

### FOUC handling
- **D-12:** Inline blocking `<script>` at the very top of `<head>` (first child of `<head>`) sets `data-theme` synchronously from `?client=` before any paint. Runs before the Tailwind config script and before the Tailwind CDN script. ~6 lines. First-paint resolves the correct theme attribute.

### Tailwind alpha-channel pattern
- **D-13:** Color tokens are declared as **space-separated RGB channel triplets**, not hex: `--accent-rgb: 243 94 31;` `--surface-rgb: 250 250 248;` etc. Inline Tailwind config resolves them with the `<alpha-value>` placeholder: `accent: 'rgb(var(--accent-rgb) / <alpha-value>)'`. This makes every Tailwind opacity utility (`bg-accent/10`, `text-accent/50`, etc.) work through the contract.
- **D-14:** RGB-triplet convention applies to **all color-class tokens** in the contract (accent, surface, text, border, neutral ramp). Fonts use normal CSS-var values (`--font-display: 'Space Grotesk', ...`) — no triplet pattern needed for non-color tokens.

### Missing-token fallback policy
- **D-15:** Rely on the **built-in CSS custom-property cascade** — any token a `[data-theme="..."]` block omits inherits its value from the `:root` defaults block. No JS validation, no console.warn, no error UI. Incomplete client themes render as "Overdrive with the tokens that were overridden." Forgiving by design — aligned with the "non-engineer can add a theme" goal.

### Font-loading pattern
- **D-16:** All theme display / body / mono fonts are **preloaded together** in the single Google Fonts `<link>` in `<head>`. Phase 1 keeps the existing three fonts (Fraunces, Plus Jakarta Sans, JetBrains Mono) unchanged. Phase 2 adds Space Grotesk. Each future client adds its fonts to the same `<link>`. Zero FOUT on theme switch is the goal; the `<head>` size cost is accepted (single-file ergonomics over micro-optimization).

### Claude's Discretion
- Exact contents of the inline FOUC `<script>` (param parse + setAttribute). Standard 5-6 line pattern.
- Slug-by-slug token list inside `:root` defaults — derived by planner from `docs/design/design-system-alpha-overdrive.md` and the inline Tailwind slate palette currently in `index.html`. Categories and naming style are locked above; specific slugs are not a Pete-facing decision.
- Ordering of theme blocks inside the `<style>` element (Overdrive first since it's the default).
- Whether the Phase 3 stub theme is named `alchemist` or another placeholder — Phase 3 detail, not Phase 1.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Project-level
- `.planning/PROJECT.md` — full constraint list (6 locked-constraint REQs governing all phases) and out-of-scope items
- `.planning/REQUIREMENTS.md` — REQ-build-theming-architecture (the v1 req this phase delivers), plus the 6 project-wide constraint REQs and the 3 scope-exclusion EXCLs
- `.planning/ROADMAP.md` § "Phase 1: Theming Architecture Foundation" — phase goal + 4 success criteria

### Source PRD
- `plan.md` — original milestone intent doc. "Locked decisions" section maps to project-wide constraint REQs; "Open questions" section items #1–#5 are answered by D-01 through D-16 above

### Design system
- `docs/design/design-system-alpha-overdrive.md` — Overdrive design system; canonical source for token names, color values, and font families used in Phase 2's Overdrive default theme block (D-06 defers slug derivation here)

### Codebase intel
- `.planning/codebase/STACK.md` — confirms Tailwind v3 CDN, no build, inline `<style>` / `<script>` pattern
- `.planning/codebase/STRUCTURE.md` — `index.html` file layout
- `.planning/codebase/CONVENTIONS.md` — 4-space indent, kebab-case CSS classes, camelCase JS, comment-divider style for sections (`// ========== HEADER ==========`) — D-10's theme dividers follow this existing convention

### App entry
- `index.html` — the single file all changes happen in. Current inline Tailwind config block (~lines 9–34 per CONVENTIONS.md) is the migration target for D-07 / D-13. Current Google Fonts `<link>` is the pattern D-16 generalizes.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- **Inline Tailwind config block** (`index.html` head, ~lines 9–34) — already extends `theme.extend.colors` with custom `primary`, `primaryHover`, and a fully-defined `slate` palette. Phase 1 transforms these into CSS-var-resolved entries (D-07, D-13) without restructuring the block shape.
- **Custom CSS `<style>` section** (~lines 36–69) — current home for `.slide`, `.answer-card`, `.check-card` selection states. Phase 1's new `<style>` element (D-10) is a *separate* `<style>` inserted *earlier* in `<head>`, holding only the token contract. This existing component-level `<style>` stays in place untouched.
- **Google Fonts `<link>`** in `<head>` — current preload pattern (Fraunces + Plus Jakarta Sans + JetBrains Mono) is exactly the pattern D-16 generalizes for future client fonts.

### Established Patterns
- **All-caps comment dividers** (`// ========== CORE LOGIC ==========` / `/* ========== HEADER ========== */`) per CONVENTIONS.md — D-10's theme-block dividers follow this existing project convention rather than inventing a new one.
- **No build, no module system** — all changes inline in `index.html` (PROJECT.md project-wide constraints; STACK.md confirms).
- **Semantic IDs + Tailwind utilities for everything visual** — markup never carries raw hex, which makes the migration to var-resolved Tailwind utilities a *config-only* change for nearly all surfaces. The few inline-styled exceptions need to be located by research and migrated to utility classes or var-backed inline styles.

### Integration Points
- **Inline Tailwind config script** (`<head>`) — D-07 and D-13 modify the `theme.extend.colors` shape here. Color declarations change from `'#4F46E5'` string form to `'rgb(var(--<token>-rgb) / <alpha-value>)'` form.
- **New inline FOUC `<script>`** (D-12) — first child of `<head>`, before the Tailwind config script.
- **New token `<style>` element** (D-10) — inserted near the top of `<head>` after the Tailwind config script, before the Tailwind CDN script (so CSS-var defaults are parsed before any rules consume them).
- **Existing component `<style>` block** (~lines 36–69) — no edits needed in Phase 1; component-level CSS continues to work because var-backed Tailwind utilities are transparent to existing selectors.

</code_context>

<specifics>
## Specific Ideas

- **Non-engineer ergonomics is a first-class constraint.** D-11 (inline recipe comment) and D-15 (forgiving missing-token cascade) both encode this — the system has to be addable-to by someone who reads but doesn't write code professionally. Anything that violates this (strict validation, build steps, external docs) was explicitly rejected.
- **The "no frankenstein" rule is structural, not stylistic.** D-08 (Phase 1 vars hold *current* hex values) is the mechanism: Phase 1 ends with byte-for-rendered-byte the same visual output. The contract is real, but the user-facing identity hasn't moved yet. Phase 2 then flips *values*, not structure.
- **RGB-channel triplet pattern (D-13) is the load-bearing detail** that makes the rest of the contract usable. Without it, every Tailwind opacity modifier in the codebase silently breaks at Phase 2. This is the decision most easily missed if not surfaced explicitly now.
- **Two separate `<style>` elements** end up in `<head>` post-Phase-1: the new token contract `<style>` near the top (D-10) and the existing component `<style>` block (`.slide`, `.answer-card`, etc.) lower down. Intentional separation — token contract is "skin," component styles are "structure."

</specifics>

<deferred>
## Deferred Ideas

- **`localStorage`-based theme persistence** — considered and rejected (Area 1). Reason: introduces stateful behavior to a static app; shared workshop links must render deterministically.
- **Per-theme media queries / dark-mode variants** — out of scope per REQ-no-dark-backgrounds (project-wide constraint). Future themes do not get dark-mode opt-ins.
- **Build-time per-client deploys** — rejected (Area 1, Area 4 alts). Single-file constraint is locked; one `index.html` URL serves all themes.
- **Strict missing-token validation** — considered and rejected (Area 7). Forgiving CSS-var cascade wins; if a future incident proves it costly, revisit then.
- **Console.warn on missing tokens** — considered and rejected (Area 7). Adds a JS-side source of truth that can drift from the CSS contract.
- **Lazy per-theme font-loading** — considered and rejected (Area 8). Premature optimization for the current client count (≤ 5–10).
- **Tailwind plugin / build-time theming** — out of scope (locked: no build step).
- **External `docs/THEMING.md` recipe doc** — rejected (Area 4 follow-up). Inline comment header is the single source of truth.
- **Two-layer palette-plus-semantic token system** — considered and rejected (Area 2 follow-up). Single-layer semantic wins for non-engineer readability and current client scale.
- **Visible "theme not found" banner** — considered and rejected (Area 1). Silent fallback is the chosen UX for shared-link resilience.

</deferred>

---

*Phase: 1-Theming Architecture Foundation*
*Context gathered: 2026-05-15*
