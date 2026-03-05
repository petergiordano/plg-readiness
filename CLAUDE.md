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
- Fraunces (display/headings), Plus Jakarta Sans (body), JetBrains Mono (labels/overlines) — Google Fonts

**Structure inside `index.html`:**
1. Tailwind config + custom CSS (`<head>`) — extends palette, defines `.slide` transition states, `.answer-card` / `.check-card` selection styles, and result reveal animations
2. Fixed UI chrome — 3px progress bar (top), back button + step counter overlay (`#quiz-chrome`)
3. Six slides (`#slide-0` through `#slide-5`) — `position: fixed; inset: 0` with `s-active / s-above / s-below` state classes driving translateY transitions
4. `#results-page` — hidden `div` that becomes a normal scroll page after the quiz; contains result cards, wedge callout, override notice, reference matrix, footer
5. Inline `<script>` at bottom — all state and logic

**Slide flow:**
- Slide 0: Welcome / CTA
- Slides 1–3: One radio question each (auto-advance on selection after 380ms delay)
- Slides 4–5: Multi-select checkboxes in a 2-column grid; fixed question header + scrollable list + sticky Continue/See Result button
- After slide 5: `showResults()` fades out slides, reveals `#results-page` as normal scroll

**Navigation system:**
- `currentSlide` integer tracks position; `goTo(n)` applies state classes to all slides
- `goNext()` / `goPrev()` call `goTo`; `updateChrome()` syncs progress bar, back button, step counter
- Keyboard: `A`/`B`/`C` select radio options on slides 1–3; `Enter` advances any slide
- `selectAnswer(btn, autoAdvance)` deselects siblings, marks selected, triggers auto-advance
- `restartQuiz()` resets all state, re-shows slides, calls `goTo(0)`

**Scoring logic** (`calculateScore()` function):
- Phase 1 radio answers (`answers.buyerUser`, `answers.viral`, `answers.scope`) stored in `answers` object
- `buyerUser === 'csuite'` or `scope === 'enterprise'` forces Sales-Led regardless of Phase 2
- Phase 2 checkbox counts (`accCount` / `fricCount`) only modify results within PLG-viable cases
- Wedge potential triggers when Sales-Led is required but `accCount >= 4` and `fricCount <= 2`
- Result states: "Pure PLG: Ideal Candidate", "PLG Motion with Optimization Needed", "Product-Led Sales (Hybrid)", "Sales-Led with Wedge Opportunity", "Sales-Led Growth Required", "Hybrid Approach Recommended"

**Phase 2 checkbox rendering** — `accelerators` and `frictionPoints` arrays defined in JS, rendered into `#accelerators-list` / `#friction-list` via `renderCheckboxes()`. Each card is a `<button>` with a hidden `<input type="checkbox">` inside; toggled via `.selected` class + `card.checked`.

**Result display** — `#result-container`, `#wedge-callout`, `#override-notice` start hidden; `calculateScore()` populates text content and removes `hidden` as needed.

## Design Guidelines

See `docs/design/Modern-Web-UI-Design-Guidelines.md` before making UI changes. Key rules:
- Slate color palette with `#4F46E5` (primary indigo) as the single accent
- Clean cards with `1.5px` borders, no heavy shadows or gradients; selected state uses `#EEF2FF` bg + indigo border
- Spacing follows 4/8/16/24/32px scale via Tailwind utilities
- Typography: Fraunces for display headings, Plus Jakarta Sans for body, JetBrains Mono for overlines/labels/keyboard hints
- Slide background: `#FAFAF8` (`surface-warm`); results hero uses `#0F172A` (`surface-dark`)

## Agents

Specialized agents in `.claude/agents/`. Read the relevant agent
before starting work that matches its domain.

- **cli-developer** -- CLI UX: argument naming, progress output, error messages, help text, shell completions
- **code-reviewer** -- Code review: best practices, anti-patterns, security, performance, readability
- **data-analyst** -- Data analysis: data exploration, visualization, statistical methods, insights
- **data-engineer** -- Data engineering: pipelines, ETL, data modeling, storage, performance
- **debugger** -- Debugging: root cause analysis, error tracing, hypothesis testing, fix verification
- **documentation-engineer** -- Documentation: API docs, README quality, user guides, code comments
- **frontend-developer** -- Frontend code: HTML/CSS/JS structure, responsive layouts, component patterns
- **python-pro** -- Python code patterns: type hints, error handling, Pythonic idioms, async, testing
- **qa-expert** -- Quality assurance: test strategy, edge cases, acceptance criteria, regression testing
- **ui-designer** -- UI design: visual hierarchy, spacing, color, typography, interaction patterns


## Reference Code

`reference/cli-tool-template.py` is a working Python CLI pattern
with .env loading, argparse, batch processing, and progress reporting.
Use as structural reference -- do not copy wholesale.
