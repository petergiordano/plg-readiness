# Phase 3: Second Theme Stub & Pluggability Proof - Pattern Map

**Mapped:** 2026-05-16
**Files analyzed:** 1 (index.html — all Phase 3 changes target this single file)
**Analogs found:** 4 / 4 (all modification targets have strong analogs in Phase 2 artifacts)

---

## File Classification

| New/Modified File | Modification Target | Role | Data Flow | Closest Analog | Match Quality |
|-------------------|---------------------|------|-----------|----------------|---------------|
| `index.html` lines 180 + 210 | WR-01 fix: `.answer-card` + `.check-card` resting bg | CSS token consumer | request-response (theme cascade) | `02-06-PLAN.md` Task 1 (BL-01 single-line flip) | exact |
| `index.html` lines 85–86 boundary | Alchemist `[data-theme="alchemist"]` override block | CSS theme block | request-response (theme cascade) | `index.html` lines 47–85 (`:root` Overdrive defaults block) | exact |
| `index.html` line 129 | Google Fonts `<link>` href append | HTML/CDN config | request-response (font load) | `02-02-PLAN.md` Task 1 (Google Fonts link swap) | exact |
| `index.html` (VALIDATION rigs) | DevTools `getComputedStyle` scripts for 3 URL-load scenarios | validation | request-response (browser DevTools) | `02-VALIDATION.md` V-11 rig | exact |

---

## Pattern Assignments

### Plan 03-01: WR-01 Fix (lines 180 + 210)

**Analog:** `02-06-PLAN.md` — BL-01 single-property flip (atomic gap-closure pattern)

**Plan shape pattern** (from 02-06-PLAN.md frontmatter + objective):
```yaml
---
type: execute
wave: N
gap_closure: true
closes_gaps:
  - "WR-01 — `.answer-card` and `.check-card` hardcode `background: white;`
     at index.html lines 180 and 210, violating Phase 1 D-02
     structure-skin separation."
---
```

The plan has exactly 1 task. No multi-task split. One fix, one commit, one acceptance criteria block.

**Task body pattern** (adapted from 02-06-PLAN.md Task 1 action block):

The action block follows this template:
1. Read the target lines first to confirm no drift (re-grep before editing — drift is possible if upstream plans shifted lines)
2. State the EXACT before/after replacement in the action
3. State what NOT to touch (sibling selectors, hover states, selected states)
4. State the commit message format

```
Read index.html lines 168–216 (the full `.answer-card` + `.check-card` CSS blocks)
to confirm `background: white;` still appears at lines 180 and 210 before editing.

Line 180 — replace `background: white;` with `background: rgb(var(--surface-elev-rgb));`
Line 210 — replace `background: white;` with `background: rgb(var(--surface-elev-rgb));`

Do NOT touch:
- Line 182: `.answer-card:hover { background: rgb(var(--accent-rgb) / 0.06); }` (already uses var)
- Line 183: `.answer-card.selected { background: rgb(var(--accent-muted-rgb)); }` (already uses var)
- Line 215: `.check-card:hover { background: ... }` (already uses var)
- Line 216: `.check-card.selected { background: ... }` (already uses var)

Commit message: `fix(03-01): replace hardcoded white resting bg on answer-card + check-card with surface-elev token (WR-01)`
```

**Acceptance criteria format** (from 02-06-PLAN.md Task 1 acceptance_criteria):

```
- `grep -c 'background: white' index.html` returns 0 (both WR-01 sites retired)
- `grep -c 'background: rgb(var(--surface-elev-rgb))' index.html` returns 2
  (both resting-state rules updated)
- `grep -nE '\.answer-card\.selected|\.check-card\.selected' index.html` still
  returns lines with `rgb(var(--accent-muted-rgb))` (selected states untouched)
- `grep -nE '\.answer-card:hover|\.check-card:hover' index.html` still returns
  lines with `rgb(var(--accent-rgb) / 0.06)` (hover states untouched)
- `python3 -m http.server 8080` + bare URL load: `.answer-card` and `.check-card`
  still render white (Overdrive `--surface-elev-rgb: 255 255 255` = white — zero
  visual delta on Overdrive render). Runtime assertion:
  `getComputedStyle(document.querySelector('.answer-card')).backgroundColor === 'rgb(255, 255, 255)'`
- No other CSS selectors changed — `git diff --stat index.html` shows 2 lines
  modified, confined to the component `<style>` block (lines 130–277 region)
```

