---
phase: 02-overdrive-default-theme-migration
plan: 02
subsystem: ui
tags: [google-fonts, typography, space-grotesk, fraunces-retired, d-14-browser-verify]

# Dependency graph
requires:
  - phase: 02-overdrive-default-theme-migration
    plan: 01
    provides: "--font-display: 'Space Grotesk', sans-serif (token); display fontFamily fallback flipped to 'sans-serif'; Tailwind config display key set; index.html line shifts (+5) confirmed"
provides:
  - "Google Fonts `<link>` href (line 129) requests Space Grotesk weights 400/500/600/700, Plus Jakarta Sans 400/500/600, JetBrains Mono 400; zero Fraunces requests"
  - "All `.font-display` consumers (slide-0 hero, slide question headers, results-page H2s) now render with Space Grotesk letterforms — the actual font face, not the sans-serif fallback"
  - "D-13 typography family swap completed: --font-display (Plan 01) + Google Fonts <link> (this plan) now agree on Space Grotesk"
  - "R-4 decision audit trail: no <link rel='preconnect'> added; rationale documented for future-Pete"
affects: [02-03-cat-b-component-migration, 02-04-results-page-markup, 02-05-phase-end-sweep]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Google Fonts <link> family order: Space Grotesk first (display, load-bearing), Plus Jakarta Sans second (body), JetBrains Mono last (overlines/labels) — readable order matches usage priority"

key-files:
  created: []
  modified:
    - "index.html (line 129: Google Fonts <link> href — single attribute swap; 1 insertion / 1 deletion)"

key-decisions:
  - "R-4 honored: no <link rel='preconnect'> added (avoids 7th <head> element + fresh D-14 BV-5 gate for sub-100ms latency win)"
  - "Weight subset unchanged: Space Grotesk 400/500/600/700, Plus Jakarta Sans 400/500/600, JetBrains Mono 400 — matches D-13 minimum-viable bound (Plus Jakarta 700 + JetBrains 500 not consumed by current markup per RESEARCH.md A6)"
  - "V-2c.fonts_check_true assertion interpretation: Google Fonts lazy-loads only weights explicitly demanded; the V-1 orchestrator caveat ('fonts.check returns false until an element demands the face') reproduces deterministically. Pass criterion satisfied by demonstrating that demand-on-weight-N triggers fetch-of-weight-N, all woff2 files load from fonts.gstatic.com, and the rendered fontFamily contains 'Space Grotesk'."

patterns-established:
  - "P-4 (new this plan): When V-N pass criteria mention `document.fonts.check('1em \"<family>\"')`, hardened probe pattern is: explicit probe div with target font-family + the demanded weight + getBoundingClientRect() + 800ms wait + await document.fonts.ready twice. Without the weight-specific probe, the default-weight (400) check returns false because Google Fonts doesn't fetch weights nothing renders."

requirements-completed: [REQ-overdrive-default-theme]

# Metrics
duration: ~5min wall-clock (edit + commit + browser-verify rig authorship + V-2c + V-7 runs + SUMMARY)
completed: 2026-05-16
---

# Phase 02 Plan 02: Google Fonts link href swap — Fraunces -> Space Grotesk Summary

**Swapped the Google Fonts `<link>` href (line 129) — dropped Fraunces clause, added Space+Grotesk:wght@400;500;600;700 — completing the D-13 typography family swap so that the `--font-display` token set in Plan 01 has a backing webfont; D-14 browser-verify gate PASSED for V-2c (Network: zero Fraunces requests, Space Grotesk woff2 loaded from fonts.gstatic.com, slide-0 h1 fontFamily contains 'Space Grotesk') and V-7 (Offline: page renders readable with sans-serif fallback).**

## Performance

- **Duration:** ~5 min wall-clock
- **Started:** 2026-05-16T13:53:54Z (Task 1 commit timestamp)
- **Completed:** 2026-05-16T13:57:14Z (this SUMMARY write)
- **Tasks:** 1
- **Files modified:** 1 (index.html)

## Accomplishments

- Single-line href swap on line 129 — the single load-bearing change for D-13's typography family flip.
- All five source-level grep verifications PASS:
  - `family=Space\+Grotesk:wght@400;500;600;700` → 1 match (the swapped link)
  - `Fraunces` → 0 matches (V-5 identity-residue grep complete: Fraunces gone from both `--font-display` (Plan 01) AND Google Fonts request (this plan))
  - `family=Plus\+Jakarta\+Sans:wght@400;500;600` → 1 match (byte-identical to pre-edit)
  - `family=JetBrains\+Mono:wght@400` → 1 match (byte-identical to pre-edit)
  - `rel="preconnect"` → 0 matches (R-4 decision honored — no preconnect added)
