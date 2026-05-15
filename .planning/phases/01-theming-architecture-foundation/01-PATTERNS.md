# Phase 1: Theming Architecture Foundation - Pattern Map

**Mapped:** 2026-05-15
**Files analyzed:** 1 file modified (`index.html`), 3 distinct edits inside `<head>`
**Analogs found:** 3 / 3 (all in-file)

> **Phase 1 scope reminder:** Single-file edit. No new files are created. All three edits land inside the `<head>` of `/Users/petergiordano/Documents/GitHub/plg-readiness-rebrand/index.html`. The existing component `<style>` block (lines 47–194) and the entire `<body>` are untouched in Phase 1.

---

## File Classification

Because no new files are created, the classification is per-**edit**, not per-file. Each edit has a role inside the `<head>` ordering chain and a "data flow" describing what produces / consumes it.

| Edit # | Inserted/Modified | Role | Data Flow | Closest Analog (in-file) | Match Quality |
|--------|------------------|------|-----------|--------------------------|---------------|
| 1 | NEW: inline FOUC `<script>` (first child of `<head>`) | runtime bootstrap (URL-param → DOM attribute) | request-time, synchronous, side-effecting once | bottom-of-body inline `<script>` block (all-state-and-logic) | **pattern-match** (same project style for inline JS, but new placement in `<head>`) |
| 2 | MODIFIED: inline Tailwind config `<script>` (currently lines 9–46) | config / declarative wiring | parse-time data (read by CDN script that follows) | **same block — its own current `theme.extend.colors` shape** | **exact** (same block, shape transformed) |
| 3 | NEW: token contract `<style>` element (inserted after edit #2, before CDN `<script>`) | declarative token store (CSS custom properties + recipe header) | parse-time CSS that Tailwind-generated rules read via `var(...)` | existing component `<style>` block (lines 47–194) | **role-match** (same CSS authoring style, different responsibility — "skin" vs. "structure") |
| — (untouched) | Existing component `<style>` block (lines 47–194) | component-level CSS (slide system, cards, results) | n/a — no change in Phase 1 | n/a | n/a |
| — (untouched) | Google Fonts `<link>` (line 8) | external resource preload | n/a — no change in Phase 1 (D-16 keeps the existing three fonts) | n/a | n/a |

---

## Current `<head>` Structural Snapshot (for placement reference)

This is the **current** shape of `<head>`. Edit #1 (FOUC) inserts after line 6. Edit #2 modifies the inline `<script>` at lines 9–46 in place. Edit #3 inserts a new `<style>` between the modified edit #2 and the CDN script. The CDN script (line 7) and Google Fonts `<link>` (line 8) move to land **after** the new token `<style>` per D-10. The component `<style>` (lines 47–194) stays exactly where it is.

**File:** `index.html` lines 1–46

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLG Readiness Diagnostic | GTM Strategy Tool</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300;9..144,700;9..144,800&family=Plus+Jakarta+Sans:wght@400;500;600&family=JetBrains+Mono:wght@400&display=swap" rel="stylesheet">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans:    ['Plus Jakarta Sans', 'sans-serif'],
                        display: ['Fraunces', 'serif'],
                        mono:    ['JetBrains Mono', 'monospace'],
                    },
                    colors: {
                        accent: {
                            DEFAULT: '#4F46E5',
                            hover:   '#4338CA',
                            muted:   '#EEF2FF',
                        },
                        surface: {
                            warm:        '#FAFAF8',
                            dark:        '#0F172A',
                            'dark-card': '#1E293B',
                        },
                        ink: '#1A1A2E',
                        slate: {
                            50:  '#F8FAFC',
                            100: '#F1F5F9',
                            200: '#E2E8F0',
                            300: '#CBD5E1',
                            400: '#94A3B8',
                            500: '#64748B',
                            600: '#475569',
                            700: '#334155',
                            800: '#1E293B',
                            900: '#0F172A',
                        }
                    }
                }
            }
        }
    </script>
    <style>
        body {
            ...
```

**Reading notes for the planner:**

- The **CDN `<script>`** is at line 7, **before** the inline config at lines 9–46. The pre-Phase-1 ordering on `main` is `CDN → fonts → inline config`. **[CORRECTED 2026-05-15 — see Phase 1 SUMMARY § "Research-level correction" + RESEARCH Pitfall 2b.]** The reason that ordering works is NOT that the CDN script is defer-equivalent; it is plain synchronous. What actually happens: CDN's IIFE creates `window.tailwind` immediately, then schedules an async `process()` call that reads `tailwind.config` later — after the inline config script has assigned it. The Phase 1 constraints are: (a) token `<style>` must precede CDN so `:root` vars are in the cascade at first paint (Pitfall 2), AND (b) CDN must precede the inline `tailwind.config` assignment so the `tailwind` global exists (Pitfall 2b). Verified correct ordering: FOUC → token `<style>` → CDN → inline config → fonts → component `<style>`. Phase 2 planners: read this corrected text, not the original "move CDN to after the inline config" framing in Edits #2/#3 below.
- The Google Fonts `<link>` (line 8) is **untouched** per D-16 — the line stays as written; only its position relative to the other `<head>` children may shift depending on the planner's chosen final ordering. RESEARCH §5 places it after the CDN script.
- There is **no `primary` / `primaryHover`** in the current file — the config already uses `accent` keys. CONTEXT.md `<code_context>` says otherwise; RESEARCH §9 corrects this. The planner must read `accent` as the established name. [VERIFIED by RESEARCH §9: grep for `primary` returns zero hits.]
- The current Tailwind v3 default **slate ramp values** at lines 31–40 are the *exact* hex values D-08 requires the Phase 1 `--neutral-*-rgb` tokens to encode (re-expressed as RGB triplets). See "Edit #2 — Pattern Assignment" below for the lift-and-transform table.

---

## Pattern Assignments

### Edit #1 — NEW inline FOUC `<script>` (first child of `<head>`)

**Role:** runtime bootstrap. Reads `?client=<slug>` from `location.search` and sets `<html data-theme="<slug>">` synchronously, before any paint.

**No file analog exists** — there is currently no inline `<script>` in `<head>`. The closest **pattern-level** analog is the bottom-of-body `<script>` block (the "all state and logic" inline script). It establishes the project's "inline `<script>`, no IIFE wrapper for top-level, no semicolons omitted" style. The FOUC script breaks one convention deliberately: it **uses an IIFE wrapper** to keep the parsed param out of `window.*`, because (unlike the bottom-of-body script) it runs in shared global scope alongside the Tailwind config script that immediately follows it.

**Canonical FOUC `<script>` body** (from RESEARCH §3, locked by D-12; the planner authors this — no existing analog to copy from):

```html
<script>
  (function () {
    var p = new URLSearchParams(location.search).get('client');
    if (p) document.documentElement.setAttribute('data-theme', p);
  })();
</script>
```

**Conventions to follow** (from CONVENTIONS.md + RESEARCH §3):

- **4-space indentation** matching the rest of `<head>` (CONVENTIONS.md line 41). The IIFE body content is indented one extra level inside `<script>`.
- **Single quotes for string literals** (`'client'`) — CONVENTIONS.md line 41 ("Single quotes used for HTML attribute values; template literals use backtick").
- **No semicolons omitted** — every statement ends with `;` (CONVENTIONS.md line 49).
- **`var` for the single local** — not `const` / `let`. The bottom-of-body script prefers `const`, but this script (a) is so short the distinction is moot, and (b) uses `var` so it can never trip a "temporal dead zone" edge case during early `<head>` parse. (RESEARCH §3 uses `var`; matches Pico.css and Miguel Grinberg's dark-mode pattern cited in RESEARCH §"Pattern 2".)
- **Variable name `p`** — intentionally short per RESEARCH §3. The planner may substitute `slug` or `clientParam`; either is fine and adds 4–10 bytes. **D-11's "non-engineer-readable" principle applies to the recipe comment, NOT to this inline script.**
- **No `try / catch`** — `URLSearchParams` is universal in target browsers (Chromium 49+, Firefox 44+, Safari 10.1+). RESEARCH §3 confirms.
- **No DOMContentLoaded wait** — `document.documentElement` exists from the moment `<html>` is parsed, which is before this script executes. The setAttribute call is always safe.

**Placement:** First child of `<head>`, before everything except the existing `<meta>` tags and `<title>`. RESEARCH §5 places it at position 2 in the new ordering (after `<title>`, before everything else).

---

### Edit #2 — MODIFIED inline Tailwind config `<script>` (currently lines 9–46)

**Role:** Tailwind utility → CSS-var binding. Same block, shape transformed.

**Analog: the current block itself.** This is an in-place transformation — the planner is rewriting `index.html` lines 9–46.

**BEFORE — current block (lines 9–46, full code excerpt):**

```html
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans:    ['Plus Jakarta Sans', 'sans-serif'],
                        display: ['Fraunces', 'serif'],
                        mono:    ['JetBrains Mono', 'monospace'],
                    },
                    colors: {
                        accent: {
                            DEFAULT: '#4F46E5',
                            hover:   '#4338CA',
                            muted:   '#EEF2FF',
                        },
                        surface: {
                            warm:        '#FAFAF8',
                            dark:        '#0F172A',
                            'dark-card': '#1E293B',
                        },
                        ink: '#1A1A2E',
                        slate: {
                            50:  '#F8FAFC',
                            100: '#F1F5F9',
                            200: '#E2E8F0',
                            300: '#CBD5E1',
                            400: '#94A3B8',
                            500: '#64748B',
                            600: '#475569',
                            700: '#334155',
                            800: '#1E293B',
                            900: '#0F172A',
                        }
                    }
                }
            }
        }
    </script>
