---
phase: 02-overdrive-default-theme-migration
plan: 01
subsystem: ui
tags: [tailwind, css-custom-properties, theming, design-system, overdrive]

# Dependency graph
requires:
  - phase: 01-theming-architecture-foundation
    provides: ":root token contract (23 tokens, RGB-triplet form) + inline Tailwind config consuming tokens via `rgb(var(--*-rgb) / <alpha-value>)` + corrected `<head>` ordering (FOUC < TOKEN_STYLE < CDN < CONFIG < FONTS < COMPONENT_STYLE)"
provides:
  - "Overdrive default `:root` token values: orange accent (#FF9000), warm off-white surface (#FFF8F0), Dark Gray text (#434343), warm-gray 10-stop neutral ramp, Space Grotesk display font"
  - "Two new Secondary palette tokens declared under their own divider: --brand-soft-rgb (#FFE599) + --brand-secondary-rgb (#F1C232)"
  - "Tailwind utilities exposed: bg-surface-elev (white card per D-02), bg-yellow-100 (Light Yellow), text-yellow-400 (Golden Yellow)"
  - "Retired tokens removed from :root: --surface-dark-rgb, --surface-dark-card-rgb"
  - "Retired Tailwind config entries removed: surface.dark, surface.dark-card"
  - "fontFamily.display fallback flipped: 'serif' -> 'sans-serif' (D-13)"
affects: [02-02-font-link-swap, 02-03-cat-b-component-migration, 02-04-results-page-markup, 02-05-phase-end-sweep]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Secondary palette divider in :root (S-2 comment-divider convention extended to a new logical group)"
    - "Tailwind colors.extend layering order: accent -> surface (warm + elev) -> ink -> slate -> yellow"

key-files:
  created: []
  modified:
    - "index.html (token contract :root block lines 47-85; inline Tailwind config lines 88-128)"

key-decisions:
  - "Q-1: Blocks 2 + 3 ship as ONE plan with two atomic commits, one per Task (preserves D-14 V-2a/V-2b granularity)"
  - "Q-2: surface.elev uses alpha-value pattern symmetrically with surface.warm"
  - "Q-4: Secondary palette divider inserted after the neutral ramp block, before Fonts block"
  - "Q-6: yellow namespace inserted after slate, before closing } of colors.extend"
  - "R-1: --accent-hover-rgb pre-locked at 230 130 0 (#E68200, ~10% darker than #FF9000) to close the frankenstein-hover bug on CTAs at 324/479/515"
  - "Claude's Discretion: --accent-muted-rgb derived as 255 241 224 (#FFF1E0 soft-orange tint) to pair with selected-state on accent"

patterns-established:
  - "P-1 extension (Phase 1 -> Phase 2): Token declaration in :root with RGB-triplet + comment-divided sub-blocks; Phase 2 adds Secondary palette as a new sub-block under its own divider"
  - "P-2 extension (Phase 1 -> Phase 2): Tailwind colors.extend entry shape `'rgb(var(--<token>-rgb) / <alpha-value>)'`; Phase 2 adds two new entries (surface.elev, yellow.{100,400}) and one deletion pair (surface.dark + surface.dark-card)"

requirements-completed: [REQ-overdrive-default-theme]

# Metrics
duration: 1min (edit + verify); ~5min wall-clock including read/grep/install puppeteer-core
completed: 2026-05-16
---

# Phase 02 Plan 01: Token Contract + Tailwind Config Migration to Overdrive Defaults Summary

**Flipped the :root token values from indigo/slate/Fraunces to Overdrive orange/warm-off-white/Dark-Gray/Space-Grotesk, added Light Yellow + Golden Yellow as Secondary palette tokens with a `yellow.{100,400}` Tailwind namespace, added `bg-surface-elev` utility, and retired the dark-surface tokens + Tailwind entries — all in two atomic commits inside index.html `<head>` with runtime browser-verify confirming every V-2a + V-2b assertion passed.**

## Performance

- **Duration:** ~1 min between the two task commits; ~5 min wall-clock including reads, greps, puppeteer-core install, and Chrome.app browser-verify
- **Started:** 2026-05-16T13:52:12Z (Task 1 commit timestamp)
- **Completed:** 2026-05-16T13:53:29Z (this SUMMARY write)
- **Tasks:** 2
- **Files modified:** 1 (index.html)

## Accomplishments

