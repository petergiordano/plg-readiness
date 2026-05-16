---
phase: 02-overdrive-default-theme-migration
verified: 2026-05-16T16:00:00Z
status: gaps_found
score: 3/4 success criteria verified (1 partial-fail blocking)
overrides_applied: 0
gaps:
  - truth: "A user opening index.html with no theme override sees the Overdrive identity across all six slides and the results page (SC #1) AND the entire app is internally coherent (SC #3) — the reference matrix region on the results page has 7 surfaces that visually collapse into their parent canvas because --neutral-50-rgb and --surface-rgb both resolve to #FFF8F0."
    status: partial
    reason: "Token-contract collision: lines 55 and 66 of index.html declare both `--surface-rgb: 255 248 240` and `--neutral-50-rgb: 255 248 240` — identical RGB values. Tailwind utilities `bg-surface-warm` and `bg-slate-50` therefore resolve to the SAME computed color. The reference matrix `<section>` at line 602 uses `bg-surface-warm`. Inside it sit 7 surfaces using `bg-slate-50`: 4 table headers (lines 615-618) and 3 grid cards (lines 671, 680, 689). All 7 surfaces render the SAME color as their parent canvas — they visually collapse with no fill differentiation. The 3 cards have only `border-slate-100` (resolves to #F5F0E8, ~10-step delta from #FFF8F0) so they have no visible boundary either. This is a real, source-verifiable functional regression. Most other Phase 2 work is correct, which is why this is graded as partial-fail rather than full-fail of SC #1."
    artifacts:
      - path: "index.html"
        issue: "Line 55 (`--surface-rgb: 255 248 240`) and line 66 (`--neutral-50-rgb: 255 248 240`) hold the same value. Tailwind `bg-slate-50` resolves through `--neutral-50-rgb` → identical to `bg-surface-warm`. 7 consumer sites — lines 615, 616, 617, 618 (table headers) + 671, 680, 689 (3-up grid cards) — sit inside a `bg-surface-warm` parent (`<section>` at line 602) and lose their fill differentiation."
    missing:
      - "Re-anchor `--neutral-50-rgb` to a value distinct from `--surface-rgb` (code review recommendation Option A: `250 243 233` / `#FAF3E9`, one step warmer-deeper) — restores card/header visibility without touching markup."
      - "OR swap the 7 affected sites to a different utility (e.g., `bg-surface-elev` white per code review Option B) — markup-touching but explicit."
      - "OR tighten the cards' border from `slate-100` to `slate-200`+ (code review Option C; partial fix, headers still flat against surface)."
deferred: []
---

# Phase 2: Overdrive Default Theme Migration — Verification Report

**Phase Goal:** The app's default visual identity is Overdrive end-to-end — every slide, the results page, callouts, and the reference matrix render coherently with no half-old / half-new state, and no dark backgrounds.

**Verified:** 2026-05-16T16:00:00Z
**Status:** gaps_found
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths (Success Criteria from ROADMAP.md)