```

**AFTER — target shape (from RESEARCH §4; per D-07, D-13, D-14):**

```html
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans:    ['var(--font-body)',    'sans-serif'],
                        display: ['var(--font-display)', 'serif'],
                        mono:    ['var(--font-mono)',    'monospace'],
                    },
                    colors: {
                        accent: {
                            DEFAULT: 'rgb(var(--accent-rgb)       / <alpha-value>)',
                            hover:   'rgb(var(--accent-hover-rgb) / <alpha-value>)',
                            muted:   'rgb(var(--accent-muted-rgb) / <alpha-value>)',
                        },
                        surface: {
                            warm:        'rgb(var(--surface-rgb)           / <alpha-value>)',
                            dark:        'rgb(var(--surface-dark-rgb)      / <alpha-value>)',
                            'dark-card': 'rgb(var(--surface-dark-card-rgb) / <alpha-value>)',
                        },
                        ink: 'rgb(var(--text-rgb) / <alpha-value>)',
                        slate: {
                            50:  'rgb(var(--neutral-50-rgb)  / <alpha-value>)',
                            100: 'rgb(var(--neutral-100-rgb) / <alpha-value>)',
                            200: 'rgb(var(--neutral-200-rgb) / <alpha-value>)',
                            300: 'rgb(var(--neutral-300-rgb) / <alpha-value>)',
                            400: 'rgb(var(--neutral-400-rgb) / <alpha-value>)',
                            500: 'rgb(var(--neutral-500-rgb) / <alpha-value>)',
                            600: 'rgb(var(--neutral-600-rgb) / <alpha-value>)',
                            700: 'rgb(var(--neutral-700-rgb) / <alpha-value>)',
                            800: 'rgb(var(--neutral-800-rgb) / <alpha-value>)',
                            900: 'rgb(var(--neutral-900-rgb) / <alpha-value>)',
                        }
                    }
                }
            }
        }
    </script>
