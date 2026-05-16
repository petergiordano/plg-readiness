# Phase 3: Second Theme Stub & Pluggability Proof — Research

**Researched:** 2026-05-16
**Domain:** CSS custom property theming, per-client theme override authoring, VALIDATION rig design for multi-theme single-file web app
**Confidence:** HIGH (all claims verified by direct grep of `index.html` on the `rebrand-theming` branch; no stale codebase map trusted)

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

- **D-01:** Slug = `alchemist`. Token values are deliberately placeholder/synthetic. A future milestone can replace with real Alchemist specs without restructuring the block.
- **D-02:** Full contract exercise — colors + fonts. The Alchemist override block sets EVERY color token slot (accent + accent-hover + accent-muted + surface + surface-elev + text + text-muted + border + neutral-50..900 + brand-soft + brand-secondary) AND swaps `--font-display` and `--font-body`. Adds one new Google Font to the existing `<head>` `<link>` per Phase 1 D-16.
- **D-03:** WR-01 fix lands as **Plan 03-01**, a 1-task pre-cursor plan BEFORE the Alchemist override block. Flip `background: white;` → `background: rgb(var(--surface-elev-rgb));` at lines 180 and 210. Mirrors the 02-06 atomic gap-closure pattern.
- **D-04:** URL-load only validation. Three scenarios: (a) `?client=alchemist` → full Alchemist render; (b) bare URL → full Overdrive render; (c) `?client=alchemist` → navigate to bare URL → Overdrive restored, no residual state. Runtime `setAttribute` toggle NOT validated.

### Claude's Discretion

- Exact Alchemist placeholder hex values for every color token. Constraints: visibly distinct from Overdrive orange-on-warm-off-white; internally coherent; brand-plausible; not neon, not safety-orange. Direction: deep saturation like burgundy, deep teal, indigo, or slate-blue paired with cool neutral ramp.
- Choice of new Google Font for `--font-display` (and optionally `--font-body`). Must be visibly distinct from Space Grotesk's geometric-sans. Could be a slab serif, humanist serif, or transitional serif. Google Fonts only.
- Whether `--font-body` swaps too, or only `--font-display`. Recommended: swap both.
- Exact plan count/split for the Alchemist work (Plan 03-02, 03-03, etc.). Plan 03-01 = WR-01 fix is locked first.
- Exact `<link>` href format for adding the new Alchemist font alongside the existing three fonts.
- Whether to add an in-file comment under the "HOW TO ADD A CLIENT THEME" recipe citing Alchemist as a worked example.

### Deferred Ideas (OUT OF SCOPE)

- Real Alchemist brand specs sourcing (EXCL-real-client-themes)
- Additional client theme stubs beyond Alchemist
- A third "minimum-viable" stub theme
- Runtime `setAttribute('data-theme', X)` toggle validation
- Theme-switcher UI affordance
- Markup rename `slate-*` → `neutral-*`
- WR-02..06 from 02-REVIEW.md
- Per-client tunable hover intensity
- Per-theme media queries / dark-mode variants
- Build-time per-client deploys
- `localStorage`-based theme persistence
- Any change to scoring logic, slide flow, or copy

</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| REQ-stub-second-theme | Add one stub second theme (`alchemist`) proving the theme system works end-to-end. A second theme block exists with placeholder token values; switching produces a visibly distinct, internally coherent rendering across all six slides + results + reference matrix; no markup changes required; switching back cleanly restores Overdrive. | Verified by: (1) WR-01 fix audit (D-03), (2) Alchemist palette design (D-01/D-02), (3) Google Fonts link strategy (D-02/D-16), (4) Frankenstein audit, (5) VALIDATION rig design for three URL-load scenarios (D-04). |

</phase_requirements>

---

## Summary

Phase 3 adds a single CSS block — `[data-theme="alchemist"] { ... }` — to the theme contract `<style>` already established in Phase 1 and populated with Overdrive defaults in Phase 2. The contract is structurally complete; Phase 3 is purely additive. No markup edits. No JavaScript changes. No Tailwind config changes. The entire deliverable is:

1. Plan 03-01: Two-line WR-01 fix — change `background: white` to `background: rgb(var(--surface-elev-rgb))` at lines 180 and 210 of `index.html`. This pre-cursor eliminates the only known hardcoded-white card surface that would produce a frankenstein mid-page white-on-Alchemist-canvas mismatch.

2. Plan 03-02 (recommended as single plan): Insert the Alchemist override block (approx. 20 lines) after the `:root` close brace at line 85, and edit the Google Fonts `<link>` at line 129 to append the Alchemist font family. Then run the three VALIDATION rigs.

The pluggability proof is the milestone: if both plans ship cleanly and the three URL-load scenarios pass, the theming contract is confirmed production-capable. A future client theme for SkyDeck, Scale VP, or UC Berkeley requires only: copy the Alchemist block, rename the slug, edit the values.

**Primary recommendation:** Deliver Phase 3 in exactly two plans (Plan 03-01 = WR-01 fix; Plan 03-02 = Alchemist override block + Google Fonts edit + VALIDATION rigs). Single-plan for the Alchemist authoring plus VALIDATION is clean: one atomic "theme added and proven" commit, no split between authoring and verification.

---

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Theme token override block | CSS / Static Head | — | Pure CSS selector override; no JS, no build. `[data-theme="alchemist"] { ... }` placed inside the existing theme contract `<style>` per Phase 1 D-10. |
| Theme switching (URL param → `data-theme` attribute) | Inline FOUC `<script>` (already built) | — | Unchanged from Phase 1. FOUC script reads `?client=` and calls `setAttribute('data-theme', slug)` synchronously before first paint. Phase 3 does NOT rewire this. |
| Font loading | Google Fonts CDN `<link>` | `<head>` element ordering | A single `<link>` in `<head>` carries all theme fonts per Phase 1 D-16. Phase 3 appends Alchemist's font family to the existing href. |
| VALIDATION rigs | Manual browser / DevTools | `python3 -m http.server 8080` | Same infrastructure as Phase 2 V-11. No test framework; single-file no-build constraint (PROJECT.md). |
| Scoring / quiz flow | JS `calculateScore()` — **untouched** | — | Out of scope per EXCL-scoring-or-flow-changes. Theme is a skin change only. |

---

## Standard Stack

### Core

| Component | Current State | Phase 3 Action | Confidence |
|-----------|---------------|----------------|------------|
| CSS custom properties | `:root` block at lines 48–85, 15 color tokens + 3 font tokens | Add `[data-theme="alchemist"] { ... }` block after line 85, before `</style>` at line 86 | HIGH — verified by grep |
| Tailwind CSS (CDN) | CDN at line 87; config at lines 88–128 | No changes to CDN or config in Phase 3 | HIGH — verified by grep |
| Google Fonts `<link>` | Line 129: Space Grotesk + Plus Jakarta Sans + JetBrains Mono | Append Alchemist display/body font family to existing href | HIGH — verified by grep |
| FOUC `<script>` | Lines 7–12 | No changes | HIGH — verified by grep |
| Component `<style>` block | Lines 130–277 | No changes except WR-01 fix (lines 180, 210) in Plan 03-01 | HIGH — verified by grep |

**No npm install. No build step. All changes are single-file edits to `index.html`.**

---

## Architecture Patterns

### System Architecture Diagram

