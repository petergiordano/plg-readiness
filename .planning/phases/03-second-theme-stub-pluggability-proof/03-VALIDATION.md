---
phase: 3
slug: second-theme-stub-pluggability-proof
status: draft
nyquist_compliant: false
wave_0_complete: true
created: 2026-05-16
---

# Phase 3 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution. Derived from `03-RESEARCH.md` § Validation Architecture.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | None — manual browser-load + DevTools (PROJECT.md `REQ-single-file-no-build` constraint) |
| **Config file** | None |
| **Quick run command** | `grep -nE 'background: white' index.html` (WR-01 residue check) + `grep -nE 'data-theme="alchemist"' index.html` (override block presence) |
| **Full suite command** | `python3 -m http.server 8080` then run three URL-load scenarios in Chrome via DevTools (or Chrome MCP automation mirroring Phase 2 V-11) |
| **Estimated runtime** | ~5–8 minutes for full three-scenario sweep |

---

## Sampling Rate

- **After Plan 03-01 commit (WR-01 fix):** `grep -c 'background: white' index.html` → 0 (both sites at lines 180 + 210 fixed)
- **After Plan 03-02 Task 1 (Alchemist block inserted):** `grep -c 'data-theme="alchemist"' index.html` → 1; `grep` confirms all 15 color tokens + 2 font tokens present
- **After Plan 03-02 Task 2 (Google Fonts `<link>` edit):** D-14 browser-verify gate — Space Grotesk + IBM Plex Serif both load (DevTools Network tab `font.css2` request includes both families; computed `font-family` on a representative heading under each theme resolves correctly)
- **After Plan 03-02 Tasks 3–5 (VALIDATION rigs):** Three scenario assertions all pass; V-11 surface-differentiation guard passes under Alchemist; Phase 2 Overdrive render unchanged
- **Before `/gsd-verify-work`:** All three URL-load scenarios + V-11 guard PASS in a clean Chrome session
- **Max feedback latency:** ~30 seconds per scenario (browser load + computed-style read)

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 03-01-01 | 01 | 1 | REQ-stub-second-theme (SC #2 pre-cursor) | — | N/A | source grep | `grep -nE '^\s*background: white' index.html` → 0 results | ✅ | ⬜ pending |
| 03-02-01 | 02 | 2 | REQ-stub-second-theme (SC #1, SC #4) | — | N/A | source grep + manual review | `grep -c 'data-theme="alchemist"' index.html` → 1; diff confirms only `<style>` insertions | ✅ | ⬜ pending |
| 03-02-02 | 02 | 2 | REQ-stub-second-theme (SC #1) | — | N/A | source grep + runtime | `grep -nE 'IBM\+?Plex\+?Serif' index.html` → 1; DevTools Network confirms 200 OK on the IBM Plex Serif `font.css2` fetch | ✅ | ⬜ pending |
| 03-02-03 | 02 | 2 | REQ-stub-second-theme (SC #2 — Alchemist render) | — | N/A | DevTools runtime | Scenario (a) — `?client=alchemist`: `getComputedStyle` returns Alchemist accent + surface + IBM Plex Serif on representative selectors across all six slides + results + reference matrix | ✅ | ⬜ pending |
| 03-02-04 | 02 | 2 | REQ-stub-second-theme (SC #2, Phase 2 regression) | — | N/A | DevTools runtime | Scenario (b) — bare URL: `getComputedStyle` returns Overdrive accent + warm surface + Space Grotesk on the same selectors; V-11 card !== parent | ✅ | ⬜ pending |
| 03-02-05 | 02 | 2 | REQ-stub-second-theme (SC #3 — switch-back restore) | — | N/A | DevTools runtime | Scenario (c) — incognito → `?client=alchemist` → bare URL: Overdrive identity restored, no FOUC on navigate-back, no stale `data-theme` value, computed font on heading is Space Grotesk (not IBM Plex Serif from cache) | ✅ | ⬜ pending |
| 03-02-06 | 02 | 2 | REQ-stub-second-theme (V-11 carry-over) | — | N/A | DevTools runtime | Under `?client=alchemist`: `bg-slate-50` card computed bg !== parent computed bg (Alchemist `--neutral-50-rgb` strictly differs from `--surface-rgb`) | ✅ | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [x] No test files to create — single-file static web app constraint (`REQ-single-file-no-build`)
- [x] No framework install — existing browser DevTools is the verification surface
- [x] VALIDATION scenario assertions written inline in Plan 03-02 task bodies (DevTools console snippets), not as separate files

*All Wave 0 dependencies satisfied by existing infrastructure (browser + Chrome DevTools / Chrome MCP).*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Alchemist render is "brand-plausible" (looks intentional, not demo-cartoony) | REQ-stub-second-theme (D-01 placeholder-quality bar) | Subjective design judgment outside automation reach | Load `?client=alchemist`, eyeball all six slides + results + reference matrix; pass if no surface looks broken, mid-redesign, or accidentally-styled |
| Switch-back has no perceptible FOUC | REQ-stub-second-theme (SC #3) | Visual flash is browser-perceptible but hard to assert via computed-style | Throttle network to "Fast 3G" in DevTools, navigate `?client=alchemist` → bare URL; pass if no flash of Alchemist serif before Overdrive sans renders |
| No visual regression on Overdrive under bare URL | Phase 2 regression guard | Eye-check covers cases computed-style assertions miss (spacing, hover states, transitions) | Load bare URL after Alchemist work merges; compare side-by-side to a screenshot of pre-Phase-3 main; pass if visually identical |

---

## Validation Sign-Off

- [x] All tasks have automated verify or grouped DevTools assertions
- [x] Sampling continuity: every Plan 03-02 task has at least one assertion
- [x] Wave 0 covers all MISSING references (none — no test framework needed)
- [x] No watch-mode flags (browser is the runtime)
- [x] Feedback latency < 60s per scenario
- [ ] `nyquist_compliant: true` — set when planner has authored Plan 03-02 task list and confirmed every task maps to a row above

**Approval:** pending