```

**Transformation rules** (from RESEARCH §4 + Pattern 1):

| Current value form | Target value form | Applies to |
|---|---|---|
| `'#RRGGBB'` | `'rgb(var(--<token>-rgb) / <alpha-value>)'` | every key under `colors:` (accent, surface, ink, slate) — D-13, D-14 |
| `['<Font Name>', 'sans-serif']` | `['var(--font-<role>)', 'sans-serif']` | every entry under `fontFamily:` — D-14 fonts skip the triplet pattern |

**Why fonts use `var(--font-<role>)` instead of the RGB-triplet pattern:** D-14 — triplet pattern is color-tokens-only. Fonts are full strings (`'Plus Jakarta Sans', sans-serif`), not numeric channels — they don't need `<alpha-value>` substitution. Tailwind's fontFamily array entries can be CSS-var references directly.

**Why `slate` keys 50–900 use `--neutral-*-rgb` names (not `--slate-*-rgb`):** D-07 specifies `--neutral-*` as the contract slug naming. The Tailwind utility name `slate-*` stays unchanged in markup (so the ~80 existing `slate-*` usages keep working), but the underlying token slug is `--neutral-*` — semantic, brand-neutral, brandable. The mapping `slate → --neutral-*` lives only in this config block.

**Conventions preserved across the transformation:**

- **4-space indentation, same level depth** as the current block (CONVENTIONS.md line 41).
- **Same key ordering** — fontFamily before colors; within colors, the existing order is `accent → surface → ink → slate`. No reason to change it.
- **Trailing commas** on the last item in each object — present in current block (e.g., line 22 `muted: '#EEF2FF',` has trailing comma). Preserve in target.
- **Aligned-equals style** for visual scanning — the current block aligns the `:` columns within `fontFamily` (lines 14–16) and `accent` (lines 20–22). The target shape from RESEARCH §4 preserves this alignment around the longer `rgb(var(...))` values; the planner should match the existing visual rhythm.
- **Single quotes** for string values (`'#4F46E5'` → `'rgb(var(--accent-rgb) / <alpha-value>)'`).

---

### Edit #3 — NEW token contract `<style>` element

**Role:** declarative token store. Holds the inline recipe comment (D-11), the `:root` defaults block (current indigo / slate / Fraunces values re-expressed as RGB triplets + Overdrive-style slug names per D-08), and — **Phase 1 has no `[data-theme="..."]` override blocks**. Phase 2 introduces an Overdrive override block; Phase 3 introduces a second-theme stub.

**Analog: the existing component `<style>` block at lines 47–194.** Same CSS authoring conventions, different responsibility. The new `<style>` is "skin" (tokens). The existing `<style>` is "structure" (components). Two separate `<style>` elements coexist in `<head>` after Phase 1.

**Excerpt from analog — existing component `<style>` opening lines** (`index.html` lines 47–69):

```html
    <style>
        body {
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
            overflow: hidden;
        }
        body.results-mode { overflow: auto; }

        /* ── Slide system ─────────────────────────────── */
        .slide {
            position: fixed;
            inset: 0;
            background: #FAFAF8;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            transition: transform 0.44s cubic-bezier(0.4, 0, 0.2, 1),
                        opacity   0.34s ease;
        }
        .slide.s-below   { transform: translateY(72px); opacity: 0; pointer-events: none; }
        .slide.s-active  { transform: translateY(0);    opacity: 1; pointer-events: all;  }
        .slide.s-above   { transform: translateY(-72px); opacity: 0; pointer-events: none; }
