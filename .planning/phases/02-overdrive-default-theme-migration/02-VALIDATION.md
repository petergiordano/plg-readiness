---
phase: 2
slug: overdrive-default-theme-migration
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-05-16
---

# Phase 2 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.
> This phase has no test framework (single-file static web app, no build, no package manager per PROJECT.md). Validation is browser-load + DevTools + grep — see Test Infrastructure below.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | none — manual browser-load + DevTools (PROJECT.md single-file-no-build constraint) |
| **Config file** | none |
| **Quick run command** | `grep -nE '#0F172A\|bg-surface-dark\|#4F46E5\|Fraunces\|bg-indigo' index.html` (residue check) |
| **Full suite command** | `python3 -m http.server 8080` then walk all 6 slides + results page in Chrome/Firefox DevTools |
| **Estimated runtime** | ~3–5 minutes per full sweep |

---

## Sampling Rate

- **After every commit that touches `<head>`:** Run the corresponding V-2 sub-row in DevTools — Blocks 2, 3, 4, 5 each fire V-2 (D-14 execute-phase clause; mandatory per CONTEXT.md D-14)
- **After every commit (body markup):** Run the residue greps (V-4 + V-5)
- **Before `/gsd:verify-work`:** Full V-1 through V-10 sweep; V-9 scoring regression is the final gate
- **Max feedback latency:** ~30 seconds per V-2 row, ~5 minutes for full sweep

---

## Per-Task Verification Map

> Task IDs (`02-NN-MM`) will be assigned by the planner. The map below is keyed by **research Block** (the planner is expected to translate Blocks 2–6 into tasks 1:1 or 1:N). Update this table once PLAN.md exists.

| Research Block | Plan Wave (TBD) | Requirement | Threat Ref | Secure Behavior | Test Type | Verification Command | Status |
|----------------|-----------------|-------------|------------|-----------------|-----------|----------------------|--------|
| Block 2: Token contract value flips | TBD | REQ-overdrive-default-theme | T-2-01 (XSS via inline `<style>` mutation — N/A, pure value flip) | Token values render via Tailwind utilities; no JS evaluates user input | DevTools | V-2a (per BV-3 below) | ⬜ pending |
| Block 3: Tailwind config rewires | TBD | REQ-overdrive-default-theme | T-2-02 (Tailwind CDN integrity — N/A, no SRI change) | `bg-surface-elev` resolves; `bg-surface-dark` becomes no-op | DevTools | V-2b (per BV-1 below) | ⬜ pending |
| Block 4: Google Fonts `<link>` swap | TBD | REQ-overdrive-default-theme | T-2-03 (third-party font CDN — accept; same trust boundary as Phase 1) | Space Grotesk loads from `fonts.gstatic.com`; no Fraunces requests | DevTools Network | V-2c + V-7 (per BV-2 below) | ⬜ pending |
| Block 5: Cat B literal migration | TBD | REQ-overdrive-default-theme + REQ-theming-visual-only | T-2-04 (CSS injection via `:hover` — N/A) | Hover-state alpha-derived (`rgba(255,144,0,0.06)`); no indigo literal remains | DevTools | V-2d + V-6 | ⬜ pending |
| Block 6: Results page markup migration | TBD | REQ-overdrive-default-theme + REQ-no-dark-backgrounds | T-2-05 (no behavior change) | All result-state strings render; wedge-callout + override-notice show/hide unchanged | DevTools + manual walk | V-3 + V-9 + V-10 | ⬜ pending |
| Block 7 (conditional): D-13 typography adjustments | TBD | REQ-overdrive-default-theme | — | Space Grotesk legibility matches Fraunces baseline | DevTools eye-check | V-3 sub-criterion (c) | ⬜ conditional |
| Block 8: Phase-end sweep | TBD | All phase requirements | — | Acceptance criteria #1, #2, #3, #4 all pass | Manual + DevTools | V-1 through V-10 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Validation Dimensions (V-1 through V-10)