**Verification block pattern** (from 02-06-PLAN.md verification section):

```bash
# Machine-verifiable source-level proof:
grep -c 'background: white' index.html
# Expected: 0

grep -c 'background: rgb(var(--surface-elev-rgb))' index.html
# Expected: 2 (one per card type)

# Regression guard: Tailwind config and token contract unchanged
grep -nE '^[[:space:]]+--surface-elev-rgb:' index.html
# Expected: 1 match in :root block (unchanged)
```

---

### Plan 03-02 Task 1: Alchemist `[data-theme="alchemist"]` Override Block

**Analog:** `index.html` lines 47–85 — the existing `:root` Overdrive defaults block

**INSERT POINT:** After `:root` close brace at line 85, before `</style>` at line 86.

**Comment-divider convention** (from index.html line 47):
```css
/* ========== :ROOT DEFAULTS (Overdrive — Phase 2 production values) ========== */
```
Phase 3 uses the same `/* ========== NAME ========== */` pattern:
```css
/* ========== ALCHEMIST ========== */
```

**Token-declaration ordering** (extracted from index.html lines 48–85 — the `:root` block):

The ordering is locked by convention. Alchemist MUST follow this exact sequence:
1. Accent group (`--accent-rgb`, `--accent-hover-rgb`, `--accent-muted-rgb`)
2. Surfaces group (`--surface-rgb`, `--surface-elev-rgb`)
3. Text group (`--text-rgb`, `--text-muted-rgb`)
4. Border (`--border-rgb`)
5. Neutral ramp (`--neutral-50-rgb` through `--neutral-900-rgb`, 10 stops)
6. Secondary palette (`--brand-soft-rgb`, `--brand-secondary-rgb`)
7. Fonts (`--font-display`, `--font-body`, optionally `--font-mono`)

**RGB-triplet format** (from index.html lines 50–84):

Space-separated channels, no commas, no hex. Each declaration follows this alignment:
```css
    --accent-rgb:        255 144 0;        /* #FF9000 Overdrive Orange */
    --surface-rgb:           255 248 240;  /* #FFF8F0 warm off-white */
    --neutral-50-rgb:  250 243 233;   /* #FAF3E9 one step warmer-deeper... */
```

The pattern: 12-space leading indent, property name + colon, variable spacing to column-align values within each group, RGB triplet, semicolon, 2+ spaces, inline comment with hex equivalent and role description.

**Complete Alchemist block (ready to insert — from 03-RESEARCH.md Code Examples section):**

```css
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

**Acceptance criteria pattern** (adapted from 02-06-PLAN.md Task 1 acceptance_criteria + 03-RESEARCH.md Validation Architecture):

```
- `grep -c 'data-theme="alchemist"' index.html` returns 1
- `grep -c '\-\-accent-rgb:.*15 118 110' index.html` returns 1
  (Alchemist accent token landed)
- `grep -cE '^[[:space:]]*--neutral-[0-9]+-rgb:' index.html` returns 20
  (10 Overdrive in :root + 10 Alchemist in override — full ramp in both blocks)
- `grep -c 'IBM Plex Serif' index.html` returns 2
  (--font-display + --font-body in Alchemist block)
- The block is placed INSIDE the existing `<style>` element (lines 13-86 region)
  NOT in a new `<style>` element — confirm:
  `grep -c '<style>' index.html` still returns 2 (unchanged count)
- `document.documentElement.getAttribute('data-theme')` returns `'alchemist'`
  when page loads with `?client=alchemist`
- `getComputedStyle(document.documentElement).getPropertyValue('--accent-rgb').trim()`
  returns `'15 118 110'` under `?client=alchemist`
