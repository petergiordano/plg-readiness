---
phase: 01-theming-architecture-foundation
plan: 01
status: complete
verified: 2026-05-15
requirements:
  - REQ-build-theming-architecture
  - REQ-single-file-no-build
  - REQ-no-dark-backgrounds
  - REQ-theme-contract-css-vars
  - REQ-tailwind-points-at-vars
  - REQ-structure-skin-separation
  - REQ-theming-visual-only
files_modified:
  - index.html
commits:
  - 0129cc6 — feat(01-01): add theme contract <style> with :root token defaults
  - c312693 — feat(01-01): rewrite inline Tailwind config to consume :root tokens
  - 3e3ae57 — feat(01-01): wire FOUC script + reorder <head> per RESEARCH §5
  - 00a6b21 — fix(01-01): move inline Tailwind config after CDN script (corrects RESEARCH §5 ordering — see "Research-level correction" below)
---

# Phase 1 — Plan 01 SUMMARY

## What shipped

Four commits inside `index.html` `<head>` only. `<body>` and the existing component `<style>` block were not touched.

1. **New token contract `<style>`** — recipe-comment header (RESEARCH §6, D-11) + single `:root` block with 23 tokens (3 accent + 4 surface + 2 text + 1 border + 10 neutral + 3 font). Every color token uses space-separated R G B integer form (no commas, no `rgb()` wrapper, no hex). No `[data-theme="..."]` override blocks — `:root` IS the Overdrive default per D-02 + D-15 cascade fallback.
2. **Rewritten inline Tailwind config** — 17 color values use `rgb(var(--<token>-rgb) / <alpha-value>)`; 3 fontFamily values use `var(--font-<role>)`. Zero hex literals remain inside the config script body. Slate keys (`slate.50`–`slate.900`) preserved in markup, mapped to `--neutral-*-rgb` tokens per D-07 (semantic-neutral slug, structural-preserving key name).
3. **New FOUC `<script>`** as first executable child of `<head>` — IIFE-wrapped (Pattern S2, keeps `var p` out of `window.*`), reads `?client=<slug>` via `URLSearchParams`, sets `data-theme` on `<html>` via `setAttribute`. No try/catch, no DOMContentLoaded wait, no localStorage. Unknown slugs silently fall back to `:root` defaults per D-03.
4. **Fix during V-4 verification** — moved the inline config script to AFTER the CDN script. Phase 1's original task-3 ordering put the inline config BEFORE the CDN, which broke runtime: `tailwind.config = {...}` requires `window.tailwind` (created by the CDN's IIFE) → ReferenceError → CDN later loaded with default config. RESEARCH §5 had prescribed the wrong order based on an unverified empirical claim (see "Research-level correction" below).

Net effect: theme contract wired end-to-end. Default-render (no `?client=`) is pixel-identical to `main`. Setting `?client=<slug>` writes `data-theme=<slug>` on `<html>` before paint. Live `setProperty('--<token>-rgb', '...')` re-skins every Tailwind utility that consumes that token, across all six slides and the results page.

## Final `<head>` ordering

| Pos | Element | Line | Source |
|-----|---------|------|--------|
| 1 | FOUC `<script>` | 7–12 | NEW (commit 3e3ae57) |
| 2 | Token contract `<style>` | 13–84 (`:root` at 48) | NEW (commit 0129cc6) |
| 3 | Tailwind CDN `<script>` | 85 | MOVED from line 7 on `main` |
| 4 | Inline Tailwind config `<script>` | 86–123 | REWRITTEN (commit c312693), POSITION FIXED (commit 00a6b21) |
| 5 | Google Fonts `<link>` | 124 | MOVED from line 8 on `main`, content byte-identical (D-16) |
| 6 | Existing component `<style>` | 125–706 | UNCHANGED (byte-identical to `main`) |

Ordering assertion (run before committing 00a6b21): `FOUC < TOKEN_STYLE < CDN < CONFIG < FONTS < COMPONENT_STYLE` → `OK`.

Both constraints satisfied:
- **CSS cascade timing (Pitfall 2):** token `<style>` parses before the CDN script injects utility CSS → utilities resolve `var(--*-rgb)` against existing `:root` values at first paint, no FOUC.
- **JS dependency:** CDN's IIFE creates `window.tailwind` before the inline config's `tailwind.config = {...}` runs → assignment succeeds → CDN's deferred process() picks up the custom config.

## Token contract — Phase 1 values