| #   | Truth | Status | Evidence |
| --- | ----- | ------ | -------- |
| 1   | Overdrive identity end-to-end across all six slides AND the results page (Space Grotesk, Plus Jakarta Sans, JetBrains Mono, Overdrive accent + surface tokens) | PARTIAL-FAIL | Slides 0–5 and the dark-hero-retired callout region: VERIFIED. Results-page reference matrix region: FAILED — 7 surfaces (4 table headers + 3 cards) visually collapse into parent because `--neutral-50-rgb` == `--surface-rgb` (both `255 248 240`). The results page is part of the SC #1 scope and does not render coherently. |
| 2   | Dark results hero (`#0F172A`) gone; warm off-white surfaces with orange-as-structure (dividers, orange-backed callouts) | VERIFIED | `grep '#0F172A'` returns 0 matches. Three 4px orange section dividers in place (lines 538, 602, 703). Main result card has 3px orange left-border (line 543). Two callouts have 5px orange top-strips (lines 557, 577). |
| 3   | Entire app internally coherent — no surface, control, badge, or card carries the old indigo / slate / Fraunces identity | VERIFIED (literal) / WARNING (spirit) | V-5 grep (`#4F46E5\|#4338CA\|#EEF2FF\|#A5B4FC\|#818CF8\|#F8F7FF\|Fraunces\|bg-indigo\|text-indigo`) returns 0 matches. No retired-identity residue remains. However, the BL-01 collapse (above) violates the spirit of "internally coherent" — invisible cards inside a flat warm canvas is the opposite of coherent. Graded VERIFIED on literal text; flagged as the same BL-01 root cause as SC #1 partial-fail above. |
| 4   | Quiz behaves exactly as before: same six slides, same scoring, same result strings, same wedge-callout and override-notice logic | VERIFIED | All 6 slides present (`id="slide-0"` through `id="slide-5"`). All 7 scoring/flow JS functions byte-identical to `main` (`calculateScore`, `showResults`, `selectAnswer`, `restartQuiz`, `renderCheckboxes`, `goTo`, `updateChrome` — verified by per-function md5 against `git show main:index.html`). All 6 result strings present in source (`grep` lines 966, 975, 984, 988, 992, 997). |

