# Phase 1: Theming Architecture Foundation - Research

**Researched:** 2026-05-15
**Domain:** Single-file static web app theming — CSS custom properties + Tailwind CDN config + runtime switch mechanism, inside `index.html`
**Confidence:** HIGH

## Summary

Phase 1 ships a theming **contract**, not a visual change. The work is structural: an inline FOUC `<script>` (~6 lines, first child of `<head>`), a modified inline Tailwind config that swaps every literal hex for `rgb(var(--<token>-rgb) / <alpha-value>)` references, and a new `<style>` element near the top of `<head>` holding one `:root` defaults block plus per-client override blocks. The `:root` block is populated with the **current** hex values (re-expressed as RGB triplets and named with Overdrive-style semantic slugs), so end-of-Phase-1 visual diff is zero.

The load-bearing detail is D-13's RGB-triplet pattern (`--accent-rgb: 79 70 229;` rather than `--accent: #4F46E5;`). Without it, opacity utilities like `bg-accent/10` or `bg-slate-800/50` (one of which is already in the markup at line 474) break silently at Phase 2 when values change. The pattern is confirmed working on the Tailwind v3.x CDN build the project consumes [CITED: https://tailwindcss.com/blog/tailwindcss-v3-1].

The current markup already uses the tokenized `bg-accent` / `bg-accent-hover` naming — there is **no `primary` / `primaryHover` migration to perform** (CONTEXT.md's mention of `primaryHover` reflects the older state captured in CONVENTIONS.md, not the current `index.html`). The 80 `slate-*` utility usages tokenize through the config-only rewrite with zero markup edits.

**Primary recommendation:** Insert three structural elements at the top of `<head>` (FOUC script, modified Tailwind config script, new token `<style>`), translate every current hex into an RGB-triplet CSS var labeled with the Overdrive-style semantic slug, keep all markup untouched, and verify with a side-by-side render against `main`.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Theme switch mechanism**
- **D-01:** Canonical runtime switch is `?client=<slug>` URL param. An inline blocking `<script>` at the top of `<head>` (before the Tailwind CDN `<script>`) reads `location.search`, parses the param, and synchronously sets `document.documentElement.setAttribute('data-theme', slug)`. CSS only ever keys on `[data-theme="..."]`.
- **D-02:** Default render (no `?client=` param) is **Overdrive**. Bare URL = Overdrive brand.
- **D-03:** Unknown `?client=` value (typo, deleted theme) silently falls back to Overdrive. No banner, no console warning. Safe-by-default for shared workshop links.

**Brandable token scope**
- **D-04:** Brandable surface is **colors + typography only**. Radii, spacing, shadows stay shared across all clients (structural rhythm, not brand-variable).
- **D-05:** Tokens are **semantic, single-layer** — `--accent`, `--accent-hover`, `--surface`, `--surface-elev`, `--text`, `--text-muted`, `--border`, `--font-display`, `--font-body`, `--font-mono` (plus the `--neutral-*` scale from D-07). No two-layer palette-plus-semantic indirection.
- **D-06:** Exact slug-by-slug token list and Overdrive values to be derived by planner/researcher from `docs/design/design-system-alpha-overdrive.md`. Locked here: *naming style* (semantic) and *category scope* (colors + typography); NOT the specific slug list.

**Slate-utility treatment (load-bearing for Phase 1 scope)**
- **D-07:** Tokenize the neutral scale as **`--neutral-50` through `--neutral-900`** CSS vars in `:root`. Inline Tailwind config remaps the `slate` palette to those vars (e.g. `slate: { 50: 'rgb(var(--neutral-50-rgb) / <alpha-value>)', 100: ..., ... }`). The ~101 existing `slate-*` utility usages in markup work unchanged — no markup edits in Phase 1.
- **D-08:** Phase 1's `--neutral-*` vars hold the **current slate hex values** (sourced from the existing inline Tailwind slate palette declaration). End-of-Phase-1 visual diff = zero. Phase 2 changes the values only.
- **D-09:** Neutrals are brandable per client — future client themes may ship cool, warm, or other neutral ramps via the same `--neutral-*` overrides.

**Client theme storage & DX**
- **D-10:** All theme code lives in a **single `<style>` element near the top of `<head>`** (after the inline Tailwind config script, before the Tailwind CDN `<script>`). Contents in order: `:root` defaults block, then each `[data-theme="<client>"]` override block. Blocks are separated by comment dividers in the existing project style: `/* ========== <CLIENT> ========== */`.
- **D-11:** The `<style>` element opens with an **inline "how to add a client theme" comment header** — the canonical recipe for non-engineers (copy block → rename slug → edit hex/font values). No separate `docs/THEMING.md`; one source of truth that cannot drift from the code.

**FOUC handling**
- **D-12:** Inline blocking `<script>` at the very top of `<head>` (first child of `<head>`) sets `data-theme` synchronously from `?client=` before any paint. Runs before the Tailwind config script and before the Tailwind CDN script. ~6 lines. First-paint resolves the correct theme attribute.

**Tailwind alpha-channel pattern**
- **D-13:** Color tokens are declared as **space-separated RGB channel triplets**, not hex: `--accent-rgb: 243 94 31;` `--surface-rgb: 250 250 248;` etc. Inline Tailwind config resolves them with the `<alpha-value>` placeholder: `accent: 'rgb(var(--accent-rgb) / <alpha-value>)'`. This makes every Tailwind opacity utility (`bg-accent/10`, `text-accent/50`, etc.) work through the contract.
- **D-14:** RGB-triplet convention applies to **all color-class tokens** in the contract (accent, surface, text, border, neutral ramp). Fonts use normal CSS-var values (`--font-display: 'Space Grotesk', ...`) — no triplet pattern needed for non-color tokens.

**Missing-token fallback policy**
- **D-15:** Rely on the **built-in CSS custom-property cascade** — any token a `[data-theme="..."]` block omits inherits its value from the `:root` defaults block. No JS validation, no console.warn, no error UI. Incomplete client themes render as "Overdrive with the tokens that were overridden." Forgiving by design.

**Font-loading pattern**
- **D-16:** All theme display / body / mono fonts are **preloaded together** in the single Google Fonts `<link>` in `<head>`. Phase 1 keeps the existing three fonts (Fraunces, Plus Jakarta Sans, JetBrains Mono) unchanged. Phase 2 adds Space Grotesk.

### Claude's Discretion
- Exact contents of the inline FOUC `<script>` (param parse + setAttribute). Standard 5-6 line pattern.
- Slug-by-slug token list inside `:root` defaults — derived by planner from `docs/design/design-system-alpha-overdrive.md` and the inline Tailwind slate palette currently in `index.html`. Categories and naming style are locked above; specific slugs are not a Pete-facing decision.
- Ordering of theme blocks inside the `<style>` element (Overdrive first since it's the default).
- Whether the Phase 3 stub theme is named `alchemist` or another placeholder — Phase 3 detail, not Phase 1.

### Deferred Ideas (OUT OF SCOPE)
- `localStorage`-based theme persistence (Area 1) — introduces stateful behavior to a static app; shared workshop links must render deterministically.
- Per-theme media queries / dark-mode variants — out of scope per REQ-no-dark-backgrounds.
- Build-time per-client deploys — single-file constraint is locked.
- Strict missing-token validation — forgiving CSS-var cascade wins.
- Console.warn on missing tokens — adds a JS-side source of truth that can drift from the CSS contract.
- Lazy per-theme font-loading — premature optimization at current client count (≤ 5–10).
- Tailwind plugin / build-time theming — locked: no build step.
- External `docs/THEMING.md` recipe doc — inline comment header is the single source of truth.
- Two-layer palette-plus-semantic token system — single-layer semantic wins for non-engineer readability.
- Visible "theme not found" banner — silent fallback is the chosen UX for shared-link resilience.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| REQ-build-theming-architecture | Build the theming architecture: CSS-variable contract + Tailwind wiring + theme switch mechanism. | All four sub-criteria mapped: (a) `:root` block contents specified in §"Exact `:root` Token Defaults"; (b) Tailwind config rewrite specified in §"Modified Inline Tailwind Config Shape"; (c) switch mechanism specified in §"FOUC Script (D-12)"; (d) zero-visual-regression strategy specified in §"Verification Approach for Success Criterion #4". |
</phase_requirements>

## Project Constraints (from CLAUDE.md)

These directives from `./CLAUDE.md` carry the same authority as locked decisions. Plans must comply:

- **Single file, no build.** All changes inside `index.html`. No bundler, no package manager, no separate JS/CSS files. (Reinforces REQ-single-file-no-build.)
- **Tailwind CDN with inline config.** Tailwind is loaded via `https://cdn.tailwindcss.com` and its config is the inline `<script>` block at the top of `<head>` (~lines 9–46 in current `index.html`). Phase 1 modifies the *contents* of that block, not its location or its pattern.
- **Google Fonts via `<link>`.** Fraunces + Plus Jakarta Sans + JetBrains Mono load from one `<link>` in `<head>`. Pattern stays; Phase 1 does not change the link.
- **Design guidelines reference:** `docs/design/Modern-Web-UI-Design-Guidelines.md` (current indigo/slate identity) and `docs/design/design-system-alpha-overdrive.md` (target identity — Phase 2 consumes it, Phase 1 only borrows slug naming).
- **`reference/cli-tool-template.py` is structural reference, not for copy.** Not relevant to Phase 1; theming work is entirely browser-side.

## Architectural Responsibility Map

Single-tier app — everything is browser-side. The map is still useful because Phase 1 touches three distinct layers inside the single `index.html`:

| Capability | Primary Layer | Secondary Layer | Rationale |
|------------|---------------|-----------------|-----------|
| Token definitions (`--accent-rgb`, `--neutral-50-rgb`, fonts) | New `<style>` block in `<head>` | — | Tokens must be parsed before any rule that consumes them. CSS-only — no JS owns them. |
| Tailwind utility → token resolution | Inline Tailwind config `<script>` in `<head>` | — | The mapping `slate-200 → rgb(var(--neutral-200-rgb) / <alpha-value>)` lives in the CDN-script config object; this is where utility class names become token references. |
| Theme switch (URL param → `data-theme` attribute) | Inline FOUC `<script>` (first child of `<head>`) | — | Synchronous, blocking, pre-paint. Owns the single side effect: `document.documentElement.setAttribute('data-theme', slug)`. |
| Component-level styles (`.slide`, `.answer-card` etc.) | Existing `<style>` block (~lines 47–194) | — | Untouched in Phase 1. Continues to reference literal hex values (out of scope; flagged in §"Non-Utility Hex Usages"). |
| Markup utility classes (`bg-slate-200`, `text-accent`, etc.) | Existing markup throughout `index.html` | — | Untouched in Phase 1. Var-backed Tailwind utilities are transparent to existing selectors. |

**Why this matters for Phase 1:** the three new structural insertions must be ordered correctly — FOUC script first (sets `data-theme` before any rule resolves), Tailwind config script second (so the CDN script that runs immediately after sees the modified config), token `<style>` third (so `:root` defaults exist when generated Tailwind rules use `var(...)`), CDN script fourth (consumes the modified config and emits CSS rules), existing Google Fonts `<link>` and existing component `<style>` last. Misordering this list is the most likely Phase 1 implementation bug.

## Standard Stack

### Core (already in use — Phase 1 keeps everything, modifies only the inline Tailwind config and adds a new `<style>` + `<script>` in `<head>`)

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Tailwind CSS | v3.x (CDN: `https://cdn.tailwindcss.com`) | Utility-first CSS framework — all visual classes resolve through it | Already deployed; `<alpha-value>` placeholder pattern works on v3.1+ CDN builds [CITED: tailwindcss.com/blog/tailwindcss-v3-1] |
| Google Fonts | Latest CSS API | Loads Fraunces + Plus Jakarta Sans + JetBrains Mono | Already deployed; D-16 generalizes the existing `<link>` pattern |
| Native CSS custom properties | n/a (browser built-in) | Token contract storage + cascade-based fallback (D-15) | No library needed — CSS-var cascade is exactly the behavior D-15 wants |
| Native `URLSearchParams` | n/a (browser built-in) | Parse `?client=` in FOUC script (D-12) | Universal browser support; ~1 line of code; no library needed |

### Supporting

None. Phase 1 adds zero dependencies. No package install. No build step.

### Alternatives Considered

| Instead of | Could Use | Tradeoff (why rejected) |
|------------|-----------|------------------------|
| Inline Tailwind config + CDN | `tailwind.config.js` + CLI build | Violates REQ-single-file-no-build (locked) |
| Single-layer semantic tokens | Two-layer palette+semantic indirection | Rejected — D-05; harder for non-engineers to add a theme |
| RGB-triplet vars (`--accent-rgb: 79 70 229`) | Hex strings (`--accent: #4F46E5`) | Locked D-13. Hex strings can't combine with Tailwind's `/` opacity modifier — line 474 (`bg-slate-800/50`) would silently break at Phase 2 |
| CSS custom-property cascade fallback | JS validation + `console.warn` | Rejected — D-15. Validation duplicates source of truth and drifts |
| URL-param switch | localStorage persistence | Rejected — Area 1. Workshop links must render deterministically |

**Installation:** None. CDN dependencies already in `<head>`.

**Version verification:** The Tailwind CDN at `https://cdn.tailwindcss.com` serves Tailwind v3.x [VERIFIED: WebFetch against the CDN URL identified the bundle as v3.x and confirmed presence of the `<alpha-value>` substitution logic in the minified source]. The `<alpha-value>` placeholder was added in **Tailwind v3.1** [CITED: https://tailwindcss.com/blog/tailwindcss-v3-1]. The CDN tracks the latest v3 release, so the pattern works without pinning. No version-pinning action is needed for Phase 1; if Tailwind v4 ever ships through the same CDN URL, the pattern needs re-verification — note in commit message that v3.x is the operating assumption.

## Architecture Patterns

### System Architecture (Phase 1 `index.html` after the structural changes)

```
Browser opens index.html (with optional ?client=<slug>)
        |
        v
[1] Inline FOUC <script> (NEW — first child of <head>, D-12)
        Reads URLSearchParams, calls document.documentElement.setAttribute('data-theme', slug) if slug present
        |
        v
[2] Inline Tailwind config <script> (MODIFIED, D-07/D-13)
        Defines theme.extend.colors using 'rgb(var(--<token>-rgb) / <alpha-value>)' strings
        Defines theme.extend.fontFamily using ['var(--font-display)', 'serif'] arrays
        |
        v
[3] New token contract <style> (NEW, D-10/D-11/D-14/D-15)
        Inline recipe comment header (D-11)
        :root { --accent-rgb, --accent-hover-rgb, --surface-warm-rgb, --neutral-*-rgb, --font-display, ... }
        /* ========== OVERDRIVE (default — values held by :root) ========== */    [block intentionally empty in Phase 1]
        /* ========== <CLIENT-PLACEHOLDER> ========== */                          [optional stub for Phase 3]
        |
        v
[4] Tailwind CDN <script src="https://cdn.tailwindcss.com">
        Reads window.tailwind.config (set by [2]), generates utility CSS rules that reference the vars defined in [3]
        |
        v
[5] Google Fonts <link> (UNCHANGED, D-16)
        Loads Fraunces + Plus Jakarta Sans + JetBrains Mono
        |
        v
[6] Existing component <style> block (UNCHANGED, ~lines 47–194)
        .slide / .answer-card / .check-card / .key-badge / .result-overline rules
        Still references literal hex values (#4F46E5, #E2E8F0, etc.) — out of Phase 1 scope, flagged for Phase 2
        |
        v
[7] <body> with markup using bg-accent / text-slate-500 / bg-surface-warm utilities (UNCHANGED)
        Tailwind resolves each utility through the var-backed config from [2], pulling values from [3]
        If [data-theme] is set on <html>, override rules in [3] take precedence; otherwise :root defaults win
        |
        v
First paint shows correct theme. No FOUC.
```

**Reading the flow:** Element order in `<head>` is load-bearing. If `[3]` (token `<style>`) comes after `[4]` (CDN script), generated rules reference undefined vars on first parse; values resolve only after the `<style>` is parsed, which is normally same-tick but creates a window for misinterpretation. Putting `[3]` before `[4]` removes any ambiguity.

### Recommended Project Structure

```
index.html (single file — no other files touched)
├── <head>
│   ├── meta tags                              [unchanged]
│   ├── <title>                                [unchanged]
│   ├── <script> FOUC                          [NEW — first child of <head>, 6 lines]
│   ├── <style> token contract                 [NEW — recipe comment + :root + theme blocks]
│   ├── <script src="cdn.tailwindcss.com">     [unchanged content; new position after token <style>]
│   ├── <script> Tailwind config (modified)    [REWRITTEN in place; must follow CDN — see Pitfall 2b]
│   ├── <link> Google Fonts                    [unchanged content; position shifts after Phase 1]
│   └── <style> component CSS                  [unchanged; line numbers shift +~80 due to new <head> inserts]
└── <body>                                     [unchanged]
```

**[CORRECTED 2026-05-15 — see Phase 1 SUMMARY § "Research-level correction"]** The CDN `<script src="https://cdn.tailwindcss.com">` is a plain synchronous script (NOT defer-equivalent) — it loads and executes in document order. Its IIFE defines `window.tailwind` as a side effect, then schedules a `process()` call asynchronously after reading `tailwind.config`. The asynchronous `process()` is why CDN-before-config works (config gets set by the inline script before `process()` fires). But the reverse — inline config BEFORE CDN — does NOT work: the inline `tailwind.config = {...}` throws `ReferenceError: tailwind is not defined` because the CDN's IIFE hasn't run yet to create the global. Two constraints, both load-bearing:
- **Token `<style>` must precede CDN** so `:root` vars are in the cascade when Tailwind injects utility CSS at first paint (Pitfall 2).
- **CDN must precede inline `tailwind.config` assignment** so `window.tailwind` exists when the assignment runs (Pitfall 2b — surfaced during Phase 1 V-4 verification).

The canonical Phase 1 ordering is therefore: FOUC → token `<style>` → CDN `<script>` → inline Tailwind config `<script>` → Google Fonts `<link>` → existing component `<style>`. D-10's original wording ("after the inline Tailwind config script, before the Tailwind CDN `<script>`") read for the token `<style>` is structurally incorrect for this reason and is also corrected post-Phase-1. The pre-Phase-1 `main`-branch ordering (CDN → fonts → inline config → component style) implicitly satisfied the JS dependency by having CDN first; Phase 1 preserves that, only inserting FOUC and the new token `<style>` before the CDN.

### Pattern 1: RGB-triplet CSS var + Tailwind `<alpha-value>` placeholder
**What:** Color tokens are declared as space-separated R/G/B integer triplets (not hex), and the Tailwind config resolves them as `rgb(var(--token-rgb) / <alpha-value>)`. Tailwind's runtime substitutes `<alpha-value>` with `1` for solid utilities and with the modifier value for opacity utilities (`/50` → `0.5`).
**When to use:** Every color token in the contract (D-14). Fonts skip this pattern — they're plain CSS-var values.
**Example:**
```css
/* In :root */
--accent-rgb: 79 70 229;       /* #4F46E5 as RGB triplet */
```
```javascript
// In inline Tailwind config
colors: {
  accent: {
    DEFAULT: 'rgb(var(--accent-rgb) / <alpha-value>)',
    hover:   'rgb(var(--accent-hover-rgb) / <alpha-value>)',
  }
}
```
- `bg-accent` → `background-color: rgb(79 70 229 / 1)`
- `bg-accent/50` → `background-color: rgb(79 70 229 / 0.5)`
- A theme override that changes `--accent-rgb: 255 144 0;` re-resolves every `bg-accent*` utility on the page without any rule rewrite.

Source: [CITED: https://tailwindcss.com/blog/tailwindcss-v3-1] — "Instead of writing a function that receives an `opacityValue` argument, you can write a string with an `<alpha-value>` placeholder, and Tailwind will replace that placeholder with the correct alpha value based on the utility."

### Pattern 2: Synchronous pre-paint theme switch via inline `<script>`
**What:** An inline blocking `<script>` runs before the browser paints anything. It reads `?client=` from `location.search` and calls `document.documentElement.setAttribute('data-theme', slug)` if a value is present.
**When to use:** Phase 1's switch mechanism (D-12). Critical that this script is **inline** (not external) and **first** in `<head>` so it executes before any rendered content.
**Example:**
```html
<script>
  (function () {
    var p = new URLSearchParams(location.search).get('client');
    if (p) document.documentElement.setAttribute('data-theme', p);
  })();
</script>
```
- IIFE keeps the script out of global scope.
- Variable name `p` is intentionally short — script is read by non-engineers per D-11 spirit; readability of intent matters more than verbose naming.
- No try/catch — `URLSearchParams` is universal in target browsers; failure modes don't apply.
- No localStorage fetch — explicitly rejected.

Source: [CITED: pattern matches consensus from miguelgrinberg.com dark-mode guide and Pico.css examples on FOUC prevention]. `document.documentElement` always exists during `<head>` parsing — no DOMContentLoaded wait needed.

### Pattern 3: `:root` defaults + `[data-theme="..."]` override blocks in one `<style>`
**What:** One `<style>` element contains the entire theme contract — `:root` block at top (the default Overdrive identity, which in Phase 1 holds the current indigo/slate hex values), then one `[data-theme="<slug>"]` selector per client. Each override block redeclares only the tokens that differ from `:root`; the cascade fills in the rest from `:root` (D-15).
**When to use:** Phase 1 establishes the structure with `:root` only. Phase 3 adds the first override block.
**Example:**
```html
<style>
/* ============================================================
   THEME CONTRACT — How to add a new client theme:
   1. Copy the ":root" block below.
   2. Change the selector to [data-theme="<your-client-slug>"].
   3. Edit any token values you want to override. Leave the rest
      alone — they inherit from :root.
   4. Visit the app with ?client=<your-client-slug> in the URL.
   ============================================================ */

/* ========== :ROOT DEFAULTS (Overdrive) ========== */
:root {
  /* Accent colors */
  --accent-rgb:        79 70 229;     /* #4F46E5 — current indigo (Phase 1) */
  --accent-hover-rgb:  67 56 202;     /* #4338CA */
  /* ... etc ... */

  /* Fonts */
  --font-display: 'Fraunces', serif;
  --font-body:    'Plus Jakarta Sans', sans-serif;
  --font-mono:    'JetBrains Mono', monospace;
}

/* ========== ALCHEMIST (Phase 3 stub) ========== */
/* [data-theme="alchemist"] { ... } */
</style>
```

### Anti-Patterns to Avoid

- **Declaring color tokens as hex strings (`--accent: #4F46E5;`).** Breaks every Tailwind opacity modifier. The codebase already uses `bg-slate-800/50` (line 474) — this would silently break at Phase 2 if the triplet pattern is skipped. D-13 exists specifically to prevent this.
- **Putting the FOUC script in an external file or at the end of `<head>`.** External scripts queue behind the network; late-in-`<head>` scripts may execute after some paint has begun. Inline + first child is the only safe placement.
- **Mixing the token `<style>` with the existing component `<style>`.** Two separate `<style>` elements are intentional (CONTEXT.md `<specifics>`): one is skin, the other is structure. Phase 1's new `<style>` does not absorb the existing one.
- **Touching markup.** Phase 1 is config-only + new-block-only. Editing any utility class in `<body>` is out of scope and risks visual regression.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Parsing `?client=<slug>` from URL | Custom regex on `location.search` | `new URLSearchParams(location.search).get('client')` | Built-in, universal, one line. Custom regex has edge cases (multiple `?`, encoded characters, etc.) |
| Validating "is this a known theme slug?" | JS lookup table + `console.warn` | Browser CSS-var cascade (D-15) | Locked rejected. Forgiving fallback is the chosen UX |
| Theme persistence across reloads | `localStorage.setItem('theme', slug)` | URL param only (D-01) | Locked rejected. Workshop links must be deterministic |
| Generating CSS at build time per client | Build pipeline | Inline override blocks in one `<style>` (D-10) | Locked rejected. No build step |
| Color manipulation (lighten/darken at runtime) | JS color math | Pre-declared sibling tokens (`--accent-rgb` + `--accent-hover-rgb`) | One extra token is cheaper than one extra line of code |

**Key insight:** Phase 1's whole job is to use platform primitives (CSS custom properties, the cascade, URLSearchParams, Tailwind's built-in alpha placeholder) and avoid adding any abstraction. The single piece of new JavaScript is ~6 lines.

## Runtime State Inventory

> Phase 1 is a structural refactor of `index.html` — no rename/migration. State inventory still relevant because the app is deployed and may have cached or referenced resources.

| Category | Items Found | Action Required |
|----------|-------------|------------------|
| Stored data | None — app is fully static, stateless. No DB, no cache, no service worker (verified by grep — no SW registration in `index.html`). | None |
| Live service config | The deployed `index.html` is the only artifact (single-file static app). | None — re-deploy after Phase 1 ships will replace it atomically |
| OS-registered state | None | None |
| Secrets and env vars | None (`STACK.md` confirms no .env, no API keys) | None |
| Build artifacts / installed packages | None (no build step; Tailwind CDN and Google Fonts are external) | None |

**Cache nuance:** Browsers cache `index.html` per the host's headers. Visitors with a cached pre-Phase-1 `index.html` won't see the new theming until cache expires. This is a Phase 2/3 user-facing concern (when values *do* change); for Phase 1 it's invisible (zero-visual-diff guarantee).

## Specific Research Answers (from the planner's questions)

This section answers every numbered question the planner asked, with the exact values/text the plan will need.

### 1. Exact `--neutral-50` through `--neutral-900` RGB triplet values (current slate, D-08)

Sourced from the inline Tailwind config block at `index.html` lines 31–40. These are the Tailwind v3 default slate hex values, which is what the current app uses today.

| CSS var | Value | Hex equivalent |
|---------|-------|----------------|
| `--neutral-50-rgb`  | `248 250 252` | `#F8FAFC` |
| `--neutral-100-rgb` | `241 245 249` | `#F1F5F9` |
| `--neutral-200-rgb` | `226 232 240` | `#E2E8F0` |
| `--neutral-300-rgb` | `203 213 225` | `#CBD5E1` |
| `--neutral-400-rgb` | `148 163 184` | `#94A3B8` |
| `--neutral-500-rgb` | `100 116 139` | `#64748B` |
| `--neutral-600-rgb` | `71 85 105`   | `#475569` |
| `--neutral-700-rgb` | `51 65 85`    | `#334155` |
| `--neutral-800-rgb` | `30 41 59`    | `#1E293B` |
| `--neutral-900-rgb` | `15 23 42`    | `#0F172A` |

[VERIFIED: read directly from `index.html` lines 31–40, then converted hex→RGB.]

### 2. Exact `:root` Token Defaults (Phase 1 values — CURRENT identity, Overdrive-style slug names)

**The key reading nuance:** D-02 says "default render is Overdrive" and D-08 says "Phase 1 vars hold *current* hex values." These reconcile cleanly:

- **Phase 1:** The `:root` block uses Overdrive-style slug *names* (`--accent-rgb`, `--surface-rgb`, `--font-display`, etc. — the contract is in place), but holds the *current* (indigo / slate / Fraunces) *values*. Visual diff = zero.
- **Phase 2:** Same slug names, different values (Overdrive orange, warm off-white, Space Grotesk). Visual diff = the full Overdrive identity.

So `--accent-rgb` in Phase 1 = `79 70 229` (current indigo `#4F46E5`), **not** `255 144 0` (Overdrive orange `#FF9000`). The planner must not let this read backward.

[VERIFIED against CONTEXT.md `<decisions>` D-02 and D-08 + CONTEXT.md `<specifics>` paragraph 2: "Phase 1 ends with byte-for-rendered-byte the same visual output. The contract is real, but the user-facing identity hasn't moved yet. Phase 2 then flips *values*, not structure."]

#### Recommended full `:root` token list for Phase 1

| Token | Phase 1 value | Source | Phase 2 (Overdrive) value (for reference only) |
|-------|---------------|--------|------------------------------------------------|
| `--accent-rgb` | `79 70 229` | current `#4F46E5` (line 20) | `255 144 0` (`#FF9000` Overdrive orange) |
| `--accent-hover-rgb` | `67 56 202` | current `#4338CA` (line 21) | TBD Phase 2 (darker orange) |
| `--accent-muted-rgb` | `238 242 255` | current `#EEF2FF` (line 22) | TBD Phase 2 (warm yellow tint) |
| `--surface-rgb` | `250 250 248` | current `#FAFAF8` warm off-white (line 25) | `255 248 240` (`#FFF8F0` Overdrive warm off-white) |
| `--surface-elev-rgb` | `255 255 255` | white (used in answer-card backgrounds — implicit; current cards have `background: white;` on line 97 etc.) | `255 255 255` |
| `--surface-dark-rgb` | `15 23 42` | current `#0F172A` (line 26) — **but Phase 2 removes the dark hero per REQ-no-dark-backgrounds**; this token survives Phase 1 only because the dark results hero still exists at end of Phase 1 | Token retired or repurposed Phase 2 |
| `--surface-dark-card-rgb` | `30 41 59` | current `#1E293B` (line 27) | Same as above |
| `--text-rgb` | `26 26 46` | current `ink: #1A1A2E` (line 29) | `67 67 67` (`#434343` Overdrive dark gray) |
| `--text-muted-rgb` | `100 116 139` | current `slate-500 #64748B` (the dominant body-secondary color in markup — 20 usages) | `138 138 138` (`#8A8A8A` Overdrive gray 2) |
| `--border-rgb` | `226 232 240` | current `slate-200 #E2E8F0` (the dominant border color — 21 usages) | `229 229 229` (`#E5E5E5` Overdrive border-light) |
| `--neutral-50-rgb` through `--neutral-900-rgb` | See §1 table above | current slate scale | Overdrive warm-neutral ramp (Phase 2 decides) |
| `--font-display` | `'Fraunces', serif` | current line 15 | `'Space Grotesk', sans-serif` Phase 2 |
| `--font-body` | `'Plus Jakarta Sans', sans-serif` | current line 14 | unchanged |
| `--font-mono` | `'JetBrains Mono', monospace` | current line 16 | unchanged |

**Notes for the planner:**
- `--surface-elev-rgb` doesn't exist in the current config but is implied by `background: white;` on the answer cards. Adding it now means component-level white backgrounds (Phase 2 work) can move onto the token cleanly.
- `--text-muted-rgb` ≠ `--neutral-500-rgb` *today* (both are `#64748B`), but they are conceptually distinct — muted body text vs. mid-gray neutral. Keep them as separate tokens so Phase 2 can move one without dragging the other.
- `--border-rgb` ≠ `--neutral-200-rgb` *today* (both are `#E2E8F0`) — same reasoning.

[ASSUMED] The `--surface-elev-rgb` token is a Claude-discretion add; CONTEXT.md D-05 lists `--surface-elev` in its example slug list. Worth confirming with Pete before locking, but the precedent for adding it is in the decision text itself.

### 3. Exact FOUC `<script>` (D-12)

Recommended canonical implementation (6 lines including the closing tag):

```html
<script>
  (function () {
    var p = new URLSearchParams(location.search).get('client');
    if (p) document.documentElement.setAttribute('data-theme', p);
  })();
</script>
```

**Placement:** First child of `<head>`, before the inline Tailwind config `<script>`, before the Tailwind CDN `<script>`. Before everything else.

**Timing details:**
- `document.documentElement` exists from the moment `<html>` is parsed — this script runs while `<head>` is being parsed, *after* `<html>` has been created in the DOM. The setAttribute call is therefore always safe; no DOMContentLoaded wait needed [CITED: HTML5 spec parsing model; confirmed by Pico.css FOUC examples and Miguel Grinberg's dark-mode guide].
- The script is synchronous (no `async` / `defer` / `type="module"` attributes), so the parser blocks until it completes. This is exactly what prevents FOUC.
- No try/catch: `URLSearchParams` is supported in every browser the app targets (Chromium 49+, Firefox 44+, Safari 10.1+). If a planner wants belt-and-suspenders, wrapping the body in `try { ... } catch (_) {}` is harmless but unnecessary.

**Why an IIFE:** keeps `p` out of `window.*`. The script runs once and disappears. Important hygiene because the rest of `<head>` (Tailwind config script and CDN script) executes in the same shared global.

**Notes on the variable name `p`:** intentionally short — D-11's "non-engineer-readable" principle applies to the `<style>` recipe comment, not to inline scripts. But the planner may prefer `slug` or `clientParam` for clarity; either is fine and adds 4–10 bytes.

### 4. Modified Inline Tailwind Config Shape

**BEFORE** (current `index.html` lines 9–46):
```javascript
tailwind.config = {
  theme: {
    extend: {
      fontFamily: {
        sans:    ['Plus Jakarta Sans', 'sans-serif'],
        display: ['Fraunces', 'serif'],
        mono:    ['JetBrains Mono', 'monospace'],
      },
      colors: {
        accent: {
          DEFAULT: '#4F46E5',
          hover:   '#4338CA',
          muted:   '#EEF2FF',
        },
        surface: {
          warm:        '#FAFAF8',
          dark:        '#0F172A',
          'dark-card': '#1E293B',
        },
        ink: '#1A1A2E',
        slate: {
          50:  '#F8FAFC',
          /* ... 100–900 ... */
          900: '#0F172A',
        }
      }
    }
  }
}
```

**AFTER** (Phase 1 target shape):
```javascript
tailwind.config = {
  theme: {
    extend: {
      fontFamily: {
        sans:    ['var(--font-body)',    'sans-serif'],
        display: ['var(--font-display)', 'serif'],
        mono:    ['var(--font-mono)',    'monospace'],
      },
      colors: {
        accent: {
          DEFAULT: 'rgb(var(--accent-rgb)       / <alpha-value>)',
          hover:   'rgb(var(--accent-hover-rgb) / <alpha-value>)',
          muted:   'rgb(var(--accent-muted-rgb) / <alpha-value>)',
        },
        surface: {
          warm:        'rgb(var(--surface-rgb)           / <alpha-value>)',
          dark:        'rgb(var(--surface-dark-rgb)      / <alpha-value>)',
          'dark-card': 'rgb(var(--surface-dark-card-rgb) / <alpha-value>)',
        },
        ink: 'rgb(var(--text-rgb) / <alpha-value>)',
        slate: {
          50:  'rgb(var(--neutral-50-rgb)  / <alpha-value>)',
          100: 'rgb(var(--neutral-100-rgb) / <alpha-value>)',
          200: 'rgb(var(--neutral-200-rgb) / <alpha-value>)',
          300: 'rgb(var(--neutral-300-rgb) / <alpha-value>)',
          400: 'rgb(var(--neutral-400-rgb) / <alpha-value>)',
          500: 'rgb(var(--neutral-500-rgb) / <alpha-value>)',
          600: 'rgb(var(--neutral-600-rgb) / <alpha-value>)',
          700: 'rgb(var(--neutral-700-rgb) / <alpha-value>)',
          800: 'rgb(var(--neutral-800-rgb) / <alpha-value>)',
          900: 'rgb(var(--neutral-900-rgb) / <alpha-value>)',
        }
      }
    }
  }
}
```

**Why fonts use `var(--font-body)` instead of the RGB triplet pattern:** D-14 says triplet pattern is for color tokens only. Fonts are full strings (`'Plus Jakarta Sans', sans-serif`), not numeric channels — they don't need `<alpha-value>` substitution. Tailwind's fontFamily array entries can be CSS-var references directly.

**Note on `sans` key:** the current config maps `sans` → Plus Jakarta Sans, which is the body font. The `body` Tailwind class default is also `sans`, so this is correct. Phase 1 keeps the `sans` key (markup uses `font-sans` on the `<body>` element at line 196). The `--font-body` var name is the semantic equivalent.

### 5. Exact `<head>` Element Ordering Phase 1 Establishes

Inserted/modified positions inside `<head>`, in document order:

1. **`<meta>` tags + `<title>`** — unchanged
2. **NEW: inline FOUC `<script>`** (D-12, §3 above)
3. **MODIFIED: inline Tailwind config `<script>`** (D-07, D-13, D-14, §4 above) — was line 9, content rewritten
4. **NEW: token contract `<style>` element** (D-10, D-11, D-14, D-15, see §"Inline Recipe Comment" below for the comment header)
5. **MOVED: Tailwind CDN `<script src="https://cdn.tailwindcss.com">`** — was line 7, now positioned after the token `<style>` so generated rules can reference the vars without ambiguity
6. **UNCHANGED: Google Fonts `<link>`** (D-16) — current line 8; no value changes in Phase 1
7. **UNCHANGED: existing component `<style>` block** (~current lines 47–194) — `.slide`, `.answer-card`, `.check-card`, etc.

Then `</head>` and `<body class="bg-surface-warm text-ink font-sans">` (unchanged).

**Verification against current `index.html`:** the *current* order is `<title>` (line 6) → CDN `<script>` (line 7) → Google Fonts `<link>` (line 8) → inline Tailwind config `<script>` (lines 9–46) → component `<style>` (lines 47–194). Phase 1 changes:
- Insert FOUC `<script>` at the very top (new position 2).
- Move CDN `<script>` from position 3 to position 5 (after the new token `<style>`).
- Insert new token `<style>` at position 4.

This is the order D-10 specifies: "after the inline Tailwind config script, before the Tailwind CDN `<script>`."

### 6. Inline Recipe Comment Content (D-11)

Recommended draft (drop-in for the top of the new `<style>` block):

```css
/* =============================================================
   THEME CONTRACT
   -------------------------------------------------------------
   This block holds every brandable token in the app. The
   ":root" block below is the default (Overdrive). Each
   "[data-theme=<slug>]" block below it is a client override.

   HOW TO ADD A CLIENT THEME (for non-engineers):

   1. Copy the entire ":root { ... }" block below.
   2. Change ":root" to [data-theme="your-client-slug"].
      Slug is lowercase, dash-separated, no spaces.
      Example: [data-theme="alchemist"]
   3. Edit the values you want different from Overdrive.
      Leave the rest alone -- anything you don't override
      will use Overdrive's value.
   4. Save the file. Visit the app with
      "?client=your-client-slug" in the URL to see it.

   COLORS are written as three numbers separated by spaces
   (the R, G, B channels of the color). To convert a hex
   like "#FF9000" to this format:
     #FF9000  ->  255 144 0
   Online converters (Google "hex to rgb") do this in one step.

   FONTS are written as full CSS font stacks, e.g.
     'Space Grotesk', sans-serif
   Add new font files to the Google Fonts <link> above so they
   load with the page.

   That is the whole system. There is nothing else to learn.
   ============================================================= */
```

The comment is intentionally informal and addressable to a non-engineer. The "There is nothing else to learn." final line is load-bearing — it reflects D-11's intent that this is the single source of truth.

[ASSUMED] The Phase 1 plan-checker or Pete may want to copy-edit the prose. The structure (5 numbered steps, color-format note, font-format note, closing reassurance) is what matters; word-level edits are fine.

### 7. Verification Approach for Success Criterion #4 (Zero Visual Regression)

**Recommendation: side-by-side manual visual sweep against `main`, scripted with a single browser command.**

**The cheapest demonstrable proof:**
1. Open `index.html` from `main` branch in browser tab A.
2. Open `index.html` from `rebrand-theming` (post-Phase-1) in browser tab B.
3. Tile windows side by side. Walk through every slide and the results page, comparing pixel-level appearance.
4. Use the worktree pattern (per git-discipline rule) to have both versions accessible without branch-switching.

**Why this over pixel-diff:**
- True pixel diffs (Playwright snapshot, Percy, BackstopJS) need install + CI setup — violates single-file-no-build spirit and is overkill for a one-shot zero-diff check.
- The visual surface is small: 6 slides + 1 results page + 1 reference matrix section. ~10 minutes for a human sweep.
- Font rendering can vary between OS/browser versions, so pixel diffs would produce false positives anyway.

**Why this over programmatic check (`getComputedStyle`):**
- Programmatic checks tell you values match but don't catch *positional* regressions (a wrong z-index, a misordered flex item, a layout-shift from a forgotten `position: fixed`). A human looking at two tabs catches those instantly.
- Setting up a JS snapshot pass adds non-trivial code; humans see at a glance.

**Checklist for the sweep:**
- [ ] Slide 0 (Welcome): hero text, "Start Assessment" button color/hover, kbd-hint badge
- [ ] Slides 1–3 (radio): answer-card border colors (default + hover + selected), key-badge styling, header text, slate-500 body
- [ ] Slide 4–5 (checkboxes): check-card background, check-box icon (selected state), 2-column grid spacing, sticky Continue button
- [ ] Results hero (dark): bg-surface-dark, indigo-bordered result card, slate-700 borders, slate-100/300/400 text levels
- [ ] Wedge callout + override notice: amber-400 icon, slate-800/50 background (this one tests the opacity-modifier pattern survived)
- [ ] Reference matrix: bg-slate-50 cards, bg-indigo-100 badge, text-indigo-800 text (one of the rare stray colors — see §11)
- [ ] Footer: bg-surface-dark, text-slate-500 copy

**One programmatic backup (cheap):** in browser devtools console on the post-Phase-1 build, run:
```javascript
getComputedStyle(document.querySelector('.bg-accent')).backgroundColor
```
Should return `rgb(79, 70, 229)`. If it returns `rgba(79, 70, 229, 0)` or `var(--accent-rgb)` literally, the `<alpha-value>` substitution failed and the contract is broken.

### 8. Tailwind CDN Version Pinning

**Finding:** the `<alpha-value>` substitution pattern works on **Tailwind v3.1 and later** [CITED: https://tailwindcss.com/blog/tailwindcss-v3-1]. The CDN at `https://cdn.tailwindcss.com` serves the latest v3.x build [VERIFIED: WebFetch identified Tailwind v3.x in the CDN bundle, with the `<alpha-value>` substitution logic present in minified source].

**Recommendation:** no pinning action for Phase 1. Use the same `<script src="https://cdn.tailwindcss.com">` line. The pattern is feature-complete in v3.1 (June 2022) and the CDN has been stable on v3.x for 3+ years.

**Watchpoint:** if/when the CDN URL begins serving Tailwind v4, the `<alpha-value>` pattern is *replaced* by a different mechanism (Tailwind v4 uses CSS `@theme` blocks and the `--alpha(...)` function instead). At that point this contract would need rewriting. The CDN URL has not yet flipped to v4 as of 2026-05; Phase 1 ships under v3.x assumptions. The commit message should note "Tailwind v3.x CDN" so the assumption is greppable later.

### 9. `primary` / `primaryHover` Key Migration

**Finding:** there is no `primary` / `primaryHover` migration to do. The current `index.html` config (lines 19–23) already uses `accent` keys: `accent.DEFAULT`, `accent.hover`, `accent.muted`. Markup correspondingly uses `bg-accent`, `bg-accent-hover`, `text-accent`. [VERIFIED: grep for `primary` / `primaryHover` in `index.html` returns zero hits in either config or markup.]

**Source of the confusion in CONTEXT.md:** the `<code_context>` section mentions "current inline Tailwind config block ... already extends `theme.extend.colors` with custom `primary`, `primaryHover`" — this matches the snapshot recorded in `.planning/codebase/CONVENTIONS.md` ("Custom colors: `primary` (`#4F46E5`), `primaryHover` (`#4338CA`)"). That snapshot is stale; the file has since been refactored to use `accent` naming. [VERIFIED: `index.html` lines 19–23 show `accent: { DEFAULT, hover, muted }`, not `primary`.]

**Recommendation for Phase 1:** treat `accent` as the established name. The shape just changes from hex literals to `rgb(var(--accent-rgb) / <alpha-value>)`. No markup edits. CONVENTIONS.md should be updated to reflect reality, but that's a documentation cleanup (out of Phase 1 scope).

### 10. `slate` Utility Audit

**Finding:** 80 `slate-*` utility usages in `index.html` (not the "~101" estimated in CONTEXT.md). Breakdown:

| Utility | Count |
|---------|-------|
| `text-slate-400` | 22 |
| `border-slate-200` | 21 |
| `text-slate-500` | 20 |
| `border-slate-100` | 7 |
| `bg-slate-50` | 7 |
| `text-slate-300` | 4 |
| `border-slate-700` | 4 |
| `bg-slate-100` | 3 |
| `text-slate-600` | 2 |
| `text-slate-200` | 2 |
| `bg-slate-800` | 2 |
| `bg-slate-200` | 2 |
| `text-slate-800` | 1 |
| `text-slate-700` | 1 |
| `text-slate-100` | 1 |
| `hover:text-slate-300` | 1 |
| `border-slate-800` | 1 |

All 80 are pure utility classes in markup or inside the JS-rendered template at lines 686–697 (`renderCheckboxes`). The JS-rendered classes are **static template-string literals**, not dynamically built names — they resolve through the Tailwind config like any other class. [VERIFIED: grep `renderCheckboxes` body shows `text-slate-400` as a literal string in a template; no concatenation builds class names from data.]

**One special case — opacity modifier:** line 474 uses `bg-slate-800/50` (50% alpha on slate-800). This is the canary for the `<alpha-value>` pattern. If the triplet pattern works, this resolves correctly post-Phase-1; if hex strings were used instead, this utility would emit `background-color: #1E293B/50;` (invalid CSS) and silently drop the rule.

**No dynamic concatenation, no inline-style `slate` references.** [VERIFIED.]

### 11. Non-Utility Hex Usages (raw color values that bypass the Tailwind utility pipeline)

Grep `index.html` for raw `#[0-9A-Fa-f]{3,8}` patterns finds **three distinct categories**:

#### Category A: inline Tailwind config (lines 20–40) — REPLACED in Phase 1
These hex strings are exactly what Phase 1 rewrites. Not out-of-scope; this *is* the scope.

#### Category B: component `<style>` block (lines 47–194) — OUT OF PHASE 1 SCOPE
Literal hex values used in component CSS rules:
- Line 59: `background: #FAFAF8;` (`.slide` bg) — = current `--surface-rgb`
- Line 91, 123: `border: 1.5px solid #E2E8F0;` (answer-card, check-card borders) — = current `--neutral-200-rgb`
- Line 99, 132: `border-color: #A5B4FC; background: #F8F7FF;` (hover states) — NOT in the var contract (these are derived hovers; not Overdrive-mapped)
- Line 100, 133: `border-color: #4F46E5; background: #EEF2FF;` (selected states) — = current `--accent-rgb` + `--accent-muted-rgb`
- Line 104, 137, 184: `border: 1.5px solid #CBD5E1;` (key-badge, check-box, kbd-hint) — = current `--neutral-300-rgb`
- Line 108, 180: `color: #94A3B8;` (key-badge text, kbd-hint text) — = current `--neutral-400-rgb`
- Line 112: `border-color: #818CF8; color: #818CF8;` (key-badge hover) — NOT in the var contract
- Line 114, 143, 168: `color: #4F46E5;` / `border-color: #4F46E5; background: #4F46E5;` — = current `--accent-rgb`
- Line 162: `color: #64748B;` (result-overline) — = current `--text-muted-rgb`
- Line 173: `border-top: 1px solid rgba(79,70,229,0.2);` — RGB form of `--accent-rgb` at 20% alpha

These hex values **continue to work after Phase 1** because the file still parses them as literal colors. The visual result is unchanged. They become a Phase 2 problem (when value-flipping starts; these literals won't follow theme overrides and will create the "frankenstein" state CONTEXT.md flags). Phase 1 plans should **list them as out-of-scope, name them in the plan, and defer to Phase 2**.

**Phase 1 implication:** because Phase 1's `:root` holds *current* values, every Category B hex still matches its var-backed equivalent. Zero visual diff is preserved.

#### Category C: inline styles in markup body
- Line 460: `style="border-left: 3px solid #4F46E5;"` (result-card left border)
- Line 465: `style="background:rgba(15,23,42,0.5);"` (inset card on dark hero)
- Line 496: `style="background:rgba(245,158,11,0.15);"` (override-notice icon bg — Tailwind `amber-500` at 15%)

Same disposition as Category B: literal values that work today, will not follow theme overrides at Phase 2. **Phase 1 leaves them; flags them in the plan as Phase 2 cleanup.**

#### Category D: stray non-tokenized Tailwind utilities in markup
Grep also found three utilities outside the `slate`/`accent`/`surface`/`ink` tokenized set:
- Line 497: `text-amber-400` — Tailwind default amber, used on warning icon
- Line 557: `bg-indigo-100 text-indigo-800` — Tailwind default indigo, used on a reference-matrix badge
- Line 598: `bg-indigo-50` — Tailwind default indigo, used on a Product-Led Sales card

**These resolve through Tailwind's *default* palette, not through the inline config.** Phase 1's slate-remapping doesn't touch them — they'll continue to render as Tailwind's built-in amber/indigo values. They're a Phase 2 issue (when Phase 2 wants every brand color to flow through the contract).

**Phase 1 implication:** flag these three stray utilities in the plan as deferred cleanup. They preserve zero visual diff in Phase 1 (still render exactly as before) and become tokenization candidates in Phase 2.

### 12. Validation Architecture Section

See the dedicated `## Validation Architecture` section below.

## Common Pitfalls

### Pitfall 1: Forgetting the RGB-triplet pattern (using hex in `:root`)
**What goes wrong:** `--accent: #4F46E5;` in `:root`, then `accent: 'var(--accent)'` in the Tailwind config. Looks correct. `bg-accent` works. `bg-accent/50` silently emits invalid CSS and the rule is dropped — element renders with no background.
**Why it happens:** hex looks more natural than space-separated channels; the failure is silent (no console error) and only the opacity modifier breaks.
**How to avoid:** D-13 + §4 above. Always RGB triplet + `<alpha-value>`.
**Warning signs:** `bg-slate-800/50` on line 474 renders without a translucent dark background; wedge callout looks transparent.

### Pitfall 2: Misordering `<head>` elements (token `<style>` after CDN script)
**What goes wrong:** Token `<style>` element placed after `<script src="cdn.tailwindcss.com">`. CDN script reads the inline config (which references undefined vars), generates utility rules, applies them — but the rules now reference `var(--accent-rgb)` which doesn't exist yet because the `<style>` block hasn't been parsed. Browser falls back to no color. Page renders empty / invalid until the `<style>` is parsed.
**Why it happens:** the CDN `<script>` is currently at line 7 (before the inline config). Easy to leave it there.
**How to avoid:** explicitly move it to *after* the new token `<style>` block. The order in §5 above is the canonical one.
**Warning signs:** first-paint shows the page with no color on `bg-accent` / `bg-slate-200` elements; colors snap in milliseconds later.

### Pitfall 2b: Inline Tailwind config BEFORE CDN script
**[ADDED 2026-05-15 — surfaced during Phase 1 V-4 verification.]**
**What goes wrong:** Inline `<script>tailwind.config = {...}</script>` placed BEFORE `<script src="https://cdn.tailwindcss.com">` in document order. The inline script's `tailwind.config = ...` runs while `window.tailwind` is still undefined (CDN's IIFE hasn't executed yet) → `Uncaught ReferenceError: tailwind is not defined` → inline script aborts → CDN later loads with its default config (no `accent`, no Fraunces, no slate overrides).
**Why it happens:** A "safer" ordering instinct says "set config before the runtime reads it." False for the Tailwind CDN — the CDN ISN'T a passive consumer of a pre-existing global; its IIFE is what CREATES the global. The inline config must run AFTER the CDN.
**How to avoid:** CDN `<script>` MUST come before any inline `tailwind.config` assignment. Combined with Pitfall 2, the canonical ordering is FOUC → token `<style>` → CDN → inline config → fonts → component `<style>`.
**Warning signs:** browser console shows `Uncaught ReferenceError: tailwind is not defined`; page renders with default-browser sans-serif (no Fraunces) and no `bg-accent` (CTAs invisible). Verify with `python3 -m http.server` + DevTools console — this failure mode is NOT catchable by grep ordering assertions.

### Pitfall 3: Editing markup to add `data-theme` somewhere
**What goes wrong:** instinct says "I should also add `data-theme="overdrive"` to `<html>` to make the default explicit." Doing so means CSS keys on `[data-theme="overdrive"]` instead of `:root`, breaking the cascade-fallback policy (D-15) — a client override that omits a token now falls back to *nothing*, not to Overdrive defaults.
**Why it happens:** explicit-is-better-than-implicit instinct.
**How to avoid:** bare URL = no attribute set = `:root` wins. That's the design. Don't add a default attribute.
**Warning signs:** future client themes render with missing values (white text on white background, etc.) when they leave tokens unspecified.

### Pitfall 4: Putting the FOUC script at the bottom of `<head>`
**What goes wrong:** Tailwind CDN script runs first, generates CSS, browser starts laying out the page using `:root` defaults. *Then* FOUC script runs, flips `data-theme`, and the page re-renders. User sees a brief flash.
**Why it happens:** "script in `<head>`" instinct without specifying *first* in `<head>`.
**How to avoid:** explicit position: first child of `<head>`. Above everything else, including `<title>` if needed (though after `<meta charset>` is fine).
**Warning signs:** loading `?client=alchemist` flashes Overdrive briefly before Alchemist resolves.

### Pitfall 5: Letting Phase 1 creep into Category B/C/D hex cleanup
**What goes wrong:** plan tries to "fix" the component `<style>` block hex values as part of Phase 1. This is value-changing work (or near-it: tokenizing means rewriting `.answer-card.selected { border-color: #4F46E5; }` as `.answer-card.selected { border-color: rgb(var(--accent-rgb)); }`, which then *will* shift visually when Phase 2 changes `--accent-rgb`).
**Why it happens:** completionism. The fix is "obvious."
**How to avoid:** Phase 1 success criterion #4 is **zero visual regression** — the only way to guarantee that is to leave hex values where they are. Cataloging is OK; touching is not.
**Warning signs:** plan includes a task to "tokenize component-style hex values." Reject. That's Phase 2.

## Code Examples

### Final shape of the new `<style>` block (skeleton — populate with §2's full token list)

```html
<style>
/* =============================================================
   THEME CONTRACT
   ... (full comment from §6 above)
   ============================================================= */

:root {
  /* Accent colors */
  --accent-rgb:        79 70 229;        /* #4F46E5 */
  --accent-hover-rgb:  67 56 202;        /* #4338CA */
  --accent-muted-rgb:  238 242 255;      /* #EEF2FF */

  /* Surfaces */
  --surface-rgb:           250 250 248;  /* #FAFAF8 warm off-white */
  --surface-elev-rgb:      255 255 255;  /* white */
  --surface-dark-rgb:      15 23 42;     /* #0F172A — retired Phase 2 */
  --surface-dark-card-rgb: 30 41 59;     /* #1E293B — retired Phase 2 */

  /* Text */
  --text-rgb:        26 26 46;     /* #1A1A2E — current "ink" */
  --text-muted-rgb:  100 116 139;  /* #64748B — current slate-500 */

  /* Borders */
  --border-rgb: 226 232 240;  /* #E2E8F0 — current slate-200 */

  /* Neutral ramp (current Tailwind slate defaults) */
  --neutral-50-rgb:  248 250 252;
  --neutral-100-rgb: 241 245 249;
  --neutral-200-rgb: 226 232 240;
  --neutral-300-rgb: 203 213 225;
  --neutral-400-rgb: 148 163 184;
  --neutral-500-rgb: 100 116 139;
  --neutral-600-rgb: 71 85 105;
  --neutral-700-rgb: 51 65 85;
  --neutral-800-rgb: 30 41 59;
  --neutral-900-rgb: 15 23 42;

  /* Fonts */
  --font-display: 'Fraunces', serif;
  --font-body:    'Plus Jakarta Sans', sans-serif;
  --font-mono:    'JetBrains Mono', monospace;
}

/* ========== OVERDRIVE (default — values held by :root) ========== */
/* No override block needed; :root IS the Overdrive default after Phase 2.
   In Phase 1, :root holds the current identity; Phase 2 rewrites these values. */

/* Future client overrides go here, separated by dividers:
   ========== <CLIENT-SLUG> ========== */
</style>
```

### Final shape of the modified inline Tailwind config

See §4 above for the full BEFORE/AFTER.

### Final shape of the FOUC script

See §3 above.

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Tailwind config with hex literals + theme switch via class on body | Tailwind config with `rgb(var(...) / <alpha-value>)` + theme switch via `data-theme` on `<html>` + URL param FOUC script | Tailwind v3.1 (June 2022) introduced `<alpha-value>` placeholder; community pattern crystalized 2023–2024 | Enables opacity-modifier utilities (`bg-accent/50`) under a CSS-variable-driven theme contract |
| `dark:` variant for light/dark toggle | `[data-theme="<slug>"]` selectors for arbitrary themes (one per client) | Pattern established by modern UI libraries (Radix, shadcn/ui) 2022–2024 | Generalizes from light/dark binary to arbitrary multi-theme; works for per-client rebrand |

**Deprecated/outdated:**
- **`tailwind.config.js` with separate stylesheet build** — irrelevant here because we're locked single-file-no-build; mentioned only to note the v4 migration discussion when it becomes relevant.

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | `--surface-elev-rgb` should be a separate token from `--surface-rgb` and held at `255 255 255` (white) in Phase 1. | §2 Recommended token list | Adds one unused token in Phase 1; trivial to remove. Pete may prefer to defer. |
| A2 | The exact wording of the inline recipe comment (§6) is correct in tone for a non-engineer audience. | §6 | Pete may rewrite the prose; structure should hold. |
| A3 | Side-by-side visual sweep is the cheapest acceptable proof of zero visual regression. | §7 | If Pete wants a stricter check (Playwright snapshot), this can be added; cost is non-trivial setup. |
| A4 | Tailwind CDN at `https://cdn.tailwindcss.com` will continue serving v3.x and not silently flip to v4 during this phase. | §8 | If CDN flips mid-phase, the `<alpha-value>` pattern breaks; mitigation is to pin to a specific v3 CDN URL. |
| A5 | Categories B (component `<style>`), C (inline-style hex), D (stray Tailwind defaults) hex usages are correctly deferred to Phase 2. | §11 | If any of them must move to Phase 1, scope creep risks the zero-visual-diff guarantee. |
| A6 | Keeping the existing `accent.muted` key (which maps to `#EEF2FF`, the selected-card background) is correct — it's tokenized through `--accent-muted-rgb` in Phase 1. | §2, §4 | This token may not belong in the Overdrive contract; Phase 2 may rename/retire it. Phase 1 risk is zero. |

**If this table seems heavy:** items A1, A2, A3 are Claude-discretion fills (per CONTEXT.md). A4 is a real external dependency. A5–A6 are Phase 1/Phase 2 boundary calls. The planner should flag A1 and A6 for Pete-level confirmation if the plan-checker surfaces concerns.

## Open Questions

1. **Should `--surface-elev-rgb` exist in Phase 1?** (A1)
   - What we know: D-05 lists `--surface-elev` in the example slug list. Current code uses `background: white;` on answer cards, which is an implicit surface-elev.
   - What's unclear: Pete hasn't explicitly confirmed this token is in scope for Phase 1 vs. Phase 2.
   - Recommendation: include it in Phase 1's `:root` block (cheap; consistent with D-05 example list); the plan-checker can revisit.

2. **Should the empty Overdrive comment block (`/* ========== OVERDRIVE ========== */`) exist in Phase 1?**
   - What we know: D-10 says theme blocks are separated by dividers in the existing comment-divider style. Overdrive is the default-held-by-`:root`, so there is no `[data-theme="overdrive"]` block in Phase 1 or Phase 2.
   - What's unclear: include the divider as a placeholder for documentation purposes, or omit it because there's nothing to divide?
   - Recommendation: omit the empty divider; the recipe comment plus `:root` block explains the default. Add the first divider when Phase 3 introduces the first override block.

3. **Should Phase 1 explicitly catalog Category B/C/D hex values in a code comment for Phase 2 to find later?**
   - What we know: Phase 1 leaves these alone (zero visual diff).
   - What's unclear: should the plan create an artifact (TODO comments, a `<!-- TODO -->` block, a checklist in the planning dir) so Phase 2 doesn't have to re-discover them?
   - Recommendation: write a brief "Phase 2 cleanup list" into the Phase 1 plan's hand-off section, listing the line numbers from §11 of this document. Don't litter `index.html` with TODO comments — they violate the single-file-clean ethos.

## Environment Availability

Phase 1 is config-only browser work. No external tool dependencies beyond what's already in `index.html` (Tailwind CDN, Google Fonts CDN). Skipping the dependency table — none apply.

**One implicit dependency:** verification depends on having a browser to render `index.html`. Trivially satisfied; Pete is on macOS Darwin 25.3 with a working browser per environment context.

## Validation Architecture

**Nyquist validation status:** unknown — `.planning/config.json` not present at time of research. Default is "include the section."

### Test Framework

No formal test framework. The project has no `package.json`, no test runner, no CI. Validation is browser-based.

| Property | Value |
|----------|-------|
| Framework | Manual browser inspection + devtools console |
| Config file | None |
| Quick run command | `python3 -m http.server 8080` (from project root), then visit `http://localhost:8080` |
| Full suite command | (same) |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| REQ-build-theming-architecture (criterion 1: single `:root` block) | Token defs live in one `:root` block at top of `index.html` | manual-grep | `grep -nE '^:root \{' index.html` should return exactly one line, near top of file | ✅ check is one shell command |
| REQ-build-theming-architecture (criterion 2: Tailwind resolves through vars) | Editing a single `--*-rgb` value in `:root` changes the rendered output without other edits | manual-browser | Open index.html, in devtools console run `document.documentElement.style.setProperty('--accent-rgb', '255 0 0')`; verify `bg-accent` elements turn red | ✅ devtools |
| REQ-build-theming-architecture (criterion 3: switch mechanism wired) | Visiting `?client=test` sets `data-theme="test"` on `<html>` before paint | manual-browser | Open `index.html?client=test`, devtools console: `document.documentElement.getAttribute('data-theme')` should return `'test'` | ✅ devtools |
| REQ-build-theming-architecture (criterion 4: zero visual regression with no override) | Side-by-side compare `main` vs. `rebrand-theming` HEAD | manual-visual | Open both branches' `index.html` in adjacent tabs, walk the §7 checklist | ✅ checklist in §7 |
| Pattern: opacity modifier still works | `bg-slate-800/50` (line 474) resolves to translucent dark bg | devtools | `getComputedStyle(document.querySelector('#wedge-callout')).backgroundColor` should be `rgba(30, 41, 59, 0.5)` | ✅ devtools |
| FOUC absence | Loading `?client=alchemist` does not flash Overdrive identity before resolving | manual-visual | Throttle network to "Slow 3G" in devtools, hard-reload — observe first paint | ✅ devtools |

### Sampling Rate

- **Per task commit:** the responsible task's manual check (one of the rows above)
- **Per wave merge:** all six rows
- **Phase gate:** full §7 visual sweep against `main`

### Wave 0 Gaps

None. The project has no test infrastructure and Phase 1 doesn't establish any. Manual checks via `python3 -m http.server` + browser devtools cover the surface. If Pete wants automated visual regression, a future phase could add Playwright + GitHub Actions; not in Phase 1 scope.

## Sources

### Primary (HIGH confidence)
- **`index.html`** (current state on `rebrand-theming` branch) — read directly for current hex values (lines 19–40), current Tailwind config shape, current component-style hex values (lines 47–194), markup-side raw hex (lines 460, 465, 496), grep-based utility counts.
- **`.planning/phases/01-theming-architecture-foundation/01-CONTEXT.md`** — locked decisions D-01 through D-16, claude's-discretion items, deferred items.
- **`.planning/REQUIREMENTS.md`** — REQ-build-theming-architecture acceptance criteria.
- **`.planning/ROADMAP.md`** — Phase 1 success criteria.
- **`.planning/PROJECT.md`** — project-wide constraints.
- **`docs/design/design-system-alpha-overdrive.md`** — Overdrive token slug naming (Phase 2 reference; Phase 1 borrows slug names only).
- **Tailwind CSS v3.1 release post** — [https://tailwindcss.com/blog/tailwindcss-v3-1](https://tailwindcss.com/blog/tailwindcss-v3-1) — canonical source for `<alpha-value>` placeholder pattern.

### Secondary (MEDIUM confidence)
- **WebFetch against `https://cdn.tailwindcss.com`** — confirmed CDN serves Tailwind v3.x with `<alpha-value>` substitution logic present in minified source.
- **WebFetch against `https://v3.tailwindcss.com/docs/customizing-colors`** — confirmed pattern is documented in v3 docs (though specific section content didn't load fully).
- **WebSearch** — community pattern consensus for `<alpha-value>` + CSS vars (multiple corroborating sources: Tailwind GitHub PR #8501, Discussion #10347, ProTailwind workshop, miguelgrinberg.com FOUC guide).

### Tertiary (LOW confidence)
- Inline recipe comment exact wording (§6) — drafted by Claude; needs Pete-review before commit.
- `--surface-elev-rgb` inclusion decision — flagged as A1 assumption.

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — current `index.html` directly read; Tailwind v3.x CDN behavior verified via WebFetch + release notes.
- Architecture: HIGH — `<head>` ordering is well-established CSS-variable-themable pattern; CONTEXT.md D-10/D-12 explicit on order.
- Pitfalls: HIGH — Pitfalls 1 and 4 are well-documented community knowledge; Pitfalls 2, 3, 5 are derived from this codebase's specifics.
- Token values (§2 list): HIGH for the "Phase 1 holds current values" reading; MEDIUM for the discretionary token names (`--surface-elev-rgb` in particular) — flagged in Assumptions Log.
- Validation Architecture: MEDIUM — no test framework exists; manual checks proposed are reasonable but not formally executable.

**Research date:** 2026-05-15
**Valid until:** 2026-06-15 (30 days — stable: CDN behavior unlikely to flip, CONTEXT.md is locked, codebase change rate is low on this branch)
