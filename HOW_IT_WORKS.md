# How It Works: PLG Readiness Diagnostic

> An interactive diagnostic tool that helps B2B SaaS founders determine the right go-to-market motion for their product. A founder answers six questions and gets a recommended motion — Pure PLG, Product-Led Sales, Sales-Led, or a Wedge strategy — with reasoning. The entire app is one self-contained HTML file with no build step.

## In Plain Terms

PLG stands for "product-led growth" — a strategy where the product itself, rather than a sales team, drives signups and revenue (think Slack or Figma, where you can just start using it). Not every company should go this route. This tool asks a founder six questions about who buys their product, how it spreads, and what its scope is. Based on the answers, it tells the founder which sales approach fits their situation. Some answers (like "the buyer is a C-suite executive") force a sales-led recommendation no matter what else is true. The result is a clear verdict plus an explanation of why, so a founder can stop guessing about their growth strategy. Running it successfully means a founder opens a web page, clicks through a short quiz, and walks away with a concrete recommendation.

## What This Project Does

Guides early-stage B2B SaaS founders to the correct go-to-market motion through a short, opinionated diagnostic. It encodes go-to-market coaching logic into a scoring algorithm so a founder gets a defensible recommendation instead of a gut call. Used by founders directly (self-serve) and as a coaching artifact in advisory sessions.

## How It's Organized

- `index.html` — the entire application: markup, styles, and logic in one file
- `docs/design/` — design system references (brand guide, UI guidelines, design spec); read before UI changes
- `docs/design/archive/` — superseded design framework docs
- `reference/cli-tool-template.py` — unrelated structural reference for Python CLIs; not part of the app
- `.planning/codebase/` — GSD codebase analysis docs (architecture, conventions, concerns, testing)
- `.claude/` — agents, persona, and skills config for Claude Code

## How It Runs

- Entry point: `index.html` — opened directly in a browser or served as a static file
- No runtime, no build system, no package manager
- Dependencies are CDN-only, loaded at page load: Tailwind CSS (utility styling, configured via inline `tailwind.config` block in `<head>`) and Google Fonts (Fraunces, Plus Jakarta Sans, JetBrains Mono)
- All state and logic live in a single inline `<script>` at the bottom of the file
- No environment variables, no secrets, no server

## The Core Flow

1. Slide 0 shows a welcome screen with a CTA to start
2. Slides 1–3 each ask one radio question; selecting an answer stores it in the `answers` object and auto-advances after 380ms
3. Slides 4–5 present multi-select checkbox grids (accelerators, friction points); user selects any number and clicks a sticky Continue button
4. `goTo(n)` drives all navigation, applying `.s-active / .s-above / .s-below` classes for slide transitions; `updateChrome()` syncs the progress bar and back button
5. After slide 5, `showResults()` fades out the slides and reveals `#results-page` as a normal scroll page
6. `calculateScore()` reads `answers` plus checked inputs, applies the scoring rules, and populates the result DOM (`#result-container`, `#wedge-callout`, `#override-notice`)

## Key Concepts & Patterns

- **Single-file architecture** — everything is in `index.html` on purpose; no build step keeps it trivially deployable and editable. Adding a separate JS/CSS file breaks this contract.
- **Fixed-slide navigation** — slides are `position: fixed; inset: 0` and animate via state classes, not DOM mounting/unmounting. New slides must follow the `#slide-N` + state-class pattern.
- **Override rules in scoring** — certain answers (`buyerUser === 'csuite'`, `scope === 'enterprise'`) force Sales-Led regardless of Phase 2 input. Phase 2 checkbox counts only modify results within PLG-viable cases.
- **Wedge detection** — a special case where Sales-Led is required but high accelerator count and low friction count signal a wedge opportunity; surfaced via `#wedge-callout`.
- **Data-driven checkboxes** — Phase 2 options live in `accelerators` / `frictionPoints` JS arrays and render via `renderCheckboxes()`. Add options by editing the arrays, not the markup.

## How to Work on It

```bash
# Run locally — no build step
python3 -m http.server 8080
# then visit http://localhost:8080

# Or just open the file directly
open index.html
```

- No install, no test command, no build command
- Edit `index.html` directly; refresh the browser to see changes
- Before UI changes, read `docs/design/Modern-Web-UI-Design-Guidelines.md` and `docs/design/DESIGN_SPEC_plg-readiness.md`
- This project uses GSD workflow conventions; planning artifacts live in `.planning/`

## What to Know Before Changing Things

- **No build system is a feature, not a gap** — keep the app a single static `index.html`. Do not introduce bundlers, npm, or external asset files.
- **CDN dependencies require network at load time** — Tailwind and Google Fonts load from CDNs; the app degrades without internet (unstyled, fallback fonts).
- **Scoring override logic is order-sensitive** — Phase 1 forced-result rules run before Phase 2 modifiers. Changing the order changes recommendations silently.
- **Slide count is wired into navigation** — `currentSlide` bounds, progress bar math, and `updateChrome()` assume 6 slides (0–5). Adding or removing a slide means updating these together.
- **Color palette is constrained** — slate palette with `#4F46E5` as the single accent; selected card state is `#EEF2FF` bg + indigo 1.5px border. Do not introduce new accent colors or heavy shadows/gradients.

<!-- agent-maintained: start -->
## Registry

> _Runtime integrations — APIs, CLI tools, services, and data sources this system calls or connects to. One row per component. Coding agent maintains this; skill never overwrites it._

| Component | Type | Status | What it provides |
|---|---|---|---|
| Tailwind CSS CDN (cdn.tailwindcss.com) | service | active | Utility-class styling, configured via inline `tailwind.config` |
| Google Fonts | service | active | Fraunces, Plus Jakarta Sans, JetBrains Mono webfonts |

## Assumptions

> _Things this system takes as given. Silent failure or wrong output if any assumption breaks. Coding agent maintains this; skill never overwrites it._

| Assumption | Where it matters | Risk if wrong |
|---|---|---|
| Network available at page load | Tailwind + Google Fonts CDN loads | App renders unstyled with fallback fonts |
| Exactly 6 slides (0–5) | Navigation, progress bar, `updateChrome()` | Off-by-one in progress/bounds; broken nav |
| Phase 1 answers can force a result before Phase 2 runs | `calculateScore()` override logic | Wrong GTM recommendation surfaced silently |

## Configurables

> _Hardcoded thresholds, paths, and parameters — the operational knobs. Coding agent maintains this; skill never overwrites it._

| Parameter | Value | Location |
|---|---|---|
| Radio auto-advance delay | 380ms | inline `<script>` in `index.html` |
| Wedge trigger thresholds | `accCount >= 4` and `fricCount <= 2` | `calculateScore()` in `index.html` |
| Slide count | 6 (`#slide-0`–`#slide-5`) | markup + navigation logic in `index.html` |

## Update Protocol

> _Run after each phase completes (triggered by SUMMARY.md hook). Update only the agent-maintained sections above — skill-owned sections are regenerated by `/how-it-works`._

- **Registry** — add a row for any new integration introduced this phase; update Status for completed or deprecated items
- **Assumptions** — add a row if this phase introduced a new inference, heuristic, or external dependency
- **Configurables** — add a row for any new threshold, hardcoded value, or path
- **What to Know Before Changing Things** — flag any new gotcha uncovered during implementation
<!-- agent-maintained: end -->

<!-- how-it-works-meta
generated: 2026-05-14T00:00:00Z
fingerprint:
  top_level_dirs: [docs, reference]
  config_files: []
  entry_points: [index.html]
  tech_stack: [tailwind]
  test_command: null
  build_command: null
  deploy_method: manual
-->
