# Coding Conventions

**Analysis Date:** 2026-03-05

## Overview

This is a single-file static web app (`index.html`). All conventions apply to HTML structure, inline CSS, Tailwind utility classes, and the inline `<script>` block at the bottom of the file.

## Naming Patterns

**HTML IDs:**
- Use kebab-case: `result-container`, `result-title`, `result-description`, `result-recommendation`, `wedge-callout`, `override-notice`, `override-explanation`, `accelerators-list`, `friction-list`
- IDs are the primary JS-to-DOM interface — every element JS manipulates has an explicit ID

**HTML Names (form inputs):**
- Use camelCase for radio group names: `buyerUser`, `viral`, `scope`
- Use lowercase for checkbox group names: `accelerator`, `friction`
- Radio values use descriptive lowercase strings: `same`, `manager`, `csuite`, `organic`, `siloed`, `individual`, `team`, `enterprise`

**JavaScript Variables:**
- Use camelCase: `buyerUser`, `viral`, `scope`, `accCount`, `fricCount`, `resultContainer`, `resultTitle`, `resultDesc`, `resultRec`, `wedgeCallout`, `overrideNotice`, `overrideExplanation`
- Boolean flags use descriptive names: `requiresSales`, `isPurePLG`, `hasWedgePotential`
- Data arrays use camelCase plural nouns: `accelerators`, `frictionPoints`

**JavaScript Functions:**
- Use camelCase verbs: `renderCheckboxes()`, `calculateScore()`

**CSS Classes (custom):**
- Use kebab-case for custom classes: `.checkbox-wrapper`, `.checkbox-square`, `.check-icon`, `.radio-wrapper`, `.radio-circle`, `.radio-dot`, `.radio-label`

**Tailwind Classes:**
- Follow Tailwind conventions as defined — the inline `tailwind.config` block extends colors with camelCase keys: `primary`, `primaryHover`

## Code Style

**Formatting:**
- No formatter configured (no `.prettierrc`, `.eslintrc`, or `biome.json`)
- HTML uses 4-space indentation consistently throughout the file
- JavaScript uses 4-space indentation
- CSS inside `<style>` uses 4-space indentation

**Linting:**
- No linting tooling configured
- No `package.json` or devDependencies exist — this is a zero-build project

## HTML Structure Conventions

**Section organization inside `index.html`:**
1. `<head>`: Tailwind CDN script, Google Fonts link, Tailwind config block, custom `<style>` block
2. `<nav>`: Sticky navigation bar
3. `<header>`: Hero section
4. `<main id="assessment">`: Assessment form sections (Phase 1 and Phase 2)
5. Result container (inside `<main>`) — always present in DOM, shown/hidden via Tailwind `hidden` class
6. `<section>`: Problem Scope Matrix reference table and key insight cards
7. `<footer>`: Footer
8. `<script>`: All application logic at end of `<body>`

**Card/section pattern:**
```html
<div class="bg-white rounded-xl border border-slate-200 p-6">
    <h3 class="text-lg font-semibold text-slate-900 mb-2">Title</h3>
    <p class="text-sm text-slate-500 mb-4">Subtitle</p>
    <!-- content -->
</div>
```

**Show/hide pattern — use Tailwind `hidden` class:**
- Result elements start with `hidden` class in HTML
- JS removes `hidden` to show: `element.classList.remove('hidden')`
- JS adds `hidden` to hide: `element.classList.add('hidden')`
- Never use `display: none` inline style or `element.style.display`

## Import Organization

**No module imports.** The project has no build system. Dependencies are loaded via CDN in `<head>`:
1. Tailwind CSS CDN script
2. Google Fonts link

## Error Handling

**User input validation:**
- Phase 1 radio completeness is validated before `calculateScore()` proceeds
- Uses native `alert()` for validation errors: `alert('Please complete all Phase 1 questions before analyzing.')`
- Optional chaining used on radio selectors to safely handle no-selection state: `document.querySelector('input[name="buyerUser"]:checked')?.value`

