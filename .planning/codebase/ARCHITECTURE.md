# Architecture

**Analysis Date:** 2026-03-05

## Pattern Overview

**Overall:** Single-file static web application — no build system, no server, no framework.

**Key Characteristics:**
- All HTML, CSS, and JavaScript live in `index.html`
- No module system; all code executes in browser global scope
- State is held entirely in DOM input elements (no JS state object)
- CDN-loaded dependencies only (Tailwind CSS, Inter font)

## Layers

**Presentation Layer:**
- Purpose: HTML structure and visual layout
- Location: `index.html` lines 71–441 (body HTML sections)
- Contains: Semantic HTML sections (nav, header, main, section, footer), Tailwind utility classes
- Depends on: Tailwind CSS (CDN), custom CSS styles defined in `<head>`
- Used by: Browser rendering engine

**Style Layer:**
- Purpose: Visual appearance and interactive checkbox/radio states
- Location: `index.html` lines 9–69 (`<head>` — Tailwind config block + `<style>` tag)
- Contains: Tailwind config extending color palette; CSS sibling-selector rules for hidden `<input>` + visible adjacent `<div>` pattern
- Depends on: Tailwind CSS CDN (`https://cdn.tailwindcss.com`)
- Used by: Presentation layer

**Data Layer:**
- Purpose: Static content definitions for Phase 2 checkboxes
- Location: `index.html` lines 444–484 (top of inline `<script>`)
- Contains: `accelerators` array (9 items), `frictionPoints` array (9 items), each with `label` and `example` fields
- Depends on: Nothing
- Used by: Application logic (`renderCheckboxes`)

**Application Logic Layer:**
- Purpose: DOM rendering, user input collection, scoring calculation, result display
- Location: `index.html` lines 443–603 (inline `<script>` at bottom of `<body>`)
- Contains: `renderCheckboxes()`, `calculateScore()`
- Depends on: DOM elements by ID, data arrays
- Used by: User interactions (button click, page load)

## Data Flow

**Checkbox Rendering (page load):**

1. Browser parses `index.html` and reaches the `<script>` block
2. `accelerators` and `frictionPoints` arrays are defined
3. `renderCheckboxes(accelerators, 'accelerators-list', 'accelerator')` is called immediately
4. `renderCheckboxes(frictionPoints, 'friction-list', 'friction')` is called immediately
5. Each call iterates the array, creates `<label>` elements with hidden `<input>` checkboxes, and appends them to the target container ID

**Scoring (button click):**

1. User clicks "Analyze My Product Strategy" button, which calls `calculateScore()` inline via `onclick`
2. Phase 1 radio values read from DOM: `buyerUser`, `viral`, `scope` via `querySelector`
3. Phase 2 counts read from DOM: `accCount` (checked accelerators), `fricCount` (checked friction points) via `querySelectorAll(...).length`
4. Validation: If any Phase 1 radio is unselected, `alert()` fires and function returns
5. All result containers reset to `hidden`; `result-container` made visible
6. Scoring logic evaluates conditionals and sets `textContent` on result DOM elements
7. Result container scrolls into view via `scrollIntoView`

**State Management:**
- No JavaScript state object exists
- All user selections live in browser DOM input state (checked/unchecked radio and checkbox inputs)
- Result display state controlled by adding/removing Tailwind `hidden` class on DOM elements

## Key Abstractions

**Input Controls (CSS Pattern):**
- Purpose: Visually styled radio buttons and checkboxes that use native browser input behavior
- Pattern: Hidden `<input>` element followed by a styled `<div>`; CSS sibling selector (`:checked + div`) applies active styles
- Defined at: `index.html` lines 42–68
- Used by: All Phase 1 radio groups (hardcoded HTML) and all Phase 2 checkboxes (rendered by JS)

**Checkbox Data Arrays:**
- Purpose: Single source of truth for Phase 2 content
- Examples: `accelerators` (line 444), `frictionPoints` (line 465)
- Pattern: Array of `{ label: string, example: string }` objects consumed by `renderCheckboxes()`

**Result Cards:**
- Purpose: Pre-rendered but hidden UI shells that JS populates and reveals
- Elements: `#result-container`, `#result-title`, `#result-description`, `#result-recommendation`, `#wedge-callout`, `#override-notice`, `#override-explanation`
- Pattern: All in DOM at load time; shown/hidden by adding/removing `hidden` class

## Entry Points

**Page Load:**
- Location: `index.html` — inline `<script>` block (lines 443–603) executes immediately at parse time
- Triggers: Browser parsing the bottom-of-body script tag
- Responsibilities: Defines data arrays, calls `renderCheckboxes()` twice to populate Phase 2 UI

**User Assessment Submission:**
- Location: `index.html` line 325 — `<button onclick="calculateScore()">`
- Triggers: User clicking "Analyze My Product Strategy"
- Responsibilities: Validates Phase 1 completion, computes GTM recommendation, updates result DOM

## Scoring Logic

**Hard Overrides (Phase 1 determines result regardless of Phase 2):**
- `buyerUser === 'csuite'` OR `scope === 'enterprise'` → forces Sales-Led path
- `buyerUser === 'same'` AND `scope === 'individual'` → Pure PLG path

**Wedge Trigger:**
- Condition: `requiresSales === true` AND `accCount >= 4` AND `fricCount <= 2`
- Result: "Sales-Led with Wedge Opportunity" + `#wedge-callout` shown

**Result States (6 total):**
1. `"Pure PLG: Ideal Candidate"` — isPurePLG + viral=organic + accCount≥4 + fricCount≤1
2. `"PLG Motion with Optimization Needed"` — isPurePLG but friction present
3. `"Product-Led Sales (Hybrid)"` — scope=team or buyerUser=manager
4. `"Sales-Led with Wedge Opportunity"` — requiresSales + hasWedgePotential
5. `"Sales-Led Growth Required"` — requiresSales without wedge potential
6. `"Hybrid Approach Recommended"` — all other cases

## Error Handling

**Strategy:** Minimal — single `alert()` for incomplete Phase 1; no other error handling.

**Patterns:**
- Phase 1 validation: `if (!buyerUser || !viral || !scope)` → `alert()` + early return
- Phase 2 checkboxes: No validation; zero selections are valid (count defaults to 0)
- No try/catch blocks anywhere

## Cross-Cutting Concerns

**Logging:** None — no `console.log` statements.
**Validation:** Phase 1 completeness check only; no input sanitization (inputs are constrained radio/checkbox controls with no free text).
**Authentication:** Not applicable — fully static, no user accounts.

---

*Architecture analysis: 2026-03-05*