```

---

### Plan 03-02 Task 2: Google Fonts `<link>` href Append

**Analog:** `02-02-PLAN.md` Task 1 — Google Fonts link swap (Fraunces → Space Grotesk)

**Current href at line 129** (verified by Read on 2026-05-16):
```html
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600&family=JetBrains+Mono:wght@400&display=swap" rel="stylesheet">
```

**Target href (IBM Plex Serif prepended):**
```html
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Serif:wght@400;600;700&family=Space+Grotesk:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600&family=JetBrains+Mono:wght@400&display=swap" rel="stylesheet">
```

**Query-string concatenation pattern** (from 02-02-PLAN.md action block, lines 95–111):

The Google Fonts API href format is:
```
https://fonts.googleapis.com/css2?family=<FAMILY>:wght@<WEIGHTS>&family=<FAMILY>:wght@<WEIGHTS>&display=swap
```

Rules (extracted from 02-02-PLAN.md):
- Each family separated by `&family=` (ampersand-prefix, no `?family=` for 2nd+)
- `&display=swap` appears ONCE at the end only
- `rel="stylesheet"` attribute is preserved byte-identical
- Element position in `<head>` unchanged (do not move the `<link>` element)
- IBM Plex Serif weights: `wght@400;600;700` (semicolon-separated, covers bold/semibold/regular)

**Action block pattern** (from 02-02-PLAN.md Task 1 action, adapted):

```
Re-grep `<link href="https://fonts.googleapis.com` to confirm the current
`<link>` is at line 129 after Plan 03-02 Task 1 inserts the Alchemist block
(the ~30-line insert shifts line 129 to approximately line 159 — re-grep
before editing; do not use stale line number).

Replace ONLY the `href` attribute value. Keep the element position, keep
`rel="stylesheet"`, keep all existing family clauses byte-identical.
Prepend: `family=IBM+Plex+Serif:wght@400;600;700&` before `family=Space+Grotesk`.

Do NOT add a second `&display=swap`. Do NOT add `<link rel="preconnect">`.
Do NOT change any other `<head>` element.

Commit message: `feat(03-02): add IBM Plex Serif to Google Fonts link for Alchemist theme`
```

**D-14 browser-verify gate pattern** (from 02-VALIDATION.md V-2c row + V-7):

This fires immediately after the `<link>` edit. The planner must include a browser-verify sub-step:

```javascript
// D-14 gate: run in DevTools console after loading http://localhost:8080/?client=alchemist
// (a) Font loading — no console errors at load
// (b) Space Grotesk still loads (Overdrive regression guard)
document.fonts.check('1em "Space Grotesk"')
// Expected: true

// (c) IBM Plex Serif loads (Alchemist font)
document.fonts.check('1em "IBM Plex Serif"')
// Expected: true (may need probe div to trigger lazy load — see V-1 log caveat)

// (d) Network tab: fonts.googleapis.com request returns 200
// (e) zero console errors (red)
```

The V-1 Orchestrator Run Log in 02-VALIDATION.md contains this caveat (applies here):
`fonts.check('1em "Font Name"')` may return `false` initially on lazy-loaded fonts. After an element demands the font (or after `document.fonts.ready` + 500ms), it returns `true`. The planner should include a probe-div approach or await `document.fonts.ready` before asserting.

**Acceptance criteria pattern** (from 02-02-PLAN.md acceptance_criteria):

```
- `grep -nE 'IBM\+Plex\+Serif:wght@400;600;700' index.html` returns 1 match
- `grep -nE 'family=Space\+Grotesk:wght@400;500;600;700' index.html` returns 1 match
  (Space Grotesk clause preserved byte-identical)
- `grep -nE 'display=swap' index.html` returns 1 match
  (only one display=swap in the href — no duplicate)
- `grep -c 'Fraunces' index.html` returns 0 (no regression)
- D-14 gate passes: both `document.fonts.check` assertions true
- Network tab: `fonts.googleapis.com/css2?family=IBM...` returns HTTP 200
```

---

### Plan 03-02 Tasks 3–5: VALIDATION Rigs (Three URL-Load Scenarios)

**Analog:** `02-VALIDATION.md` V-11 rig (surface-differentiation guard) + V-1 through V-3 pattern

**Rig infrastructure pattern** (from 02-VALIDATION.md Test Infrastructure table):

```
Server:   python3 -m http.server 8080 (from repo root)
Browser:  Chrome with DevTools console open
Session:  Incognito windows for scenarios (a) and (b); regular tab for scenario (c)
Quiz shortcut: answers = {buyerUser: 'same', viral: 'organic', scope: 'team'}; showResults()
              (same programmatic shortcut used in Phase 2 V-11)
```

**V-11 rig structure pattern** (from 02-VALIDATION.md lines 151–163 — the exact rig to copy):

```javascript
// COPY THIS PATTERN FOR ALL VALIDATION ASSERTIONS
const card = document.querySelector('section.bg-surface-warm .grid .bg-slate-50');
const parent = card.closest('.bg-surface-warm');
const cardBg = getComputedStyle(card).backgroundColor;
const parentBg = getComputedStyle(parent).backgroundColor;
console.log('card:', cardBg, '| parent:', parentBg, '| different:', cardBg !== parentBg);
// Pass: cardBg !== parentBg returns true
```

**Scenario (a) — `?client=alchemist` full Alchemist render:**

Load `http://localhost:8080/?client=alchemist` in incognito. Run each assertion in DevTools console:

