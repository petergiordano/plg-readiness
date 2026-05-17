---
phase: 03-second-theme-stub-pluggability-proof
plan: 02
status: partial
partial_reason: "Tasks 1 + 2 (source edits) complete and committed. Plan paused at D-14 manual-browser-verify gate after Task 2. Tasks 3, 4, 5 (VALIDATION scenarios) deferred to orchestrator (Chrome MCP) and human user. Continuation agent will finalize this SUMMARY after gate + scenarios PASS."
subsystem: theming
tags:
  - theming
  - alchemist
  - second-theme-stub
  - pluggability-proof
  - css-vars
  - google-fonts
  - ibm-plex-serif
requires:
  - 03-01 (WR-01 single-file flip — both `.answer-card` and `.check-card` resting bg now flow through `--surface-elev-rgb` token; without this, Alchemist render would have stuck-on white)
  - Phase 2 (Overdrive defaults migration; the `:root` block this plan extends below)
  - Phase 1 (theme contract; FOUC `<script>`; Tailwind config resolving through `var(--<token>-rgb)`)
provides:
  - "[data-theme=\"alchemist\"]: Full 15-color + 2-font CSS override block gated by attribute selector; activated by URL `?client=alchemist` via Phase 1 FOUC `<script>`"
  - "Google Fonts <link> href: now loads IBM Plex Serif weights 400/600/700 in addition to Space Grotesk/Plus Jakarta Sans/JetBrains Mono — single combined <link> per Phase 1 D-16"
affects:
  - index.html theme contract `<style>` (lines 47–127 after edit; Alchemist block at lines 87–127)
  - index.html `<head>` Google Fonts `<link>` (now at line 168 after Task 1 shift; href value changed only)
tech-stack:
  added:
    - "IBM Plex Serif (Google Fonts; transitional serif; weights 400/600/700)"
  patterns:
    - "[data-theme=\"<slug>\"] attribute-selector override block — CSS cascade overrides `:root` defaults; one rule block per client"
    - "Combined Google Fonts <link> with `&family=` separator and single `&display=swap` at end (Phase 1 D-16)"
key-files:
  created: []
  modified:
    - "index.html (theme contract `<style>` insertion + Google Fonts `<link>` href edit)"
decisions:
  - "D-01 (CONTEXT): Slug is `alchemist`; all token values are deliberately placeholder/synthetic (no real Alchemist brand specs sourced, per EXCL-real-client-themes)."
  - "D-02 (CONTEXT): Full-contract scope — every color token slot AND both `--font-display` and `--font-body` explicitly declared; `--font-mono` intentionally NOT overridden (Alchemist inherits JetBrains Mono per 03-RESEARCH Research Area 3)."
  - "D-04 (CONTEXT): Validation scope is URL-load only; runtime `setAttribute('data-theme', X)` toggle explicitly NOT validated."
metrics:
  completed_tasks: 2
  remaining_tasks: 3
  source_edits_complete: true
  source_commits: 2
---

# Phase 3 Plan 02: Alchemist Second-Theme Stub & Pluggability Proof — PARTIAL Summary

**Source edits complete. Plan paused at D-14 manual-browser-verify gate after Task 2. Awaiting orchestrator's Chrome MCP gate execution + Tasks 3–5 VALIDATION scenarios.**

## One-Liner

Insert the `[data-theme="alchemist"]` override block (full 15-color + 2-font contract) into the theme `<style>`, and prepend IBM Plex Serif weights 400/600/700 to the existing combined Google Fonts `<link>` — proving the Phase 1 theming architecture supports per-client rebrand without touching markup, JS, Tailwind config, or the FOUC script.

## Tasks Completed (Source-Level)

| # | Task | Commit | Files | Lines Changed |
|---|------|--------|-------|---------------|
| 1 | Insert Alchemist override block in theme contract `<style>` between `:root` close and `</style>` | `ef1a773` | `index.html` | +39 (Alchemist block) |
| 2 | Edit Google Fonts `<link>` href to prepend IBM Plex Serif weights 400/600/700 | `c433066` | `index.html` | 1 line replaced (href value only) |

**Total source diff:** 39 inserts + 1 line replaced; all changes confined to (a) theme contract `<style>` block and (b) Google Fonts `<link>` href.

## Task 1 Detail: Alchemist Override Block

