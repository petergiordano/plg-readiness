# Phase 2: Overdrive Default Theme Migration — Pattern Map

**Mapped:** 2026-05-16
**Files analyzed:** 1 file modified (`index.html`), 0 files created
**Analogs found:** 5 / 5 (all in-file)
**Edit categories:** Cat A (token contract) · Tailwind config · Cat B (component `<style>` literals) · Cat C (inline-style hex) · Cat D (markup utilities)

---

> **Framing for this phase.** This is a single-file static web app. There are no other source files. The standard "find an existing file to copy patterns from" framing does not apply — every Phase 2 edit modifies sections of `index.html` in place. Accordingly, the "analogs" are **patterns already established within `index.html`** by Phase 1 (token-RGB-triplet syntax, RGB-triplet + `<alpha-value>` Tailwind binding, comment-divided `:root` blocks, Pattern S2 IIFE FOUC, V-4-corrected `<head>` ordering). For each Phase 2 edit category below, the "Analog" column points to the Phase 1 site that defines the pattern to replicate, and concrete code excerpts show both the existing pattern (to follow structurally) and the current Phase 2 site state (the literal to migrate away from).

**Re-grep verification at write-time (2026-05-16, HEAD `b1af5f7`):** Every line anchor cited below was independently re-grepped — both start AND end of any range — per CONTEXT.md `<specifics>` "re-grep both START AND END" instruction.

---

## Edit Classification

Because no new files are created, classification is per-**edit-category**, not per-file. Each row maps a Phase 2 edit category to the in-file Phase 1 site that establishes the pattern to follow.

