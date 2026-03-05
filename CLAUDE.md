# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A single-file static web app: a PLG Readiness Diagnostic tool that helps founders determine their appropriate go-to-market motion (Pure PLG, Product-Led Sales, Sales-Led, or Wedge strategy).

## Running Locally

No build step. Open `index.html` directly in a browser or serve it:

```bash
python3 -m http.server 8080
# then visit http://localhost:8080
```

## Architecture

Everything lives in `index.html`. There is no build system, no package manager, no separate JS or CSS files.

**Dependencies (CDN only):**
- Tailwind CSS — loaded via CDN with an inline config block at the top of `<head>`
- Inter font — loaded from Google Fonts

**Structure inside `index.html`:**
1. Tailwind config + custom CSS (top of `<head>`) — extends the color palette and defines checkbox/radio visual states using CSS sibling selectors (hidden `<input>` + styled adjacent `<div>`)
2. HTML sections — nav, hero, Phase 1 (radio questions), Phase 2 (checkbox lists rendered by JS), result container, matrix reference table, footer
3. Inline `<script>` at bottom — all application logic

**Scoring logic** (`calculateScore()` function):
- Phase 1 radio answers act as hard overrides. `buyerUser === 'csuite'` or `scope === 'enterprise'` forces Sales-Led regardless of Phase 2.
- Phase 2 checkboxes (`accCount` / `fricCount`) only modify results within PLG-viable cases.
- Wedge potential triggers when Sales-Led is required but `accCount >= 4` and `fricCount <= 2`.
- Result states: "Pure PLG: Ideal Candidate", "PLG Motion with Optimization Needed", "Product-Led Sales (Hybrid)", "Sales-Led with Wedge Opportunity", "Sales-Led Growth Required", "Hybrid Approach Recommended"

**Phase 2 checkbox rendering** — `accelerators` and `frictionPoints` arrays are defined in JS and rendered dynamically into `#accelerators-list` and `#friction-list` via `renderCheckboxes()`.

**Result display** — result cards, the wedge callout, and the override notice are all in the DOM but hidden via Tailwind's `hidden` class; JS removes/adds `hidden` to show them.

## Design Guidelines

See `docs/design/Modern-Web-UI-Design-Guidelines.md` before making UI changes. Key rules:
- Slate color palette with `#4F46E5` (primary indigo) as the single accent
- Clean cards with subtle borders, no heavy shadows or gradients
- Spacing follows 4/8/16/24/32px scale via Tailwind utilities
- Typography: Inter, large headings, 16-18px body text