**Location:** `index.html` lines 87–127 (immediately after `:root` close at line 85; immediately before theme contract `</style>` at line 128 post-insert).

**Comment divider used (D-10):** `/* ========== ALCHEMIST ========== */`

**Indentation convention:** 8-space leading indent on comment divider + selector line; 12-space leading indent on declarations (matches `:root` block convention at lines 47–85).

**Tokens declared (full D-02 contract):**

| Token | RGB triplet | Hex | Role |
|---|---|---|---|
| `--accent-rgb` | `15 118 110` | `#0F766E` | Deep teal |
| `--accent-hover-rgb` | `13 99 93` | `#0D635D` | ~10% darker teal for hover |
| `--accent-muted-rgb` | `204 238 237` | `#CCEEED` | Soft-teal selected-card bg |
| `--surface-rgb` | `248 250 252` | `#F8FAFC` | Cool near-white canvas |
| `--surface-elev-rgb` | `255 255 255` | `#FFFFFF` | White elevated cards (same as Overdrive — declared per D-02 full-contract requirement, NOT relying on D-15 cascade) |
| `--text-rgb` | `30 41 59` | `#1E293B` | Deep slate |
| `--text-muted-rgb` | `100 116 139` | `#64748B` | Slate-500 muted |
| `--border-rgb` | `203 213 225` | `#CBD5E1` | Slate-300 borders |
| `--neutral-50-rgb` | `241 245 249` | `#F1F5F9` | **MUST differ from `--surface-rgb` for V-11 pass** (✓ confirmed at source level: `241 245 249` ≠ `248 250 252`) |
| `--neutral-100-rgb` | `226 232 240` | `#E2E8F0` | |
| `--neutral-200-rgb` | `203 213 225` | `#CBD5E1` | |
| `--neutral-300-rgb` | `148 163 184` | `#94A3B8` | |
| `--neutral-400-rgb` | `100 116 139` | `#64748B` | |
| `--neutral-500-rgb` | `71 85 105` | `#475569` | |
| `--neutral-600-rgb` | `51 65 85` | `#334155` | |
| `--neutral-700-rgb` | `30 41 59` | `#1E293B` | |
| `--neutral-800-rgb` | `15 23 42` | `#0F172A` | |
| `--neutral-900-rgb` | `7 15 30` | `#070F1E` | |
| `--brand-soft-rgb` | `219 234 254` | `#DBEAFE` | Soft indigo tint |
| `--brand-secondary-rgb` | `99 102 241` | `#6366F1` | Indigo |
| `--font-display` | `'IBM Plex Serif', serif` | — | Transitional serif |
| `--font-body` | `'IBM Plex Serif', serif` | — | Same serif for body (D-02 + 03-RESEARCH recommendation) |

**`--font-mono` intentionally NOT overridden** per 03-RESEARCH Research Area 3 — JetBrains Mono carries across all themes.

**Token ordering** follows the `:root` convention exactly: accent → surfaces → text → border → neutral ramp → secondary palette → fonts.

**Grep verification evidence (Task 1, all 11 checks PASS):**

| # | Check | Expected | Actual |
|---|-------|----------|--------|
| 1 | `grep -c 'data-theme="alchemist"'` | (selector landed) | **2** (1 comment example at line 26 + 1 selector at line 88; pre-existing comment was already 1) |
| 2 | `grep -c '/\* ========== ALCHEMIST ========== \*/'` | 1 | **1** |
| 3 | `grep -cE '^\s+--accent-rgb:\s+15 118 110'` | 1 | **1** |
| 4 | `grep -cE '^\s+--neutral-[0-9]+-rgb:'` | 20 | **20** |
| 5 | `grep -cE "^\s+--font-display:\s+'IBM Plex Serif'"` | 1 | **1** |
| 6 | `grep -cE "^\s+--font-body:\s+'IBM Plex Serif'"` | 1 | **1** |
| 7 | `grep -c '<style>'` | 2 | **2** |
| 8 | `grep -cE "^\s+--font-mono:"` | 1 | **1** |
| 9 | Token line ordering | accent < surface < neutral-50 | accent@90, surface@95, neutral-50@106 ✓ |
| 10 | Overdrive accent unchanged | 1 (255 144 0) | **1** |
| 11 | Overdrive --font-display unchanged | 1 (Space Grotesk) | **1** |

Plus: HTTP server returned `200`; FOUC script intact (1 match); Tailwind slate config intact (10 ramp lines).