- All seven asserted token values flipped to Overdrive defaults (`--accent-rgb`, `--accent-hover-rgb`, `--accent-muted-rgb`, `--surface-rgb`, `--text-rgb`, `--text-muted-rgb`, `--border-rgb`) plus the warm-gray 10-stop neutral ramp anchored on Overdrive Gray spec (D-06).
- Two net-new tokens declared under a new `Secondary palette` divider: `--brand-soft-rgb: 255 229 153` (#FFE599 Light Yellow) + `--brand-secondary-rgb: 241 194 50` (#F1C232 Golden Yellow) — extending the brand contract from 23 to 25 tokens (net +2 after the two retirements below).
- Two retired tokens deleted from `:root`: `--surface-dark-rgb` and `--surface-dark-card-rgb` (D-01 dark-hero retirement preparation; final markup retires in Plan 02-04).
- `--font-display` flipped from `'Fraunces', serif` to `'Space Grotesk', sans-serif`; Google Fonts `<link>` still loads Fraunces — that swap lands in Plan 02-02.
- Tailwind config: `colors.surface` rewritten (`dark` + `'dark-card'` deleted, `elev` added consuming `--surface-elev-rgb`); new `colors.yellow` namespace declared with only the two stops the markup will consume (`.100` -> `--brand-soft-rgb`, `.400` -> `--brand-secondary-rgb`); `fontFamily.display` fallback flipped from `'serif'` to `'sans-serif'`.
- D-14 V-2a + V-2b runtime browser-verify gate **PASSED** via headless Chrome.app + puppeteer-core against `python3 -m http.server 8080` (see "D-14 verification" section below).

## Task Commits

1. **Task 1: Flip :root token values + add Secondary palette + delete dark tokens** — `c4e868a` (feat)
2. **Task 2: Rewire Tailwind config — add surface.elev + yellow.{100,400}, retire surface.dark/dark-card, flip display fallback** — `b220b73` (feat)

## Files Created/Modified

- `index.html` — token contract `<style>` `:root` block (lines 47-85, was 47-83 pre-edit; +2 net lines from Secondary palette block) and inline Tailwind config `<script>` (lines 88-128, was 86-123 pre-edit; +5 net lines from yellow namespace addition minus 2 lines for dark + dark-card deletion plus 1 line for surface.elev addition).

## Decisions Made

All decisions executed exactly as locked in PLAN.md Resolved planner decisions (Q-1, Q-2, Q-4, Q-6, R-1, Claude's-Discretion `--accent-muted-rgb` value). No new decisions arose during execution.

## Deviations from Plan

None — plan executed exactly as written. No Rule 1/2/3/4 deviations triggered. Source-level greps for every asserted token value returned exactly the expected counts (six positive token assertions = 1 match each; `--surface-dark-(rgb|card-rgb)` declaration grep = 0; `--font-display 'Fraunces'` grep = 0; four Tailwind config positive greps = expected counts; surface.dark/dark-card config-name grep = 0). The two slight refinements below are formatting choices within plan scope, not deviations:

- **Whitespace inside the new `surface:` block**: the plan suggested padding `elev:` to align the `/` column with the existing `warm:` line. Because the `dark:` and `'dark-card':` siblings were both deleted (those were the longest keys), the `warm:` line's previous padding became asymmetric with the new two-entry shape. I re-padded `warm:` and `elev:` to align their `/` columns with each other (both at column 47), giving a tidy two-line block. The plan's S-2 comment-divider / P-2 column-alignment rule is preserved by symmetry between the two remaining entries.

## D-14 verification (V-2a + V-2b browser-verify gate)

**Outcome: PASS** — every computed-style and config-shape assertion in VALIDATION.md V-2a + V-2b returned the expected value.

**Method:** Started `python3 -m http.server 8080` from the worktree root; drove headless Chrome.app via `puppeteer-core` (installed in `/tmp/v2-verify-deps` only — no project dependency added); ran `getComputedStyle` + `window.tailwind.config` introspection on `http://localhost:8080/index.html`; killed server after run.

**V-2a assertions (after Task 1's token contract flip):**

| Assertion | Expected | Actual | Result |
|---|---|---|---|
| `getComputedStyle(:root).getPropertyValue('--accent-rgb').trim()` | `'255 144 0'` | `'255 144 0'` | PASS |
| `getComputedStyle(document.body).backgroundColor` | `'rgb(255, 248, 240)'` | `'rgb(255, 248, 240)'` | PASS |
| `--accent-hover-rgb` | `'230 130 0'` | `'230 130 0'` | PASS |
| `--surface-rgb` | `'255 248 240'` | `'255 248 240'` | PASS |
| `--text-rgb` | `'67 67 67'` | `'67 67 67'` | PASS |
| `--brand-soft-rgb` | `'255 229 153'` | `'255 229 153'` | PASS |
| `--brand-secondary-rgb` | `'241 194 50'` | `'241 194 50'` | PASS |
| `--font-display` contains `'Space Grotesk'` | true | `"'Space Grotesk', sans-serif"` | PASS |
| `getComputedStyle(#progress-fill).backgroundColor` | `'rgb(255, 144, 0)'` (orange, not indigo) | `'rgb(255, 144, 0)'` | PASS |

**V-2b assertions (after Task 2's Tailwind config rewire):**

| Assertion | Expected | Actual | Result |
|---|---|---|---|
| `tailwind.config.theme.extend.colors.surface` keys | `['warm', 'elev']` (dark + dark-card absent) | `['warm', 'elev']` | PASS |
| `colors.surface.elev` | contains `'--surface-elev-rgb'` | `'rgb(var(--surface-elev-rgb) / <alpha-value>)'` | PASS |
| `colors.surface.warm` | contains `'--surface-rgb'` | `'rgb(var(--surface-rgb)      / <alpha-value>)'` | PASS |
| `'dark' in colors.surface` | false | false | PASS |
| `'dark-card' in colors.surface` | false | false | PASS |
| `colors.yellow` keys | `['100', '400']` | `['100', '400']` | PASS |
| `colors.yellow[100]` | contains `'--brand-soft-rgb'` | `'rgb(var(--brand-soft-rgb)      / <alpha-value>)'` | PASS |
| `colors.yellow[400]` | contains `'--brand-secondary-rgb'` | `'rgb(var(--brand-secondary-rgb) / <alpha-value>)'` | PASS |
| Elements still matching `.bg-surface-dark, .bg-surface-dark-card` rendering with non-transparent bg | 0 | 0 (3 matching elements found in markup, 0 render dark — Tailwind generates no CSS for the now-deleted utility entries) | PASS |

**Console noise (informational, NOT blocking):**
- 1 `console.error` for `GET /favicon.ico HTTP/1.1` 404 — this is a baseline pre-existing browser default request that this project has never resolved (no favicon declared in `index.html`). It existed in Phase 1 + on `main`. Not caused by Phase 2 edits. The V-1 orchestrator run log similarly noted baseline console noise (the Tailwind CDN production warning) as expected. Excluding this baseline 404, the page loaded with zero red errors.
- Tailwind CDN production warning was NOT observed in the headless puppeteer run (Phase 1 V-2 + Phase 2 V-1 orchestrator runs both observed it; suppression in headless mode is environment-dependent and not a regression).

## Issues Encountered

None.

## Open carry-over (per PLAN.md `<output>`)

- **Plan 02-02:** Google Fonts `<link>` at line 129 (was line 124 pre-Phase-2; shifted +5 by Plan 02-01's net additions) still loads Fraunces. `--font-display` resolves to `'Space Grotesk', sans-serif` per Plan 02-01, but the face has not been fetched yet — slide-0 `h1` and other `.font-display` consumers currently render with the `sans-serif` fallback (system default) until Plan 02-02 swaps the `<link href>`. This is the expected interim visual state.
- **Plan 02-03:** Component `<style>` block (lines 130-277, was 125-272 pre-Phase-2; shifted +5) still has Cat B indigo/slate literals at the 18 sites enumerated in 01-01-SUMMARY.md / PATTERNS.md P-3. They auto-re-theme on the `--neutral-*-rgb` flips landed in Plan 02-01 (slate utilities now resolve to warm-gray), but the literal `#4F46E5` / `#EEF2FF` / `#A5B4FC` / `#F8F7FF` / `#818CF8` colors in `.answer-card`, `.check-card`, `.key-badge` selected + hover states still render indigo/light-indigo because Phase 1 left them as literals (D-08 zero-visual-diff). Plan 02-03 migrates them per PATTERNS.md P-3a..P-3e.
- **Plan 02-04:** Results page (lines 538-705, was 533-700 pre-Phase-2; shifted +5) still uses `bg-surface-dark` + `bg-surface-dark-card` markup utility names. The deleted Tailwind config entries mean these utilities generate no CSS — so those elements now have transparent backgrounds and fall through to the body's warm off-white. Inline `style="background:rgba(15,23,42,0.5);"` on line 548 and `style="background:rgba(245,158,11,0.15);"` on line 579 still render literal dark / amber tints. Plan 02-04 retires the dark-hero markup, adds the three orange section dividers (D-05), wires the 3px orange left-border on the main result card (D-02), and adds the callout top-strips (D-03).

## Next Phase Readiness

- Token contract foundation is in place. Every subsequent Phase 2 plan reads through the new tokens (`--accent-rgb`, `--surface-rgb`, `--brand-soft-rgb`, `--brand-secondary-rgb`) and new utilities (`bg-surface-elev`, `bg-yellow-100`, `text-yellow-400`).
- V-2 D-14 gate cadence proven workable: source-level greps + runtime DevTools-protocol assertions both fired and matched. Subsequent `<head>`-touching plans (02-02 font swap) should reuse the puppeteer-core verify rig in `/tmp/v2-verify-deps` (puppeteer-core is installed there; just adapt the `v2-verify.mjs` assertion set for V-2c).
- One small recommendation for the orchestrator's VALIDATION.md revision: V-1(e) `document.fonts.check('1em "Space Grotesk")` — same caveat noted in the V-1 orchestrator run log (returns `false` until an element demands the face). Not blocking. Carry forward into V-2c (Plan 02-02 verify gate) as "after probe triggers Space Grotesk render."

## Self-Check: PASSED

- `index.html` exists: FOUND
- Commit `c4e868a` (Task 1): FOUND in git log
- Commit `b220b73` (Task 2): FOUND in git log
- SUMMARY.md path `.planning/phases/02-overdrive-default-theme-migration/02-01-SUMMARY.md`: this file (written and about to commit)
- All V-2a + V-2b assertions: PASS (see D-14 verification table above)
- No modifications to STATE.md or ROADMAP.md (orchestrator owns those writes after wave merge): confirmed via `git diff --name-only HEAD~2 HEAD` returning only `index.html`

---
*Phase: 02-overdrive-default-theme-migration*
*Plan: 01*
*Completed: 2026-05-16*
