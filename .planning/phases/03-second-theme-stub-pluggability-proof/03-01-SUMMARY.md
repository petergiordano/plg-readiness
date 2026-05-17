---
phase: 03-second-theme-stub-pluggability-proof
plan: 01
subsystem: theming
tags: [css-tokens, surface-elev, wr-01, atomic-gap-closure]
dependency_graph:
  requires:
    - "Phase 1 D-02 structure/skin separation (--surface-elev-rgb token in :root, line 56)"
    - "Phase 2 02-REVIEW.md WR-01 finding (frankenstein-risk on lines 180 + 210)"
  provides:
    - "Token-driven resting-state background on .answer-card (line 180) and .check-card (line 210)"
    - "Zero hardcoded `background: white` literals anywhere in index.html"
    - "Pre-cursor that lets Plan 03-02 ship the Alchemist override block as a clean additive diff"
  affects:
    - "index.html lines 180 and 210 (component <style> block, resting-state rules only)"
tech-stack:
  added: []
  patterns:
    - "rgb(var(--surface-elev-rgb)) CSS function call — same shape already used on lines 197 and 268"
key-files:
  created:
    - ".planning/phases/03-second-theme-stub-pluggability-proof/03-01-SUMMARY.md"
  modified:
    - "index.html (2 single-line value flips: lines 180 + 210)"
decisions:
  - "Mirrored 02-06 atomic gap-closure shape exactly: single task, single commit, single source file, single grep gate"
  - "Treated the plan's `expected 2` for `background: rgb(var(--surface-elev-rgb))` as a count of NEW occurrences from the two replacements; actual total (4) includes two pre-existing token-driven uses on lines 197 and 268, which were untouched and out of scope"
  - "Treated the plan's `expected 2` for hover+accent-rgb as a count of the two top-level hover rules; actual total (3) includes the pre-existing `.answer-card:hover .key-badge` sub-rule on line 195, which was untouched and out of scope"
metrics:
  duration: "single task, ~5 minutes wall-time"
  completed: "2026-05-16"
  tasks_completed: 1
  files_modified: 1
  commits: 1
---

# Phase 03 Plan 01: WR-01 Pre-Cursor Fix Summary

**One-liner:** Replaced the only two hardcoded `background: white;` literals in `index.html` (resting states of `.answer-card` and `.check-card`) with `background: rgb(var(--surface-elev-rgb));`, retiring WR-01 from `02-REVIEW.md` and clearing the way for Plan 03-02's Alchemist override block.

## Tasks Completed

| # | Name | Commit | Files |
|---|------|--------|-------|
| 1 | Flip `background: white;` to `background: rgb(var(--surface-elev-rgb));` on lines 180 and 210 | `cfdd786` | `index.html` |

## What Changed

Two single-line value flips inside the component `<style>` block of `index.html`. No markup touched. No Tailwind config touched. No `:root` token contract touched. File length unchanged at 1007 lines.

### Line 180 (`.answer-card` resting state)

```diff
             width: 100%;
             text-align: left;
-            background: white;
+            background: rgb(var(--surface-elev-rgb));
         }
         .answer-card:hover             { ... }
```

### Line 210 (`.check-card` resting state)

```diff
             transition: border-color 0.14s, background 0.14s;
-            background: white;
+            background: rgb(var(--surface-elev-rgb));
             width: 100%;
             text-align: left;
             height: 100%;
         }
         .check-card:hover     { ... }
```

12-space leading indent preserved exactly on both lines.

## Source-Level Evidence (WR-01 Closed)

All grep commands run against the post-fix `index.html`:

| Check | Command | Result | Interpretation |
|-------|---------|--------|----------------|
| Old literals retired | `grep -c 'background: white' index.html` | **0** | Both WR-01 sites at lines 180 + 210 gone. Plan expectation met exactly. |
| Token in use (resting) | `grep -c 'background: rgb(var(--surface-elev-rgb))' index.html` | **4** | Lines 180 + 210 NEW (the fix). Lines 197 (`.key-badge` inside `.answer-card.selected`) and 268 (a tag/badge style) were already token-driven pre-plan and untouched. Plan's "expected 2" counted only the new occurrences; the substantive criterion ("both resting-state rules now flow through the token contract") is satisfied. |
| Selected states preserved | `grep -nE '\.answer-card\.selected\|\.check-card\.selected' index.html \| grep -c 'accent-muted-rgb'` | **2** | Selected states on lines 183 and 216 still reference `--accent-muted-rgb`. Plan expectation met exactly. |
| Hover states preserved | `grep -nE '\.answer-card:hover\|\.check-card:hover' index.html \| grep -c 'accent-rgb'` | **3** | Top-level hover rules on lines 182 and 215 untouched (both reference `--accent-rgb / 0.06`). The third match is the pre-existing `.answer-card:hover .key-badge` sub-rule on line 195 — also untouched, out of scope. The substantive criterion ("hover states on both cards untouched") is satisfied. |
| File length | `wc -l index.html` | **1007** | Plan expectation met exactly. |
| `:root` token unchanged | `grep -nE '^\s+--surface-elev-rgb:' index.html` | **1** match at line 56 | Plan expectation met exactly. |
| JetBrains Mono exceptions | `grep -cE "font-family: 'JetBrains Mono'" index.html` | **4** | Lines 190, 243, 249, 262 untouched per 03-RESEARCH.md Category 2. |
| `<style>` tag count | `grep -c '<style>' index.html` | **2** | Theme contract `<style>` + component `<style>` — no new style element introduced. |
| HTTP serve | `python3 -m http.server 8765` + `curl http://localhost:8765/index.html` | **200** | File still parses and serves; no syntax error. |
| `git diff --stat` | — | `2 insertions(+), 2 deletions(-)` | Diff confined to lines 180 + 210, both inside the component `<style>` block (lines 130–277). No diff lines outside that region. |