**Note on grep #1 (deviation observation):** The plan's expected value of `1` for `grep -c 'data-theme="alchemist"' index.html` did not account for the pre-existing comment example at line 26 (`Example: [data-theme="alchemist"]`). Pre-Task-1 count was already 1 (comment only); post-Task-1 count is 2 (comment + selector). The substantive assertion — "the Alchemist selector block landed" — is satisfied. This is an authoring-time drift in the plan's acceptance criterion, not a behavioral issue.

## Task 2 Detail: Google Fonts `<link>` Edit

**Location:** `index.html` line 168 (shifted from line 129 by 39 lines after Task 1's insertion — re-grepped before editing per plan's read_first directive).

**Before (byte-identical):**
```
https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600&family=JetBrains+Mono:wght@400&display=swap
```

**After (byte-identical):**
```
https://fonts.googleapis.com/css2?family=IBM+Plex+Serif:wght@400;600;700&family=Space+Grotesk:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600&family=JetBrains+Mono:wght@400&display=swap
```

**Edit pattern:** Prepended `family=IBM+Plex+Serif:wght@400;600;700&` immediately after `?` and before `family=Space+Grotesk`. All three pre-existing `family=` clauses preserved byte-identical. Single `&display=swap` at end preserved. `rel="stylesheet"` attribute and `<head>` position preserved.

**Grep verification evidence (Task 2, all 9 checks PASS):**

| # | Check | Expected | Actual |
|---|-------|----------|--------|
| 1 | `grep -cE 'family=IBM\+Plex\+Serif:wght@400;600;700'` | 1 | **1** |
| 2 | `grep -cE 'family=Space\+Grotesk:wght@400;500;600;700'` | 1 | **1** |
| 3 | `grep -cE 'family=Plus\+Jakarta\+Sans:wght@400;500;600'` | 1 | **1** |
| 4 | `grep -cE 'family=JetBrains\+Mono:wght@400'` | 1 | **1** |
| 5 | `grep -cE 'display=swap'` | 1 | **1** (no duplicate per Pitfall 3) |
| 6 | `grep -c 'rel="stylesheet"'` | 1 | **1** (no preconnect added) |
| 7 | `grep -c '<link href="https://fonts\.googleapis\.com'` | 1 | **1** (single combined `<link>` per D-16) |
| 8 | `grep -c 'Fraunces'` | 0 | **0** (no Phase 0 font regression) |
| 9 | HTTP code | 200 | **200** |

**Diff verification:** Exactly 1 line modified, confined to the `<link>` href value. No surrounding `<head>` elements touched.

## D-14 Browser-Verify Gate (DEFERRED to orchestrator)

Task 2 is the first `<head>`-touching change in Phase 3. Per Phase 2 D-14 mandate, a runtime browser-verify gate must fire BEFORE the VALIDATION rigs in Tasks 3–5. This executor agent does not have Chrome MCP tools — the gate is deferred to the orchestrator.

**Gate steps (per Plan Task 2 `<gate>`):**

1. Start `python3 -m http.server 8080` from repo root.
2. Open Chrome incognito; load `http://localhost:8080/?client=alchemist`; open DevTools.
3. Run in console: `await document.fonts.ready` then `document.fonts.check('1em "IBM Plex Serif"')` — expect `true`.
4. Run: `document.fonts.check('1em "Space Grotesk"')` — expect `true`.
5. Run: `document.fonts.check('1em "Plus Jakarta Sans"')` — expect `true`.
6. Run: `document.fonts.check('1em "JetBrains Mono"')` — expect `true`.
7. Network tab: filter `fonts.googleapis.com`, reload — expect HTTP 200 on CSS2 request.
8. Console: expect zero red errors related to font loading (Tailwind CDN production-build warning is pre-existing and acceptable).

**Gate status:** ⏸ PENDING — orchestrator (Chrome MCP) executes after this agent returns.

## Tasks 3, 4, 5 — VALIDATION Scenarios (DEFERRED)

Three blocking `checkpoint:human-verify` tasks. Orchestrator (Chrome MCP) + human user execute. Continuation agent will finalize this SUMMARY after PASS signals.

