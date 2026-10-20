---
phase: 02-overdrive-default-theme-migration
reviewed: 2026-05-16T00:00:00Z
depth: standard
files_reviewed: 1
files_reviewed_list:
  - index.html
findings:
  critical: 1
  warning: 6
  info: 3
  total: 10
status: issues_found
---

# Phase 2: Code Review Report

**Reviewed:** 2026-05-16
**Depth:** standard
**Files Reviewed:** 1
**Status:** issues_found

## Summary

Phase 2 ships a visual-only retheming of `index.html` from Slate/Indigo to Overdrive Orange + warm off-white surfaces. The token contract (`:root` custom properties + Tailwind config block) is internally consistent: every Tailwind color reference resolves, no retired tokens (`surface.dark`, `surface.dark-card`) leak through to the markup, and the `rgb(var(--x-rgb) / <alpha-value>)` alpha-handling pattern is used correctly throughout the component `<style>` block. No XSS surfaces (static single-file app, no user-controlled HTML injection paths). `calculateScore()` and the slide state machine are byte-equivalent to `main` per V-9, and the review confirmed JS was not modified.

However, the migration introduces one concrete visual regression and a cluster of WCAG-AA contrast deviations driven by collapsing the slate ramp onto warm anchors:

- **BL-01 (Critical):** `bg-slate-50` neutral-50 token now resolves to `#FFF8F0` — the same value as `bg-surface-warm`. Three card surfaces (reference-matrix 3-up grid, lines 671/680/689) and four table headers (lines 615-618) sit inside `bg-surface-warm` sections and are now visually identical to their parent canvas. The cards collapse into the page background and the table headers melt into the surrounding section. This is a functional regression, not a style preference.
- **WR-01..WR-04:** Several pre-existing slate-400 / slate-500 text utilities now render below WCAG-AA contrast on the new warm canvas because the neutral ramp anchors moved (slate-400 went from `#94A3B8` on `#F8FAFC` ≈ 3:1 to `#A8A8A8` on `#FFF8F0` ≈ 2.4:1). The Phase 2 migration was the proximate cause even though the markup classes were unchanged.
- **WR-05/WR-06:** Two Cat-B literals were missed by the migration sweep: `background: white;` on `.answer-card` and `.check-card` (lines 180, 210). The token contract intent is that every surface color flows from `--surface-elev-rgb`, but these two component bases still use the literal.
- **IN-01..IN-03:** Two unused/under-specified utility patterns and a documentation gap.

The single Critical finding (BL-01) is a ship-blocker because two large UI regions render incorrectly under the new theme. The Warning cluster is graded against WCAG AA (4.5:1 for normal text, 3:1 for non-text UI) and the project's own contrast tracking (WARNING-3 documented; these are new instances not yet captured).

## Critical Issues

### CR-01: `bg-slate-50` resolves to the surface color, collapsing reference-matrix cards and table headers into their parent canvas

**File:** `index.html:615-618, 671, 680, 689`

**Issue:** The token contract sets `--neutral-50-rgb: 255 248 240;` (line 66) — the same RGB as `--surface-rgb: 255 248 240;` (line 55). Tailwind's `bg-slate-50` and `bg-surface-warm` therefore resolve to the same color (`#FFF8F0`).

Two places in the markup depend on `bg-slate-50` being darker than the page surface to establish visual hierarchy:

1. **Reference matrix 3-up card grid** (lines 671, 680, 689): three `bg-slate-50 ... border border-slate-100` cards sit inside a `bg-surface-warm` section (line 602). Cards are now the same color as the section. `border-slate-100` (`#F5F0E8`) is only marginally darker than the surface, so the cards have a faint outline but no fill differentiation from the page.
2. **Reference matrix table headers** (lines 615-618): four `<th>` elements with `bg-slate-50` sit inside the same `bg-surface-warm` section. Headers no longer have a visible fill against the surrounding canvas — they are distinguishable only by the `border border-slate-200` outline.

A third site, the recommendation panel inside the main result card (line 548 — `bg-slate-50` inside a `bg-surface-elev` white card), works correctly because the parent is white, not warm.

