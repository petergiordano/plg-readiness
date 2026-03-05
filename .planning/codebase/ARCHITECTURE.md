# Architecture

**Analysis Date:** 2026-03-05

## Pattern Overview

**Overall:** Single-File Static Web Application

**Key Characteristics:**
- Entire application lives in one file: `index.html`
- No build system, no compilation, no server-side logic
- CDN-delivered dependencies only (Tailwind CSS, Google Fonts)
- Inline JavaScript handles all app state and scoring logic
- No persistence layer — all state is ephemeral (exists only in DOM during the session)

## Layers

**Presentation Layer (HTML structure):**
- Purpose: Defines the visual skeleton and all static content
- Location: `index.html` lines 71–441
- Contains: Nav, hero, Phase 1 radio questions, Phase 2 checkbox containers, result container, matrix reference table, footer
- Depends on: CSS styles in `<head>`, JavaScript at bottom of `<body>`
- Used by: Browser rendering engine

**Style Layer (CSS):**
- Purpose: Defines visual appearance and interactive states
- Location: `index.html` lines 9–69 (Tailwind config block + `<style>` block)
- Contains: Tailwind CDN config with custom palette, CSS sibling selectors for checkbox/radio visual states
- Depends on: `https://cdn.tailwindcss.com`, Google Fonts CDN
- Used by: HTML elements via utility class names and CSS selector rules

**Data Layer (JS arrays):**
- Purpose: Stores all checkbox content as structured data
- Location: `index.html` lines 444–484
- Contains: `accelerators` array (9 items) and `frictionPoints` array (9 items), each with `label` and `example` fields
- Depends on: Nothing
- Used by: `renderCheckboxes()` function

**Rendering Layer (JS function):**
- Purpose: Dynamically generates Phase 2 checkbox DOM elements from data arrays
- Location: `index.html` lines 487–511, `renderCheckboxes()` function
- Contains: DOM creation logic that builds `<label>` + `<input>` + `<div>` structures
- Depends on: `accelerators`, `frictionPoints` arrays; `#accelerators-list` and `#friction-list` DOM elements
- Used by: Runs on page load (lines 510–511)

**Scoring/Logic Layer (JS function):**
- Purpose: Reads user selections, applies scoring rules, updates result DOM
- Location: `index.html` lines 513–602, `calculateScore()` function
- Contains: Input reading, validation, scoring decision tree, DOM manipulation for results
- Depends on: All Phase 1 radio inputs and Phase 2 checkbox inputs; result DOM elements
- Used by: "Analyze My Product Strategy" button `onclick` handler (line 325)

## Data Flow

**Assessment Flow:**

1. Page loads — `renderCheckboxes()` executes immediately, injecting 9 accelerator and 9 friction checkbox elements into `#accelerators-list` and `#friction-list`
2. User selects Phase 1 radio answers (buyerUser, viral, scope) — native browser radio behavior, no JS involved
3. User selects Phase 2 checkboxes — native browser checkbox behavior, no JS involved
4. User clicks "Analyze My Product Strategy" button — triggers `calculateScore()`
5. `calculateScore()` reads all selected inputs via `document.querySelector()` / `document.querySelectorAll()`
6. Validation check: if any Phase 1 radio is unselected, `alert()` is fired and function exits
7. Scoring decision tree runs (see Scoring Logic section)
8. `result-container` `hidden` class is removed; result text nodes are populated
9. Conditionally, `wedge-callout` and/or `override-notice` `hidden` classes are removed
10. `scrollIntoView()` scrolls user to result

**State Management:**
- No state object — state lives entirely in DOM input elements
- Result is computed fresh every time the button is clicked
- Previous result is overridden (not appended) on recalculation

## Key Abstractions

**Result States (6 named outcomes):**
- Purpose: Maps scoring logic branches to human-readable GTM recommendations
- Values: `"Pure PLG: Ideal Candidate"`, `"PLG Motion with Optimization Needed"`, `"Product-Led Sales (Hybrid)"`, `"Sales-Led with Wedge Opportunity"`, `"Sales-Led Growth Required"`, `"Hybrid Approach Recommended"`
- Pattern: Not an enum — result title/description/recommendation are set directly on DOM text nodes

**Phase 1 Radio Inputs (3 questions, hard override signals):**
- `buyerUser`: `"same"` | `"manager"` | `"csuite"`
- `viral`: `"organic"` | `"siloed"`
- `scope`: `"individual"` | `"team"` | `"enterprise"`

**Phase 2 Checkbox Counts (numeric signals, secondary modifiers):**
- `accCount`: integer 0–9, count of checked PLG accelerators
- `fricCount`: integer 0–9, count of checked friction points

**Checkbox Item Schema:**
```javascript
{ label: String, example: String }
```

## Entry Points

**Page Load:**
- Location: `index.html` lines 510–511, inline script at bottom of `<body>`
- Triggers: Browser `DOMContentLoaded` (implicit — scripts at bottom of body)
- Responsibilities: Renders Phase 2 checkboxes into DOM before user interaction

**User-Triggered Calculation:**
- Location: `index.html` line 325, button `onclick="calculateScore()"`
- Triggers: User clicks "Analyze My Product Strategy" button
- Responsibilities: Validate inputs, compute GTM recommendation, display result

## Scoring Logic

**Override Logic (hard gates):**
```
requiresSales = (buyerUser === 'csuite') OR (scope === 'enterprise')
```
When `requiresSales` is true, result is always Sales-Led (or Sales-Led with Wedge). Phase 2 counts cannot override this.

**Wedge Potential (modifier within Sales-Led):**
```
hasWedgePotential = requiresSales AND accCount >= 4 AND fricCount <= 2
```

**Pure PLG Ideal (strongest PLG signal):**
```
isPurePLG = (buyerUser === 'same') AND (scope === 'individual')
isPurePLG AND viral === 'organic' AND accCount >= 4 AND fricCount <= 1
→ "Pure PLG: Ideal Candidate"
```

**Decision Tree Priority (highest to lowest):**
1. `requiresSales` → Sales-Led branch (with or without wedge)
2. `isPurePLG` + strong signals → Pure PLG Ideal
3. `isPurePLG` + weaker signals → PLG with Optimization
4. `scope === 'team'` OR `buyerUser === 'manager'` → Product-Led Sales
5. Default → Hybrid Approach

## Error Handling

**Strategy:** Minimal — single validation with `alert()` dialog

**Patterns:**
- Incomplete Phase 1: `alert('Please complete all Phase 1 questions before analyzing.')` then early `return`
- No error handling on DOM queries — silently fails if elements not found (not expected in practice since HTML is static)

## Cross-Cutting Concerns

**Logging:** None — no console logging or analytics
**Validation:** Phase 1 completeness only — Phase 2 has no minimum requirement
**Authentication:** None — fully public, no auth layer

---

*Architecture analysis: 2026-03-05*