```

**Conventions extracted from the analog** (to apply to the new token `<style>`):

- **4-space indentation** at the `<style>` content level; rule bodies indented one more level (matches CONVENTIONS.md line 41 and visible in the analog).
- **Section dividers use `/* ── <Section Name> ─────────── */` style** (box-drawing horizontal `─`, not ASCII hyphens) — visible at the analog's lines 55, 70, 79, 85, 117, 147, 177. **However:** D-10 explicitly specifies a different divider for theme blocks: `/* ========== <CLIENT> ========== */` (ASCII equals). This is intentional — theme dividers signal "different concern" from component CSS, and the all-caps `==========` style is the one CONVENTIONS.md describes as project standard (CONVENTIONS.md line 54). The HTML body uses a third style (`<!-- ═══...═══ -->`, box-drawing double horizontal — see lines 218–220 below). The planner must use **D-10's `========== <NAME> ==========` style** for theme-block dividers in the new `<style>`, not the existing component `<style>`'s `── <Section> ───` style.
- **Inline `;`-terminated declarations**, lowercase property names, single rule per logical concern.
- **Comments above the block** they describe (not inline after).

**Excerpt — existing HTML divider style** (`index.html` lines 218–220, for cross-reference; do **not** copy this style into the new `<style>` — it's HTML-comment style, while edit #3 needs CSS-comment style):

```html
    <!-- ═══════════════════════════════════════
         SLIDE 0 — Welcome
    ═══════════════════════════════════════ -->