**No try/catch blocks.** The app has no async operations, no API calls, and no external data dependencies — no error handling beyond form validation is needed.

## JavaScript Patterns

**Data definition:**
- Data arrays (`accelerators`, `frictionPoints`) are defined as array-of-objects at the top of the script block, before functions
- Each object has consistent shape: `{ label: string, example: string }`

**DOM manipulation:**
- Query elements once at the start of `calculateScore()` and assign to local `const` variables before use
- Use `document.getElementById()` for stable ID-based lookups
- Use `document.querySelector()` with attribute selectors for radio/checkbox state
- Use `document.querySelectorAll()` + `.length` to count checked checkboxes

**Dynamic HTML generation:**
- `renderCheckboxes()` uses `document.createElement()` and `.innerHTML` template string assignment
- Template strings used for multi-line HTML snippets within `renderCheckboxes()`
- `container.appendChild(wrapper)` used to insert generated elements

**Scoring logic:**
- Scoring uses boolean derived variables (`requiresSales`, `isPurePLG`, `hasWedgePotential`) declared as `const` before the if/else chain
- The if/else chain reads top-to-bottom from most restrictive to least: Sales-Led override first, then Pure PLG ideal, then PLG with friction, then PLS hybrid, then fallback
- Result text is set directly on element `.textContent` for plain text, or `.textContent` string interpolation for dynamic values

**Inline event handlers:**
- The calculate button uses `onclick="calculateScore()"` inline attribute — the function is defined globally in the script block

## Tailwind Configuration

The Tailwind config block in `<head>` extends the default theme:
```javascript
tailwind.config = {
    theme: {
        extend: {
            fontFamily: { sans: ['Inter', 'sans-serif'] },
            colors: {
                primary: '#4F46E5',
                primaryHover: '#4338CA',
                slate: { 50..900 } // Full slate scale redefined
            }
        }
    }
}
```
Use `bg-primary`, `text-primary`, `hover:bg-primaryHover` — not raw hex values in Tailwind classes.

## Visual / Design Conventions

Defined in `docs/design/Modern-Web-UI-Design-Guidelines.md`. Key rules that apply to code:

**Spacing scale:** Use Tailwind spacing utilities that map to 4/8/16/24/32px — `p-4`, `p-6`, `p-8`, `gap-4`, `mb-6`, `py-12`, `py-16`

**Color palette:**
- Background: `bg-slate-50`
- Cards: `bg-white` with `border border-slate-200`
- Primary accent: `#4F46E5` via `bg-primary` / `text-primary`
- Body text: `text-slate-800`, secondary: `text-slate-600`, muted: `text-slate-500`

**Radius:** `rounded-xl` for cards and large containers; `rounded-lg` for inputs and buttons; `rounded-full` for pills/badges

**Shadows:** Avoid heavy shadows. Use `shadow-sm` at most; prefer borders for card definition.

**Typography:**
- Headings: `font-bold` + `tracking-tight`
- Body: default Inter weight
- Labels: `text-sm font-medium text-slate-700`
- Captions/examples: `text-xs text-slate-500`

## Comments

**HTML comments:** Used to label major sections: `<!-- Navigation -->`, `<!-- Hero Section -->`, `<!-- Assessment Section -->`, `<!-- Phase 1: Problem & Stakeholder Assessment -->`, `<!-- Phase 2: Product Characteristics -->`, `<!-- Result Section -->`, `<!-- Logic Script -->`

**CSS comments:** Used to label groups: `/* Checkbox Styles */`, `/* Radio Button Styles */`

**JavaScript comments:** Used sparingly to mark major sections: `// Render Checkboxes`, `// Phase 1: Get radio selections`, `// Phase 2: Get checkbox counts`, `// UI Elements`, `// Validate Phase 1 completion`, `// Reset visibility`, `// ========== CORE LOGIC ==========`, `// Override Logic:`, `// Pure PLG:`, `// Wedge potential:`

---

*Convention analysis: 2026-03-05*