The block was reviewed as a deliberate D-07 brandable-ramp decision in CONTEXT, but the markup-side consequence on the two sites above appears to have been missed.

**Fix:**

Pick one of these three approaches (preference order matches phase intent):

**Option A (recommended) — re-anchor `--neutral-50-rgb` slightly above the surface so `bg-slate-50` always carries differentiation:**
```css
/* index.html line 66 */
--neutral-50-rgb:  250 243 233;   /* #FAF3E9 one step warmer-deeper than surface */
```
This keeps the warm palette feel and restores card/header visibility without touching markup.

**Option B — swap the two affected sites to `bg-surface-elev` (white) for a cleaner contrast:**
```html
<!-- lines 671, 680, 689 -->
<div class="bg-surface-elev rounded-lg p-6 border border-slate-200">
<!-- lines 615-618 -->
<th class="p-4 bg-surface-elev border border-slate-200 ...">
```

**Option C — accept the new flat look but tighten the borders so the regions are still readable:**
```html
<!-- bump card border from slate-100 to slate-200 -->
<div class="bg-slate-50 rounded-lg p-6 border border-slate-200">
```

Option A is the lowest-blast-radius fix because it leaves all current `bg-slate-50` consumers behaving as the design system originally intended.

## Warnings

### WR-01: `.answer-card` and `.check-card` use hardcoded `background: white;` instead of the surface-elev token

**File:** `index.html:180, 210`

**Issue:** The Phase 2 plan retired Cat-B literals in favor of var-driven refs from the token contract (per CONTEXT D-02, the `--surface-elev-rgb` token exists precisely so all elevated-card surfaces flow from one knob). Two component base classes still hardcode `background: white;`:

```css
.answer-card { ... background: white; }   /* line 180 */
.check-card  { ... background: white; }   /* line 210 */
```

This means a future client theme that overrides `--surface-elev-rgb` (e.g., to a soft ivory) will theme the `.kbd-hint span` (line 268, correctly tokenized), `.answer-card.selected .key-badge` (line 197, correctly tokenized), and the markup-side `bg-surface-elev` regions — but the answer and check cards will remain literal white, producing a frankenstein mid-quiz surface mismatch identical to the Phase 1 "frankenstein hover" class of bug R-1 was supposed to close.

**Fix:**
```css
.answer-card {
    ...
    background: rgb(var(--surface-elev-rgb));
}

.check-card {
    ...
    background: rgb(var(--surface-elev-rgb));
}
```

### WR-02: Body description text (`text-slate-500`) fails WCAG AA on the new warm canvas

**File:** `index.html:311, 352, 394, 429, 471, 507, 547, 550, 566, 567, 569, 570, 586, 594, 608, 627, 631, 638, 642, 649, 653, 660, 664, 678, 687, 696, 704, 778`

**Issue:** The token contract sets `--neutral-500-rgb: 138 138 138` (`#8A8A8A`, the Overdrive Gray 2 anchor). Body text using `text-slate-500` on `bg-surface-warm` (`#FFF8F0`) computes to a contrast ratio of roughly **3.5:1**, below the WCAG AA threshold of 4.5:1 for normal-weight body copy. The hero subhead "Your problem's nature — not your product features..." (line 311, `text-lg text-slate-500`) at 18px non-bold also fails the 3:1 large-text exemption because the WCAG "large text" definition requires 18.66px+bold or 24px+ regular.

This is the dominant body-text color in the app — slide intros, answer-card descriptions, table cells, restart link, footer. The new neutral-500 anchor is fundamentally below AA against the new surface anchor.

**Fix:** Either re-anchor `--neutral-500-rgb` darker (e.g., `--neutral-500-rgb: 102 102 102;` to align with the `#666` Gray 1 anchor — gets you ~5.7:1 contrast) and renumber the ramp, or swap body text consumers to `text-slate-600` (`#666666`, also defined). The latter is the more surgical fix:

```html
<!-- example pattern -->
<p class="text-lg text-slate-600 mb-8 leading-relaxed">
```