```javascript
// 1. data-theme attribute set
document.documentElement.getAttribute('data-theme')
// Expected: 'alchemist'

// 2. Accent token (root-level CSS var)
getComputedStyle(document.documentElement).getPropertyValue('--accent-rgb').trim()
// Expected: '15 118 110'

// 3. Body surface (cool near-white — not Overdrive warm)
getComputedStyle(document.body).backgroundColor
// Expected: 'rgb(248, 250, 252)'

// 4. Slide-0 heading font
getComputedStyle(document.querySelector('#slide-0 h1')).fontFamily
// Expected: contains 'IBM Plex Serif'

// 5. Progress bar accent color (teal not orange)
getComputedStyle(document.querySelector('#progress-fill')).backgroundColor
// Expected: 'rgb(15, 118, 110)'

// 6. Answer-card resting bg (post WR-01 fix — resolves to surface-elev = white)
getComputedStyle(document.querySelector('.answer-card')).backgroundColor
// Expected: 'rgb(255, 255, 255)'

// 7. Answer-card border (Alchemist border-rgb = slate-300)
getComputedStyle(document.querySelector('.answer-card')).borderColor
// Expected: 'rgb(203, 213, 225)'

// 8. Font loaded
document.fonts.check('1em "IBM Plex Serif"')
// Expected: true

// 9. V-11 guard under Alchemist (re-run with Alchemist values)
// After completing quiz via shortcut: answers = {buyerUser: 'same', viral: 'organic', scope: 'team'}; showResults()
const card = document.querySelector('section.bg-surface-warm .grid .bg-slate-50');
const parent = card.closest('.bg-surface-warm');
const cardBg = getComputedStyle(card).backgroundColor;
const parentBg = getComputedStyle(parent).backgroundColor;
console.log('card:', cardBg, '| parent:', parentBg, '| different:', cardBg !== parentBg);
// Expected: card 'rgb(241, 245, 249)' | parent 'rgb(248, 250, 252)' | different: true
```

**Scenario (b) — Bare URL full Overdrive render (zero regression):**

Load `http://localhost:8080/` in incognito:

```javascript
// 1. No data-theme attribute (Overdrive = bare URL = no attribute)
document.documentElement.getAttribute('data-theme')
// Expected: null

// 2. Overdrive accent token
getComputedStyle(document.documentElement).getPropertyValue('--accent-rgb').trim()
// Expected: '255 144 0'

// 3. Body surface (warm off-white)
getComputedStyle(document.body).backgroundColor
// Expected: 'rgb(255, 248, 240)'

// 4. Heading font (Space Grotesk — Overdrive)
getComputedStyle(document.querySelector('#slide-0 h1')).fontFamily
// Expected: contains 'Space Grotesk'

// 5. Space Grotesk loaded
document.fonts.check('1em "Space Grotesk"')
// Expected: true

// 6. IBM Plex Serif also loads (it's in the combined link — but not applied to Overdrive)
document.fonts.check('1em "IBM Plex Serif"')
// Expected: true (loads but not applied to Overdrive selectors)

// 7. V-11 Phase 2 regression guard (Overdrive values — must still pass)
// After completing quiz via shortcut: answers = {buyerUser: 'same', viral: 'organic', scope: 'team'}; showResults()
const card = document.querySelector('section.bg-surface-warm .grid .bg-slate-50');
const parent = card.closest('.bg-surface-warm');
console.log('V-11 Overdrive:', getComputedStyle(card).backgroundColor, '!==', getComputedStyle(parent).backgroundColor, ':', getComputedStyle(card).backgroundColor !== getComputedStyle(parent).backgroundColor);
// Expected: 'rgb(250, 243, 233)' !== 'rgb(255, 248, 240)' : true
```

**Scenario (c) — Switch-back restore (Alchemist → bare URL → Overdrive):**