- **Task 3 (Scenario a):** `?client=alchemist` renders full Alchemist identity across all six slides + results page + reference matrix. 13 DevTools assertions to verify token resolution, font loading, V-11 surface-differentiation guard under Alchemist values.
- **Task 4 (Scenario b):** Bare URL renders full Overdrive identity (Phase 2 zero-regression guard). 11 assertions verifying `data-theme === null`, accent `255 144 0`, V-11 guard PASSES under Overdrive values, IBM Plex Serif loaded but not applied.
- **Task 5 (Scenario c):** Switch-back restore — incognito → `?client=alchemist` → bare URL → Overdrive restored, no residual state, no FOUC. 6 assertions + FOUC eye-check.

## Scope-Boundary Confirmations (Source-Level)

- ✓ No markup edits — `grep -c 'data-theme' index.html` returns `5` (1 FOUC script + 3 pre-existing comment lines + 1 new CSS selector); zero inline `data-theme="..."` attributes on any DOM element.
- ✓ No JS changes — FOUC `<script>` at lines 7–12 byte-identical; no scoring/flow changes.
- ✓ No Tailwind config changes — Tailwind slate ramp (10 lines) intact; all utility-to-token mappings unchanged.
- ✓ No FOUC script changes — `grep -cE 'setAttribute.*data-theme' index.html` returns `1` (the original Phase 1 inline `<script>`).
- ✓ Single combined `<style>` for theme contract per Phase 1 D-10 — `grep -c '<style>' index.html` returns `2` (theme contract + component; no new `<style>` introduced).
- ✓ Single combined Google Fonts `<link>` per Phase 1 D-16 — exactly one `<link>` to `fonts.googleapis.com`; no separate `<link>` per theme; no `<link rel="preconnect">` added.
- ✓ RGB-triplet space-separated format per Phase 1 D-13 — every Alchemist color override uses `R G B` triplet format (no commas, no hex, no `rgb()` wrapper).
- ✓ Full D-02 contract — every color token slot AND both `--font-display` + `--font-body` explicitly declared (no D-15 cascade reliance); `--font-mono` intentionally NOT overridden.
- ✓ WR-01 fix from Plan 03-01 still in place — `grep -c 'background: white' index.html` returns `0`; `grep -c 'background: rgb(var(--surface-elev-rgb))' index.html` returns `2`.

## Deviations from Plan

**1. [Observation — not Rule-1/2/3 fix] `data-theme="alchemist"` grep count off-by-one in plan's acceptance criterion**

- **Found during:** Task 1 pre-verification grep
- **Issue:** Plan's acceptance criterion states `grep -c 'data-theme="alchemist"' index.html` should return exactly `1` post-Task-1. However, the pre-existing comment at line 26 (`Example: [data-theme="alchemist"]`) already contained the string before Task 1 (pre-state count = 1). Post-Task-1 count is 2 (comment + selector).
- **Resolution:** No source change needed. Substantive assertion ("Alchemist selector block landed") is satisfied. Documenting as authoring-time drift in plan, not as a code defect. The other 10 verification checks for Task 1 (more specific patterns) all return their expected values exactly.
- **Files modified:** None
- **Commit:** N/A (observation only)

## Self-Check: PASSED (Source-Level for Tasks 1 + 2)

**Commits exist:**
- `ef1a773` — Task 1: Alchemist override block ✓
- `c433066` — Task 2: Google Fonts `<link>` href ✓

```bash
git log --oneline -3
# c433066 feat(03-02): add IBM Plex Serif weights 400/600/700 to Google Fonts <link> for Alchemist theme (D-16 single-link pattern)
# ef1a773 feat(03-02): add Alchemist override block to theme contract (full 15-color + 2-font override; D-02 contract exercise)
# 8cf2345 docs(phase-03): update tracking after wave 1 — plan 03-01 complete
```

**Files exist:**
- `index.html` (modified, see git log above)

**Outstanding (deferred to orchestrator + continuation agent):**
- D-14 browser-verify gate execution (Chrome MCP)
- Tasks 3, 4, 5 VALIDATION scenarios (Chrome MCP + human approval signals)
- Final SUMMARY.md with runtime evidence (continuation agent overwrites this partial)

## Next Step

Orchestrator picks up D-14 gate via Chrome MCP, then runs Tasks 3, 4, 5 VALIDATION scenarios. Continuation agent finalizes this SUMMARY with full runtime evidence + replaces "status: partial" with "status: complete".

Pointer to phase-level verification (post-finalization): `/gsd-verify-work 3`.