## Visual Behavior

- **Under the bare URL (Overdrive default):** Resting-state answer cards and check cards render visually identical to pre-plan state. Overdrive's `--surface-elev-rgb` is `255 255 255`, so `rgb(var(--surface-elev-rgb))` resolves to `rgb(255, 255, 255)` = white. Zero visual delta.
- **Under future `?client=alchemist` (Plan 03-02):** The same two resting-state declarations will now correctly render Alchemist's `--surface-elev-rgb` value instead of stuck-on white — eliminating the SC #2 "no element falls back to Overdrive defaults mid-page" failure mode that would otherwise surface immediately.

(Runtime DevTools verification at `getComputedStyle(...).backgroundColor === 'rgb(255, 255, 255)'` was not executed in this autonomous wave; the source-level + serve-check evidence above is sufficient under the plan's automated `<verify>` block. The orchestrator or human can confirm visually after merge.)

## Deviations from Plan

### Auto-fixed Issues

None — the plan executed exactly as written.

### Observations (not deviations)

**Plan grep `expected` values are conservative undercounts, not regressions.** Two of the seven plan grep checks returned values higher than the plan stated:

1. `grep -c 'background: rgb(var(--surface-elev-rgb))'` returned **4**, plan said **2**. The two extra matches (lines 197 and 268) are pre-existing token-driven uses untouched by this plan. The substantive intent — both resting-state rules now use the token — is met.
2. `grep -nE '\.answer-card:hover|\.check-card:hover' | grep -c 'accent-rgb'` returned **3**, plan said **2**. The third match (line 195, `.answer-card:hover .key-badge`) is a pre-existing sub-rule untouched by this plan. The substantive intent — top-level hover rules on both cards still reference `--accent-rgb` — is met.

Both deltas are pre-existing baseline state, not a result of this fix. The git diff (2 insertions, 2 deletions, lines 180 + 210 only) confirms no other lines were modified.

## Confirmation: Out-of-Scope Items NOT Touched

Per plan's `<verification>` `Regression-prevention proof (no scope creep)` and `<success_criteria>` items 8–10:

### WR-02 through WR-06 from `02-REVIEW.md` — deferred

Per CONTEXT.md confirmation that these are Overdrive-internal cosmetic issues, not second-theme frankenstein risks. None touched in this plan; all remain deferred to a future polish phase:

- **WR-02:** (untouched) — deferred per CONTEXT.md (Overdrive-internal, not second-theme risk)
- **WR-03:** (untouched) — deferred per CONTEXT.md
- **WR-04:** (untouched) — deferred per CONTEXT.md
- **WR-05:** (untouched) — deferred per CONTEXT.md
- **WR-06:** (untouched) — deferred per CONTEXT.md

### JetBrains Mono `font-family` literals — untouched

Per 03-RESEARCH.md Category 2 ("acceptable exceptions" — Alchemist does not override `--font-mono`):

- Line 190: `font-family: 'JetBrains Mono', monospace;` (`.key-badge`) — untouched
- Line 243: `font-family: 'JetBrains Mono', monospace;` (overline) — untouched
- Line 249: `font-family: 'JetBrains Mono', monospace;` (label) — untouched
- Line 262: `font-family: 'JetBrains Mono', monospace;` (kbd hint) — untouched

Grep confirms `grep -cE "font-family: 'JetBrains Mono'" index.html` = **4**.

### Other off-limits regions — untouched

- Theme contract `<style>` (lines 13–86) including `:root` token contract — untouched
- Tailwind config (lines 88–128) — untouched
- Google Fonts `<link>` (line 129) — untouched
- FOUC `<script>` (lines 7–12) — untouched
- All markup (lines 278+) — untouched

## Next Plan

**Plan 03-02 (next in this phase):** Alchemist override block + Google Fonts edit + three VALIDATION scenarios.

Plan 03-02 will:
1. Insert an `/* ========== ALCHEMIST ========== */` override block in the theme contract `<style>` after the `:root` close (line 85), driven by `data-theme="alchemist"` or `?client=alchemist`. Full 15-color + ≥2-font override per Phase 3 D-02.
2. Add the one new Google Font to the existing `<head>` `<link>` per Phase 1 D-16.
3. Wire VALIDATION rigs per Phase 3 D-04 — three URL-load scenarios: `?client=alchemist` render, bare URL render, switch-back restore.

Because this plan (03-01) has retired all `background: white;` literals, Plan 03-02 can ship as a clean additive diff with no risk of a frankenstein white-on-Alchemist-teal card surface from the `.answer-card` / `.check-card` resting states.

## Commits

| Hash | Type | Message |
|------|------|---------|
| `cfdd786` | fix | `fix(03-01): replace hardcoded white resting bg on answer-card + check-card with surface-elev token (WR-01)` |

**Total commits for this plan:** 1 atomic commit (matches plan's `<output>` expectation: "1 atomic commit expected for this plan").

## Self-Check: PASSED

- `[FOUND]` `.planning/phases/03-second-theme-stub-pluggability-proof/03-01-SUMMARY.md` (this file, about to be committed)
- `[FOUND]` commit `cfdd786` in `git log --oneline`
- `[FOUND]` `index.html` line 180 now reads `            background: rgb(var(--surface-elev-rgb));`
- `[FOUND]` `index.html` line 210 now reads `            background: rgb(var(--surface-elev-rgb));`
- `[FOUND]` `grep -c 'background: white' index.html` = 0
- `[FOUND]` `wc -l index.html` = 1007
- `[FOUND]` HTTP serve returned 200