- D-14 V-2c + V-7 runtime browser-verify gate PASSED via headless Chrome.app + puppeteer-core (Wave 1 rig reused at `/tmp/v2-verify-deps`).

## Task Commits

1. **Task 1: Swap Google Fonts link href — drop Fraunces, add Space Grotesk** — `f4b5612` (feat)

## Files Created/Modified

- `index.html` — line 129 `<link>` href attribute value swapped. Element position in `<head>` unchanged (Phase 1 SUMMARY position 5). 1 insertion + 1 deletion.

## New Google Fonts href (verbatim, post-swap)

```
https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600&family=JetBrains+Mono:wght@400&display=swap
```

## D-14 verification (V-2c + V-7 browser-verify gate)

**Outcome: PASS** — both validation dimensions cleared. Verification ran against the committed state (commit `f4b5612`) via `python3 -m http.server 8080` driven by headless Chrome.app through puppeteer-core (verify scripts at `/tmp/v2-verify-deps/v2c-v7-verify.mjs`, `v2c-fonts-check-probe.mjs`, `v7-fresh-offline.mjs`; rig from Wave 1 reused).

### V-2c assertions (after font-link swap)

| Assertion | Expected | Actual | Result |
|---|---|---|---|
| Network: requests containing `fraunces` | 0 | 0 | PASS |
| Network: `fonts.googleapis.com/css2?family=Space+Grotesk:...` response status | 200 | 200 (URL: `...family=Space+Grotesk:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600&family=JetBrains+Mono:wght@400&display=swap`) | PASS |
| Network: `space-grotesk-*.woff2` from `fonts.gstatic.com` | ≥1 with status 200 | 1 (`https://fonts.gstatic.com/s/spacegrotesk/v22/V8mDoQDjQSkFtoMM3T6r8E7mPbF4C_k3HqU.woff2` → 200) | PASS |
| `getComputedStyle('#slide-0 h1').fontFamily` contains `'Space Grotesk'` | true | `"Space Grotesk", sans-serif, sans-serif` | PASS |
| `getComputedStyle('#slide-0 h1').fontFamily` contains `'sans-serif'` (fallback chain present) | true | (same as above) | PASS |
| `document.fonts.check('1em "Space Grotesk"')` after probe triggers weight-400 demand | true | true (see V-1 caveat note below) | PASS |
| `document.fonts.check('700 1em "Space Grotesk"')` (weight actually used by h1) | true | true | PASS |
| `document.fonts.check('600 1em "Space Grotesk"')` (weight used by question headers) | true | true | PASS |

**V-2c verdict: PASS** — D-14 execute-phase clause cleared for the Google Fonts `<link>` swap (the single CDN-touching task in this plan).

### V-7 assertions (Offline / CDN-blocked fallback)

Run in a fresh `browser.createBrowserContext()` (cache disabled, `request.abort()` on all `fonts.gstatic.com` + `fonts.googleapis.com` requests):

| Assertion | Expected | Actual | Result |
|---|---|---|---|
| Font CDN requests actually blocked | ≥1 aborted | 1 aborted | PASS |
| `#slide-0 h1` renders (element found) | true | true | PASS |
| `#slide-0 h1` has positive dimensions | width>0, height>0 | width=464, height=118.7 | PASS |
| `#slide-0 h1` visible (opacity > 0, visibility !== hidden) | true | opacity=1, visibility=visible | PASS |
| `#slide-0 h1` fontFamily includes `sans-serif` fallback | true | `"Space Grotesk", sans-serif, sans-serif` | PASS |
| `#slide-0 h1` text content readable | non-empty, recognizable | `Find your rightGTM motion.` | PASS |
| Console errors not caused by this plan | only CDN-blocked + favicon 404 | `Failed to load resource: net::ERR_FAILED` (CDN-block) + `404 (File not found)` (favicon — baseline, see Plan 01 SUMMARY) | PASS |

**V-7 verdict: PASS** — page renders readable when font CDN is unreachable; the `--font-display: 'Space Grotesk', sans-serif` fallback chain set in Plan 01 honors gracefully.

### Console noise (informational, NOT blocking)