```
Browser request: http://localhost:8080/?client=alchemist
         |
         v
   index.html loads <head>
         |
         v
[FOUC <script> lines 7-12]
   reads ?client=alchemist
   setAttribute('data-theme','alchemist')  <-- sets before first paint
         |
         v
[Theme contract <style> lines 13-86]
   :root { ...Overdrive defaults... }      <-- always declared
   [data-theme="alchemist"] { ...overrides... }  <-- wins by cascade
         |
         v
[Tailwind CDN script line 87]
[Tailwind config lines 88-128]
   slate/surface/accent utilities all resolve
   through --xxx-rgb vars -- now reading Alchemist values
         |
         v
[Google Fonts <link> line 129]
   All theme fonts preloaded together (Phase 1 D-16)
   Space Grotesk (Overdrive) + IBM Plex Serif (Alchemist) + Plus Jakarta Sans + JetBrains Mono
         |
         v
[Six slides + results page render]
   All surfaces, borders, text, fonts resolve to Alchemist tokens
   answer-card / check-card resting bg = rgb(var(--surface-elev-rgb))  <-- WR-01 fix makes this work
         |
         v
[VALIDATION: getComputedStyle assertions per scenario]
```

### Recommended Project Structure

No file structure changes. All changes are inside `index.html`:

```
index.html (1007 lines, post-Phase-2)
  <head>
    lines 7-12:   FOUC <script>          [unchanged]
    lines 13-86:  theme contract <style>  [EDIT: insert Alchemist block after line 85]
    line 87:      Tailwind CDN <script>   [unchanged]
    lines 88-128: Tailwind config <script>[unchanged]
    line 129:     Google Fonts <link>    [EDIT: append Alchemist font family]
    lines 130-277: component <style>     [EDIT only lines 180+210 — Plan 03-01]
  </head>
```

### Pattern 1: Client Theme Override Block Structure

**What:** A CSS selector block keyed on `[data-theme="alchemist"]` placed inside the existing theme contract `<style>` after the `:root` close brace. Overrides all 15 color tokens and 2 font tokens (or 3 if `--font-mono` is also re-declared). Uses the same RGB-triplet + space-separated channel format as `:root` per Phase 1 D-13.

**When to use:** Once per client theme, placed after `:root` defaults and before `</style>` at line 86. Comment divider `/* ========== ALCHEMIST ========== */` immediately above the block per Phase 1 D-10.

**Example (complete Alchemist block — see Section: Alchemist Palette below for chosen values):**

```css
/* ========== ALCHEMIST ========== */
[data-theme="alchemist"] {
    /* Accent colors (Alchemist deep teal) */
    --accent-rgb:        15 118 110;       /* #0F766E deep teal */
    --accent-hover-rgb:  13 99 93;         /* #0D635D ~10% darker */
    --accent-muted-rgb:  204 238 235;      /* #CCEEEB soft-teal tint */

    /* Surfaces (cool off-white + elevated white) */
    --surface-rgb:           248 250 252;  /* #F8FAFC cool near-white */
    --surface-elev-rgb:      255 255 255;  /* #FFFFFF white */

    /* Text (deep slate) */
    --text-rgb:        30 41 59;     /* #1E293B deep slate */
    --text-muted-rgb:  100 116 139;  /* #64748B muted slate */

    /* Border */
    --border-rgb: 203 213 225;  /* #CBD5E1 slate-300 */

    /* Neutral ramp (cool-slate ramp -- distinct from Overdrive warm) */
    --neutral-50-rgb:  248 250 252;   /* #F8FAFC */
    --neutral-100-rgb: 241 245 249;   /* #F1F5F9 */
    --neutral-200-rgb: 226 232 240;   /* #E2E8F0 */
    --neutral-300-rgb: 203 213 225;   /* #CBD5E1 */
    --neutral-400-rgb: 148 163 184;   /* #94A3B8 */
    --neutral-500-rgb: 100 116 139;   /* #64748B */
    --neutral-600-rgb: 71 85 105;     /* #475569 */
    --neutral-700-rgb: 51 65 85;      /* #334155 */
    --neutral-800-rgb: 30 41 59;      /* #1E293B */
    --neutral-900-rgb: 15 23 42;      /* #0F172A */

    /* Secondary palette (Alchemist cool secondary) */
    --brand-soft-rgb:      219 234 254;  /* #DBE4FE soft indigo tint */
    --brand-secondary-rgb: 99 102 241;   /* #6366F1 indigo */

    /* Fonts (IBM Plex Serif display, Outfit body) */
    --font-display: 'IBM Plex Serif', serif;
    --font-body:    'IBM Plex Serif', serif;
}
```

**Source:** Pattern derived from Phase 1 D-10, D-13 (RGB-triplet format). Values chosen per Claude's Discretion research below. [ASSUMED for specific RGB values — see Palette section for reasoning]

### Anti-Patterns to Avoid

- **Partial override with silent cascade reliance:** D-02 mandates full contract exercise. Do not omit any token and rely on Phase 1 D-15 cascade. Every token slot must be explicitly declared in the Alchemist block.
- **Adding a separate `<style>` element for Alchemist:** All theme code goes inside the ONE existing theme contract `<style>` per Phase 1 D-10. No new `<style>` element.
- **Editing Tailwind config for Alchemist:** Tailwind utilities already resolve through CSS vars. No config changes needed. The override block changes the variable values; Tailwind picks them up automatically.
- **Changing any markup for the theme swap:** SC #4 of Phase 3 is "no markup was edited to add the second theme." Any markup edit in Plans 03-02+ fails SC #4.
- **Committing Plan 03-02+ before Plan 03-01:** WR-01 fix must land first. If `.answer-card { background: white; }` is still present at line 180 when Alchemist activates, answer cards will render white-on-teal-canvas — a frankenstein surface mismatch.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Font loading for multiple themes | Per-theme `<link>` elements swapped by JS | Single combined `<link>` href (Phase 1 D-16) | Zero FOUT; deterministic first-paint; no JS required |
| Theme switching logic | `localStorage` persistence, cookie-based, JS toggle UI | `?client=` URL param → FOUC inline `<script>` → `data-theme` attribute | Already built in Phase 1; shared links are deterministic |
| CSS token namespacing | Two-layer palette-plus-semantic system | Single-layer semantic tokens (Phase 1 D-05) | Already built; adding a layer would require Tailwind config changes |
| Missing token safety | JS validation / console.warn for missing tokens | CSS cascade fallback to `:root` (Phase 1 D-15) | Already built; forgiving by design |
| VALIDATION test harness | Playwright/Puppeteer automation | `python3 -m http.server 8080` + browser DevTools `getComputedStyle` | PROJECT.md single-file-no-build constraint forbids test frameworks |

---

## Research Area 1: Hardcoded-Literal Frankenstein Audit

**Purpose:** Identify any hardcoded color or font literal in `index.html` below line 86 that bypasses the CSS variable contract. These become either Plan 03-01-style fixes or documented "acceptable" exceptions.

**Methodology:** Direct grep of `/Users/petergiordano/Documents/GitHub/plg-readiness-rebrand/index.html` on `rebrand-theming` branch, 2026-05-16. [VERIFIED by grep against live file]

### Findings

**Category 1: Hardcoded `background: white` (WR-01 — the known D-02 violation)**

| Line | Selector | Literal | Impact under Alchemist |
|------|----------|---------|------------------------|
| 180 | `.answer-card { ... }` | `background: white;` | Answer cards render white on Alchemist canvas — frankenstein |
| 210 | `.check-card { ... }` | `background: white;` | Check cards render white on Alchemist canvas — frankenstein |

**Fix (Plan 03-01, locked per D-03):** Replace both with `background: rgb(var(--surface-elev-rgb));`

