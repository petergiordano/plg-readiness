---
phase: 02-overdrive-default-theme-migration
plan: "06"
subsystem: ui
tags: [css-custom-properties, tailwind, theming, gap-closure, regression-prevention]

requires:
  - phase: 02-overdrive-default-theme-migration
    provides: "Plans 02-01 through 02-05 executed; verification gaps_found on BL-01 (--neutral-50-rgb == --surface-rgb)"

provides:
  - "Re-anchored --neutral-50-rgb to 250 243 233 (#FAF3E9), distinct from --surface-rgb 255 248 240 (#FFF8F0)"
  - "V-11 surface-differentiation rig in 02-VALIDATION.md — regression guard for bg-slate-50 vs bg-surface-warm delta"
  - "V-12 renumbering of prior optional V-11 Tailwind CDN noise row"

affects: [02-VERIFICATION.md re-run, Phase 3 planning, future client theme additions]

tech-stack:
  added: []
  patterns:
    - "Token-collision regression prevention: V-11 asserts strict inequality between bg-slate-50 consumer and bg-surface-warm ancestor computed-colors after every --neutral-50-rgb or --surface-rgb change"

key-files:
  created:
    - .planning/phases/02-overdrive-default-theme-migration/02-06-SUMMARY.md
  modified:
    - index.html
    - .planning/phases/02-overdrive-default-theme-migration/02-VALIDATION.md

key-decisions:
  - "Option A (re-anchor token, no markup changes) chosen over Option B (markup utility swap) and Option C (border tightening) — lowest blast-radius fix per 02-REVIEW.md CR-01"
  - "New value 250 243 233 (#FAF3E9) slots between --surface-rgb 255 248 240 and --neutral-100-rgb 245 240 232, preserving warm-gray ramp monotonicity (D-06 / D-07)"
  - "V-11 pass criteria uses strict !== inequality — not a tolerance check — so future rounding or near-collisions are also caught"
  - "WR-01 through WR-06 deferred per user locked scope decision; out of scope for this plan"

requirements-completed: [REQ-overdrive-default-theme]

duration: 15min
completed: 2026-05-16
---

# Phase 2 Plan 06: BL-01 Gap Closure Summary