```javascript
// Setup: Open incognito. Load http://localhost:8080/?client=alchemist
// Confirm scenario (a) passes first.
// In the SAME TAB (not new tab), navigate to http://localhost:8080/
// Then run:

// 1. data-theme cleared by full page navigation (FOUC script did not set it)
document.documentElement.getAttribute('data-theme')
// Expected: null (NOT 'alchemist' — confirms no sticky DOM state across navigation)

// 2. Overdrive token restored
getComputedStyle(document.documentElement).getPropertyValue('--accent-rgb').trim()
// Expected: '255 144 0'

// 3. Body surface restored to warm off-white
getComputedStyle(document.body).backgroundColor
// Expected: 'rgb(255, 248, 240)'

// 4. FOUC check: slide-0 heading should be Space Grotesk-orange, not IBM Plex Serif-teal
// (eye-check: observe slide-0 on load — no flash of teal heading before orange appears)
getComputedStyle(document.querySelector('#slide-0 h1')).fontFamily
// Expected: contains 'Space Grotesk'
```

**Pass/fail format pattern** (from 02-VALIDATION.md V-11 pass criteria):

Each assertion passes with STRICT EQUALITY or STRICT INEQUALITY. The format used in 02-VALIDATION.md:
- Pass condition is explicit: e.g., "`cardBg !== parentBg` returns `true`"
- Expected values are concrete: e.g., "`rgb(250, 243, 233)` and `rgb(255, 248, 240)`"
- No tolerance checks — strict `===` or `!==` only

---

## Shared Patterns

### CSS Token Contract Format
**Source:** `index.html` lines 47–85 (`:root` block)
**Apply to:** Plan 03-02 Task 1 (Alchemist override block)

Every color token uses `R G B;` space-separated triplets. No hex. No commas. No `rgb()` wrapper in `:root` — only in consumers. Inline hex comments are required for human readability.

```css
/* Correct (matches :root convention): */
--accent-rgb: 15 118 110;  /* #0F766E deep teal */

/* Wrong (do not use): */
--accent-rgb: rgb(15, 118, 110);  /* wrong */
--accent-rgb: #0F766E;            /* wrong */
--accent-rgb: 15, 118, 110;       /* wrong — no commas */
```

### D-14 Browser-Verify Gate
**Source:** `02-VALIDATION.md` V-2 rows + V-1 Orchestrator Run Log caveat
**Apply to:** Plan 03-02 Task 2 (Google Fonts `<link>` edit) — MANDATORY

Every `<head>`-touching commit requires a browser-verify sub-step before the task is marked done. The V-1 log caveat: `document.fonts.check()` returns `false` for lazy-loaded fonts until an element demands the face. Use a probe element or `await document.fonts.ready` before asserting.

### Atomic Commit Convention
**Source:** `02-06-PLAN.md` output block (2 atomic commits expected)
**Apply to:** Plan 03-01 (1 commit), Plan 03-02 (2 commits: CSS block + VALIDATION)

Commit message format: `type(plan-id): description (verification-rig-reference)`

Examples from Phase 2:
- `feat(02-02): swap Google Fonts <link> — Fraunces -> Space Grotesk (V-2c + V-7 passed)`
- Token-value flip commit: `fix(02-06): re-anchor --neutral-50-rgb to #FAF3E9 (BL-01 closure)`

### V-11 Regression Guard
**Source:** `02-VALIDATION.md` lines 151–163
**Apply to:** Plan 03-02 Tasks 3–5 — run under both `?client=alchemist` AND bare URL

The V-11 rig is a regression guard that MUST be re-run under Alchemist values:
- Alchemist: `--neutral-50-rgb = 241 245 249` must differ from `--surface-rgb = 248 250 252`
- The `section.bg-surface-warm .grid .bg-slate-50` selector path is the canonical sample point
- Both the Alchemist and Overdrive passes must report strict inequality

---

## No Analog Found

None. All four modification targets have exact or near-exact analogs in Phase 2 artifacts.

---

## Metadata

**Analog search scope:** `.planning/phases/02-overdrive-default-theme-migration/` (all plan, summary, validation files) + `index.html` lines 1–245

**Files scanned:**
- `index.html` (lines 1–90, 125–245 — theme contract block + WR-01 sites)
- `02-06-PLAN.md` (full — atomic gap-closure pattern)
- `02-02-PLAN.md` (lines 1–120 — Google Fonts link pattern)
- `02-VALIDATION.md` (full — V-11 rig, V-1–V-12 structure, Manual-Only table)
- `03-CONTEXT.md` (full — locked decisions D-01..D-04)
- `03-RESEARCH.md` (full — verified line numbers, proposed palette, IBM Plex Serif choice)

**Pattern extraction date:** 2026-05-16