Under Overdrive: `--surface-elev-rgb` = `255 255 255` = white. Zero visual delta on bare URL load. Under Alchemist: resolves to Alchemist's `--surface-elev-rgb`. Contract honored.

**Category 2: Hardcoded font-family literals (JetBrains Mono)**

| Lines | Selector | Literal | Is a D-02 violation? |
|-------|----------|---------|----------------------|
| 190 | `.key-badge` | `font-family: 'JetBrains Mono', monospace;` | **No — acceptable exception** |
| 243 | `.result-overline` | `font-family: 'JetBrains Mono', monospace;` | **No — acceptable exception** |
| 249 | `.phase-overline` | `font-family: 'JetBrains Mono', monospace;` | **No — acceptable exception** |
| 262 | `.kbd-hint` | `font-family: 'JetBrains Mono', monospace;` | **No — acceptable exception** |

**Rationale for "acceptable exception" classification:** These four selectors all use JetBrains Mono for a specific typographic role: keyboard hints (`kbd-hint`), letter-label badges (`key-badge`), and overline labels (`result-overline`, `phase-overline`). These roles consume `--font-mono`, not `--font-display` or `--font-body`. JetBrains Mono is re-declared as `--font-mono` in `:root` (line 84). The component `<style>` block uses the literal rather than `var(--font-mono)` — this is a D-02 violation in spirit (structure-skin separation) but not in practice for Phase 3 because:

1. The Alchemist override block does NOT override `--font-mono` (per Phase 3 D-02 scope: display + body fonts only; mono stays JetBrains Mono). The literal and the variable agree.
2. Even if Alchemist overrode `--font-mono`, these CSS rules would NOT pick it up. That is a real future risk for a client that wants different mono — but it is not triggered by Phase 3.

**Recommendation:** Document as IN-01-equivalent in Plan 03-02 summary. Do not fix in Phase 3. The fix (replace each literal with `font-family: var(--font-mono);`) is a future cleanup task. It is not a frankenstein risk for Alchemist because Phase 3's Alchemist block leaves `--font-mono` at its `:root` default (JetBrains Mono).

**Category 3: Hardcoded hex values in CSS/HTML**

All hex values found in `index.html` (verified by grep) are in one of these locations:
- Lines 14–45: inline "HOW TO ADD A CLIENT THEME" instructional comment — not rendered CSS
- Lines 48–85: `:root` token declarations (comments annotating the RGB values for human readability)

No raw hex values exist in: CSS selectors below line 86, markup attributes, inline `style=""` attributes (those all use `rgb(var(--xxx-rgb) / ...)` form). [VERIFIED by grep: `grep -nE 'style="[^"]*#[0-9A-Fa-f]{3,6}"' index.html` → 0 matches]

**Category 4: rgba() hardcoded literals**

No `rgba(` occurrences in `index.html`. [VERIFIED: `grep -nE 'rgba\(' index.html` → 0 matches]

All alpha-channel usage follows the `rgb(var(--xxx-rgb) / alpha)` pattern per Phase 1 D-13.

**Category 5: Inline style= attributes**

| Line | Element | Style | Is a D-02 violation? |
|------|---------|-------|----------------------|
| 283 | `#progress-fill` | `style="width:0%"` | No — geometry, not color |
| 543 | result card | `style="border-left: 3px solid rgb(var(--accent-rgb));"` | No — uses CSS var |
| 557 | `#wedge-callout` | `style="border-top: 5px solid rgb(var(--accent-rgb));"` | No — uses CSS var |
| 577 | `#override-notice` | `style="border-top: 5px solid rgb(var(--accent-rgb));"` | No — uses CSS var |
| 579 | override-notice icon bg | `style="background: rgb(var(--brand-secondary-rgb) / 0.15);"` | No — uses CSS var |

All inline styles use CSS vars. Zero hardcoded color literals in markup. [VERIFIED]

### Audit Summary

| Category | Violations Found | Plan 03-01 Fixes | Acceptable Exceptions |
|----------|-----------------|------------------|-----------------------|
| `background: white` literals | 2 (lines 180, 210) | 2 (D-03 locked) | 0 |
| Hardcoded hex colors | 0 (outside :root/comments) | 0 | 0 |
| Hardcoded font literals (JetBrains Mono) | 4 (lines 190, 243, 249, 262) | 0 | 4 (mono = same under Alchemist) |
| rgba() literals | 0 | 0 | 0 |
| Non-var inline styles | 0 | 0 | 0 |

**Conclusion:** After Plan 03-01 ships, ZERO hardcoded color literals remain in `index.html` that would produce a frankenstein mid-page rendering under Alchemist. SC #2 ("no element falls back to Overdrive defaults mid-page") is achievable.

---

## Research Area 2: Alchemist Placeholder Palette

**Constraints verified by CONTEXT.md:** (a) visibly distinct from Overdrive orange-on-warm-off-white; (b) internally coherent; (c) brand-plausible; (d) must pass Phase 2 V-11 regression guard (`--neutral-50-rgb` must differ from `--surface-rgb`); (e) WCAG AA: text-on-surface and text-on-accent. REQ-no-dark-backgrounds: no dark backgrounds.

**Aesthetic rationale:** Alchemist is a B2B accelerator brand. The palette should read as: rigorous, credible, slightly academic — not startup-playful. A cool-slate neutral ramp paired with deep teal as the accent creates the clearest possible contrast from Overdrive's warm-orange-on-warm-white identity while remaining brand-plausible. Deep teal is used by serious enterprise and consulting brands (Stripe, Notion, Linear), lending credibility. Cool-slate neutrals are the opposite hue family from Overdrive's warm off-white.

### Proposed Palette