| Edit Category | Role | Data Flow | Location | Closest Analog (in-file) | Match Quality |
|---------------|------|-----------|----------|--------------------------|---------------|
| **Cat A: Token contract value flips** | declarative token store (CSS custom properties) | parse-time CSS that Tailwind utilities read via `var(...)` | `index.html` lines 13–84 (`<style>` containing `:root`) | Same block — Phase 1's existing `:root` shape | **exact** (same block, value flips only; +2 tokens added; 2 tokens deleted) |
| **Tailwind config rewires** | declarative theme config (consumed at parse time by CDN's IIFE) | reads `:root` tokens through `rgb(var(--*) / <alpha-value>)` pattern | `index.html` lines 86–123 (`<script>` containing `tailwind.config`) | Same block — Phase 1's existing `accent`/`surface`/`slate` namespaces | **exact** (same block, add `surface.elev`, add `yellow:` namespace, delete `surface.dark`/`surface.dark-card`, flip `display` fontFamily fallback) |
| **Cat B: Component `<style>` literal migration** | component-level CSS (resting/hover/selected states for `.answer-card`, `.check-card`, `.key-badge`, `.check-box`, `.kbd-hint`, `.result-overline`, `.phase-overline`, `.phase-rule`) | reads `:root` tokens at parse time via `rgb(var(--*-rgb))` and `rgb(var(--*-rgb) / α)` | `index.html` lines 125–272 (`<style>` block) at 18 sites enumerated below | Phase 1's `:root` declarations + the Tailwind config's `<alpha-value>` pattern (lines 97–117) | **role-match** (Phase 1 did NOT migrate these — D-08 zero-visual-diff guarantee held them as literals; Phase 2 migrates per the catalog Phase 1 SUMMARY locked at 01-01-SUMMARY.md lines 124–139) |
| **Cat C: Inline-style hex migration** | one-off declarative styles in body markup (border-left accent, callout-bg tints, icon-bg tints) | inline `style="..."` reading `var(...)` via `rgb(var(--*-rgb))` | `index.html` lines 538, 543, 574 | **NO existing in-file analog** — Phase 1 left these as raw hex; the pattern is being established by Phase 2 itself per D-02/D-03/D-10 and matches the Tailwind config's `rgb(var(--*-rgb) / α)` form (lines 97–117) used in the analogous role | **convention-match** (no prior site uses var-driven inline-style — first instances) |
| **Cat D: Body markup utility renames** | Tailwind utility class names on body elements (no CSS authored; resolves through Tailwind config + `:root`) | parse-time Tailwind utility generation reads config from line 86–123 block | `index.html` results region (lines 530–704) at 10 sites enumerated below | Existing Tailwind utility usage that already routes through `:root` tokens (e.g., `bg-accent` line 278, `bg-surface-warm` line 274, `text-slate-500` line 603, `text-ink` line 602, `font-display` line 541) | **exact** (same utility-name pattern; Phase 2 swaps to differently-named utilities that resolve through the same contract) |

---

## Phase 1 patterns to replicate (the structural analogs)

These are the in-file patterns Phase 2 must follow. Each excerpt is from the current `index.html` post-Phase-1 state.

### Pattern P-1: Token declaration in `:root` — RGB-triplet + comment-divided blocks

**Source:** `index.html` lines 47–82 (current Phase 1 `:root` block).

**Excerpt (lines 47–66):**
```css
/* ========== :ROOT DEFAULTS (Overdrive — current Phase 1 values) ========== */
:root {
    /* Accent colors (current indigo) */
    --accent-rgb:        79 70 229;        /* #4F46E5 */
    --accent-hover-rgb:  67 56 202;        /* #4338CA */
    --accent-muted-rgb:  238 242 255;      /* #EEF2FF */

    /* Surfaces (current warm off-white + dark hero — dark tokens retire in Phase 2) */
    --surface-rgb:           250 250 248;  /* #FAFAF8 */
    --surface-elev-rgb:      255 255 255;  /* white — implicit on .answer-card / .check-card */
    --surface-dark-rgb:      15 23 42;     /* #0F172A — retired Phase 2 */
    --surface-dark-card-rgb: 30 41 59;     /* #1E293B — retired Phase 2 */

    /* Text (current ink + dominant slate-500) */
    --text-rgb:        26 26 46;     /* #1A1A2E */
    --text-muted-rgb:  100 116 139;  /* #64748B */

    /* Border (dominant slate-200) */
    --border-rgb: 226 232 240;  /* #E2E8F0 */
```

**Pattern rules to replicate in Phase 2:**
1. Token name: `--<role>-rgb:` (kebab-case, `-rgb` suffix for all color tokens).
2. Value: three space-separated integers (no commas, no `rgb()` wrapper, no hex). Format: `R G B`.
3. Trailing hex comment: `/* #HEXVALUE */` on the same line.
4. Comment-divided logical groups (D-10): `/* ========== Header ========== */` for top-level sections; `/* Block name */` for sub-blocks inside the `:root` block.
5. Retirement annotation precedent: lines 57–58 already carry `/* #HEX — retired Phase 2 */` inline — Phase 2 simply deletes these two lines.

**Phase 2 application:**
- Flip values in place for: `--accent-rgb` (line 50), `--accent-hover-rgb` (line 51), `--accent-muted-rgb` (line 52), `--surface-rgb` (line 55), `--text-rgb` (line 61), `--text-muted-rgb` (line 62), `--border-rgb` (line 65), `--neutral-50-rgb` through `--neutral-900-rgb` (lines 68–77), `--font-display` (line 80).
- Keep value unchanged: `--surface-elev-rgb` (line 56), `--font-body` (line 81), `--font-mono` (line 82).
- Delete lines 57–58 (`--surface-dark-rgb`, `--surface-dark-card-rgb`).
- Insert 2 new tokens with their own `/* ========== Secondary palette ========== */` divider (RESEARCH Q-4 recommendation: between neutral ramp block end at line 77 and Fonts block at line 79):
  ```css
  /* ========== Secondary palette ========== */
  --brand-soft-rgb:      255 229 153;  /* #FFE599 Light Yellow */
  --brand-secondary-rgb: 241 194 50;   /* #F1C232 Golden Yellow */
  ```

---

### Pattern P-2: Tailwind config consumer — `rgb(var(--*) / <alpha-value>)`

**Source:** `index.html` lines 95–118 (current Phase 1 `colors:` extend block).

**Excerpt (lines 95–118):**
```javascript
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
        ...
        900: 'rgb(var(--neutral-900-rgb) / <alpha-value>)',
    }
}
```

**Pattern rules to replicate in Phase 2:**
1. Every color extension uses the literal template string `'rgb(var(--<token>-rgb) / <alpha-value>)'`. No hex, no commas, no `rgba()`. The `<alpha-value>` placeholder is Tailwind v3.1+ canonical [VERIFIED via Context7 `/tailwindlabs/tailwindcss.com`; v3.1 blog post].
2. Whitespace inside the `rgb(...)` literal is preserved for column alignment (see accent block lines 97–99: padding before `/` keeps the `<alpha-value>` column aligned). Pure aesthetics; Tailwind ignores intra-string whitespace.
3. Nested object keys use the Tailwind utility-name convention (`accent.DEFAULT` → `bg-accent`; `accent.hover` → `bg-accent-hover`; `slate.50` → `bg-slate-50`).
4. Hyphenated keys go in single quotes: `'dark-card'` → `bg-surface-dark-card`.
5. fontFamily entries (lines 90–94) use `['var(--font-<role>)', '<fallback>']` array form, not the `<alpha-value>` pattern.

**Phase 2 application:**
- Flip `display` fallback (line 92): `['var(--font-display)', 'serif']` → `['var(--font-display)', 'sans-serif']`.
- Delete lines 103–104 (`dark:` and `'dark-card':` entries inside `surface:` object).
- Insert one new entry inside `surface:` object (after `warm:` line 102, before closing brace line 105):
  ```javascript
  elev:        'rgb(var(--surface-elev-rgb)      / <alpha-value>)',
  ```
- Insert new `yellow:` namespace after the `slate:` block (after line 118 closing brace, before the outer `}` of the `colors:` block — per RESEARCH Q-6 recommendation):
  ```javascript
  yellow: {
      100: 'rgb(var(--brand-soft-rgb)      / <alpha-value>)',
      400: 'rgb(var(--brand-secondary-rgb) / <alpha-value>)',
  }
  ```
- Recommendation per RESEARCH § File-Level Scope: declare ONLY `yellow.100` and `yellow.400` (the two stops the markup consumes), not the full Tailwind yellow palette. Matches Phase 1's `accent` (3 stops only) restraint.

---

### Pattern P-3: Cat B literal → var-driven rewrite

**Source:** Phase 1 SUMMARY hand-off catalog (01-01-SUMMARY.md lines 124–139) + the `rgb(var(--*) / α)` form Phase 1 established in the Tailwind config (P-2 above). Phase 1 did not migrate these — D-08 zero-visual-diff held them as literals — but the rewrite-form is locked.

**Current state (excerpt from `index.html` lines 169–192):**
```css
/* ── Answer cards (radio) ─────────────────────── */
.answer-card {
    ...
    border: 1.5px solid #E2E8F0;
    ...
    background: white;
}
.answer-card:hover             { border-color: #A5B4FC; background: #F8F7FF; }
.answer-card.selected          { border-color: #4F46E5; background: #EEF2FF; }
.key-badge {
    ...
    border: 1.5px solid #CBD5E1;
    ...
    font-size: 11px; color: #94A3B8;
    ...
}
.answer-card:hover .key-badge  { border-color: #818CF8; color: #818CF8; }
.answer-card.selected .key-badge {
    border-color: #4F46E5; color: #4F46E5; background: white;
}
```

**Phase 2 rewrite pattern (grouped by sub-category):**

**(P-3a) Resting borders → `rgb(var(--border-rgb))` or `rgb(var(--neutral-300-rgb))`:**
```css
/* Before */
border: 1.5px solid #E2E8F0;        /* lines 169, 201 */
border: 1.5px solid #CBD5E1;        /* lines 182, 215, 262 */
/* After */
border: 1.5px solid rgb(var(--border-rgb));        /* lines 169, 201 */
border: 1.5px solid rgb(var(--neutral-300-rgb));   /* lines 182, 215, 262 */
```

**(P-3b) Hover states → alpha-derived from `--accent-rgb` (D-11 — the new pattern Phase 2 establishes):**
```css
/* Before */
.answer-card:hover { border-color: #A5B4FC; background: #F8F7FF; }              /* line 177 */
.answer-card:hover .key-badge { border-color: #818CF8; color: #818CF8; }        /* line 190 */
.check-card:hover  { border-color: #A5B4FC; background: #F8F7FF; }              /* line 210 */
/* After */
.answer-card:hover { border-color: rgb(var(--accent-rgb) / 0.4); background: rgb(var(--accent-rgb) / 0.06); }
.answer-card:hover .key-badge { border-color: rgb(var(--accent-rgb) / 0.4); color: rgb(var(--accent-rgb) / 0.4); }
.check-card:hover  { border-color: rgb(var(--accent-rgb) / 0.4); background: rgb(var(--accent-rgb) / 0.06); }
```

The 0.4 / 0.06 alphas are Phase 2's locked hover intensities (D-11) — same pattern as the Tailwind config's `<alpha-value>` substitution (P-2), but with literal alpha values inside raw CSS instead of the Tailwind placeholder.

**(P-3c) Selected states → `rgb(var(--accent-rgb))` + `rgb(var(--accent-muted-rgb))`:**
```css
/* Before */
.answer-card.selected   { border-color: #4F46E5; background: #EEF2FF; }              /* line 178 */
.check-card.selected    { border-color: #4F46E5; background: #EEF2FF; }              /* line 211 */
.check-card.selected .check-box { border-color: #4F46E5; background: #4F46E5; }      /* line 221 */
.answer-card.selected .key-badge { border-color: #4F46E5; color: #4F46E5; background: white; }  /* line 192 */
/* After */
.answer-card.selected   { border-color: rgb(var(--accent-rgb)); background: rgb(var(--accent-muted-rgb)); }
.check-card.selected    { border-color: rgb(var(--accent-rgb)); background: rgb(var(--accent-muted-rgb)); }
.check-card.selected .check-box { border-color: rgb(var(--accent-rgb)); background: rgb(var(--accent-rgb)); }
.answer-card.selected .key-badge { border-color: rgb(var(--accent-rgb)); color: rgb(var(--accent-rgb)); background: rgb(var(--surface-elev-rgb)); }
```

Note line 192's `background: white` migrates to `rgb(var(--surface-elev-rgb))` per RESEARCH § File-Level Scope "Note on lines 192, 262" + Q-3 recommendation. This wires the Phase-1-declared-but-unconsumed `--surface-elev-rgb` token. Same decision applies to line 262 (`.kbd-hint span`).

**(P-3d) Text colors → `rgb(var(--text-muted-rgb))` / `rgb(var(--accent-rgb))` / `rgb(var(--neutral-400-rgb))`:**
```css
/* Before */
color: #94A3B8;                /* lines 186 (.key-badge), 258 (.kbd-hint) */
color: #64748B;                /* line 240 (.result-overline) */
color: #4F46E5;                /* line 246 (.phase-overline) */
border-top: 1px solid rgba(79,70,229,0.2);  /* line 251 (.phase-rule) */
/* After */
color: rgb(var(--neutral-400-rgb));         /* lines 186, 258 */
color: rgb(var(--text-muted-rgb));          /* line 240 — semantic intent "muted text" */
color: rgb(var(--accent-rgb));              /* line 246 */
border-top: 1px solid rgb(var(--accent-rgb) / 0.2);  /* line 251 — alpha-on-accent */
```

**(P-3e) `.slide` background → `rgb(var(--surface-rgb))`:**
```css
/* Before (line 137) */
background: #FAFAF8;
/* After */
background: rgb(var(--surface-rgb));
```

This makes the component honor the contract — `--surface-rgb` flips to `#FFF8F0` in Block 2, and `.slide` automatically picks it up.

---

### Pattern P-4: Inline-style with var-driven RGB

**Source:** No existing in-file analog. Phase 1's only inline-style use case was `style="width:0%"` on `#progress-fill` (line 278) — a runtime-managed value, not a brand color. Phase 2 introduces var-driven inline-style as a new pattern for one-off structural elements (orange left-borders on cards, soft-color callout bgs, icon-bg tints).

**Pattern shape (Phase 2 convention to establish):**
```html
style="<css-property>: <value-with-token>;"
```
where `<value-with-token>` follows the same form as the Tailwind config (P-2):
```
rgb(var(--<token>-rgb))                 /* opaque */
rgb(var(--<token>-rgb) / <decimal-alpha>)  /* alpha-modulated */
```

**Current state (3 sites — all in results page region):**

**Line 538** (main result card left-border accent):
```html
<div class="bg-surface-dark-card rounded-xl border border-slate-700 overflow-hidden" style="border-left: 3px solid #4F46E5;">
```
→ After:
```html
<div class="bg-surface-elev rounded-xl border border-slate-200 overflow-hidden" style="border-left: 3px solid rgb(var(--accent-rgb));">
```
(Class changes are Cat D — see P-5; inline-style change is Cat C.)

**Line 543** (wedge inner recommendation card bg, currently dark-on-dark — needs migration since dark surfaces retire):
```html
<div class="rounded-lg p-5 border border-slate-700" style="background:rgba(15,23,42,0.5);">
```
→ After (per RESEARCH § File-Level Scope wedge callout recommendation):
```html
<div class="rounded-lg p-5 border border-slate-200 bg-slate-50">
```
The inline `style="..."` drops entirely; the bg comes from the re-themed `bg-slate-50` utility (which post-Phase-2 resolves to warm-50 via `--neutral-50-rgb`).

**Line 574** (override-notice warning icon bg, currently amber-tinted):
```html
<div class="flex-shrink-0 w-10 h-10 rounded-lg flex items-center justify-center" style="background:rgba(245,158,11,0.15);">
```
→ After (per D-10 + RESEARCH recommendation — keeps the 0.15-alpha visual weight, retones to golden-yellow):
```html
<div class="flex-shrink-0 w-10 h-10 rounded-lg flex items-center justify-center" style="background: rgb(var(--brand-secondary-rgb) / 0.15);">
```

**Pattern rules:**
1. Inline-style is acceptable for **structural brand-element accents** (orange left-borders on cards, soft alpha tints for icon-bgs) when the corresponding Tailwind utility either does not exist (`bg-surface-elev` is being added in Phase 2 itself but won't cover left-border-thickness shapes) or would be more verbose than the inline form. Default preference remains Tailwind utility.
2. Inline-style values use the same `rgb(var(--<token>-rgb))` or `rgb(var(--<token>-rgb) / α)` form as the Tailwind config — single source of truth holds.
3. No raw hex in inline-style values. (V-8 grep will catch any: `grep -nE 'style="[^"]*#[0-9A-Fa-f]{3,6}"' index.html` must return zero matches except documentation comments inside the recipe header — and that header uses `#FF9000` only in a comment, not in a `style="..."` attribute.)

---

### Pattern P-5: Markup utility class swaps (Cat D)

**Source:** Existing in-file Tailwind utility usage that already resolves through the `:root` contract. Phase 2 replaces utility class names; the underlying class-resolution mechanism is unchanged from Phase 1.

**Existing analog excerpts (the pattern is already pervasive):**
```html
<!-- Line 274 — body bg via surface token -->
<body class="bg-surface-warm text-ink font-sans">
<!-- Line 278 — accent token on progress fill -->
<div id="progress-fill" class="bg-accent" style="width:0%"></div>
<!-- Line 324 — CTA combining accent + accent-hover utility classes -->
<a class="inline-flex items-center gap-3 px-7 py-3.5 bg-accent text-white font-semibold rounded-lg hover:bg-accent-hover transition-colors text-base">
<!-- Line 541 — display font on a heading -->
<h2 id="result-title" class="font-display text-3xl font-bold text-slate-100 mb-4 leading-tight"></h2>
<!-- Line 603 — secondary text via slate utility -->
<p class="text-base text-slate-500 max-w-2xl">
```

**Phase 2 application — 10 markup edit sites in results page region (lines 530–704):**

| Line | Current markup utility | Phase 2 swap | Pattern source |
|------|------------------------|--------------|----------------|
| 533 | `<div class="bg-surface-dark pt-20 pb-16 md:pb-24">` | `<section class="bg-surface-warm pt-20 pb-16 md:pb-24 border-t-[4px] border-accent">` (per D-05(a) + Q-5 recommendation) | `bg-surface-warm` (line 274), `border-accent` follows accent-utility pattern (line 278) |
| 538 | `bg-surface-dark-card rounded-xl border border-slate-700` (+ inline-style — see P-4) | `bg-surface-elev rounded-xl border border-slate-200` (new `surface.elev` utility added in Tailwind config) | `bg-surface-warm` (line 274) — same `bg-surface-*` pattern, new variant |
| 541 | `text-slate-100` | `text-ink` | `text-ink` (line 602, 619, 672, 681, 690) — pattern already in use elsewhere |
| 542 | `text-slate-400` | `text-slate-500` | `text-slate-500` (line 603, 622, 633) — re-themes through `--neutral-500-rgb` |
| 543 | `border-slate-700` | `border-slate-200 bg-slate-50` (per P-4 above) | `border-slate-200` (line 597, 610) — existing pattern |
| 544 | `text-slate-300` | `text-ink` | (same as 541) |
| 545 | `text-slate-400` | `text-slate-500` | (same as 542) |
| 552 | `bg-slate-800/50 rounded-xl border border-slate-700 p-6` | drop `bg-slate-800/50` and `border border-slate-700`; add `bg-surface-elev` + orange top-strip via inline style `border-top: 5px solid rgb(var(--accent-rgb));` (D-03) OR `border-t-[5px] border-accent` arbitrary-value | inline-style accent rule = P-4; `bg-surface-elev` = new utility |
| 560–565 | `text-slate-200`, `text-slate-300`, `text-slate-400` | `text-ink`, `text-slate-600`, `text-slate-500` (light-mode equivalents) | All three target utilities already in active use |
| 572 | (same shape as 552) | (same treatment as 552) | (same) |
| 574 | inline style (Cat C — see P-4) | (Cat C migration per P-4) | P-4 |
| 575 | `text-amber-400` | `text-yellow-400` (resolves through `--brand-secondary-rgb` per D-12) | New `yellow:` namespace from Tailwind config edit |
| 580–581 | `text-slate-200`, `text-slate-400` | `text-ink`, `text-slate-500` | (existing utilities) |
| 589 | `text-slate-500 hover:text-slate-300` (lightens on hover — broken on light bg) | `text-slate-500 hover:text-slate-700` (darkens on hover) | Same `text-slate-*` family, different stop — existing utility pattern |
| 597 | `bg-white border-t border-slate-200 py-16 md:py-24` | `bg-surface-warm border-t-[4px] border-accent py-16 md:py-24` (D-05(b) + D-01 one-bg) | Same `bg-surface-warm` + accent-border pattern as Cat D line 533 |
| 635 | `bg-indigo-100 text-indigo-800` | `bg-yellow-100 text-ink` (per R-2 recommendation — yellow-bg signals secondary tier; `text-ink` restores WCAG AA contrast) | New `yellow:` namespace + existing `text-ink` |
| 676 | `bg-indigo-50` | `bg-yellow-100` (per D-09 — PLS card icon bg) | New `yellow:` namespace |
| 698 | `bg-surface-dark border-t border-slate-800 py-10` | `bg-surface-warm border-t-[4px] border-accent py-10` (D-04 + D-05(c) — one orange rule does both jobs) | Same pattern as Cat D lines 533, 597 |

**Pattern rules:**
1. Tailwind utility class names follow Tailwind's standard naming. Phase 2 utility-name swaps that resolve through new Tailwind config entries (`bg-surface-elev`, `bg-yellow-100`, `text-yellow-400`) require the Tailwind config edit to land **before or concurrently with** the markup edit. Block 3 (config edit) must land before Block 6 (markup edit) per RESEARCH Implementation Approach.
2. Arbitrary-value utilities (`border-t-[4px]`) are Tailwind-supported and acceptable for one-off thicknesses that don't justify a config entry.
3. Slate utility names are kept (`bg-slate-50`, `text-slate-500`, `border-slate-200`) per D-08 — they auto-re-theme through the `--neutral-*-rgb` flips in Block 2. Semantic mismatch ("slate" name → warm-gray render) is accepted cost.

---

## Shared patterns (cross-cutting across all 5 edit categories)

### S-1: RGB-triplet + `<alpha-value>` pattern (Phase 1 D-13 — Phase 2 extends to D-11 hovers + D-12 yellow tokens)

**Source:** `index.html` lines 97–117 (Tailwind config) + Phase 1 D-13 lock.

**Apply to:** Every new color token Phase 2 introduces. Every Tailwind config color entry. Every CSS hover/selected/border declaration in Cat B. Every Cat C inline-style.

```javascript
/* In Tailwind config */
'rgb(var(--<token>-rgb) / <alpha-value>)'

/* In raw CSS (Cat B) — replace <alpha-value> with literal decimal alpha */
rgb(var(--<token>-rgb))             /* opaque */
rgb(var(--<token>-rgb) / 0.4)       /* hover border (D-11) */
rgb(var(--<token>-rgb) / 0.06)      /* hover background (D-11) */
rgb(var(--<token>-rgb) / 0.2)       /* phase-rule top border */
rgb(var(--<token>-rgb) / 0.15)      /* warning-icon bg (D-10) */
```

### S-2: Comment-divider convention (Phase 1 D-10)

**Source:** `index.html` lines 47, 49, 54, 60, 64, 67, 79 (`:root` block sub-section headers) + lines 133, 148, 157, 163, 195, 225, 255 (`.slide`, `.slide-inner`, `#progress-fill`, etc. block headers in component `<style>`).

**Apply to:** The new Secondary palette block in `:root` (Phase 2's +2 tokens insert under a new `/* ========== Secondary palette ========== */` divider per Q-4).

```css
/* ========== Secondary palette ========== */
--brand-soft-rgb:      255 229 153;  /* #FFE599 Light Yellow */
--brand-secondary-rgb: 241 194 50;   /* #F1C232 Golden Yellow */
```

### S-3: V-4-corrected `<head>` ordering — do not re-order

**Source:** Phase 1 SUMMARY § "Final `<head>` ordering" + Phase 1 SUMMARY § "Research-level correction" (load-bearing).

**Apply to:** None — Phase 2 makes no ordering changes. Every Phase 2 edit modifies content **within** an existing `<head>` element (lines 7–12 FOUC, lines 13–84 token style, line 124 Google Fonts link, lines 86–123 Tailwind config) at its current position. The 6-element ordering (`FOUC < TOKEN_STYLE < CDN < CONFIG < FONTS < COMPONENT_STYLE`) is preserved exactly.

**Why this matters for PATTERNS.md:** If the planner is tempted to add a `<link rel="preconnect">` for Space Grotesk fonts (Overdrive §4 loading snippet shows it), that becomes a 7th `<head>` element AND fires a fresh D-14 browser-verify gate (BV-5). RESEARCH § "Out of scope for this research" recommends NOT adding preconnect; planner must explicitly decide. The pattern to follow is: zero new `<head>` elements unless explicitly justified.

### S-4: D-14 browser-verify on every `<head>`-touching task

**Source:** CONTEXT.md D-14; RESEARCH § Browser-Verify Required (BV-1 through BV-4); the V-4 Phase 1 ReferenceError lesson.

**Apply to:** Blocks 2, 3, 4, 5 (every commit that touches `<head>` content). Block 6 (body markup) does NOT fire D-14 but does require visual coherence verify for D-01..D-05.

This is a process pattern, not a code pattern — but it is load-bearing for the phase's correctness guarantee and must be encoded in VALIDATION.md as hard gate rows (per D-14 "NOT a single end-of-phase sweep").

### S-5: Single source of truth (Phase 1 D-11 — extends to Phase 2)

**Source:** `:root` block (lines 47–82) IS the only place token values live; the Tailwind config (lines 86–123) IS the only place utility-class → token bindings live.

**Apply to:** Every Phase 2 edit. The inline "HOW TO ADD A CLIENT THEME" recipe header (lines 14–47) remains accurate byte-for-byte after Phase 2 — Phase 2's contract growth (+2 tokens) is the only structural change, and the recipe's "edit values you want different" instruction still describes the right mental model.

---

## Edits with no in-file analog (first instances of new patterns)

| Edit | Why no analog | Phase 2 establishes pattern by analogy to |
|------|---------------|-------------------------------------------|
| Cat C inline-style with `rgb(var(--*-rgb))` value (3 sites: 538, 543, 574) | Phase 1 left these as raw hex (D-08 zero-visual-diff). No prior inline-style in-file uses the var-driven form. | The Tailwind config's `rgb(var(--*) / <alpha-value>)` form (P-2). Inline-style is just the same syntax expressed in a `style="..."` attribute. |
| D-11 alpha-derived hover treatment (3 sites: 177, 190, 210) | Phase 1's hover states stayed as `#A5B4FC` / `#F8F7FF` literals. No prior in-file hover uses the alpha-on-accent form. | The Tailwind utility `bg-accent/20` pattern that Phase 1 SUMMARY hand-off notes as an alternative for line 251 (.phase-rule's `rgba(79,70,229,0.2)`). Same mechanism — alpha multiplier on accent — expressed in raw CSS rather than Tailwind. |
| D-12 `--brand-soft-rgb` / `--brand-secondary-rgb` tokens (2 new tokens) | Phase 1 contract had no "secondary palette" tier. | Same form as existing `--accent-rgb` / `--accent-hover-rgb` / `--accent-muted-rgb` (lines 50–52) — RGB-triplet, `-rgb` suffix, trailing hex comment. |
| D-02 `bg-surface-elev` Tailwind utility (1 new entry) | Phase 1 declared `--surface-elev-rgb` in `:root` but did not wire a Tailwind consumer (per Phase 1 SUMMARY line 72). | Same form as existing `surface.warm` (line 102) — `'rgb(var(--surface-elev-rgb) / <alpha-value>)'`. |
| D-05 orange section dividers (3 sites: above main card, between result-card-group and reference matrix, above footer) | No prior section-divider element exists in the results page (current line 597 uses `border-t border-slate-200` and the dark hero at line 533 has no divider). | Same `border-t-[Npx] border-accent` Tailwind utility shape used as a one-off accent rule. |

---

## Metadata

**Analog search scope:** Single file (`index.html`) post-Phase-1. No external analogs sought (single-file static web app — no other source files exist).

**Files scanned:** 1 (`index.html`, 1002 lines).

**Re-grep verification at write-time (2026-05-16, HEAD `b1af5f7`):**
- `:root` block: opens line 48, closes line 83. ✓ Matches RESEARCH § File-Level Scope.
- Token-contract `<style>`: opens line 13, closes line 84. ✓
- Tailwind config `<script>`: opens line 86, closes line 123. ✓ (Line 92 `display:` fontFamily fallback at `'serif'`; lines 103–104 `dark:`/`'dark-card':` confirmed present.)
- Google Fonts `<link>`: line 124. ✓ (Single line, currently loads `Fraunces:opsz,wght@9..144,300;9..144,700;9..144,800` + `Plus+Jakarta+Sans:wght@400;500;600` + `JetBrains+Mono:wght@400`.)
- Component `<style>` block: opens line 125, closes line 272. ✓
- Cat B literal sites: lines 137, 169, 177, 178, 182, 186, 190, 192, 201, 210, 211, 215, 221, 240, 246, 251, 258, 262. All ✓ at write-time.
- Cat C inline-style sites: lines 538, 543, 574. All ✓ (line 538 carries `style="border-left: 3px solid #4F46E5;"`; line 543 carries `style="background:rgba(15,23,42,0.5);"`; line 574 carries `style="background:rgba(245,158,11,0.15);"`).
- Cat D markup utility sites: lines 533, 538, 541, 542, 543, 544, 545, 552, 560–565, 572, 575, 580–581, 589, 597, 635, 676, 698. All ✓ at write-time.
- CTA hover sites (R-1 risk): lines 324, 479, 515 carry `hover:bg-accent-hover` — confirms R-1's claim that `--accent-hover-rgb` MUST flip alongside `--accent-rgb` to avoid frankenstein.

**Pattern extraction date:** 2026-05-16.

**Source authority:**
- Phase 1 patterns: extracted directly from `index.html` post-Phase-1 state (HEAD `b1af5f7`). `01-01-SUMMARY.md` cross-referenced for the Cat B catalog at lines 124–139 and the V-4 corrected `<head>` ordering at lines 38–46.
- Phase 2 scope: extracted from `02-CONTEXT.md` (D-01..D-14) and `02-RESEARCH.md` (§ File-Level Scope, § Implementation Approach, § Browser-Verify Required).
- Stale codebase maps (`.planning/codebase/STACK.md`, `CONVENTIONS.md`) NOT cited per CONTEXT.md `<canonical_refs>` "codebase intel (note staleness)" warning — `index.html` re-grep is the authoritative source.
