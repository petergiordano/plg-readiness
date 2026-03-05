# Coding Conventions

**Analysis Date:** 2026-03-05

## Project Context

This is a single-file static web app. All code lives in `index.html`. There is no build system, no TypeScript, no module bundler, and no separate JS or CSS files. Conventions reflect a vanilla HTML/CSS/JS codebase with Tailwind CSS loaded from CDN.

## Naming Patterns

**HTML IDs:**
- kebab-case: `result-container`, `result-title`, `result-description`, `result-recommendation`, `wedge-callout`, `override-notice`, `override-explanation`, `accelerators-list`, `friction-list`
- IDs identify unique DOM elements that JS reads or mutates; every interactive target has one

**HTML name attributes (form inputs):**
- camelCase for radio groups: `buyerUser`, `viral`, `scope`
- camelCase for checkbox groups: `accelerator`, `friction`

**JavaScript variables:**
- camelCase for all locals: `buyerUser`, `viral`, `scope`, `accCount`, `fricCount`, `resultContainer`, `resultTitle`, `resultDesc`, `resultRec`, `wedgeCallout`, `overrideNotice`, `overrideExplanation`
- camelCase for booleans prefixed with verb: `requiresSales`, `isPurePLG`, `hasWedgePotential`
- Short abbreviations used for counts: `accCount`, `fricCount`

**JavaScript functions:**
- camelCase: `renderCheckboxes()`, `calculateScore()`
- Function names are imperative verbs describing the action

**JavaScript constants (data arrays):**
- camelCase plural nouns: `accelerators`, `frictionPoints`

**CSS classes:**
- Tailwind utility classes only for layout and visual styling
- Custom CSS class names use kebab-case: `checkbox-wrapper`, `radio-wrapper`, `checkbox-square`, `radio-circle`, `radio-dot`, `radio-label`, `check-icon`
- Custom classes are semantic (describe the component role, not the style)

## Code Style

**Formatting:**
- No linting or formatting tools configured (no `.eslintrc`, no `.prettierrc`, no `biome.json`)
- 4-space indentation throughout HTML and JavaScript (consistent)
- Single quotes used for HTML attribute values; template literals use backtick with `${}` interpolation
- Opening braces on same line as control structures

**JavaScript style:**
- `const` preferred over `let` or `var` for all variable declarations in `calculateScore()`
- Arrow function syntax used in `forEach`: `list.forEach((item, index) => { ... })`
- Optional chaining (`?.`) used for safe DOM queries: `document.querySelector('input[name="buyerUser"]:checked')?.value`
- Template literals used for DOM construction in `renderCheckboxes()` — multi-line strings with `\`` backticks
- No semicolons omitted — all statements end with semicolons

**HTML structure:**
- Semantic elements: `<nav>`, `<header>`, `<main>`, `<section>`, `<footer>`, `<table>`, `<thead>`, `<tbody>`
- Comments mark each major section: `<!-- Navigation -->`, `<!-- Hero Section -->`, `<!-- Phase 1: ... -->`, `<!-- Logic Script -->`
- Section comments use `<!-- ===== HEADER ===== -->` style dividers inside the `<script>` block: `// ========== CORE LOGIC ==========`

## Import Organization

No import/module system. All dependencies loaded in `<head>` in this order:
1. Tailwind CDN script
2. Google Fonts link
3. Inline `<script>` for Tailwind config
4. Inline `<style>` for custom CSS overrides

Application logic lives in a single inline `<script>` tag at the bottom of `<body>`, after all HTML.

**Path Aliases:** Not applicable (no module system).

## Data Structures

**Content arrays** — data items are plain objects with exactly two keys:
```javascript
{ label: "...", example: "e.g., ..." }
```
Labels are full declarative sentences. Examples use the `e.g.,` prefix pattern and always reference real company/product names.

**Scoring variables** — boolean flags derived from Phase 1 radio values:
```javascript
const requiresSales = buyerUser === 'csuite' || scope === 'enterprise';
const isPurePLG = buyerUser === 'same' && scope === 'individual';
const hasWedgePotential = requiresSales && accCount >= 4 && fricCount <= 2;
```

## Error Handling

**User input validation:**
- Phase 1 completeness checked before scoring: if any radio unanswered, `alert()` is called and `return` exits early
- No try/catch in the main application script (DOM operations are trusted)
- Optional chaining (`?.value`) used to safely read radio values without throwing

**No silent failures:**
- The `alert()` call provides explicit user feedback for incomplete form submission

## DOM Manipulation Pattern

**Show/hide pattern** — result sections start with Tailwind's `hidden` class in HTML; JS removes or adds `hidden` to control visibility:
```javascript
resultContainer.classList.remove('hidden');
wedgeCallout.classList.add('hidden');
overrideNotice.classList.remove('hidden');
```

**Dynamic rendering pattern** — `renderCheckboxes()` uses `createElement` + `innerHTML` assignment + `appendChild`:
```javascript
function renderCheckboxes(list, elementId, name) {
    const container = document.getElementById(elementId);
    list.forEach((item, index) => {
        const wrapper = document.createElement('label');
        wrapper.className = "...";
        wrapper.innerHTML = `...template string...`;
        container.appendChild(wrapper);
    });
}
```

**Text content pattern** — result text is set via `.textContent` (not `.innerHTML`) to prevent XSS:
```javascript
resultTitle.textContent = "Sales-Led Growth Required";
```
Exception: `resultDesc.textContent` uses template literals with interpolated trusted variables only.

## Tailwind CSS Usage

**Config extension** — Tailwind config is inlined in `<head>` and extends the default theme:
- Custom colors: `primary` (`#4F46E5`), `primaryHover` (`#4338CA`)
- Font family override: `sans` → Inter
- Slate palette explicitly defined (does not rely on Tailwind defaults for slate)

**Custom CSS overrides** — CSS sibling selector pattern (`input:checked + div`) handles interactive state for hidden `<input>` elements. This is the only custom CSS in the file and should not be replaced with JS.

**Spacing scale:** 4/8/16/24/32px via Tailwind utilities (`p-4`, `p-6`, `p-8`, `gap-3`, `gap-4`, `gap-8`, `mb-2`, `mb-4`, `mb-6`, `mb-8`, `mb-12`, `mb-16`).

## Logging

No logging framework. No `console.log` in production code. Debug output is not present in the application script.

## Comments

**When to comment:**
- Section headers use all-caps comment dividers: `// ========== CORE LOGIC ==========`
- Inline comments explain non-obvious logic gates: `// Override Logic: C-Suite sign-off OR Enterprise System = Sales-Led`
- HTML comments label every major section block
- No JSDoc — functions are short and self-documenting

## Function Design

**Size:** Functions are short and single-purpose. `renderCheckboxes()` is ~15 lines. `calculateScore()` is ~90 lines (the largest function) handling all scoring logic in one place.

**Parameters:** `renderCheckboxes(list, elementId, name)` — positional parameters, no options objects.

**Return values:** `renderCheckboxes()` returns nothing (side effect only). `calculateScore()` returns nothing (all effects are DOM mutations).

## Module Design

No modules. No exports. All code is global-scope within the inline `<script>` block. Global names used: `accelerators`, `frictionPoints`, `renderCheckboxes`, `calculateScore`.

`renderCheckboxes` is called immediately after definition (at script parse time). `calculateScore` is called only via the button's `onclick` attribute.

---

*Convention analysis: 2026-03-05*