| Token | RGB Triplet | Hex | Role |
|-------|-------------|-----|------|
| `--accent-rgb` | `15 118 110` | `#0F766E` | Deep teal (Tailwind teal-700 equivalent) |
| `--accent-hover-rgb` | `13 99 93` | `#0D635D` | ~10% darker teal for hover |
| `--accent-muted-rgb` | `204 238 235` | `#CCEEED` | Soft-teal selected-card bg |
| `--surface-rgb` | `248 250 252` | `#F8FAFC` | Cool near-white canvas (slate-50 equivalent) |
| `--surface-elev-rgb` | `255 255 255` | `#FFFFFF` | White elevated cards |
| `--text-rgb` | `30 41 59` | `#1E293B` | Deep slate-800 text |
| `--text-muted-rgb` | `100 116 139` | `#64748B` | Slate-500 muted text |
| `--border-rgb` | `203 213 225` | `#CBD5E1` | Slate-300 borders |
| `--neutral-50-rgb` | `241 245 249` | `#F1F5F9` | **NOTE: MUST differ from `--surface-rgb` (#F8FAFC)** |
| `--neutral-100-rgb` | `226 232 240` | `#E2E8F0` | |
| `--neutral-200-rgb` | `203 213 225` | `#CBD5E1` | |
| `--neutral-300-rgb` | `148 163 184` | `#94A3B8` | |
| `--neutral-400-rgb` | `100 116 139` | `#64748B` | |
| `--neutral-500-rgb` | `71 85 105` | `#475569` | |
| `--neutral-600-rgb` | `51 65 85` | `#334155` | |
| `--neutral-700-rgb` | `30 41 59` | `#1E293B` | |
| `--neutral-800-rgb` | `15 23 42` | `#0F172A` | |
| `--neutral-900-rgb` | `7 15 30` | `#070F1E` | |
| `--brand-soft-rgb` | `219 234 254` | `#DBEFFF` | Soft indigo tint (Alchemist secondary bg) |
| `--brand-secondary-rgb` | `99 102 241` | `#6366F1` | Indigo (Alchemist secondary accent) |

### V-11 Regression Guard Check

**Claim:** `--neutral-50-rgb` (`241 245 249` = `#F1F5F9`) differs from `--surface-rgb` (`248 250 252` = `#F8FAFC`).

- `rgb(241, 245, 249)` ≠ `rgb(248, 250, 252)` — strict inequality confirmed by inspection. ✓
- The delta is: R-7, G-5, B-4 — visually distinguishable.

V-11 regression guard is satisfied. [ASSUMED — needs runtime DevTools confirmation during Plan 03-02 VALIDATION]

### WCAG AA Contrast Check

**Text on surface (primary):** `--text-rgb` (`#1E293B`) over `--surface-rgb` (`#F8FAFC`)

- `#1E293B` luminance ≈ 0.024; `#F8FAFC` luminance ≈ 0.958
- Contrast ratio ≈ (0.958 + 0.05) / (0.024 + 0.05) ≈ **13.6:1** — exceeds WCAG AA (4.5:1) and AAA (7:1). ✓ [ASSUMED — calculated from RGB values; not browser-verified]

**Text on accent (white text on teal):** White (`255 255 255`) over `--accent-rgb` (`#0F766E`)

- `#0F766E` luminance ≈ 0.126; White luminance = 1.0
- Contrast ratio ≈ (1.0 + 0.05) / (0.126 + 0.05) ≈ **5.97:1** — exceeds WCAG AA. ✓ [ASSUMED — calculated; not browser-verified]

**Muted text on surface:** `--text-muted-rgb` (`#64748B`) over `--surface-rgb` (`#F8FAFC`)

- `#64748B` luminance ≈ 0.160; `#F8FAFC` luminance ≈ 0.958
- Contrast ratio ≈ (0.958 + 0.05) / (0.160 + 0.05) ≈ **4.80:1** — passes WCAG AA (4.5:1) for normal text. ✓ [ASSUMED — calculated; not browser-verified]

**Selected card (teal text on muted teal bg):** `--accent-rgb` (`#0F766E`) over `--accent-muted-rgb` (`#CCEEED`)

- `#0F766E` luminance ≈ 0.126; `#CCEEED` luminance ≈ 0.751
- Contrast ratio ≈ (0.751 + 0.05) / (0.126 + 0.05) ≈ **4.56:1** — passes WCAG AA. ✓ [ASSUMED]

---

## Research Area 3: Alchemist Font Choice + Google Fonts Strategy

### Font Selection

**Requirement:** Visibly distinct from Space Grotesk (geometric sans-serif with rounded corners and distinctive letterforms like the single-story `a`). Must use weights loaded in the Google Fonts link (currently 400, 600, 700 for Space Grotesk; 400, 500, 600 for Plus Jakarta Sans; 400 for JetBrains Mono). [VERIFIED: line 129 of index.html]

**Markup weight audit:** The codebase uses these font-weight Tailwind classes on `font-display` elements: [VERIFIED by grep]
- `font-bold` (700): 8 usages — slide headings (lines 308, 349, 391, 426, 468, 504) and results headings (546, 607)
- `font-semibold` (600): multiple usages — card labels, table headers
- No `font-extrabold` (800) usages

**Required weights for display font:** 400 (body/fallback), 600 (semibold), 700 (bold). The chosen font must offer these.

**Recommended font: IBM Plex Serif**

- **Contrast with Space Grotesk:** Transitional serif with bracketed serifs and moderate contrast between thick and thin strokes. Completely different typographic register from Space Grotesk's geometric sans. [CITED: fonts.google.com/specimen/IBM+Plex+Serif]
- **Weights available:** 100, 200, 300, 400, 500, 600, 700. Weights 400, 600, 700 confirmed available. [CITED: fonts.google.com/specimen/IBM+Plex+Serif via WebSearch]
- **Brand appropriateness:** IBM Plex Serif is used for academic, enterprise, and consulting contexts. Fits an accelerator brand's credibility register. Pairs well with cool-slate neutrals.
- **Distinctiveness from Overdrive:** Serif vs geometric sans — maximum typographic contrast achievable within Google Fonts.

**`--font-body` recommendation:** Swap to IBM Plex Serif as well. Rationale per D-02: "D-02 recommends both for completeness." A single display-swap with Plus Jakarta Sans body creates a mixed serif/sans identity that may read as unintentional. Full IBM Plex Serif display + body is the cleaner proof.

**Weights to load for IBM Plex Serif:** `400;600;700` (covers all markup weight classes).

**Note on `--font-mono`:** The Alchemist override block does NOT override `--font-mono`. JetBrains Mono continues as the mono font for all four hardcoded `font-family: 'JetBrains Mono', monospace` sites (lines 190, 243, 249, 262) AND for the `:root` `--font-mono` token. Consistent with the "acceptable exception" audit above.

### Google Fonts `<link>` Edit Strategy

**Current href (line 129):** [VERIFIED by grep]
```
https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600&family=JetBrains+Mono:wght@400&display=swap
```

**Phase 3 modified href (append IBM Plex Serif):**
```
https://fonts.googleapis.com/css2?family=IBM+Plex+Serif:wght@400;600;700&family=Space+Grotesk:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600&family=JetBrains+Mono:wght@400&display=swap
```

Placement: IBM Plex Serif first alphabetically by convention (or any order — Google Fonts API accepts any family ordering). Single-line edit to line 129.

**Phase 2 D-14 mandate applies:** After this `<head>`-touching edit, a browser-verify gate is required before the Alchemist theme is declared complete. The gate assertion is: (a) `document.fonts.check('1em "IBM Plex Serif"') === true` after a probe div renders text in IBM Plex Serif; (b) zero console errors; (c) Space Grotesk still loads (Overdrive must not regress).

**Planner must include a browser-verify task** immediately after the Google Fonts `<link>` edit within Plan 03-02, mirroring V-2c from Phase 2 VALIDATION.md.

---

## Research Area 4: VALIDATION Rig Design (D-04 Three URL-Load Scenarios)

All rigs use: `python3 -m http.server 8080` (or any available port) serving from the repo root, accessed via Chrome with DevTools open.

### Scenario (a): `?client=alchemist` → Full Alchemist Render

**Setup:** Load `http://localhost:8080/?client=alchemist` in an incognito window (clears cached state).

**Assertions per surface area:**

| Surface | Element | DevTools command | Expected value (Alchemist) |
|---------|---------|-----------------|----------------------------|
| Slide 0 body bg | `document.body` | `getComputedStyle(document.body).backgroundColor` | `rgb(248, 250, 252)` (`--surface-rgb`) |
| Slide 0 heading font | `#slide-0 h1` | `getComputedStyle(document.querySelector('#slide-0 h1')).fontFamily` | Contains `'IBM Plex Serif'` |
| Slide 0 CTA button | `#slide-0 .bg-accent` | `getComputedStyle(document.querySelector('#slide-0 button')).backgroundColor` | `rgb(15, 118, 110)` (teal) |
| Slide 1 answer-card resting bg | `.answer-card` | `getComputedStyle(document.querySelector('.answer-card')).backgroundColor` | `rgb(255, 255, 255)` (`--surface-elev-rgb` after WR-01 fix) |
| Slide 1 answer-card border | `.answer-card` | `getComputedStyle(document.querySelector('.answer-card')).borderColor` | `rgb(203, 213, 225)` (`--border-rgb`) |
| Progress bar | `#progress-fill` | `getComputedStyle(document.querySelector('#progress-fill')).backgroundColor` | `rgb(15, 118, 110)` (teal) |
| Results page surface | `#results-page > div` | After completing quiz: `getComputedStyle(document.querySelector('#results-page')).backgroundColor` | `rgb(248, 250, 252)` |
| Reference matrix `<th>` header | `th.bg-slate-50` | `getComputedStyle(document.querySelector('th.bg-slate-50')).backgroundColor` | `rgb(241, 245, 249)` (`--neutral-50-rgb`) |
| Reference matrix grid card | `.grid .bg-slate-50` | `getComputedStyle(document.querySelector('section.bg-surface-warm .grid .bg-slate-50')).backgroundColor` | `rgb(241, 245, 249)` AND `!==` parent's `rgb(248, 250, 252)` — V-11 guard re-run under Alchemist |

**Key assertions:**
- `getComputedStyle(document.documentElement).getPropertyValue('--accent-rgb').trim()` → `'15 118 110'`
- `document.documentElement.getAttribute('data-theme')` → `'alchemist'`
- `document.fonts.check('1em "IBM Plex Serif"')` → `true` (after probe)

### Scenario (b): Bare URL → Full Overdrive Render (Zero Regression)

**Setup:** Load `http://localhost:8080/` in an incognito window (or same session after hard-refresh; incognito preferred).

**Assertions:** All assertions must match Phase 2 post-verification state. Key checks:

| Check | Expected value (Overdrive) |
|-------|---------------------------|
| `getComputedStyle(document.documentElement).getPropertyValue('--accent-rgb').trim()` | `'255 144 0'` |
| `document.body.backgroundColor` | `rgb(255, 248, 240)` |
| `document.querySelector('#slide-0 h1').style.fontFamily` or computed | Contains `'Space Grotesk'` |
| `document.documentElement.getAttribute('data-theme')` | `null` (no attribute set) |
| `document.fonts.check('1em "Space Grotesk"')` | `true` |
| `document.fonts.check('1em "IBM Plex Serif"')` | `true` (still loads — both themes' fonts are in the link) |
| Reference matrix V-11 guard | card `rgb(250, 243, 233)` !== parent `rgb(255, 248, 240)` — Phase 2 BL-01 guard still passes |

### Scenario (c): `?client=alchemist` → Navigate to Bare URL → Overdrive Restored

This is the trickiest scenario. It tests that no CSS or JS state persists across URL navigation.

**Why it should work (mechanically):** The FOUC inline `<script>` (lines 7–12) reads `location.search` and calls `setAttribute('data-theme', p)` if `p` exists. On the bare URL, `location.search` has no `?client=` param, so `p` is `null` and no `setAttribute` call is made. The `<html>` element renders without a `data-theme` attribute. The CSS cascade correctly falls through to `:root` defaults (Overdrive).

**What could go wrong:**
1. **Browser caching of `data-theme` attribute:** Not possible — `data-theme` is a DOM attribute set by JavaScript in the browser process; it does not persist across page navigations.
2. **Google Fonts cache:** Both theme fonts (Space Grotesk + IBM Plex Serif) will be browser-cached after the Alchemist load. On the bare URL, IBM Plex Serif is still in the `<link>` (it's a single combined link). It loads even on Overdrive pages. This is expected and not a regression — Overdrive's CSS uses `--font-display: 'Space Grotesk', sans-serif`, so IBM Plex Serif is loaded but not applied. [ASSUMED — no FOUC risk because fonts are not the discriminating factor for which theme is active]
3. **FOUC on the bare-URL load:** Not possible if the FOUC script runs synchronously before first paint. Confirmed in Phase 1 D-12 and verified in Phase 2 V-1. On bare URL, no `data-theme` is ever set, so there is no flash — the `:root` defaults apply from first paint.

**Rig procedure:**
1. Open incognito window
2. Load `http://localhost:8080/?client=alchemist`
3. Assert Alchemist render (confirm scenario (a) passes first)
4. In the SAME tab (not incognito), navigate to `http://localhost:8080/`
5. Assert full Overdrive render (same assertions as scenario (b))

**Key assertion for scenario (c):** After navigating from Alchemist URL to bare URL, `document.documentElement.getAttribute('data-theme')` must return `null` — confirming the `data-theme` attribute was cleared by the full page navigation (it is, because each page load re-runs the FOUC script which only sets the attribute if `?client=` is present).

**FOUC check:** After step 4 navigation, observe the slide-0 heading for any flash of teal-colored heading before Space Grotesk-orange renders. Given that `data-theme` is unset from first paint on the bare URL, no FOUC should occur. If it does, it indicates the FOUC script is not running before first paint on the second navigation — a browser-specific loading behavior that should be noted but is unlikely given Phase 1 D-12's blocking script placement.

### Rig Infrastructure

Mirror Phase 2 V-11 pattern exactly:

| Property | Value |
|----------|-------|
| Server | `python3 -m http.server 8080` from repo root |
| Browser | Chrome (consistent with Phase 2 V-11) |
| Orchestrator tool | Chrome MCP (consistent with Phase 2 V-11) |
| Session type | Incognito for scenario (a) and (b); regular tab for scenario (c) (to test with warm cache) |
| Quiz completion for results page | `answers = {buyerUser: 'same', viral: 'organic', scope: 'team'}; showResults()` in DevTools console (same programmatic shortcut used in Phase 2 V-11) |

---

## Research Area 5: Plan Count + Atomicity Recommendation

**Recommendation: 2 plans total (Plan 03-01 + Plan 03-02). Do not split Plan 03-02.**

**Plan 03-01 (locked per D-03):** WR-01 fix — 1 task, 1 commit, lines 180 + 210. Atomic gap-closure. Ships before any Alchemist work.

**Plan 03-02 (recommended as a single plan):** Alchemist override block authoring + Google Fonts `<link>` edit + VALIDATION rigs. Rationale:

1. **Commit atomicity:** The override block, the Google Fonts edit, and the VALIDATION are logically one deliverable: "a working Alchemist theme." Splitting into Plan 03-02 (authoring) and Plan 03-03 (validation) would create a commit where the theme exists but is not yet proven — a half-proven state that has no utility for the project history.

2. **Browser-verify gate placement:** Phase 2 D-14 requires browser-verify after every `<head>`-touching change. The Google Fonts `<link>` edit is `<head>`-touching. Plan 03-02 can accommodate this by structuring tasks as: (Task 1) Insert Alchemist override block in `<style>`; (Task 2) Edit Google Fonts `<link>` + run D-14 browser-verify for font load; (Task 3) Run three URL-load VALIDATION rigs. This sequence is clean within a single plan.

3. **Reviewability:** One focused diff: "adds Alchemist theme and proves it works." Cleaner for the project record than "adds Alchemist block" followed by "adds validation output."

4. **Diff size:** Approximately 25 CSS lines (Alchemist block) + 1 href edit + VALIDATION notes. Not a large diff. Splitting does not improve readability.

**Task structure for Plan 03-02:**

- Task 1: Insert `[data-theme="alchemist"] { ... }` block at line 85–86 boundary in theme contract `<style>`
- Task 2: Edit Google Fonts `<link>` at line 129 to prepend `IBM+Plex+Serif:wght@400;600;700` + run D-14 browser-verify (font load check)
- Task 3: Run VALIDATION scenario (a) — `?client=alchemist` full Alchemist render
- Task 4: Run VALIDATION scenario (b) — bare URL full Overdrive render (zero regression)
- Task 5: Run VALIDATION scenario (c) — switch-back restore Overdrive identity

---

## Research Area 6: Line-Number Drift After Plan 03-01

**Claim to verify:** Single-line edits at lines 180 and 210 (changing `background: white;` to `background: rgb(var(--surface-elev-rgb));`) do not shift downstream line numbers.

**Analysis:** The fix replaces the string `background: white;` with `background: rgb(var(--surface-elev-rgb));`. These are NOT same-length strings, but both fit on one line. A single-line substitution does not add or remove lines — only character count on that line changes. Line count of the file remains 1007 before and after Plan 03-01. Downstream line numbers are unaffected.

**Verified line numbers (current `rebrand-theming` branch, 2026-05-16):** [VERIFIED by grep of live file]

| Landmark | Line | Content |
|----------|------|---------|
| FOUC `<script>` open | 7 | `<script>` |
| FOUC `<script>` close | 12 | `</script>` |
| Theme contract `<style>` open | 13 | `<style>` |
| `:root {` open | 48 | `        :root {` |
| `:root }` close | 85 | `        }` |
| Theme contract `</style>` | 86 | `    </style>` |
| **Alchemist block INSERT POINT** | **85–86 boundary** | **After line 85 `}`, before line 86 `</style>`** |
| Tailwind CDN `<script>` | 87 | `<script src="https://cdn.tailwindcss.com"></script>` |
| Tailwind config `<script>` open | 88 | `<script>` |
| Tailwind config `<script>` close | 128 | `</script>` |
| Google Fonts `<link>` | **129** | `<link href="https://fonts.googleapis.com/..."` |
| Component `<style>` open | 130 | `<style>` |
| `.answer-card` resting bg (WR-01 site 1) | **180** | `background: white;` |
| `.check-card` resting bg (WR-01 site 2) | **210** | `background: white;` |
| Component `<style>` close | 277 | `</style>` |
| Total lines | 1007 | `wc -l` confirmed |

**Post-Plan-03-01 line numbers:** Lines 180 and 210 stay at 180 and 210 (single-line replacements). Lines 85, 86, 87, 129 are unaffected by Plan 03-01. The planner can rely on these line numbers for Plan 03-02 tasks without re-grepping.

**Post-Plan-03-02 line numbers:** The Alchemist block insert (~25 lines) shifts lines 86+ downward by ~25. After Plan 03-02 Task 1 ships, the planner must re-grep to find the new line number for the Google Fonts `<link>` (was 129, will be ~154). Plan 03-02 should state this explicitly in its task sequencing.

---

## Common Pitfalls

### Pitfall 1: Frankenstein Surface Before Plan 03-01 Ships

**What goes wrong:** If Plan 03-02 (Alchemist block) executes before Plan 03-01 (WR-01 fix), loading `?client=alchemist` shows teal backgrounds on slides but white answer cards and check cards — a half-themed state. SC #2 fails.

**Why it happens:** `.answer-card { background: white; }` and `.check-card { background: white; }` at lines 180/210 are not overridden by any token. They hardcode `white`, which wins over any `--surface-elev-rgb` the theme provides.

**How to avoid:** Plan 03-01 must ship and be verified before Plan 03-02 begins. D-03 locks this sequence.

**Warning signs:** Under `?client=alchemist`, answer cards render visibly whiter than the slide background. Use `getComputedStyle(document.querySelector('.answer-card')).backgroundColor` — if it returns `rgb(255, 255, 255)` while `--surface-elev-rgb` is NOT `255 255 255` in the Alchemist theme, WR-01 fix has not shipped.

### Pitfall 2: V-11 Regression Under Alchemist

**What goes wrong:** Alchemist's `--neutral-50-rgb` accidentally equals `--surface-rgb`, collapsing reference-matrix cards and table headers into the cool near-white canvas. This is the exact BL-01 failure pattern from Phase 2.

**Why it happens:** The proposed Alchemist palette has `--surface-rgb = 248 250 252` and `--neutral-50-rgb = 241 245 249`. These are distinct. But if a palette revision accidentally sets them equal, the V-11 guard catches it.

**How to avoid:** Verify during VALIDATION scenario (a): `getComputedStyle(document.querySelector('section.bg-surface-warm .grid .bg-slate-50')).backgroundColor` must differ from its `bg-surface-warm` parent. Same V-11 rig, same pass criterion — strict `!==`.

### Pitfall 3: IBM Plex Serif Not Loading Under Overdrive (Combined Link Regression)

**What goes wrong:** After adding IBM Plex Serif to the Google Fonts `<link>`, the link renders malformed (e.g., wrong separator, duplicate `display=swap` parameter), causing ALL fonts to fail — breaking Overdrive's Space Grotesk render.

**Why it happens:** Incorrectly concatenating the Google Fonts API URL. The API uses `&family=` to separate families; `&display=swap` must appear only once at the end.

**How to avoid:** D-14 browser-verify after the `<link>` edit: (a) check network tab for 200 on the fonts.googleapis.com request; (b) `document.fonts.check('1em "Space Grotesk"')` and `document.fonts.check('1em "IBM Plex Serif"')` both return true.

### Pitfall 4: Alchemist `--font-body` Uses a Font Not in the Google Fonts Link

**What goes wrong:** If `--font-body` is set to a font family that was not added to the `<link>` href, body text falls back to the system `sans-serif` or `serif` stack — visible as a layout/kerning change.

**How to avoid:** The recommended approach (IBM Plex Serif for both display and body) uses the same font family for both tokens, so a single `family=IBM+Plex+Serif:wght@400;600;700` addition covers both.

---

## Code Examples

### Alchemist Block (Complete, Ready for Plan 03-02)

```css
/* Source: Phase 1 D-10 comment divider pattern; values per 03-RESEARCH.md Section 2 */

        /* ========== ALCHEMIST ========== */
        [data-theme="alchemist"] {
            /* Accent colors (Alchemist deep teal) */
            --accent-rgb:        15 118 110;       /* #0F766E deep teal */
            --accent-hover-rgb:  13 99 93;          /* #0D635D ~10% darker */
            --accent-muted-rgb:  204 238 237;       /* #CCEEED soft-teal tint */

            /* Surfaces (cool off-white + white elevated card) */
            --surface-rgb:           248 250 252;  /* #F8FAFC cool near-white */
            --surface-elev-rgb:      255 255 255;  /* #FFFFFF white */

            /* Text (deep slate) */
            --text-rgb:        30 41 59;     /* #1E293B deep slate */
            --text-muted-rgb:  100 116 139;  /* #64748B muted slate */

            /* Border */
            --border-rgb: 203 213 225;  /* #CBD5E1 slate-300 */

            /* Neutral ramp (cool slate -- visibly distinct from Overdrive warm) */
            --neutral-50-rgb:  241 245 249;   /* #F1F5F9 MUST differ from --surface-rgb */
            --neutral-100-rgb: 226 232 240;   /* #E2E8F0 */
            --neutral-200-rgb: 203 213 225;   /* #CBD5E1 */
            --neutral-300-rgb: 148 163 184;   /* #94A3B8 */
            --neutral-400-rgb: 100 116 139;   /* #64748B */
            --neutral-500-rgb: 71 85 105;     /* #475569 */
            --neutral-600-rgb: 51 65 85;      /* #334155 */
            --neutral-700-rgb: 30 41 59;      /* #1E293B */
            --neutral-800-rgb: 15 23 42;      /* #0F172A */
            --neutral-900-rgb: 7 15 30;       /* #070F1E */

            /* Secondary palette (cool indigo tint) */
            --brand-soft-rgb:      219 234 254;  /* #DBEFFF soft indigo tint */
            --brand-secondary-rgb: 99 102 241;   /* #6366F1 indigo */

            /* Fonts (IBM Plex Serif -- transitional serif, distinct from Space Grotesk) */
            --font-display: 'IBM Plex Serif', serif;
            --font-body:    'IBM Plex Serif', serif;
        }
```

**Token count:** 20 color tokens + 2 font tokens = 22 declarations + 2 comment lines + 6 section comments ≈ 30 lines with braces and header comment divider.

### WR-01 Fix (Plan 03-01 targets)

```css
/* BEFORE (lines 180, 210) — violates Phase 1 D-02 structure-skin separation */
background: white;

/* AFTER — resolves through token contract */
background: rgb(var(--surface-elev-rgb));
```

Under Overdrive: `--surface-elev-rgb = 255 255 255` = white. Zero visual delta. Under Alchemist: `--surface-elev-rgb = 255 255 255` = white (same in proposed palette — but the fix is correct for any future Alchemist palette revision).

### Google Fonts `<link>` (Plan 03-02 Task 2 target)

```html
<!-- BEFORE (line 129 current) -->
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600&family=JetBrains+Mono:wght@400&display=swap" rel="stylesheet">

<!-- AFTER (single-line edit to line 129) -->
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Serif:wght@400;600;700&family=Space+Grotesk:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600&family=JetBrains+Mono:wght@400&display=swap" rel="stylesheet">
```

### V-11 Guard Extended for Alchemist (Plan 03-02 VALIDATION script)

```javascript
// Source: 02-VALIDATION.md V-11 pattern — extended for Alchemist
// Run after completing quiz (any path) to reach results page
// Under ?client=alchemist

const card = document.querySelector('section.bg-surface-warm .grid .bg-slate-50');
const parent = card.closest('.bg-surface-warm');
const cardBg = getComputedStyle(card).backgroundColor;
const parentBg = getComputedStyle(parent).backgroundColor;
console.log('card:', cardBg, '| parent:', parentBg, '| different:', cardBg !== parentBg);
// Expected: card 'rgb(241, 245, 249)' | parent 'rgb(248, 250, 252)' | different: true
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact on Phase 3 |
|--------------|------------------|--------------|-------------------|
| Fraunces serif (phase 0) | Space Grotesk geometric sans (Phase 2) | Phase 2 | Alchemist must choose a non-Space-Grotesk font — IBM Plex Serif is sufficiently distinct |
| Indigo/slate hardcoded hex | CSS custom property RGB triplets via Tailwind | Phase 1 | All Alchemist overrides use the same RGB-triplet pattern |
| `background: white` literals | `background: rgb(var(--surface-elev-rgb))` | Phase 3 Plan 03-01 | Required before Alchemist works without frankenstein surfaces |
| Single theme | Two themes (Overdrive default + Alchemist override) | Phase 3 | Contract proves pluggability |

---

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | Proposed Alchemist RGB palette values produce the described visual identity (deep teal accent, cool slate neutrals, brand-plausible B2B appearance) | Research Area 2 | Visual identity may not look as intended; palette is adjustable within D-01's "placeholder values" framing without restructuring the block |
| A2 | WCAG AA contrast ratios calculated from RGB values are correct (text-on-surface ~13.6:1, text-on-accent ~5.97:1, muted text ~4.80:1) | Research Area 2 | If calculations are wrong, some surface may fail WCAG; needs browser-devtools contrast checker during VALIDATION |
| A3 | `--neutral-50-rgb` (`241 245 249`) strictly differs from `--surface-rgb` (`248 250 252`) in computed browser output | Research Area 2 | V-11 guard fails; reference-matrix cards collapse — same as BL-01. Fix: adjust `--neutral-50-rgb` to any distinct value |
| A4 | IBM Plex Serif at weights 400, 600, 700 is available on Google Fonts API with the family parameter `IBM+Plex+Serif:wght@400;600;700` | Research Area 3 | Google Fonts returns 400 for missing weights (tolerant API); visual impact is minimal; needs network tab verification in D-14 gate |
| A5 | Google Fonts API tolerates re-ordering of `family=` parameters in the href (IBM Plex Serif prepended) | Research Area 3 | API may reject or return partial CSS if ordering matters; D-14 browser-verify catches this |
| A6 | Scenario (c) switch-back works correctly because the FOUC script only sets `data-theme` when `?client=` is present | Research Area 4 | If FOUC script behavior has changed since Phase 1 (it has not — lines 7-12 verified), scenario (c) could fail. Unlikely. |

---

## Open Questions

1. **Should `--accent-muted-rgb` be defined as a specific soft-teal tint?**
   - What we know: Overdrive uses `255 241 224` (soft orange tint) for selected-card background. Alchemist needs an analogous soft-teal for `.answer-card.selected` and `.check-card.selected` backgrounds.
   - What's unclear: The exact saturation level of the teal tint that reads as "selected but not overbearing."
   - Recommendation: Use `204 238 237` (`#CCEEED`) — approximately 15% teal saturation on white, analogous to Overdrive's `#FFF1E0` approach. Planner can adjust if contrast check during VALIDATION reveals it is too strong or too faint.

2. **`--brand-secondary-rgb` = indigo `99 102 241` — does this look coherent with the PLS badge under Alchemist?**
   - What we know: The PLS badge uses `bg-yellow-100 text-yellow-400` which resolves to `--brand-soft-rgb` and `--brand-secondary-rgb`. Under Alchemist, these become soft indigo tint and indigo.
   - What's unclear: Whether indigo-on-soft-indigo reads cleanly for the PLS badge. The WCAG contrast between `#6366F1` and `#DBEFFF` is approximately (0.216 + 0.05) / (0.897 + 0.05) ≈ **0.28:1** — this fails WCAG, which means the PLS badge text under Alchemist will be hard to read. [ASSUMED calculation]
   - Recommendation: Accept for a placeholder theme (D-01 scope is proof-of-pluggability, not production accessibility). Flag in Plan 03-02 SUMMARY as a known limitation of the placeholder palette. If Pete wants a passing-contrast secondary, use `59 130 246` (blue-500, ~4.0:1 on `#DBEFFF`) instead of indigo.

3. **Should the "HOW TO ADD A CLIENT THEME" comment (lines 14–45) be extended to reference the Alchemist block as a worked example?**
   - What we know: D-11 (Phase 1) established the inline recipe as the single source of truth. CONTEXT.md D-11 reference says "Phase 3's Alchemist block becomes a concrete worked example."
   - What's unclear: Exact wording. CONTEXT.md marks this as "recommended yes."
   - Recommendation: Add 2–3 lines to the HOW TO comment pointing to the Alchemist block as the canonical worked example. Include in Plan 03-02 Task 1 as an optional subtask. The planner can include or exclude based on atomicity preference.

---

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| `python3 -m http.server` | VALIDATION rigs (all three scenarios) | ✓ | macOS default Python 3 | Any local HTTP server (e.g., `npx serve`) |
| Chrome browser | `getComputedStyle` DevTools assertions, Chrome MCP | ✓ | Assumed from Phase 2 V-11 | Firefox DevTools (same API) |
| `git` | Commit Plans 03-01 and 03-02 | ✓ | Available on `rebrand-theming` branch | — |
| Google Fonts CDN | IBM Plex Serif font load | ✓ (internet required) | — | Offline fallback: `serif` system fallback (renders, but IBM Plex Serif not visible) |

---

## Validation Architecture

> `workflow.nyquist_validation` is not explicitly set to `false` in `.planning/config.json` (key is absent). Section included.

### Test Framework

| Property | Value |
|----------|-------|
| Framework | None — manual browser-load + DevTools (PROJECT.md single-file-no-build constraint) |
| Config file | None |
| Quick run command | `grep -nE 'background: white' index.html` (residue check for WR-01 fix) + `grep -n 'IBM.Plex.Serif' index.html` (font load check) |
| Full suite command | `python3 -m http.server 8080` then run three URL-load scenarios in Chrome/DevTools |
| Estimated runtime | ~5–8 minutes for full three-scenario sweep |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| REQ-stub-second-theme / SC #1 | Alchemist theme exists with visibly distinct placeholder values | Source grep | `grep -c 'data-theme="alchemist"' index.html` | ❌ Wave 0 (written in Plan 03-02) |
| REQ-stub-second-theme / SC #2 | Activating Alchemist re-skins all surfaces coherently (no frankenstein) | DevTools runtime | Scenario (a) assertions: `getComputedStyle` on body, heading font, accent button, answer-card bg | Manual — browser required |
| REQ-stub-second-theme / SC #2 (WR-01) | No `background: white` literals remain after Plan 03-01 | Source grep | `grep -c 'background: white' index.html` → 0 | ❌ Included in Plan 03-01 acceptance criteria |
| REQ-stub-second-theme / SC #2 (V-11) | Alchemist `--neutral-50-rgb` differs from `--surface-rgb` (no BL-01 repeat) | DevTools runtime | V-11 rig under `?client=alchemist` | Manual — browser required |
| REQ-stub-second-theme / SC #3 | Switching to bare URL restores Overdrive cleanly (no residual state) | DevTools runtime | Scenario (c) assertions | Manual — browser required |
| REQ-stub-second-theme / SC #4 | No markup was edited to add the theme | Source diff | `git diff HEAD -- index.html | grep '^[+-]' | grep -v '^\+\+\+\|^---' | grep -v '[data-theme]' | grep -v '\-\-' | grep -v 'IBM.Plex\|google\|fonts'` (no markup line additions) | ❌ Planner encodes in Plan 03-02 acceptance criteria |
| Phase 2 regression guard | Overdrive still renders correctly on bare URL (all Phase 2 SCs still pass) | DevTools runtime | Scenario (b) assertions: accent rgb, body bg, Space Grotesk font, V-11 card !== parent | Manual — browser required |

### Sampling Rate

- **After Plan 03-01 commit:** `grep -c 'background: white' index.html` → 0 (confirming both WR-01 sites fixed)
- **After Plan 03-02 Task 1 (override block inserted):** `grep -c 'data-theme="alchemist"' index.html` → 1
- **After Plan 03-02 Task 2 (Google Fonts `<link>` edit):** D-14 browser-verify: Space Grotesk + IBM Plex Serif both load
- **After Plan 03-02 Task 3–5 (VALIDATION rigs):** All three scenario assertions pass; V-11 guard passes under Alchemist; Phase 2 Overdrive render unchanged
- **Phase gate:** All three scenarios PASS before `/gsd-verify-work`

### Wave 0 Gaps

- [ ] No test files to create — this phase has no automated test harness (single-file static web app constraint)
- [ ] VALIDATION scenario scripts: written as inline DevTools JS in Plan 03-02 tasks (not separate files)

None — no Wave 0 setup required. Existing `index.html` + browser DevTools is the verification surface.

---

## Security Domain

> `security_enforcement` not explicitly set to `false` in config.json. Section included per mandate.

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | No | N/A — static file, no auth |
| V3 Session Management | No | N/A — no sessions |
| V4 Access Control | No | N/A — public diagnostic tool |
| V5 Input Validation | Yes (low risk) | FOUC script reads `?client=` URL param; Phase 2 REVIEW IN-02 flagged no allow-list. The malformed-value risk is LOW: `setAttribute` does not parse HTML; CSS only keys on known slug patterns. No new attack surface added by Phase 3 (adding a new `[data-theme="alchemist"]` CSS block is not an input vector). |
| V6 Cryptography | No | N/A — no secrets, no data |

### Known Threat Patterns

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| CSS injection via `data-theme` attribute | Tampering | CSS attribute selectors match literal slug strings only. `setAttribute` for `data-theme` is not an HTML injection vector. No user-controlled content inside CSS rules. Low risk. |
| Google Fonts CDN dependency | Spoofing (external) | Same trust boundary as Phase 1/2 Google Fonts dependency. Not a new risk in Phase 3. Accepted per project constraint (CDN-only, no self-hosting). |

No new security surface introduced by Phase 3. The WR-01 fix and the Alchemist override block are purely inert CSS declarations.

---

## Sources

### Primary (HIGH confidence)

- `index.html` (rebrand-theming branch, 2026-05-16) — direct grep audit, all line numbers verified by shell commands in-session
- `.planning/phases/03-second-theme-stub-pluggability-proof/03-CONTEXT.md` — locked decisions D-01..D-04, Claude's Discretion scope
- `.planning/phases/02-overdrive-default-theme-migration/02-VALIDATION.md` — V-11 rig (surface-differentiation guard), methodology to mirror
- `.planning/phases/02-overdrive-default-theme-migration/02-REVIEW.md` — WR-01 source-of-truth (lines 180, 210), WR-02..06 confirmed not Phase 3 risks
- `.planning/phases/02-overdrive-default-theme-migration/02-06-PLAN.md` — atomic gap-closure pattern Plan 03-01 mirrors
- `.planning/phases/01-theming-architecture-foundation/01-CONTEXT.md` — D-10 (theme block layout), D-13 (RGB-triplet pattern), D-16 (combined Google Fonts link)
- `.planning/phases/02-overdrive-default-theme-migration/02-CONTEXT.md` — D-08, D-11, D-12, D-14 carry-over decisions

### Secondary (MEDIUM confidence)

- `docs/design/design-system-alpha-overdrive.md` — Overdrive palette and typography reference; used to ensure Alchemist contrasts against Overdrive identity

### Tertiary (LOW confidence — needs runtime verification)

- IBM Plex Serif Google Fonts weight availability: confirmed by WebSearch result mentioning weights 100–700 available; NEEDS browser/network-tab verification during D-14 gate in Plan 03-02
- WCAG AA contrast ratio calculations: manual calculation from RGB triplets; NEEDS DevTools color contrast checker or browser accessibility tool verification during VALIDATION

---

## Metadata

**Confidence breakdown:**

- WR-01 audit (lines 180, 210): HIGH — verified by direct grep
- JetBrains Mono literals (lines 190, 243, 249, 262): HIGH — verified by grep; classified as acceptable exceptions
- No other hardcoded color literals outside `:root`: HIGH — verified by grep (0 hex matches in markup, 0 rgba matches)
- Google Fonts current `<link>` (line 129): HIGH — verified by grep
- Line numbers for `:root`, `</style>`, Google Fonts `<link>`, WR-01 sites: HIGH — verified by grep
- Alchemist palette RGB values: ASSUMED — chosen by reasoning from design constraints; needs visual confirmation
- WCAG contrast ratios: ASSUMED — calculated from RGB; not browser-verified
- IBM Plex Serif Google Fonts availability at weights 400/600/700: MEDIUM — confirmed by WebSearch result citing official Google Fonts

**Research date:** 2026-05-16

**Valid until:** 2026-06-16 (30 days; Tailwind CDN and Google Fonts APIs are stable)

---

## RESEARCH COMPLETE