```

This confirms the project has a strong "visual section header" culture — three different styles for three different file contexts (HTML comments, CSS comments inside `<style>`, JS comments inside `<script>`). The new token `<style>` is a CSS context, so D-10's `/* ========== <NAME> ========== */` is the right form.

**Inline recipe comment header (from RESEARCH §6, locked by D-11):**

```css
/* =============================================================
   THEME CONTRACT
   -------------------------------------------------------------
   This block holds every brandable token in the app. The
   ":root" block below is the default (Overdrive). Each
   "[data-theme=<slug>]" block below it is a client override.

   HOW TO ADD A CLIENT THEME (for non-engineers):

   1. Copy the entire ":root { ... }" block below.
   2. Change ":root" to [data-theme="your-client-slug"].
      Slug is lowercase, dash-separated, no spaces.
      Example: [data-theme="alchemist"]
   3. Edit the values you want different from Overdrive.
      Leave the rest alone -- anything you don't override
      will use Overdrive's value.
   4. Save the file. Visit the app with
      "?client=your-client-slug" in the URL to see it.

   COLORS are written as three numbers separated by spaces
   (the R, G, B channels of the color). To convert a hex
   like "#FF9000" to this format:
     #FF9000  ->  255 144 0
   Online converters (Google "hex to rgb") do this in one step.

   FONTS are written as full CSS font stacks, e.g.
     'Space Grotesk', sans-serif
   Add new font files to the Google Fonts <link> above so they
   load with the page.

   That is the whole system. There is nothing else to learn.
   ============================================================= */