**Score:** 3/4 success criteria verified; 1 partial-fail (SC #1) graded as BLOCKER.

### Required Artifacts

| Artifact | Expected | Status | Details |
| -------- | -------- | ------ | ------- |
| `index.html` `:root` block (lines 48–85) | Overdrive token values: `--accent-rgb 255 144 0`, `--surface-rgb 255 248 240`, `--text-rgb 67 67 67`, warm-gray ramp, `--font-display 'Space Grotesk'`, +2 secondary tokens `--brand-soft-rgb 255 229 153` + `--brand-secondary-rgb 241 194 50`; dark surface tokens removed | VERIFIED (with BL-01 caveat) | All values present and correct. `--surface-dark-rgb` and `--surface-dark-card-rgb` removed. Secondary palette divider in place. BL-01 caveat: `--neutral-50-rgb` collides with `--surface-rgb` at the same `255 248 240` value (line 55 vs line 66). |
| `index.html` Tailwind config (lines 88–128) | `surface.elev`, `yellow.100`, `yellow.400` exposed; `surface.dark`/`surface.dark-card` deleted; display fontFamily fallback `'sans-serif'` | VERIFIED | Line 94 fallback `'sans-serif'`. Line 105 `surface.elev`. Lines 120-123 `yellow:` namespace with `100` + `400`. No `surface.dark` entries. |
| `index.html` Google Fonts `<link>` (line 129) | Loads Space Grotesk (weights 400/500/600/700) + Plus Jakarta Sans (400/500/600) + JetBrains Mono (400); no Fraunces | VERIFIED | Line 129 href is exactly the expected target. `grep 'Fraunces'` returns 0 matches. |
| `index.html` component `<style>` block (lines 130–277) | All Cat B literal sites migrated to var-driven references; hovers alpha-derived per D-11 (`rgb(var(--accent-rgb) / 0.06)` bg, `... / 0.4` border); selected states resolve through `--accent-rgb` / `--accent-muted-rgb` | VERIFIED (with WR-01 warning) | Lines 182, 195, 215 contain `rgb(var(--accent-rgb) / 0.4)` and `/ 0.06)`. Lines 183, 216, 226 selected states resolve through `--accent-rgb` / `--accent-muted-rgb`. Lines 197 + 268 use `rgb(var(--surface-elev-rgb))`. **WR-01 (warning, not blocker):** lines 180 and 210 (`.answer-card`, `.check-card`) still hardcode `background: white` instead of `rgb(var(--surface-elev-rgb))` — not a Phase-2 regression (was literal pre-Phase-1) but violates D-02 cross-theme contract spirit. |
| `index.html` results page region (lines 535–710) | Dark hero retired; warm off-white surfaces; 3 orange section dividers; main result card on white + 3px orange left-border; 2 callouts on white + 5px orange top-strips; warning icon Golden Yellow; PLS badge Light Yellow + Dark Gray text; PLS card icon Light Yellow bg; footer warm + 4px orange top-rule | VERIFIED (structurally) / FAILED (visual coherence in reference matrix) | Structural elements present per grep evidence. BUT BL-01 collapses 7 reference-matrix surfaces visually into their parent — the structural Phase 2 work shipped but doesn't deliver coherent rendering in that region. |

### Key Link Verification

| From | To  | Via | Status | Details |
| ---- | --- | --- | ------ | ------- |
| `:root` token contract | Tailwind config `colors:` extend | RGB-triplet + `<alpha-value>` template strings | WIRED | All tokens are consumed by Tailwind utilities (`bg-accent`, `bg-surface-warm`, `bg-surface-elev`, `bg-yellow-100`, `text-yellow-400`, `text-ink`, `slate-*`). |
| Tailwind config | Markup utilities in body | CDN JIT generation | WIRED | All asserted utilities verified in markup. `bg-surface-warm` at 6 sites, `bg-surface-elev` at 3 markup sites + 2 CSS sites, `bg-yellow-100` at 2 sites, `text-yellow-400` at 1 site, `text-amber-400` retired (0 matches). |
| `<link>` (line 129) | `fonts.gstatic.com` Space Grotesk woff2 | `<link rel="stylesheet">` to Google Fonts CSS | WIRED (source-verified) | Source-level: line 129 href is exactly the target URL. Runtime font-load: per 02-05-SUMMARY claim "verified via network interception" — accepted (runtime probe was executed by the executor; not re-run by this verifier). |
| Main result card (line 543) | `--accent-rgb` + `--surface-elev-rgb` | inline style + `bg-surface-elev` utility | WIRED | Inline `style="border-left: 3px solid rgb(var(--accent-rgb));"` present; `bg-surface-elev` class present. |
| Wedge + override callouts (lines 557, 577) | `--accent-rgb` | inline `style="border-top: 5px solid rgb(var(--accent-rgb));"` | WIRED | Both callouts present with the inline top-strip style. |
| Warning icon (line 580) | `--brand-secondary-rgb` | `text-yellow-400` utility + inline bg `rgb(var(--brand-secondary-rgb) / 0.15)` | WIRED | Both present and resolve through D-12 tokens. |
| PLS badge (line 640) + PLS card icon bg (line 681) | `--brand-soft-rgb` | `bg-yellow-100` utility | WIRED | Both present. Per R-2 contrast override, PLS badge uses `text-ink` not `text-yellow-400`. |
| `calculateScore()` decision tree | All 6 result-title strings + wedge-callout + override-notice show/hide | Direct DOM manipulation via IDs `#result-title`, `#wedge-callout`, `#override-notice`, `#override-explanation` | WIRED (byte-identical to main) | All 6 result strings present. JS functions byte-identical to `main`. No Phase 2 scoring regression. |

### Data-Flow Trace (Level 4)

| Artifact | Data Variable | Source | Produces Real Data | Status |
| -------- | ------------- | ------ | ------------------ | ------ |
| `#result-title` (line 546) | `resultTitle.textContent` | `calculateScore()` lines 966/975/984/988/992/997 | Yes — 6 literal strings | FLOWING |
| `#result-recommendation` (line 550) | `recommendationEl.textContent` | `calculateScore()` recommendation block | Yes — populated per branch | FLOWING |
| `#wedge-callout` visibility (line 557) | `wedgeCallout.classList` | `calculateScore()` lines 970, 995 | Yes — show/hide logic intact | FLOWING |
| `#override-notice` visibility (line 577) | `overrideNotice.classList` | `calculateScore()` line 977 | Yes — show/hide logic intact | FLOWING |
| `#progress-fill` width (line 283) | `progressFill.style.width` | `updateChrome()` byte-identical to main | Yes — slide-based progression | FLOWING |

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
| -------- | ------- | ------ | ------ |
| HTTP server returns 200 for index.html | `curl -s -o /dev/null -w "%{http_code}" http://localhost:8765/` | `200` | PASS |
| `--surface-rgb` and `--neutral-50-rgb` both resolve to `255 248 240` (BL-01 source proof) | `grep -E -- '--surface-rgb:\|--neutral-50-rgb' index.html` | Line 55: `255 248 240`; Line 66: `255 248 240` — IDENTICAL | PASS (confirms BL-01) |
| `Fraunces` fully removed from source | `grep 'Fraunces' index.html` | 0 matches | PASS |
| All 6 result strings present in `calculateScore()` | `grep '"Pure PLG\|"PLG Motion\|"Product-Led Sales\|"Sales-Led with Wedge\|"Sales-Led Growth\|"Hybrid Approach"' index.html` | 6 matches | PASS |
| All 7 scoring/flow JS functions byte-identical to `main` | Per-function `md5` diff against `git show main:index.html` | All 7 IDENTICAL | PASS |
| 3 orange section dividers present | `grep 'border-t-\[4px\] border-accent' index.html` | 3 matches (lines 538, 602, 703) | PASS |
| Live browser runtime checks (V-2a/b/c/d, V-3 sub-criteria, V-7 offline) | Executed by Plan 05 executor per 02-05-SUMMARY, not re-run by this verifier | Reported PASS in SUMMARY; SUMMARY claims accepted for items the verifier cannot re-probe without a browser harness | SKIP (routed to human / accepted on prior evidence) |

### Probe Execution

No conventional probes declared for this phase (single-file static web app per PROJECT.md no-build constraint). VALIDATION.md V-1 through V-10 are browser-based DevTools assertions, not bash probes. The executor ran them in-session per Plan 05 SUMMARY. Verifier executed source-level greps + token-contract math (above) as the verifiable layer.

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
| ----------- | ----------- | ----------- | ------ | -------- |
| REQ-overdrive-default-theme | Plans 02-01 through 02-05 (all 5 plans declared in `requirements:`) | Default token values (the `:root` block, no `data-theme` set) produce the Overdrive visual identity; Display font Fraunces → Space Grotesk; Dark results hero removed; All six quiz slides + results page + reference matrix render coherently in Overdrive — no half-old / half-new state; Scoring logic, slide flow, and copy unchanged. | PARTIAL-FAIL (BL-01) | First 4 acceptance bullets verified at the source level. Fifth bullet (scoring/flow/copy unchanged) VERIFIED via JS byte-identity. Fourth bullet ("render coherently … no half-old / half-new state") fails on the reference matrix region due to BL-01 token collision. |

No orphaned requirements: REQUIREMENTS.md Traceability table maps REQ-overdrive-default-theme to Phase 2 only. All 5 plans declared this requirement in their frontmatter. No phase requirement was missed by any plan.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
| ---- | ---- | ------- | -------- | ------ |
| `index.html` | 55 + 66 | Two semantically distinct CSS custom properties (`--surface-rgb`, `--neutral-50-rgb`) hold the same value (`255 248 240`) without any commented note that this collision is intentional — both are independently brandable per Phase 1 D-09 and D-11, so they are EXPECTED to be flippable independently per client. The collision is a Phase 2 value-flip artifact (Plan 01 Task 1 step (e) set neutral-50 = surface anchor). | BLOCKER | Collapses `bg-slate-50` consumers inside `bg-surface-warm` parents — 7 surfaces (4 table headers + 3 cards) lose all fill differentiation against parent. Violates SC #1 ("results page renders coherently") and SC #3 spirit ("internally coherent"). |
| `index.html` | 180, 210 | `.answer-card { background: white; }` and `.check-card { background: white; }` hardcode the literal `white` instead of resolving through `--surface-elev-rgb`. | WARNING (WR-01 from code review) | Not a Phase 2 regression vs Phase 1 (literal was already present). Violates D-02 cross-theme contract: a future client theme overriding `--surface-elev-rgb` will not propagate to these surfaces. Not blocking Phase 2 goal but should be fixed before Phase 3 to honor REQ-stub-second-theme. |
| `index.html` | 311, 547, 550, 566, 569, 586, 608, 627, 631, 638, 642, 649, 653, 660, 664, 678, 687, 696, 704, 778, etc. | `text-slate-500` body text on `bg-surface-warm` — `--neutral-500-rgb: 138 138 138` on `255 248 240` ≈ 3.5:1 contrast (below WCAG AA 4.5:1) | WARNING (WR-02 from code review) | Accessibility regression caused by the Phase 2 neutral-ramp re-anchoring. Not blocking the phase goal (visual identity ships), but should be tracked. Out of scope for this verification verdict; flagged for human awareness. |
| `index.html` | 191, 263, 289, 296, 297, 314, 359, 366, 373, 401, 408, 436, 443, 450, 625, 636, 647, 658, 778 | `text-slate-400` small text on `bg-surface-warm` — `--neutral-400-rgb: 168 168 168` ≈ 2.4:1 contrast | WARNING (WR-03 from code review) | Same class of accessibility regression as WR-02. Same disposition. |
| `index.html` | 174, 187, 206, 220, 267 | `--border-rgb: 229 229 229` / `--neutral-300-rgb: 209 209 209` on `255 248 240` ≈ 1.07:1 / 1.35:1 contrast — fails WCAG 2.1 SC 1.4.11 (3:1 for non-text components) | WARNING (WR-04 from code review) | Same disposition. |
| `index.html` | 481, 517 | `bg-gradient-to-t from-surface-warm via-surface-warm` (no `to-*` stop) — degenerate gradient | INFO (WR-05 from code review) | Renders fine because parent is also `bg-surface-warm`. Future-theme footgun. Not blocking. |
| `index.html` | 579–582 | Override-notice warning icon: `text-yellow-400` on `rgba(F1C232, 0.15)` — non-text icon contrast ~1.6:1 | WARNING (WR-06 from code review) | Visible-but-low-contrast icon. Phase 2 goal "warning icon renders Golden Yellow" is met at the source level; readability is the concern. Not blocking the goal as written. |

No `TBD` / `FIXME` / `XXX` markers found in `index.html` (`grep -nE 'TBD\|FIXME\|XXX' index.html` returns 0 matches). No `TODO`/`HACK`/`PLACEHOLDER` markers either.

### Human Verification Required

No items require additional human verification beyond what the code review (02-REVIEW.md) and Plan 05 SUMMARY already surfaced. The BL-01 finding is machine-verifiable (two `:root` declarations with identical RGB triplets) — no human eye needed to confirm.

### Gaps Summary

**One blocker, one root cause:**

**BL-01 — Token-contract collision: `--neutral-50-rgb` and `--surface-rgb` both resolve to `#FFF8F0`.**

The Phase 2 value-flip (Plan 01 Task 1 step (e)) set `--neutral-50-rgb: 255 248 240` to "anchor" the warm-gray ramp on the surface color. But `--surface-rgb` is also `255 248 240`. Tailwind utilities `bg-slate-50` (→ `--neutral-50-rgb`) and `bg-surface-warm` (→ `--surface-rgb`) therefore resolve to the same `rgb(255, 248, 240)`. The reference-matrix `<section>` at line 602 carries `bg-surface-warm` and contains 7 `bg-slate-50` consumers (4 `<th>` table headers at lines 615-618, 3 `<div>` 3-up grid cards at lines 671/680/689). All 7 lose their fill differentiation against the parent — the cards become outline-only with a barely-visible `border-slate-100` (`#F5F0E8`, ~10-step delta from `#FFF8F0`); the headers become flat against the section.

The result: the reference matrix region of the results page does not render "coherently" per SC #1 (3-up cards are essentially invisible cards; table headers are no different from table body bg). This is a real, source-verifiable visual regression — confirmed without a browser by reading `:root` declarations directly.

**Why this matters relative to the SUMMARY narrative:**

Plan 05 SUMMARY claims V-3 (visual identity coherence) and V-10 (continuous-surface coherence) both PASS. V-10's assertion was specifically: "warm off-white surface CONTINUOUS across body, results page, reference matrix wrapper, footer — all four samples return `rgb(255, 248, 240)`." That assertion held — but the unintended corollary is that the surface is TOO continuous: surfaces that were supposed to differentiate (cards, headers) also return that same value. V-3's checks for "PLS badge Light Yellow" and "3 orange section dividers visible" did not enumerate the cards-inside-section visual hierarchy, so the regression was missed by the V-3 rig. The SUMMARY narrative is therefore narrowly truthful on the specific assertions run but does not surface the BL-01 collapse.

**Group: 1 root cause, 7 surface manifestations.**

The fix is one-line per the code review's recommended Option A: re-anchor `--neutral-50-rgb` to a value distinct from `--surface-rgb` (e.g., `250 243 233` / `#FAF3E9`, one step warmer-deeper). Zero markup changes; restores card/header visibility for all 7 sites; preserves warm-palette feel.

**Other findings (warnings, not blockers, not gating Phase 2 goal):**

- WR-01 (`.answer-card` / `.check-card` hardcoded `background: white`) — D-02 contract violation; concerns Phase 3 theme-switch correctness but does not block Phase 2 identity. Recommend fixing before Phase 3.
- WR-02 / WR-03 / WR-04 (WCAG-AA contrast regressions on body text + small text + borders driven by the neutral-ramp re-anchor) — accessibility concerns; Phase 2 ROADMAP success criteria do not specify WCAG-AA, so these do not gate the phase goal. Flagged for human awareness.
- WR-05 (degenerate gradient on sticky footers) — renders fine in current theme; future-theme footgun. Info.
- WR-06 (warning icon contrast inside override-notice) — visible but low-contrast. Phase 2 goal met at source; readability concern.

**Verified successes (independent of BL-01):**

- All 7 scoring/flow JS functions byte-identical to `main` — SC #4 fully verified.
- Dark surfaces fully retired (V-4 grep 0 matches) — SC #2 verified.
- Indigo / Fraunces identity fully retired (V-5 grep 0 matches) — SC #3 verified at the literal-text level.
- Token contract structural shape correct: Overdrive accent + warm off-white surface + Space Grotesk display + Plus Jakarta Sans body + JetBrains Mono mono + secondary palette (Light Yellow + Golden Yellow) + warm-gray neutral ramp.
- Tailwind config correct: `surface.elev`, `yellow.100`, `yellow.400` exposed; `surface.dark` / `surface.dark-card` deleted.
- Google Fonts `<link>` correct: Space Grotesk + Plus Jakarta Sans + JetBrains Mono; no Fraunces.
- Component `<style>` block correctly migrated: hovers alpha-derived from accent; selected states resolve through accent + accent-muted; no indigo literals.
- Results page region correctly rebuilt: dark hero retired; 3 orange section dividers; main result card on white + 3px orange left-border; 2 callouts on white + 5px orange top-strips; warning icon Golden Yellow; PLS badge Light Yellow + Dark Gray text; PLS card icon bg Light Yellow; footer warm + 4px orange top-rule.

The phase shipped most of what it set out to ship. The single blocker is a one-line value collision that the V-3 / V-10 rigs were not designed to catch.

---

_Verified: 2026-05-16T16:00:00Z_
_Verifier: Claude (gsd-verifier)_