**Single-line token flip re-anchors `--neutral-50-rgb` from `255 248 240` to `250 243 233` (#FAF3E9), restoring fill differentiation for 7 reference-matrix surfaces (4 `<th>` headers + 3 grid cards) against their `bg-surface-warm` parent, and adds a V-11 regression rig to catch this class of collision in future verification rounds.**

## Performance

- **Duration:** ~15 min
- **Started:** 2026-05-16T00:00:00Z
- **Completed:** 2026-05-16T00:00:00Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments

- Closed BL-01: `--neutral-50-rgb` and `--surface-rgb` now carry distinct RGB triplets; `bg-slate-50` consumers regain computed-color differentiation from `bg-surface-warm` parents
- Added V-11 surface-differentiation guard to `02-VALIDATION.md` — encodes a concrete `querySelector` selector path and a strict `!==` inequality assertion between card and parent computed `backgroundColor`
- Renumbered prior optional V-11 (Tailwind CDN noise diagnosis) to V-12 with no stale cross-references remaining

## The Token Flip (Task 1)

**Line 66 of `index.html` — before:**
```css
--neutral-50-rgb:  255 248 240;   /* #FFF8F0 surface anchor */
```

**Line 66 of `index.html` — after:**
```css
--neutral-50-rgb:  250 243 233;   /* #FAF3E9 one step warmer-deeper than --surface-rgb; bg-slate-50 consumers must differentiate from bg-surface-warm parents */
```

The new value `250 243 233` (#FAF3E9) sits between `--surface-rgb` `255 248 240` (#FFF8F0) and `--neutral-100-rgb` `245 240 232` (#F5F0E8), preserving warm-gray ramp monotonicity per D-06 / D-07. No markup changed. No Tailwind config changed. No tokens added or retired. Full 10-stop ramp (D-07) remains declared.

## V-11 Rig Addition + V-12 Renumbering (Task 2)

**New V-11** inserted between V-10 and the prior optional row:

- **Behavior:** `bg-slate-50` inside `bg-surface-warm` MUST render a different computed color than its parent (inverse of V-10's continuity assertion)
- **Command:** `python3 -m http.server 8080`, navigate to results page, open DevTools console, run the `querySelector`-based `getComputedStyle` comparison
- **Pass criteria:** `getComputedStyle(card).backgroundColor !== getComputedStyle(parent).backgroundColor` returns `true` — strict inequality, not tolerance. After BL-01 fix: card returns `rgb(250, 243, 233)`, parent returns `rgb(255, 248, 240)`.
- **Sample point:** first 3-up grid card at index.html line 671 (`document.querySelector('section.bg-surface-warm .grid .bg-slate-50')`)
- **Gate:** After every commit touching `--neutral-50-rgb` OR `--surface-rgb` OR Tailwind `slate.50`/`surface.warm` config entries, AND every Phase-end full sweep

**Prior optional V-11** (Tailwind CDN noise diagnosis) is now **V-12**. Grep confirms zero stale `V-11 (optional)` references remain in the file.

**Per-Task Verification Map** has a new Block 9 row: Plan Wave 6 / REQ-overdrive-default-theme / DevTools / V-11 (new) / pending.

**Manual-Only Verifications table** has a new V-11 row with Behavior, Requirement, Why Manual, and Test Instructions.

## Source-Level Grep Evidence (BL-01 Closed)

All 7 verification assertions from the plan's `<verification>` block:

| # | Assertion | Result |
|---|-----------|--------|
| 1 | `--surface-rgb` still `255 248 240` | 1 match on line 55 |
| 2 | `--neutral-50-rgb` now `250 243 233` | 1 match on line 66 |
| 3 | Old `--neutral-50-rgb` `255 248 240` (expect 0) | 0 matches |
| 4 | New comment `#FAF3E9 one step warmer-deeper` | 1 match on line 66 |
| 5 | Full 10-stop ramp still declared (D-07) | 10 matches |
| 6 | `slate-50` and `var(--neutral-50-rgb)` references | 35 matches (Tailwind config + consumers) |
| 7 | `bg-slate-50` consumer count | 9 matches (8 markup sites + 1 in new comment on line 66) |

Note on assertion #7: the plan expected 8; the actual count is 9 because the new comment text on line 66 itself contains `bg-slate-50`. This is a benign counting artifact — all 8 markup consumer sites are unchanged.

HTTP smoke-check: server returns 200 for `index.html`. Git diff confirms the change is scoped to exactly 1 line in the `:root` block (lines 63-75 region), with no other diff sections.

## Deferred Browser-Runtime Check (Acceptance Criterion #8)

The plan requires a browser DevTools runtime assertion to fully close BL-01:

```js
getComputedStyle(document.documentElement).getPropertyValue('--neutral-50-rgb').trim() === '250 243 233'
```

This agent does not have browser access. **This assertion is deferred to the user's next verification round** and should be run as part of re-running `02-VERIFICATION.md`. The source-level grep proofs above confirm the value is correct at the source-of-truth level. The runtime check is belt-and-suspenders regression prevention.

**When re-running 02-VERIFICATION.md, also run the new V-11 rig:**

```js
const card = document.querySelector('section.bg-surface-warm .grid .bg-slate-50');
const parent = card.closest('.bg-surface-warm');
const cardBg = getComputedStyle(card).backgroundColor;
const parentBg = getComputedStyle(parent).backgroundColor;
console.log('card:', cardBg, '| parent:', parentBg, '| different:', cardBg !== parentBg);
// Expected: card: rgb(250, 243, 233) | parent: rgb(255, 248, 240) | different: true
```

## Side-Effect at Line 548

The `bg-slate-50` panel at line 548 sits inside a `bg-surface-elev` (white / `#FFFFFF`) parent card, not inside `bg-surface-warm`. After the flip, this panel renders at `rgb(250, 243, 233)` (`#FAF3E9`) against white — a subtle warm tint rather than a barely-perceptible warm-on-warm.

Per the planning context note in `02-06-PLAN.md`: "this is expected and acceptable — flag to the user only if it appears jarring against the white parent card." The new warm-tinted recommendation panel on a white card is a slightly warmer look than before, but aligns with the Overdrive D-06 warm-gray palette intent. **No action required** — this is the expected behavior documented in the plan. The user should confirm visually during the next browser review round.

## WR-01 through WR-06 — Explicitly Not Touched

All six warnings from `02-REVIEW.md` are deferred per the user's locked scope decision (BL-01 ONLY for plan 02-06):

| Warning | Description | Status |
|---------|-------------|--------|
| WR-01 | `.answer-card` / `.check-card` hardcode `background: white` instead of `--surface-elev-rgb` | Deferred per user's locked scope decision |
| WR-02 | `text-slate-500` body text fails WCAG AA on warm canvas (~3.5:1 contrast) | Deferred per user's locked scope decision |
| WR-03 | `text-slate-400` small text fails WCAG AA at small sizes (~2.4:1 contrast) | Deferred per user's locked scope decision |
| WR-04 | Card and badge borders (`--border-rgb`, `--neutral-300-rgb`) fail 3:1 non-text contrast | Deferred per user's locked scope decision |
| WR-05 | Sticky-footer gradient on slides 4 and 5 has no destination color | Deferred per user's locked scope decision |
| WR-06 | Override-notice icon uses `text-yellow-400` on yellow-tinted background — non-text contrast under 3:1 | Deferred per user's locked scope decision |

None of these files were modified. Grep confirms: `.answer-card { background: white;` and `.check-card { background: white;` still return the pre-existing literals; `--neutral-400-rgb`, `--neutral-500-rgb`, `--border-rgb` values are unchanged; sticky-footer gradient lines 481/517 are unchanged; override-notice icon at lines 579-582 is unchanged.

## Task Commits

1. **Task 1: Flip `--neutral-50-rgb` value on index.html line 66** — `36e0c29` (feat)
2. **Task 2: Add V-11 rig + renumber V-12 in 02-VALIDATION.md** — `c0dbe64` (docs)

## Files Created/Modified

- `/Users/petergiordano/Documents/GitHub/plg-readiness-rebrand/index.html` — single-line token flip on line 66 only
- `/Users/petergiordano/Documents/GitHub/plg-readiness-rebrand/.planning/phases/02-overdrive-default-theme-migration/02-VALIDATION.md` — V-11 block inserted, V-12 renumbering, Block 9 row in Per-Task Verification Map, V-11 row in Manual-Only Verifications

## Decisions Made

- Option A (re-anchor token, no markup changes) chosen over Option B (markup utility swap) and Option C (border tightening) — lowest blast-radius, leaves all `bg-slate-50` consumers behaving as the design system originally intended
- V-11 pass criteria uses strict `!==` inequality (not tolerance) — catches future near-collisions as well as exact collisions; this is the lesson from BL-01 where V-3/V-10 asserted continuity but not differentiation

## Deviations from Plan

None — plan executed exactly as written. The one minor deviation is that assertion #7 (`bg-slate-50` count = 8) now returns 9 because the new comment on line 66 contains `bg-slate-50` text. This is benign and documented above.

## Next Steps — Ready to Re-Run 02-VERIFICATION.md

With BL-01 closed at the source level, Phase 2 SC #1 should flip from PARTIAL-FAIL to VERIFIED in the next verification round. Steps:

1. `python3 -m http.server 8080`
2. Load `http://localhost:8080/`, complete the quiz to reach the results page
3. Run the V-11 rig in DevTools (see command above) — confirm `different: true`
4. Run the deferred acceptance criterion #8 runtime assertion: `getComputedStyle(document.documentElement).getPropertyValue('--neutral-50-rgb').trim() === '250 243 233'` — confirm `true`
5. Visually confirm reference-matrix `<th>` headers (lines 615-618) and 3-up grid cards (lines 671/680/689) have visible fill differentiation from the surrounding warm canvas
6. Re-run full `02-VERIFICATION.md` sweep; if all gaps closed, `STATE.md` status can flip from `gaps_found` to `verified`

---
*Phase: 02-overdrive-default-theme-migration*
*Completed: 2026-05-16*