```

**`:root` block — Phase 1 values** (current identity, semantic Overdrive-style slugs; from RESEARCH §2 token table + RESEARCH §1 neutral ramp table — these tables are the **source of truth for exact RGB triplets**):

The planner must populate `:root` with the following tokens. **Phase 1 values hold the CURRENT indigo / slate / Fraunces identity** (D-08). Phase 2 changes only the values; the slug list is locked here.

| CSS var | Phase 1 value | Source in current `index.html` |
|---|---|---|
| `--accent-rgb` | `79 70 229` | hex `#4F46E5` (line 20) |
| `--accent-hover-rgb` | `67 56 202` | hex `#4338CA` (line 21) |
| `--accent-muted-rgb` | `238 242 255` | hex `#EEF2FF` (line 22) |
| `--surface-rgb` | `250 250 248` | hex `#FAFAF8` (line 25) |
| `--surface-elev-rgb` | `255 255 255` | white (implicit — `background: white;` on `.answer-card` line 97 and `.check-card` line 127). **[ASSUMED]** per RESEARCH §2 — Claude-discretion add. |
| `--surface-dark-rgb` | `15 23 42` | hex `#0F172A` (line 26) |
| `--surface-dark-card-rgb` | `30 41 59` | hex `#1E293B` (line 27) |
| `--text-rgb` | `26 26 46` | hex `#1A1A2E` (line 29, `ink`) |
| `--text-muted-rgb` | `100 116 139` | hex `#64748B` (matches `slate-500`, the dominant body-secondary color — 20 usages) |
| `--border-rgb` | `226 232 240` | hex `#E2E8F0` (matches `slate-200`, the dominant border color — 21 usages) |
| `--neutral-50-rgb` | `248 250 252` | hex `#F8FAFC` (line 31) |
| `--neutral-100-rgb` | `241 245 249` | hex `#F1F5F9` (line 32) |
| `--neutral-200-rgb` | `226 232 240` | hex `#E2E8F0` (line 33) |
| `--neutral-300-rgb` | `203 213 225` | hex `#CBD5E1` (line 34) |
| `--neutral-400-rgb` | `148 163 184` | hex `#94A3B8` (line 35) |
| `--neutral-500-rgb` | `100 116 139` | hex `#64748B` (line 36) |
| `--neutral-600-rgb` | `71 85 105` | hex `#475569` (line 37) |
| `--neutral-700-rgb` | `51 65 85` | hex `#334155` (line 38) |
| `--neutral-800-rgb` | `30 41 59` | hex `#1E293B` (line 39) |
| `--neutral-900-rgb` | `15 23 42` | hex `#0F172A` (line 40) |
| `--font-display` | `'Fraunces', serif` | line 15 |
| `--font-body` | `'Plus Jakarta Sans', sans-serif` | line 14 |
| `--font-mono` | `'JetBrains Mono', monospace` | line 16 |

**Notes from RESEARCH §2 (preserved verbatim for planner):**