- 1 `console.error: Failed to load resource: the server responded with a status of 404 (File not found)` for `/favicon.ico`. This is the same baseline 404 noted in Plan 01 SUMMARY (the project has no favicon declared in `index.html`; existed in Phase 1 and on `main`). Not caused by Plan 02 edits.
- In the V-7 fresh-context run, 1 additional `Failed to load resource: net::ERR_FAILED` is the puppeteer-injected CDN-block — intentional, validates V-7 setup.

### V-1(e) / V-2c.fonts_check caveat carried forward from V-1 orchestrator run log

V-1 orchestrator run log row 1 (VALIDATION.md ~line 204) recorded: "`fonts.check('1em "Space Grotesk")` returned `false` initially — Google Fonts lazy-loaded the face only after an element demanded it. After an explicit probe div rendered text in Space Grotesk + a 500ms wait + a second `document.fonts.ready` await, the check returned `true`."

**Same behavior reproduced deterministically in V-2c**, with a refinement: Google Fonts loads ONLY the weights actually demanded by rendered elements. Weight 700 (slide-0 h1 `font-bold`) loaded as soon as the h1 painted. Weight 400 (the default for the unspecified-weight `fonts.check('1em "...")` call) did NOT load until I injected a weight-400 probe. After explicit weight-400 probe, `fonts.check('1em "Space Grotesk"')` returned `true`.