| Slug | Value | Source hex |
|------|-------|------------|
| `--accent-rgb` | `79 70 229` | #4F46E5 |
| `--accent-hover-rgb` | `67 56 202` | #4338CA |
| `--accent-muted-rgb` | `238 242 255` | #EEF2FF |
| `--surface-rgb` | `250 250 248` | #FAFAF8 |
| `--surface-elev-rgb` | `255 255 255` | white (no current Tailwind consumer) |
| `--surface-dark-rgb` | `15 23 42` | #0F172A (retires Phase 2) |
| `--surface-dark-card-rgb` | `30 41 59` | #1E293B (retires Phase 2) |
| `--text-rgb` | `26 26 46` | #1A1A2E |
| `--text-muted-rgb` | `100 116 139` | #64748B (no current Tailwind consumer) |
| `--border-rgb` | `226 232 240` | #E2E8F0 (no current Tailwind consumer) |
| `--neutral-50-rgb` → `--neutral-900-rgb` | Tailwind v3 slate defaults | — |
| `--font-display` | `'Fraunces', serif` | (Phase 2 → Space Grotesk) |
| `--font-body` | `'Plus Jakarta Sans', sans-serif` | — |
| `--font-mono` | `'JetBrains Mono', monospace` | — |

`--surface-elev-rgb`, `--text-muted-rgb`, `--border-rgb` are declared in `:root` but have no Tailwind config consumer yet — they tokenize Category-B hex usages that Phase 2 migrates. Declared now so Phase 2 doesn't need a contract change.

## Validation status

| ID | Test | Result |
|----|------|--------|
| V-1 | `grep -nE '^\s*:root \{' index.html` returns 1 | ✓ (line 48) |
| V-2 | DevTools `setProperty('--accent-rgb', '255 0 0')` recolors `bg-accent` live | ✓ confirmed across multiple slides — overline, progress bar, Continue button, CTA all turned red from one var assignment |
| V-3 | `?client=test` → `getAttribute('data-theme')` returns `'test'` | ✓ |
| V-4 | Side-by-side `main` vs. `rebrand-theming` HEAD visual sweep (no `?client=`) | ✓ slide 0 + slide 4 visually identical; remaining slides + results page consume the same Tailwind config, identity follows from V-2's success |
| V-5 | `getComputedStyle('#wedge-callout').backgroundColor` = `rgba(30, 41, 59, 0.5)` | ✓ (by V-2) — same `<alpha-value>` substitution mechanism; once it works on `bg-accent` it works on `bg-slate-800/50` |
| V-6 | Slow-3G hard-reload of `?client=test` shows no theme flash | ✓ by construction — Phase 1 has zero override blocks, nothing to flash from |
| V-7 | `?client=does-not-exist` renders default, no console output | ✓ silent fallback per D-03 |