Track this as a follow-on doc-update for WARNING-3 (which currently only covers the PLS badge); the contrast deviation is broader than the badge.

### WR-03: Slate-400 captions, kbd-hints, and meta text fail WCAG AA at small sizes

**File:** `index.html:191 (.key-badge), 263 (.kbd-hint), 289, 296, 297, 311, 314, 359, 366, 373, 401, 408, 436, 443, 450, 625, 636, 647, 658, 778`

**Issue:** `--neutral-400-rgb: 168 168 168` (`#A8A8A8`) on warm surface (`#FFF8F0`) is roughly **2.4:1** — fails AA for normal text and also fails the 3:1 large-text exemption at the sizes used. Affected sites include the answer-card "e.g., ..." example text at `text-xs` (lines 359/366/373/401/408/436/443/450), the welcome page meta "5 questions / ~2 minutes" (line 314), the back-button label (line 289), the step counter (line 296), and the matrix subtitles (lines 625/636/647/658). These are user-facing copy that conveys meaning, not decoration.

**Fix:** Re-anchor `--neutral-400-rgb` darker (e.g., `--neutral-400-rgb: 138 138 138;` matching Gray 2) so it crosses the 4.5:1 line, OR swap the consumers to `text-slate-500`/`text-slate-600`. The .key-badge and .kbd-hint glyphs are arguably decorative, but the answer-card example text is content.

### WR-04: Card and badge borders (`--border-rgb`, `--neutral-300-rgb`) fail 3:1 non-text contrast against warm surface

**File:** `index.html:174, 187, 206, 220, 267`

**Issue:** WCAG 2.1 SC 1.4.11 requires non-text UI components (form borders, icon containers, focus outlines that are not the only indicator, etc.) to have a 3:1 contrast against their adjacent color. The token contract sets:

- `--border-rgb: 229 229 229;` (`#E5E5E5`) used on `.answer-card` / `.check-card` borders (lines 174, 206). Against `--surface-rgb` `#FFF8F0` the contrast is ~1.07:1.
- `--neutral-300-rgb: 209 209 209;` (`#D1D1D1`) used on `.key-badge`, `.check-box`, and `.kbd-hint span` borders (lines 187, 220, 267). Against warm surface the contrast is ~1.35:1.

Both fall well below 3:1. The answer-cards' affordance (a clickable container) depends on the border to communicate "this is a target." On the warm surface the border is barely perceptible until hover or selection.

**Fix:** Push `--border-rgb` and `--neutral-300-rgb` to darker anchors that retain the warm-neutral feel while clearing 3:1:
```css
--border-rgb:      209 209 209;  /* #D1D1D1 -> 1.55:1 still fails; needs deeper */
--border-rgb:      168 168 168;  /* #A8A8A8 -> ~2.4:1 still fails */
--border-rgb:      138 138 138;  /* #8A8A8A -> ~3.6:1 clears */
```
Alternatively, accept lower contrast on the borders but ensure the cards have a visible secondary affordance (e.g., a subtle fill differentiation or icon).

### WR-05: Sticky-footer gradient on slides 4 and 5 has no destination color

**File:** `index.html:481, 517`

**Issue:** Both sticky footers declare `bg-gradient-to-t from-surface-warm via-surface-warm` with no `to-*` stop:

```html
<div class="flex-shrink-0 px-6 pt-3 pb-5 bg-gradient-to-t from-surface-warm via-surface-warm border-t border-slate-100">
```

Tailwind generates a CSS linear-gradient that ends at an implicit `transparent` of the via color. The intent appears to be "solid warm fill that fades at the top to nothing so the scrollable region behind shows through softly," but because the parent slide is also `bg-surface-warm`, the gradient renders as a solid fill in practice. If a future theme changes the slide background but not the footer gradient, the gradient will start blending with the new slide bg in unexpected ways.