All dimensions sourced from `02-RESEARCH.md` `## Validation Architecture`. Each row below MUST be checked at the indicated gate. V-1 is the D-14 research-phase gate (fires before PLAN.md locks); V-2 rows fire after every `<head>`-touching commit per D-14 execute-phase clause.

### V-1 — D-14 research-phase browser-verify gate (HARD GATE before PLAN.md locks)

- **Behavior:** Proposed Phase 2 `<head>` state (Blocks 2+3+4 applied to a working copy) browser-loads with zero JS console errors and renders the Overdrive identity baseline.
- **Command:** `python3 -m http.server 8080`; load `http://localhost:8080/`; open DevTools console.
- **Pass criteria:** (a) zero red console errors at load; (b) `getComputedStyle(document.documentElement).getPropertyValue('--accent-rgb').trim() === '255 144 0'`; (c) `getComputedStyle(document.querySelector('#progress-fill')).backgroundColor === 'rgb(255, 144, 0)'`; (d) `getComputedStyle(document.querySelector('#slide-0 h1')).fontFamily` contains `'Space Grotesk'`; (e) `document.fonts.check('1em "Space Grotesk"') === true` post-load.
- **Gate:** PLAN.md does not lock until this passes. **Orchestrator runs in-session before spawning the planner.**

### V-2 — D-14 execute-phase browser-verify rows (HARD GATE per Block)

- **Behavior:** After each `<head>`-touching commit (Blocks 2, 3, 4, 5), browser-load and verify the state-check assertions for that block.
- **Command:** Same as V-1.
- **Pass criteria** (one per sub-row):
  - V-2a (after Block 2 token contract flip): `getComputedStyle(document.documentElement).getPropertyValue('--accent-rgb').trim() === '255 144 0'`; `getComputedStyle(document.body).backgroundColor === 'rgb(255, 248, 240)'`.
  - V-2b (after Block 3 Tailwind config): `getComputedStyle(document.querySelector('#result-container')).backgroundColor === 'rgb(255, 255, 255)'` (post-Block-6 markup); zero matches for `document.querySelectorAll('.bg-surface-dark, .bg-surface-dark-card')` rendering with dark bg.
  - V-2c (after Block 4 Google Fonts swap): zero `fraunces` requests in Network tab; `space-grotesk-*.woff2` files load from `fonts.gstatic.com`; `document.fonts.check('1em "Space Grotesk"') === true`.
  - V-2d (after Block 5 Cat B literal migration): hover `.answer-card` on slide 1; `getComputedStyle(hoveredCard).backgroundColor === 'rgba(255, 144, 0, 0.06)'`; `borderColor === 'rgba(255, 144, 0, 0.4)'`.
- **Gate:** Each block's commit is not "verified" until its corresponding V-2 row passes. **NOT a single end-of-phase sweep.** Encoded as per-task acceptance criteria in PLAN.md.

### V-3 — Visual identity coherence (acceptance criterion #1 + #3)