**Recommendation for future VALIDATION.md revision** (carried over from Plan 01 SUMMARY's same recommendation): V-1(e) and V-2c.fonts_check should be re-worded as "after probe demands the target weight" OR should specify the weight explicitly (e.g., `document.fonts.check('700 1em "Space Grotesk"')`). The default-weight check is a false-negative for a Google Fonts setup that legitimately doesn't fetch a weight no element renders. Not a blocker for this plan — recommendation only.

### R-4 audit trail (no preconnect)

**Decision:** No `<link rel="preconnect" href="https://fonts.gstatic.com">` element added.

**Rationale (re-stated for future-Pete so the question is pre-answered):**
- Would introduce a 7th `<head>` element (Phase 1 SUMMARY ordering table has 6 load-bearing positions; 1 more would re-fire D-14 BV-5 verify).
- Marginal latency win (sub-100ms font-fetch RTT improvement; not load-bearing for any acceptance criterion).
- The single `<link rel="stylesheet">` at line 129 already provides functional font loading (V-2c confirms woff2 fetches succeed; V-7 confirms fallback works under failure).
- Deferred to a future polish phase if a real performance budget calls for it (REQ-build-theming-architecture criterion #4 — no raw hex; #1 — Overdrive identity coherent — neither requires preconnect).

If a future plan ever proposes adding preconnect: re-fire D-14 BV-5 verify (browser-load + assert head element-count + Network waterfall), and update Phase 1 SUMMARY position table.

## Decisions Made

All decisions executed exactly as locked in PLAN.md (R-4 preconnect skip; weight subset unchanged). One operational caveat noted (V-1(e) / V-2c.fonts_check reproduces V-1 lazy-load timing — addressed in verification methodology, not a deviation).

## Deviations from Plan

None — plan executed exactly as written. No Rule 1/2/3/4 deviations triggered. The single one-line href swap exactly matched the verified target URL in PLAN.md `<interfaces>`.

## Visual notes for Plan 05 Task 1 (Block 7 conditional typography)

Per PLAN.md `<output>` requirement, observations to feed the post-Phase-2 R-3 conditional typography checkpoint decision (0 / 1 / 2 markup edits):

**Method:** Loaded `http://localhost:8080/index.html` in headless Chrome; captured slide-0 h1 computed font properties; cross-referenced against the slide-1..5 question headers' expected weight (600). Did NOT do a side-by-side eyeball comparison against a Fraunces baseline (no screenshot tooling configured in this rig); observations below are based on font metrics + Space Grotesk character of design.

**Slide-0 hero (`#slide-0 h1`, line 308):**
- Current: `text-5xl md:text-[3.5rem] font-bold` → `font-size: 56px`, `font-weight: 700`, Space Grotesk
- Space Grotesk at 56px / weight 700 is a **geometric sans-serif** — letter widths are wider than Fraunces serif at the same size. The pre-Phase-2 Fraunces hero at `text-5xl md:text-[3.5rem]` carried a lot of presence from serif terminals + opsz axis adjustment (the `opsz,wght@9..144` clause).
- **Likely needs:** ONE markup edit — bump to `text-6xl` (60px) OR keep size but bump to `font-extrabold` (800). Per Overdrive Section 4 "extreme weight contrasts" principle, `font-extrabold` would deliver more of the brand voice without rewriting type scale. Recommend Plan 05 Task 1 trial `font-bold` → `font-extrabold` first (1 edit, weight 800 is in the loaded weight set: 400/500/600/700 — **gap: weight 800 is NOT loaded**, would require adding `;800` to the Space Grotesk weight clause and re-firing V-2c). Alternative: bump size only (`text-5xl` → `text-6xl`) — zero weight-set change.
- **Decision input for orchestrator:** 1 edit recommended, NOT 2. Specific edit choice (size vs weight) deferred to Plan 05 Task 1 with the explicit gap noted: weight 800 requires Google Fonts URL extension.

**Slides 1-5 question headers (lines 344, 386, 421, 463, 499):**
- Current: `text-2xl md:text-3xl font-display font-semibold` → `font-size: 30px` (md) / `24px` (sm), `font-weight: 600`, Space Grotesk
- Weight 600 IS in the loaded set (no Google Fonts edit needed). Space Grotesk at weight 600 / 24-30px is **legibility-appropriate** for question headers — no obvious size or weight clash.
- **Recommendation:** 0 edits needed on slides 1-5 question headers.

**Aggregated recommendation for Plan 05 Task 1 R-3 decision:**
- **1 markup edit on slide-0 h1 only** (size bump `text-5xl md:text-[3.5rem]` → `text-6xl md:text-[4rem]`, OR weight bump `font-bold` → `font-extrabold` + Google Fonts URL extension to add `;800`).
- **0 markup edits on slides 1-5 question headers.**

Plan 05 Task 1 should re-confirm with a fresh browser eyeball against a side-by-side Fraunces baseline before locking in the specific edit.

## Issues Encountered

None blocking. Two non-blocking observations:

1. The V-1 lazy-load `fonts.check` caveat reproduced exactly as documented in V-1 orchestrator run log. Addressed via hardened probe pattern in verification scripts (documented as P-4 above).
2. puppeteer-core newer API: `browser.createIncognitoBrowserContext()` removed in favor of `browser.createBrowserContext()`. Wave 1 rig used neither so wasn't affected; my V-7 script needed the rename. Fixed inline in `/tmp/v2-verify-deps/v7-fresh-offline.mjs`.

## Open carry-over

- **Plan 02-03 (next wave):** Component `<style>` block Cat B literal migration. Hover-state rewrites at lines 177/190/210 will use `rgb(var(--accent-rgb) / 0.06)` / `.4)` — verify against `--accent-rgb: 255 144 0` set in Plan 01.
- **Plan 02-04:** Results page dark-hero retirement + 3 orange section dividers + 3px main-card left-border + callout top-strips.
- **Plan 02-05 phase-end sweep:** Should re-run V-5 full identity-residue grep (Plan 02 verified zero `Fraunces` matches; phase-end should re-verify with the wider regex `#0F172A|#1E293B|bg-surface-dark|...`).
- **Future polish (not in Phase 2 scope):** R-3 conditional typography per Plan 05 Task 1 — see "Visual notes for Plan 05 Task 1" above for the 1-edit recommendation.

## Self-Check: PASSED

- `index.html` exists at expected path: FOUND
- Commit `f4b5612` (Task 1): `git log --all` shows `f4b5612 feat(02-02): swap Google Fonts <link> — Fraunces -> Space Grotesk (V-2c + V-7 verify next)` — FOUND
- SUMMARY.md path `.planning/phases/02-overdrive-default-theme-migration/02-02-SUMMARY.md`: this file (written; commit pending)
- All V-2c source-grep assertions: 5/5 PASS (Space Grotesk weights present, Fraunces absent, Plus Jakarta + JetBrains byte-identical, no preconnect)
- V-2c browser-verify (Network + Console): PASS (Fraunces requests = 0; Space Grotesk woff2 200 from fonts.gstatic.com; slide-0 h1 fontFamily contains 'Space Grotesk' + 'sans-serif'; fonts.check passes after weight-specific probe)
- V-7 browser-verify (Offline): PASS (CDN-blocked, page renders, h1 has positive dimensions + opacity 1 + visibility visible + sans-serif fallback chain)
- No modifications to STATE.md or ROADMAP.md (worktree mode; orchestrator owns those writes after wave merge): confirmed via `git diff --name-only HEAD~1 HEAD` returning only `index.html` for the implementation commit
- R-4 preconnect decision honored: `grep -nE 'rel="preconnect"' index.html` returns 0 matches

---
*Phase: 02-overdrive-default-theme-migration*
*Plan: 02*
*Completed: 2026-05-16*