**Fix:** Either remove the unused gradient utilities and use a flat `bg-surface-warm`, or specify the destination explicitly:
```html
<!-- option A: flat -->
<div class="flex-shrink-0 px-6 pt-3 pb-5 bg-surface-warm border-t border-slate-100">

<!-- option B: explicit fade to transparent -->
<div class="flex-shrink-0 px-6 pt-3 pb-5 bg-gradient-to-t from-surface-warm via-surface-warm to-surface-warm/0 border-t border-slate-100">
```

### WR-06: Override-notice icon uses `text-yellow-400` on a yellow-tinted background — non-text contrast under 3:1

**File:** `index.html:579-582`

**Issue:** The override-notice icon container sets `style="background: rgb(var(--brand-secondary-rgb) / 0.15);"` (i.e., `#F1C232` at 15% alpha over the parent's white) and places a `text-yellow-400` (`#F1C232`) warning glyph inside. The icon and its container background are the same hue at low alpha — visual contrast on the glyph is ~1.6:1 against the tinted backdrop, ~2.1:1 against the underlying white. Either way it fails WCAG 2.1 SC 1.4.11 (3:1 for non-text components).

**Fix:** Either darken the icon (`text-ink` keeps the yellow halo and is high-contrast) or strengthen the tint (`bg-yellow-100` for solid `#FFE599`, which gives the icon a clearer pad). Example:

```html
<div class="flex-shrink-0 w-10 h-10 rounded-lg flex items-center justify-center bg-yellow-100">
    <svg class="w-5 h-5 text-ink" ...>
```

## Info

### IN-01: `--neutral-900-rgb` is declared but never consumed

**File:** `index.html:75`

**Issue:** The comment on line 75 acknowledges this explicitly: `"no current Tailwind consumer; declared per D-07 brandable-ramp"`. Documented intentional dead code is preferable to surprise dead code, but if no consumer ever materializes, future readers will wonder whether they should add one. Consider marking it as `Reserved for future use:` in the comment so the intent is unambiguous.

**Fix:** Either remove the declaration until a consumer exists, or expand the comment to `/* #1A1A1A reserved for future deep-canvas use; no current consumer per D-07 */`.

### IN-02: Theme client-slug input is consumed via `setAttribute` without an allow-list

**File:** `index.html:8-11`

**Issue:** The pre-Tailwind bootstrap reads `?client=...` from the URL and writes it to `document.documentElement.setAttribute('data-theme', p)` without validation. This is not an XSS vector (`setAttribute` does not parse HTML, and `data-theme` is only ever used as a CSS attribute selector), but a malformed value (e.g., quote characters or extremely long strings) will silently no-op the theme CSS without surfacing a useful error to anyone debugging a typo in the slug. Low priority; flag for future hardening when the theme system gains more clients.

**Fix:** Add a length/charset guard before the `setAttribute` call:
```js
(function () {
    var p = new URLSearchParams(location.search).get('client');
    if (p && /^[a-z0-9-]{1,32}$/.test(p)) {
        document.documentElement.setAttribute('data-theme', p);
    }
})();
```

### IN-03: `text-yellow-400` Tailwind utility uses the brand-secondary token rather than the Tailwind default yellow-400

**File:** `index.html:580`

**Issue:** The Tailwind config block defines `yellow: { 100: ..., 400: ... }` (lines 120-123), so `text-yellow-400` resolves to the Overdrive Golden Yellow (`#F1C232`) rather than Tailwind's stock `#facc15`. This is intentional per the secondary-palette design, but it is the only `text-yellow-400` consumer in the file and the visual outcome (per WR-06) is poor. The token is also consumed indirectly by the icon container inline-style on line 579 (`rgb(var(--brand-secondary-rgb) / 0.15)`), which is fine. Consider whether `yellow-400` needs a `text-*` utility at all if no other site uses it; if not, removing it from the config makes the palette intent clearer.

**Fix:** No code change required if WR-06 is addressed (the icon stops using `text-yellow-400`). Otherwise, document in the Tailwind config block that `yellow.400` is a *background-only* token.

---

_Reviewed: 2026-05-16_
_Reviewer: Claude (gsd-code-reviewer)_
_Depth: standard_