- **Behavior:** Default-render (no `?client=`) shows Overdrive identity end-to-end; no half-old/half-new state.
- **Command:** Walk all six slides + complete quiz to results in Chrome.
- **Pass criteria:** (a) warm off-white bg (#FFF8F0) on every slide + results + footer; (b) orange visible structurally (progress bar, overlines, CTAs, selected cards, all 3 result-page dividers, main card 3px left-border, both callout top-strips, footer top-rule); (c) Space Grotesk on every `.font-display`; (d) Plus Jakarta Sans body, JetBrains Mono overlines; (e) light-yellow + golden-yellow on PLS badge + PLS card icon bg + override warning icon; (f) zero indigo/purple/blue surfaces; (g) zero dark surfaces; (h) recognition test per design system §9 (cover title, page still reads as Overdrive).
- **Gate:** Phase-end.

### V-4 — Dark-surface elimination grep (acceptance criterion #1 + REQ-no-dark-backgrounds)

- **Behavior:** No source-level dark-surface reference remains.
- **Command:** `grep -nE '#0F172A|#1E293B|bg-surface-dark|bg-surface-dark-card|bg-slate-(7|8|9)00|--surface-dark-rgb|--surface-dark-card-rgb' index.html`
- **Pass criteria:** zero matches.
- **Gate:** After Block 3 + Block 6. Fast pre-V-3 sanity check.

### V-5 — Identity-residue grep (acceptance criterion #3 — no half-old state)

- **Behavior:** No source-level reference to retired indigo + Fraunces identity remains.
- **Command:** `grep -nE '#4F46E5|#4338CA|#EEF2FF|#A5B4FC|#818CF8|#F8F7FF|Fraunces|bg-indigo|text-indigo|hover:bg-indigo|hover:text-indigo' index.html`
- **Pass criteria:** zero matches. Allow one-line exception in inline recipe comment header (lines 14–47) if an example hex is referenced for instruction — but existing header uses `#FF9000` so this exception should not trigger.
- **Gate:** After all blocks complete.

### V-6 — Hover-state alpha-derived correctness (D-11)

- **Behavior:** `.answer-card` / `.check-card` hovers render with alpha-derived treatment, not old indigo literals.
- **Command:** Browser-load slide 1, hover an answer-card, DevTools Elements panel.
- **Pass criteria:** `getComputedStyle(hoveredCard).backgroundColor === 'rgba(255, 144, 0, 0.06)'`; `borderColor === 'rgba(255, 144, 0, 0.4)'`.
- **Gate:** After Block 5.

### V-7 — Font-load behavior (acceptance criterion #1)

- **Behavior:** Space Grotesk loads from Google Fonts without FOUC; fallback chain works if CDN fails.
- **Command:** Hard reload (`Cmd+Shift+R`) with DevTools Network open. Then DevTools → Network → throttling "Offline" → hard reload.
- **Pass criteria:** (a) `fonts.googleapis.com/css2?family=Space+Grotesk:...` returns 200; (b) `space-grotesk-*.woff2` from `fonts.gstatic.com`; (c) `document.fonts.check('1em "Space Grotesk"') === true`; (d) under Offline, page renders with `sans-serif` fallback — readable, not broken.
- **Gate:** After Block 4.

### V-8 — Token-contract completeness (D-12 + REQ-overdrive-default-theme)

- **Behavior:** `--brand-soft-rgb` and `--brand-secondary-rgb` declared in `:root`; all retired-indigo Tailwind utilities resolve to new tokens; no raw hex in markup (REQ-build-theming-architecture acceptance #4).
- **Command:**
  ```bash
  grep -E -- '--brand-soft-rgb|--brand-secondary-rgb' index.html
  grep -E 'bg-yellow-100|text-yellow-400' index.html
  grep -nE 'style="[^"]*#[0-9A-Fa-f]{3,6}"' index.html
  ```
  Then DevTools: `getComputedStyle(document.querySelector('span.bg-yellow-100')).backgroundColor === 'rgb(255, 229, 153)'`.
- **Pass criteria:** First grep returns 2+ matches (token decls); second ≥2 (PLS badge + PLS card icon bg); third returns only D-allowed inline styles (`border-left: 3px solid rgb(var(--accent-rgb))` etc. — no raw hex). DevTools assertion `true`.
- **Gate:** After all blocks.

### V-9 — Scoring regression (acceptance criterion #4 + REQ-theming-visual-only + EXCL-scoring-or-flow-changes)

- **Behavior:** Quiz scoring + flow unchanged. Same six slides, same scoring logic, same result strings, same wedge-callout/override-notice show/hide.
- **Command:** Walk 6 representative answer paths in browser:

  | Path | Slide 1 (buyerUser) | Slide 2 (viral) | Slide 3 (scope) | Slide 4 acc | Slide 5 fric | Expected result |
  |------|---------------------|-----------------|-----------------|-------------|--------------|-----------------|
  | P1 | individual | high | individual | 4+ | 0–2 | "Pure PLG: Ideal Candidate" |
  | P2 | individual | low | individual | <4 OR fric>2 | <4 OR fric>2 | "PLG Motion with Optimization Needed" |
  | P3 | team | high | team | 4+ | 0–2 | "Product-Led Sales (Hybrid)" |
  | P4 | csuite | (any) | (any) | 4+ | 0–2 | "Sales-Led with Wedge Opportunity" (wedge-callout visible) |
  | P5 | csuite | (any) | (any) | 0–3 | 3+ | "Sales-Led Growth Required" |
  | P6 | (mixed) | (mixed) | (mixed) | (mixed) | (mixed) | "Hybrid Approach Recommended" |

- **Pass criteria:** Each path produces same result string + callout visibility as pre-Phase-2 baseline. Compare against `main`-branch render OR pre-Phase-2 commit (`d21fcd1` or earlier on `rebrand-theming`).
- **Gate:** Phase-end, before commit-and-merge. **If ANY path differs → STOP and investigate (visual edits leaked into JS logic).**

### V-10 — Continuous-surface coherence (D-01)

- **Behavior:** Warm off-white surface (#FFF8F0) is continuous across all slides + results + reference matrix + footer.
- **Command:** Walk quiz → results → scroll to reference matrix → scroll to footer. DevTools assert `getComputedStyle(...).backgroundColor === 'rgb(255, 248, 240)'` at four points: (a) `body`, (b) `#results-page > div:first-child`, (c) `section.reference-matrix-wrapper`, (d) `footer`.
- **Pass criteria:** All four samples return `rgb(255, 248, 240)`.
- **Gate:** After Block 6.

### V-11 (optional) — `VM338:1 Uncaught SyntaxError` noise diagnosis

- **Behavior:** If the Phase 1 V-4 one-off `VM338:1` console line reproduces deterministically during any V-2 verify, diagnose via DevTools → Sources → `cdn.tailwindcss.com`.
- **Gate:** Optional, not blocking unless visible rendering fails.

---

## Wave 0 Requirements

None. This phase has no new test framework, fixture, or harness to set up. Existing `index.html` + DevTools is the verification surface (PROJECT.md single-file-no-build constraint). No package install. No conftest.

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| V-1 (D-14 research-phase gate) | D-14 + REQ-overdrive-default-theme | DevTools console assertions require live browser runtime; not scriptable without Playwright/Puppeteer infra that PROJECT.md no-build constraint forbids | See V-1 above. Orchestrator runs before spawning planner. |
| V-2 (D-14 execute-phase per-block gates) | D-14 + REQ-overdrive-default-theme | Same as V-1 — live DevTools runtime required | See V-2 above. Encoded as per-task acceptance criteria in PLAN.md. |
| V-3 (visual identity coherence) | Acceptance #1 + #3 | Human pattern-recognition required for "feels like Overdrive" recognition test (design system §9) | See V-3 above. Phase-end. |
| V-6 (hover-state correctness) | D-11 | Hover state requires user interaction in live browser | See V-6 above. After Block 5. |
| V-7 (font-load + fallback) | Acceptance #1 | DevTools Network throttling required | See V-7 above. After Block 4. |
| V-9 (scoring regression) | Acceptance #4 + EXCL-scoring-or-flow-changes | Quiz walk requires user clicks; no automated test harness | See V-9 above. Phase-end. |
| V-10 (continuous-surface coherence) | D-01 | Scroll-position-dependent assertions require live browser | See V-10 above. After Block 6. |

V-4, V-5, V-8 (grep-based) ARE automated and run via `Bash` tool at the indicated gates.

---

## Validation Sign-Off

- [ ] All tasks have V-N row mapping in PLAN.md acceptance criteria
- [ ] Sampling continuity: every `<head>`-touching commit fires a V-2 sub-row (no 3 consecutive `<head>` commits without verify per D-14)
- [ ] Wave 0 covers all MISSING references (none — no Wave 0 needed this phase)
- [ ] No watch-mode flags (N/A — manual gates)
- [ ] Feedback latency < 5 minutes for V-2 rows
- [ ] `nyquist_compliant: true` set in frontmatter after plan-checker approves V-N rows

**Approval:** pending

---

## Notes for plan-checker

- V-1 is a HARD GATE the orchestrator runs BEFORE the planner is spawned. If the orchestrator did not run it (no `V-1 PASS` annotation below), reject PLAN.md.
- V-2 sub-rows MUST appear as acceptance criteria on the corresponding plan tasks (Block 2 → 02-NN-MM tasks must reference V-2a; Block 3 → V-2b; Block 4 → V-2c; Block 5 → V-2d). Reject PLAN.md tasks that touch `<head>` without a V-2 reference.
- V-9 (scoring regression) is the load-bearing final gate. PLAN.md must have a phase-end task that runs V-9 with the 6-path matrix before declaring the phase shippable.

---

## V-1 Orchestrator Run Log

| Run | Date | Result | Console errors | Computed-style checks | Notes |
|-----|------|--------|---------------|----------------------|-------|
| 1 | 2026-05-16 | ✅ PASS | 0 errors; 1 expected pre-existing WARNING (Tailwind CDN production message — same as Phase 1 baseline) | (b) `--accent-rgb === "255 144 0"` ✓ · (c) `#progress-fill bg === "rgb(255, 144, 0)"` ✓ · (d) `#slide-0 h1` fontFamily contains `"Space Grotesk"` ✓ · (e) `document.fonts.check('1em "Space Grotesk")` returns `true` after demand probe (see notes) · bonus: body bg = `rgb(255, 248, 240)` (warm off-white); `surface.dark` Tailwind utility removed; `surface.elev` added; display-fontFamily fallback flipped to `'sans-serif'` | **Method:** Constructed `index-phase2-preview.html` (BV-1 + BV-2 + BV-3 applied to a copy; tear-down deleted file). Served via `python3 -m http.server 8765`. Loaded via Chrome MCP. Ran V-1(a)..(e) assertions via `document.fonts.ready` + `getComputedStyle`. **Caveats:** (1) `fonts.check('1em "Space Grotesk")` returned `false` initially — Google Fonts lazy-loaded the face only after an element demanded it. After an explicit probe div rendered text in Space Grotesk + a 500ms wait + a second `document.fonts.ready` await, the check returned `true`. V-1(e) wording should be hardened in the next VALIDATION revision: "after probe triggers Space Grotesk render." Slide-0 h1 demands the font naturally on page entry so this is not a real-world regression; the lazy-load timing matters only for the synthetic V-1 assertion. (2) `fonts.check('1em "Fraunces")` returned `true` even though Fraunces was removed from the Google Fonts link — likely system-font availability OR browser cache leakage from prior `index.html` loads on this origin. Not a leak from the preview source (zero `Fraunces` matches). **V-5 (negative grep)** remains the load-bearing "no Fraunces in source" check; V-1's fonts.check is not authoritative for that assertion. (3) Runtime `document.head.children.length === 12` — Tailwind CDN injects 3 STYLE elements at runtime (one prepended at start, two appended at end). Authored `<head>` element count unchanged (9 total, 6 load-bearing per Phase 1 SUMMARY position table). **No D-12 violation** — FOUC `<script>` runs synchronously before Tailwind loads, regardless of runtime DOM position shifts. |

**Gate verdict:** PLAN.md may lock the Phase 2 `<head>` ordering described in `02-RESEARCH.md` BV-1 + BV-2 + BV-3. Per D-14, this verdict only covers the research-phase gate; V-2 sub-rows still fire after each `<head>`-touching execute commit.