- `--surface-elev-rgb` does not exist as a hex literal in the current config but is implied by `background: white;` on the answer / check cards. Adding it now is a Claude-discretion call (the slug is listed in D-05's example slug list). Worth surfacing in the plan for Pete's confirmation if the planner prefers strict adherence to "current values only."
- `--text-muted-rgb` numerically equals `--neutral-500-rgb` today, but they are conceptually distinct (muted body text vs. mid-gray neutral). Keep them as separate tokens so Phase 2 can move one without dragging the other.
- `--border-rgb` numerically equals `--neutral-200-rgb` today — same reasoning.

**Phase 1 block ordering inside the new `<style>`** (per D-10, RESEARCH §3 Pattern 3, and the orchestrator's scope clarification):

1. Recipe comment header (above)
2. `/* ========== :ROOT DEFAULTS (Overdrive — current Phase 1 values) ========== */`
3. `:root { ... }` block containing the full token list from the table above
4. **No `[data-theme="..."]` override blocks in Phase 1.** Phase 2 adds Overdrive override (which Phase 1 doesn't need since `:root` already holds current values). Phase 3 adds the stub second theme.

**Placement of the `<style>` element in `<head>`:** after the modified inline Tailwind config `<script>` (edit #2), before the CDN `<script>` (which moves from current line 7 to a new position after this `<style>`). D-10 spec. See RESEARCH §5 for the full ordered list.

---

## Shared Patterns

### Pattern S1 — RGB-triplet CSS var + Tailwind `<alpha-value>` placeholder (D-13, D-14)

**Source:** RESEARCH §"Pattern 1" + Tailwind v3.1 docs.

**Applies to:** Edit #2 (every key under `colors:`) and edit #3 (every `--*-rgb` declaration in `:root`).

**Pattern:**

```css
/* In :root (edit #3) */
--accent-rgb: 79 70 229;        /* space-separated R G B integers — no commas, no parens, no rgb() wrapper */
```

```javascript
// In inline Tailwind config (edit #2)
accent: {
  DEFAULT: 'rgb(var(--accent-rgb) / <alpha-value>)',
}
```

**Result:**
- `bg-accent` → `background-color: rgb(79 70 229 / 1)`
- `bg-accent/50` → `background-color: rgb(79 70 229 / 0.5)`
- A theme override that changes `--accent-rgb: 255 144 0;` re-resolves every `bg-accent*` utility on the page without any rule rewrite.

**Critical canary:** `index.html` line 474 uses `bg-slate-800/50` (RESEARCH §10). If the triplet pattern is not applied to the slate ramp, this utility silently emits invalid CSS at Phase 2. The Phase 1 verification step must inspect this specific utility's computed style.

### Pattern S2 — Inline-script style (no IIFE for bottom-of-body, IIFE for `<head>`)

**Source:** existing bottom-of-body `<script>` block (project convention) + RESEARCH §3 (FOUC script).

**Applies to:** Edit #1.

**Rule:** Inline `<script>` in `<head>` that runs at parse time wraps its body in an IIFE to keep parsed values out of the shared `window.*` scope. Inline `<script>` at the bottom of `<body>` (which is the existing application logic) does not need this — it runs after DOM is built and existing globals (`accelerators`, `frictionPoints`, `renderCheckboxes`, `calculateScore`) are intentionally global.

### Pattern S3 — Visual section dividers (three contexts, three styles)

**Source:** grep audit of current `index.html`.

| Context | Divider Style | Example |
|---|---|---|
| HTML body comments | `<!-- ═══...═══ -->` (box-drawing double-horizontal) | line 218 (`SLIDE 0 — Welcome`) |
| Existing CSS component `<style>` | `/* ── <Name> ─────── */` (box-drawing single-horizontal) | line 55 (`Slide system`) |
| **New theme-block CSS `<style>` (edit #3)** | `/* ========== <NAME> ========== */` (ASCII equals, all-caps) | D-10 spec; no prior in-file example |
| Inline JS (bottom-of-body) | `// ========== <NAME> ==========` (CONVENTIONS.md line 54; no audited examples in current file) | per CONVENTIONS.md |

**Rule for edit #3:** use `/* ========== <NAME> ========== */` exclusively for theme-block separators. Do **not** mix in the `── <Section> ───` style used by the existing component `<style>` — the visual distinction reinforces that the new `<style>` is a different concern (skin tokens vs. component structure).

### Pattern S4 — Tailwind config block: alignment + structure

**Source:** current inline Tailwind config (`index.html` lines 9–46).

The current block visually aligns the `:` columns within each color group (`accent`, `surface`, slate ramp) and within `fontFamily`. The transformed block (edit #2 AFTER shape in RESEARCH §4) preserves this alignment around the longer `rgb(var(...))` values. Planner should reproduce this alignment for legibility — it's a non-load-bearing but established readability pattern in the file.

---

## No Analog Found

**No edits in Phase 1 require an analog the file lacks.** Every edit either modifies an existing block in place (edit #2) or has at least a pattern-level analog (edits #1, #3). The FOUC script (edit #1) is structurally new but RESEARCH §3 provides the canonical 6-line implementation; the planner should reproduce it directly rather than searching for further analogs.

---

## Metadata

**Analog search scope:** entire `index.html` (lines 1–end) plus `.planning/codebase/CONVENTIONS.md`.
**Files scanned:** 1 source file + 1 conventions doc.
**Pattern extraction date:** 2026-05-15
**Required reading completed:** CONTEXT.md (139 lines), RESEARCH.md (read in two passes — §1 through §11), CONVENTIONS.md (161 lines), `index.html` (lines 1–204 to cover all of `<head>` and the start of `<body>`).
**Audit grep coverage:** `==========` (zero current uses); `══════` (16 uses, all in `<body>` HTML comments); `──` (16 uses, all in existing component `<style>`); `primary`/`primaryHover` (zero, per RESEARCH §9 — corrects CONTEXT.md `<code_context>` paragraph 1).