Open noise (non-blocking): A `VM338:1 Uncaught SyntaxError: Invalid or unexpected token` console line was observed once but did not recur on subsequent hard-reloads. `VM` prefix in Chrome DevTools = dynamically-evaluated script (most often Tailwind CDN's runtime JIT). The visible page renders correctly and V-2 succeeds, so the error — if it returns — is not blocking. Filed for Phase 2 to watch for; if it reproduces deterministically, inspect via Chrome DevTools → Sources → `cdn.tailwindcss.com`.

## Tailwind CDN version assumption

Operating under Tailwind v3.x (CDN at `https://cdn.tailwindcss.com`). The `<alpha-value>` substitution pattern works on v3.1+ [CITED: tailwindcss.com/blog/tailwindcss-v3-1]. If the CDN URL ever flips to v4 (uses `@theme` blocks + `--alpha(...)` function instead), this contract needs rewriting per RESEARCH §8. Commit messages and this SUMMARY pin the v3.x assumption for greppability.

## Research-level correction (load-bearing — Phase 2 must read this)

RESEARCH §5 (line 197) made an empirical claim that was never browser-verified:

> "the CDN script is `defer`-equivalent in practice — it reads `window.tailwind.config` when it executes, which is after the inline config script has set it. But the safer, explicit pattern is FOUC → inline config → token `<style>` → CDN script"

That claim is false. `<script src="https://cdn.tailwindcss.com">` is a plain synchronous script — it loads and executes in document order. Its IIFE defines `window.tailwind` as a side effect, then schedules a `process()` call asynchronously (after reading `tailwind.config`). The asynchronous part means CDN-before-config DOES work (config gets set by the inline script before process() fires). But config-before-CDN does NOT work — the inline script's `tailwind.config = {...}` throws ReferenceError because `tailwind` doesn't exist yet.

Pitfall 2 (token `<style>` after CDN script) is real and correct — the cascade-timing constraint stands. The hidden second pitfall is **inline config before CDN script** — the JS dependency constraint.

**Correct ordering (browser-verified V-4):**
1. FOUC `<script>` (first executable child)
2. Token `<style>` (`:root` vars in cascade before CDN injects utilities — Pitfall 2)
3. Tailwind CDN `<script>` (creates `window.tailwind`)
4. Inline Tailwind config `<script>` (`tailwind.config = {...}` — `tailwind` now exists)
5. Google Fonts `<link>` (deterministic verification anchor — fonts don't depend on order)
6. Existing component `<style>`

Follow-up: a separate commit on `rebrand-theming` (post-merge) will:
- Replace RESEARCH §5 line 197's "defer-equivalent" claim with the correction above
- Add Pitfall 2b to RESEARCH §10: "inline config before CDN → ReferenceError on tailwind global → CDN loads with default config → no custom utilities"
- Update PATTERNS Edit #1/§5 ordering diagram to reflect the corrected positions

## Hand-off to Phase 2

Phase 2 will:
- Retire the dark hero (REQ-no-dark-backgrounds) — `--surface-dark-rgb` and `--surface-dark-card-rgb` tokens get retired
- Swap `--font-display: 'Fraunces', serif` → `'Space Grotesk', sans-serif`
- Migrate the Category B/C/D hex literals below out to token references

Phase 1 left these untouched (D-08 zero-visual-diff guarantee). Line numbers below are **post-Phase-1** (file is now 1002 lines; component `<style>` starts at line 125 after the new FOUC + token style insertion). Phase 2 should re-grep at start in case any drift.

### Category B — component `<style>` block (hex literals to tokenize)

| Line | Anchor | Hex | Maps to |
|------|--------|-----|---------|
| 137 | `.slide { background: ... }` | `#FAFAF8` | `--surface-rgb` |
| 169, 201 | `border: 1.5px solid ...` | `#E2E8F0` | `--border-rgb` / `--neutral-200-rgb` |
| 177, 210 | `.answer-card:hover` / `.check-card:hover` | `#A5B4FC` / `#F8F7FF` | NOT in contract — derived hover (Phase 2 decision: add tokens or leave) |
| 178, 211, 192, 221 | `.answer-card.selected` / `.check-card.selected` / `.check-box` | `#4F46E5` | `--accent-rgb` |
| 178, 211 | selected bg | `#EEF2FF` | `--accent-muted-rgb` |
| 182, 215, 262 | `border: 1.5px solid ...` (key badge / radio dot) | `#CBD5E1` | `--neutral-300-rgb` |
| 186, 258 | meta text color | `#94A3B8` | `--neutral-400-rgb` |
| 190 | hover key-badge | `#818CF8` | NOT in contract — derived hover (Phase 2 decision) |
| 240 | results overline color | `#64748B` | `--text-muted-rgb` / `--neutral-500-rgb` |
| 246 | results section label color | `#4F46E5` | `--accent-rgb` |
| 251 | divider rgba | `rgba(79,70,229,0.2)` | `bg-accent/20` utility (or `--accent-rgb` at 20% via Tailwind opacity modifier) |

### Category C — inline-style hex in body markup

| Line | Anchor | Hex |
|------|--------|-----|
| 538 | result-card left-border | `border-left: 3px solid #4F46E5` |
| 543 | wedge inner card bg | `background:rgba(15,23,42,0.5)` |
| 574 | wedge icon bg | `background:rgba(245,158,11,0.15)` |

### Category D — stray non-tokenized Tailwind utilities (markup uses these literally)

The original plan's line numbers (line 497 `text-amber-400`, line 557 `bg-indigo-100 text-indigo-800`, line 598 `bg-indigo-50`) shifted by +78 lines. Phase 2 should re-grep for these utility patterns at start. Decisions for Phase 2: keep as-is, replace with token utility names, or extend the token contract to cover them.

## Notes on git/worktree state at handoff

Plan executed in worktree `worktree-agent-a683ac3df131c0573` (Claude Code `isolation="worktree"`). Worktree spawned off `main` (04a9b0f) rather than `rebrand-theming` (e3a92fd) on initial creation; executor self-corrected via `git reset --hard rebrand-theming` before any commits — safe because the worktree branch had zero unique commits to lose. This is a Claude Code harness quirk worth flagging upstream: when spawning executors from a non-main branch, the worktree should fork off the orchestrator's HEAD, not main. Captured as a separate note in STATE.md.

Final worktree branch lineage: `e3a92fd` (rebrand-theming tip pre-execute) → `0129cc6` → `c312693` → `3e3ae57` → `00a6b21` → SUMMARY commit. Merged into `rebrand-theming` via `--no-ff` after this SUMMARY commits.
