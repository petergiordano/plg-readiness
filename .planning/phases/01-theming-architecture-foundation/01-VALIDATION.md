---
phase: 1
slug: theming-architecture-foundation
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-05-15
---

# Phase 1 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.
> Validation surfaces extracted from `01-RESEARCH.md` § Validation Architecture (lines 802–836).

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Manual browser inspection + DevTools console (no formal test runner; project has no `package.json` or CI) |
| **Config file** | None |
| **Quick run command** | `python3 -m http.server 8080` then visit `http://localhost:8080` |
| **Full suite command** | (same — manual sweep) |
| **Estimated runtime** | ~5 min for full §7 visual sweep |

---

## Sampling Rate

- **After every task commit:** Run the task's row from the "Per-Task Verification Map" below
- **After every plan wave:** Run all rows in the map for the touched plan
- **Before `/gsd:verify-work`:** Full §7 visual sweep + all six map rows must pass
- **Max feedback latency:** ~5 seconds per devtools check; ~5 minutes for full visual sweep

---

## Per-Task Verification Map

| Test | Plan Hook | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Verification Command / Steps | File Exists | Status |
|------|-----------|------|-------------|------------|-----------------|-----------|------------------------------|-------------|--------|
| V-1 Single `:root` block at top of file | Token contract `<style>` task | 1 | REQ-build-theming-architecture (crit. 1) | — | N/A | manual-grep | `grep -nE '^\s*:root \{' index.html` returns exactly one line, in the new theme `<style>` near top of `<head>` (regex permits the 8-space indent used inside the `<style>` block) | ✅ shell | ⬜ pending |
| V-2 Tailwind resolves through vars | Tailwind config rewrite task | 1 | REQ-build-theming-architecture (crit. 2) | — | N/A | manual-browser | Open `index.html`, in DevTools console run `document.documentElement.style.setProperty('--accent-rgb', '255 0 0')`; verify any `bg-accent` element renders red without reload | ✅ DevTools | ⬜ pending |
| V-3 Switch mechanism wired (FOUC script) | Inline FOUC `<script>` task | 1 | REQ-build-theming-architecture (crit. 3) | — | N/A | manual-browser | Open `index.html?client=test`, DevTools console: `document.documentElement.getAttribute('data-theme')` returns `'test'` | ✅ DevTools | ⬜ pending |
| V-4 Zero visual regression (no override) | All Phase 1 tasks (gate) | final | REQ-build-theming-architecture (crit. 4) | — | N/A | manual-visual | Open `main` and `rebrand-theming` HEAD in adjacent tabs at `/`, walk §7 visual sweep checklist (six slides + results page + reference matrix) | ✅ checklist | ⬜ pending |
| V-5 Opacity modifier still works through vars | Tailwind config rewrite task | 1 | REQ-tailwind-points-at-vars (project-wide) | — | N/A | devtools | `getComputedStyle(document.querySelector('#wedge-callout')).backgroundColor` returns `rgba(30, 41, 59, 0.5)` (matches `bg-slate-800/50` on line 474) | ✅ DevTools | ⬜ pending |
| V-6 FOUC absence on theme switch | Inline FOUC `<script>` task | 1 | REQ-build-theming-architecture (crit. 3) + REQ-theme-contract-css-vars | — | N/A | manual-visual | Throttle network to "Slow 3G" in DevTools, hard-reload `index.html?client=test` — observe no Overdrive-default flash before resolution | ✅ DevTools | ⬜ pending |
| V-7 Unknown `?client=` falls back silently | Inline FOUC `<script>` task | 1 | D-03 (silent fallback) | — | N/A | manual-browser | Open `index.html?client=does-not-exist` — page renders Overdrive default identity, no console error, no banner | ✅ DevTools console clean | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

*Plan-task ID columns will be filled after the planner produces `01-01-PLAN.md`.*

---

## Wave 0 Requirements

None. The project has no test infrastructure and Phase 1 does not establish any (out of scope — REQ-single-file-no-build forbids adding a test framework that would require a build step). Manual checks via `python3 -m http.server` + browser DevTools cover the full validation surface for this phase.

If automated visual-regression coverage is wanted later, a separate future phase could add Playwright + GitHub Actions — explicitly not Phase 1 scope.

---

## Manual-Only Verifications

All seven rows above are manual. Justification per row:

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Token contract structure (V-1) | REQ-build-theming-architecture (crit. 1) | No build step → no static analysis tooling; grep is the cheapest correctness check | `grep -nE '^\s*:root \{' index.html` |
| Tailwind→var resolution (V-2) | REQ-build-theming-architecture (crit. 2) | Requires live browser to test CSS-var → Tailwind utility chain end-to-end | DevTools `setProperty` on `:root`, observe re-render |
| Switch mechanism (V-3) | REQ-build-theming-architecture (crit. 3) | Requires page load with URL param to exercise FOUC `<script>` | Visit `?client=test`, read attribute |
| Zero visual regression (V-4) | REQ-build-theming-architecture (crit. 4) | No screenshot baseline in this repo; visual diff is the load-bearing acceptance gate (D-08) | Side-by-side tab compare against `main` |
| Opacity modifier (V-5) | REQ-tailwind-points-at-vars | Validates the `<alpha-value>` substitution actually fires at runtime; only reliably testable in browser | `getComputedStyle` on live element |
| FOUC absence (V-6) | REQ-build-theming-architecture (crit. 3) + REQ-theme-contract-css-vars | Tests pre-paint script ordering; only observable on slow-network load | Throttled hard-reload + visual check |
| Silent fallback (V-7) | D-03 | Tests negative case (no banner, no console.warn — D-15); only observable in DevTools | `?client=does-not-exist` + console check |

---

## Validation Sign-Off

- [ ] All tasks have manual-browser or grep verify steps documented in the map above
- [ ] Sampling continuity: every task commit has at least one map row attached
- [ ] No Wave 0 install gaps (manual-only is the chosen approach for this phase)
- [ ] No watch-mode dependencies
- [ ] V-4 (zero visual regression) executed against `main` before phase verify
- [ ] `nyquist_compliant: true` set in frontmatter after planner fills plan-task IDs in the map

**Approval:** pending
