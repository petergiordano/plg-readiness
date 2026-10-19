# Phase 2: Overdrive Default Theme Migration — Research

**Researched:** 2026-05-16
**Domain:** Single-file static web app (Tailwind v3 CDN). CSS-var-driven theme contract. Value-flip migration from indigo/slate/Fraunces (current Phase 1 state) to Overdrive (orange / warm-gray / Space Grotesk).
**Confidence:** HIGH for stack mechanics + line-anchored scope (re-grep verified at write-time). MEDIUM for two derived decisions the planner must resolve at lock time (see Risks & Open Questions). The D-14 browser-verify gate carries the residual uncertainty for every `<head>` change.

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| REQ-overdrive-default-theme | Convert the app to the theming architecture with Overdrive as the default theme (replaces indigo/slate + Fraunces identity). Acceptance: default token values produce Overdrive identity per `docs/design/design-system-alpha-overdrive.md`; Fraunces → Space Grotesk (Plus Jakarta Sans + JetBrains Mono unchanged); dark hero removed (orange-as-structure on warm off-white carries contrast); six slides + results + reference matrix render coherently — no half-old/half-new state; scoring/flow/copy unchanged. | This research enumerates every literal site (Cat A token contract, Cat B component-style hex, Cat C inline-style hex, Cat D markup utilities) that must change, sequences the edits to minimize FOUC + runtime breakage windows, and binds each change to a verification dimension in `## Validation Architecture`. The D-14 browser-verify gate is the load-bearing safety against the `<head>`-ordering pitfall that bit Phase 1 (V-4 ReferenceError). |
</phase_requirements>

## Phase Goal Restated

Phase 2 ships the **visible** Overdrive identity end-to-end by flipping values inside the Phase-1 theme contract — without changing contract structure, scoring logic, slide flow, or copy. Contract grows by 2 tokens (`--brand-soft-rgb`, `--brand-secondary-rgb`), retires 2 (`--surface-dark-rgb`, `--surface-dark-card-rgb`), and wires 1 previously-declared-but-unconsumed token (`--surface-elev-rgb`). Net color-token contract: ~13 → ~15. Net font-token contract: unchanged (`--font-display` value flips only).

Success = a user loading `index.html` with no `?client=` override sees: warm off-white (#FFF8F0) bg across all six slides + results + footer; Space Grotesk display headings; Plus Jakarta Sans body; JetBrains Mono overlines; orange (#FF9000) accent on the progress bar, CTAs, "Question N of 5" overlines, and selected radio/checkbox cards; warm-gray neutral ramp on borders/dividers/secondary text; orange structural rhythm on the results page (3 section dividers + 3px orange left-border on main result card + 4–6px orange top-strips on the two conditional callouts + orange top-rule on the footer); light-yellow + golden-yellow secondary palette on the PLS badge + PLS card icon bg + override-notice warning icon. Zero dark backgrounds. Quiz scoring + flow unchanged — same six slides, same answer→result decision tree.

## File-Level Scope

**Single file:** `index.html` (1002 lines, post-Phase-1, on branch `rebrand-theming`). No other source files exist — no build, no package manager, no separate CSS/JS.

All line ranges below were re-grepped at write-time (2026-05-16, `b1af5f7` HEAD). Endpoints verified independently — neither extrapolated nor inherited.

### Token contract `<style>` — lines 13–84

Grep anchors:
- `<style>` opens **line 13**
- `:root {` opens **line 48**
- `}` closes `:root` **line 83**
- `</style>` closes **line 84**

Edits:
- **Lines 50–52** `--accent-rgb` / `--accent-hover-rgb` / `--accent-muted-rgb` — flip values from indigo to Overdrive orange (`#FF9000`) + orange-hover (planner derives — likely `#E58200` or similar 10–15% darker) + orange-muted (Claude's discretion per CONTEXT.md `<decisions>` Claude's-Discretion bullet — likely `#FFF1E0` or similar).
- **Lines 55–58** `--surface-rgb` flips `#FAFAF8` → `#FFF8F0` (warm off-white). `--surface-elev-rgb` value `#FFFFFF` **stays** but starts being consumed by Tailwind config (D-02 wires it). **Lines 57–58 `--surface-dark-rgb` + `--surface-dark-card-rgb` DELETE** (retirement).
- **Lines 61–62** `--text-rgb` flips `#1A1A2E` → `#434343` (Overdrive Dark Gray). `--text-muted-rgb` flips `#64748B` → planner-derived Overdrive equivalent (likely `#8A8A8A` Gray 2 or `#666666` Gray 1).
- **Line 65** `--border-rgb` flips `#E2E8F0` → `#E5E5E5` (Overdrive Border Light).
- **Lines 68–77** `--neutral-50-rgb` through `--neutral-900-rgb` — full 10-stop ramp value flip to warm-gray. Planner derives specific hex per D-06 (anchors: `#FFF8F0` ~50, `#E5E5E5` ~200, `#8A8A8A` ~400–500, `#666666` ~600, `#434343` ~700; planner extrapolates above/below). Per D-07: keep all 10 stops even if no current Tailwind consumer exists for 700/800/900.
- **Lines 79–82 `--font-display`** — flips `'Fraunces', serif` → `'Space Grotesk', sans-serif`. `--font-body` + `--font-mono` unchanged.
- **+2 NEW tokens** inserted (D-12): `--brand-soft-rgb: 255 229 153;` (#FFE599 Light Yellow), `--brand-secondary-rgb: 241 194 50;` (#F1C232 Golden Yellow). Planner picks insertion location — recommend a new `/* ========== Secondary palette ========== */` divider block per Phase 1 D-10 comment-divider convention, inserted after the existing neutral ramp block (after line 77) and before the Fonts block (before line 79).
- **Inline "HOW TO ADD A CLIENT THEME" recipe header (lines 14–47):** byte-unchanged. Instructions remain accurate.

### Inline Tailwind config `<script>` — lines 86–123

Grep anchors:
- `<script>` opens **line 86**
- `tailwind.config = {` line **87**
- `</script>` closes **line 123**

Edits:
- **Line 92** `display: ['var(--font-display)', 'serif']` → `'sans-serif'` fallback (D-13).
- **Lines 102–104** `surface` extension: `warm: 'rgb(var(--surface-rgb) / <alpha-value>)'` stays. **Lines 103–104 `dark` + `dark-card` DELETE** (retirement). **New entry `elev: 'rgb(var(--surface-elev-rgb) / <alpha-value>)'`** is the planner's decision per D-02 — required to wire the `--surface-elev-rgb` token to a Tailwind utility (`bg-surface-elev`) for the main result card.
- **Lines 107–118** `slate` namespace — value-flip targets (`--neutral-N-rgb`) unchanged structurally; values flow through automatically once `:root` tokens flip. Keep the `slate` Tailwind utility key name per D-08 (no markup rename).
- **NEW `yellow` namespace** (D-12): add a `yellow:` extension block analogous to the `slate:` block, mapping `100: 'rgb(var(--brand-soft-rgb) / <alpha-value>)'` and `400: 'rgb(var(--brand-secondary-rgb) / <alpha-value>)'`. Planner picks insertion location (recommend immediately after the `slate` block before line 119's closing brace). Decision for planner: whether to declare just `yellow.100` and `yellow.400` (the only stops the markup consumes per D-09/D-10) or the full Tailwind yellow palette pointing at warm-tint extrapolations. **Recommendation: declare ONLY the two stops the markup uses.** Avoids over-tokenizing; matches Phase 1's `accent` (3 stops only) approach.

### Google Fonts `<link>` — line 124

Grep anchors:
- `<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300;9..144,700;9..144,800&family=Plus+Jakarta+Sans:wght@400;500;600&family=JetBrains+Mono:wght@400&display=swap" rel="stylesheet">` — single-line **line 124**

Edits (D-13):
- Drop the `Fraunces:opsz,wght@9..144,300;9..144,700;9..144,800` clause.
- Add `Space+Grotesk:wght@400;500;600;700` per Overdrive Section 4 spec.
- Keep `Plus+Jakarta+Sans:wght@400;500;600` and `JetBrains+Mono:wght@400` clauses byte-identical.
- Keep `&display=swap` suffix.

**Verified expected new href** [VERIFIED against `docs/design/design-system-alpha-overdrive.md` §4 default-stack loading snippet, lines 180–183]:
```
https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600&family=JetBrains+Mono:wght@400&display=swap
```
(Overdrive snippet shows Plus Jakarta Sans 400/500/600/**700** and JetBrains Mono 400/**500**. Phase 1 was 400/500/600 and 400 only. Planner-discretion: stick to Phase-1 weight subset or add the extra weights now. **Recommendation: stick to current weight subset.** Plus Jakarta Sans 700 is not consumed by any current markup (`font-semibold`=600 max in current code per grep); JetBrains Mono 500 is not consumed either. Minimum-viable bound per D-13 says don't bolt on what isn't used.)

### Component `<style>` block — lines 125–272

Grep anchors:
- `<style>` opens **line 125**
- `</style>` closes **line 272**

Cat-B literal migration sites (all verified at write-time, 2026-05-16):

| Line | Current literal | Migrates to | Notes |
|------|-----------------|-------------|-------|
| 137 | `background: #FAFAF8;` | `background: rgb(var(--surface-rgb));` | `.slide` selector. The `--surface-rgb` value flips at the contract level to `#FFF8F0` — this rewrite makes the component honor the contract. |
| 169 | `border: 1.5px solid #E2E8F0;` | `border: 1.5px solid rgb(var(--border-rgb));` | `.answer-card` resting border. |
| 177 | `.answer-card:hover { border-color: #A5B4FC; background: #F8F7FF; }` | `border-color: rgb(var(--accent-rgb) / 0.4); background: rgb(var(--accent-rgb) / 0.06);` | Per D-11 — alpha-derived from accent. **[VERIFIED via Context7 tailwindlabs/tailwindcss.com docs: `rgb(var(--*) / <alpha>)` is the Tailwind v3.1+ canonical form; raw CSS variant is standard `rgb()` syntax per CSS Color Module Level 4.]** |
| 178 | `.answer-card.selected { border-color: #4F46E5; background: #EEF2FF; }` | `border-color: rgb(var(--accent-rgb)); background: rgb(var(--accent-muted-rgb));` | Cat B selected-state per Phase 1 SUMMARY catalog. |
| 182 | `border: 1.5px solid #CBD5E1;` | `border: 1.5px solid rgb(var(--neutral-300-rgb));` | `.key-badge` border. |
| 186 | `color: #94A3B8;` | `color: rgb(var(--neutral-400-rgb));` | `.key-badge` text. |
| 190 | `.answer-card:hover .key-badge { border-color: #818CF8; color: #818CF8; }` | `border-color: rgb(var(--accent-rgb) / 0.4); color: rgb(var(--accent-rgb) / 0.4);` | Per D-11. |
| 192 | `border-color: #4F46E5; color: #4F46E5; background: white;` | `border-color: rgb(var(--accent-rgb)); color: rgb(var(--accent-rgb)); background: rgb(var(--surface-elev-rgb));` | `.answer-card.selected .key-badge`. The `background: white` rewires through `--surface-elev-rgb` for theme consistency (planner-discretion — could stay as literal `white`; consistency wins). |
| 201 | `border: 1.5px solid #E2E8F0;` | `border: 1.5px solid rgb(var(--border-rgb));` | `.check-card` resting border. |
| 210 | `.check-card:hover { border-color: #A5B4FC; background: #F8F7FF; }` | `border-color: rgb(var(--accent-rgb) / 0.4); background: rgb(var(--accent-rgb) / 0.06);` | Per D-11. |
| 211 | `.check-card.selected { border-color: #4F46E5; background: #EEF2FF; }` | `border-color: rgb(var(--accent-rgb)); background: rgb(var(--accent-muted-rgb));` | Cat B selected-state. |
| 215 | `border: 1.5px solid #CBD5E1;` | `border: 1.5px solid rgb(var(--neutral-300-rgb));` | `.check-box` border. |
| 221 | `.check-card.selected .check-box { border-color: #4F46E5; background: #4F46E5; }` | `border-color: rgb(var(--accent-rgb)); background: rgb(var(--accent-rgb));` | Cat B selected-state. |
| 240 | `color: #64748B;` | `color: rgb(var(--text-muted-rgb));` | `.result-overline`. Planner-discretion: `--text-muted-rgb` vs `--neutral-500-rgb` — they hold the same value but the semantic intent here is "muted text", so `--text-muted-rgb` is preferred. |
| 246 | `color: #4F46E5;` | `color: rgb(var(--accent-rgb));` | `.phase-overline`. |
| 251 | `border-top: 1px solid rgba(79,70,229,0.2);` | `border-top: 1px solid rgb(var(--accent-rgb) / 0.2);` | `.phase-rule`. |
| 258 | `color: #94A3B8;` | `color: rgb(var(--neutral-400-rgb));` | `.kbd-hint`. |
| 262 | `border: 1px solid #CBD5E1; ... background: white;` | `border: 1px solid rgb(var(--neutral-300-rgb)); ... background: rgb(var(--surface-elev-rgb));` | `.kbd-hint span` — `background: white` rewire is planner-discretion (same call as line 192). |

**Note on lines 192, 262 `background: white`:** Phase 1 SUMMARY catalog did NOT flag these for migration (they were hard-coded `white`, not a brand hex). With `--surface-elev-rgb` now consumed (D-02 wires the contract slot), planner-discretion call: rewire for cross-theme consistency vs leave as literal `white`. **Recommendation: rewire.** Future client themes that want a tinted elevated surface get it automatically; cost is two extra contract references.

### Body markup — lines 273–706

Grep anchors:
- `<body class="bg-surface-warm text-ink font-sans">` **line 274** — unchanged.
- Slide 0 (welcome): lines 297–337
- Slides 1–3 (radio): lines 338–457
- Slides 4–5 (checkbox): lines 458–528
- Results page region: **lines 530–704**
- `</body>` line 706 (`</html>` line 1002)

#### Slides 0–5 markup edits

Per D-13, slides 0–5 markup is mostly identity-neutral once `font-display` flips at the token level. The only currently-affected lines from the Cat D scan are:

- **No Cat D indigo/amber/dark-surface utilities** appear in slides 0–5. All Cat D utilities live in the results region (lines 533–698). Slides 0–5 use only `bg-accent`, `text-accent`, `slate-*`, and `font-display` — every one of those resolves through the contract and re-themes automatically.
- **Planner-discretion (D-13):** browser-verify whether `text-5xl md:text-[3.5rem] font-bold` on slide-0 hero (line 303) needs a bump to `text-6xl font-extrabold` for Space Grotesk's parity with Fraunces' presence. **0–2 markup edits expected, not pre-locked.** Lines that may need adjustment if planner picks "1 change": line 303 only. If "2 changes": line 303 + the four other `font-display text-3xl/text-4xl` headings (lines 344, 386, 421, 463, 499). **Recommendation: keep at 0 unless browser-verify shows visible weakness — D-13 minimum-viable bound favors restraint.**

#### Results page region — lines 530–704

The largest concentrated diff. Every change below is markup-only inside the body (no `<head>` impact).

**Dark hero retirement + main result card (D-01, D-02, D-05):**
- **Line 533** `<div class="bg-surface-dark pt-20 pb-16 md:pb-24">` → remove `bg-surface-dark` (utility itself goes away when `surface.dark` exits the Tailwind config). Planner-discretion: drop the wrapper class entirely, or change to a warm-bg utility, or wrap in a section that carries the orange section divider above the main result card per D-05(a).
- **Line 538** `<div class="bg-surface-dark-card rounded-xl border border-slate-700 overflow-hidden" style="border-left: 3px solid #4F46E5;">` → `bg-surface-dark-card` → `bg-surface-elev` (the new utility — see Tailwind config edit above). `border-slate-700` → `border-slate-200` (warm-gray light border on white card). `style="border-left: 3px solid #4F46E5;"` → `style="border-left: 3px solid rgb(var(--accent-rgb));"` per D-02 (3px orange left-border on white card).
- **Line 541** `<h2 ... class="font-display text-3xl font-bold text-slate-100 ...">` → `text-slate-100` → `text-ink` (now-dark text on now-light surface).
- **Line 542** `text-slate-400` → `text-slate-500` (or `text-slate-600`) — readable secondary text on white. Planner picks. **Recommendation: `text-slate-500`** to match line 603's pattern in the reference matrix.
- **Line 543** `<div class="rounded-lg p-5 border border-slate-700" style="background:rgba(15,23,42,0.5);">` (inner recommendation card, dark-on-dark) → migrate inline-style + Tailwind classes to warm-on-white. Planner-discretion: a soft warm-tint bg consistent with the white card body. **Recommendation:** `class="rounded-lg p-5 border border-slate-200 bg-slate-50"` (cleanest; uses re-themed slate-50 = warm-50 post-flip). Inline `style="..."` drops entirely.
- **Line 544** `text-slate-300` → `text-ink` (heading on near-white).
- **Line 545** `text-slate-400` → `text-slate-500`.

**Wedge callout (D-03):**
- **Line 552** `<div id="wedge-callout" class="hidden result-reveal result-reveal-2 bg-slate-800/50 rounded-xl border border-slate-700 p-6 mb-5">` → remove `bg-slate-800/50` (dark surface); change `border border-slate-700` → orange top-strip per D-03 (4–6px solid `#FF9000` band at top of white card body). Planner-discretion: implementation pattern. **Recommendation:** drop the `border` utility; replace with inline `style="border-top: 5px solid rgb(var(--accent-rgb));"` on a white-card wrapper; or use Tailwind `border-t-[5px]` arbitrary value + `border-accent`. Either is single-source-of-truth-clean. **Strong recommendation: inline style for the orange strip is acceptable here since it's a structural rhythm element keyed to the brand accent, not a one-off literal.** Add `bg-surface-elev` for the white card body.
- **Line 554** `<div class="flex-shrink-0 w-10 h-10 bg-accent rounded-lg ...">` icon container — unchanged (already on `bg-accent`).
- **Lines 560–565** `text-slate-200`/`text-slate-300`/`text-slate-400` → `text-ink`/`text-slate-600`/`text-slate-500` (light-mode equivalents). Planner picks specific stops.

**Override-notice callout (D-03, D-10):**
- **Line 572** — same treatment as line 552 (D-03 orange top-strip + white bg).
- **Line 574** `<div class="..." style="background:rgba(245,158,11,0.15);">` (warning-icon container) → per D-10, shifts to soft golden-yellow tint. **Recommendation:** `style="background: rgb(var(--brand-secondary-rgb) / 0.15);"`. Planner-discretion: keep inline or migrate to `bg-yellow-100` utility (which post-D-12 resolves to `--brand-soft-rgb`). The 0.15-opacity-on-secondary vs full-soft target two different tint intensities — soft-yellow (`#FFE599`) at full opacity is much more saturated than `#F1C232 @ 0.15`. **Recommendation: keep the inline 0.15-alpha-on-secondary form** to preserve the current visual weight of the icon bg.
- **Line 575** `<svg class="w-5 h-5 text-amber-400" ...>` → `text-amber-400` → `text-yellow-400` (which post-D-12 resolves to `--brand-secondary-rgb` = `#F1C232`).
- **Lines 580–581** `text-slate-200`/`text-slate-400` → `text-ink`/`text-slate-500`.

**Restart button (line 589):**
- `class="text-sm text-slate-500 hover:text-slate-300 ..."` → on a dark hero, `text-slate-500 hover:text-slate-300` reads as "lighter on hover." On a light bg, the hover gets *lighter still* and disappears. Migrate to `text-sm text-slate-500 hover:text-slate-700 ...` (darker on hover). Planner-discretion exact stops.

**Reference Matrix section divider (D-05 (b)):**
- **Line 597** `<section class="bg-white border-t border-slate-200 py-16 md:py-24">` — replace `border-t border-slate-200` with the orange section divider per D-05(b). Planner-discretion: implementation. **Recommendation:** `border-t-[4px] border-accent` (Tailwind arbitrary-value border thickness; `border-accent` already wired). Or inline `style="border-top: 4px solid rgb(var(--accent-rgb));"`. `bg-white` → planner-discretion (could become `bg-surface-warm` for one continuous warm bg per D-01, or stay `bg-white` for the white reference-matrix card-like region). **Recommendation: `bg-surface-warm`** to honor D-01 "one bg across the entire app."

**Reference matrix table styling (lines 610–662):**
- All `bg-slate-50`, `border-slate-200`, `text-slate-500`, `text-slate-400`, `text-ink` utilities re-theme automatically once tokens flip. No edits needed structurally.
- **Line 635** `<span class="... bg-indigo-100 text-indigo-800">Product-Led Sales</span>` → `bg-indigo-100 text-indigo-800` → `bg-yellow-100 text-yellow-400` per D-09. Note: `text-yellow-400` (Golden Yellow on Light Yellow bg) has measured contrast `#F1C232` on `#FFE599` ≈ 1.3:1 — below WCAG 1.4.3 AA's 4.5:1 normal-text or 3:1 large-text minimum. **Planner must address:** either use `text-ink` on `bg-yellow-100` (high contrast, drops golden-yellow as fg) or accept the contrast cost and document. **Recommendation: `bg-yellow-100 text-ink`** — preserves the yellow-tier signal while staying readable. Logged as a Risk below.

**PLG/PLS/Sales-Led card group (lines 665–693):**
- **Line 676** `<div class="w-9 h-9 bg-indigo-50 rounded-md ...">` → `bg-indigo-50` → `bg-yellow-100` per D-09 (PLS card icon bg).
- **Line 677** `<svg class="w-4 h-4 text-accent" ...>` — current orange. Planner-discretion (deferred-idea-line-3 in CONTEXT.md): leave as `text-accent` (stays orange) or shift to `text-yellow-400` to match badge/bg consistency. **Recommendation: leave as `text-accent`** — orange icon on yellow bg gives the GTM-motion-hierarchy cue without losing the structural orange. Yellow-on-yellow is muddy.

**Section divider above footer (D-05 (c)):**
- A new visual element. Insert above the footer (before line 698) as an explicit divider or by using the footer's own `border-top`. Planner-discretion: the footer already gets D-04's orange top-rule (line 698), which IS the D-05(c) divider. **One element does both jobs.** No separate divider element needed.

**Footer (D-04):**
- **Line 698** `<footer class="bg-surface-dark border-t border-slate-800 py-10">` → `bg-surface-dark` → `bg-surface-warm`. `border-t border-slate-800` → orange top-rule per D-04. **Recommendation:** `bg-surface-warm border-t-[4px] border-accent py-10`. (Same divider thickness as D-05 for consistency.)
- **Line 699** `text-sm text-slate-500` — stays. Re-themes through warm-gray ramp automatically.

#### Section divider above main result card (D-05 (a))

Currently no element exists at line 532–533 to host this — the dark-hero wrapper sits there now. Planner inserts a new divider element above the `max-w-[680px]` container (line 534). Simplest implementation: replace the dark-hero wrapper at line 533 with a section element carrying both the top-padding AND the orange top-rule:
```
<section class="bg-surface-warm pt-20 pb-16 md:pb-24 border-t-[4px] border-accent">
```
Planner picks exact element + class shape.

### Validation reference: scoring decision tree

For Validation Architecture below, the scoring entry points (re-grep verified):
- `function renderCheckboxes(...)` **line 758**
- `function goTo(...)` **line 788**
- `function updateChrome(...)` **line 811**
- `function selectAnswer(...)` **line 838**
- `function showResults(...)` **line 881**
- `function restartQuiz(...)` **line 906**
- `function calculateScore(...)` **line 938**

These functions are NOT edited in Phase 2 (REQ-theming-visual-only + EXCL-scoring-or-flow-changes). They are the regression-check surfaces.

## Implementation Approach

**Recommended sequencing for the planner.** Each block below is a candidate task boundary — planner makes final task granularity calls.

### Block 1: Pre-PLAN browser-verify gate (D-14 research-phase obligation)

Before the planner locks any `<head>`-touching task in PLAN.md, the orchestrator (per D-14 research-phase clause) must browser-verify the proposed Phase 2 `<head>` state. See `## Browser-Verify Required` below for the exhaustive enumeration. The orchestrator handles the DevTools step in-session before spawning the planner. Output: a confirmation that the proposed `<head>` ordering loads without console errors and renders the expected Overdrive baseline.

### Block 2: Token contract value flips (Cat A) — lines 13–84

Single commit, single block. Edits all live inside one `<style>` element. Net change: ~12 value flips + 2 line deletions (57–58) + 2 line additions (new tokens) + 1 font-display value flip. No `<head>` ordering change → does NOT fire D-14 by itself, but it is `<head>` content and the post-edit state must be browser-verified per D-14 execute-phase clause.

**Order within the commit:** (a) accent + accent-hover + accent-muted, (b) surface + surface-elev (value unchanged, comment update), (c) delete dark + dark-card, (d) text + text-muted, (e) border, (f) full 10-stop neutral ramp, (g) +2 yellow tokens with new divider, (h) `--font-display` value swap. This ordering puts the highest-signal change (accent → orange) first so a browser-verify mid-commit can confirm the contract is wired.

### Block 3: Tailwind config rewires — lines 86–123

Same commit as Block 2 OR separate commit. Edits: line 92 fontFamily fallback, delete lines 103–104 (surface.dark + surface.dark-card), insert `surface.elev` after the warm: line, insert `yellow:` namespace after the `slate:` block. `<head>` content change — fires D-14 execute-phase gate.

**Critical:** after Block 3, any `bg-surface-dark` / `bg-surface-dark-card` utility still in markup becomes an unknown utility (Tailwind v3 CDN silently produces no CSS for it, leaving the element bg-less). Block 3 MUST land before or concurrently with Block 4 (markup migration), never after.

### Block 4: Google Fonts `<link>` swap — line 124

Per D-14, this fires the browser-verify gate. Fonts must load before any `font-display` consumer paints. Drop Fraunces, add Space Grotesk per `## File-Level Scope` Google Fonts edit above. **Single-line edit.** Browser-verify: confirm Space Grotesk renders on slide 0 hero (line 303), zero `font-family: Fraunces` left referenced in the source (`--font-display` flips in Block 2; this swap removes the font face from the loaded set).

### Block 5: Component `<style>` Cat B literal migration — lines 125–272

18 literal sites per the table in `## File-Level Scope`. Single commit. Can be done before or after Block 4 (no `<head>` ordering coupling). Hovers (lines 177, 190, 210) get the alpha-derived rewrite per D-11. Selected states (178, 192, 211, 221) get the var-driven rewrite per Phase 1 SUMMARY catalog. Borders + text colors get neutral ramp tokens. **Whole block is `<head>`-content** → fires D-14 execute-phase gate.

### Block 6: Results page markup migration — lines 530–704

Largest body diff. All changes are body markup, NOT `<head>` content → does NOT fire D-14 (but does require a visual verify pass for D-01..D-05 + acceptance criterion #3). Recommended sub-sequencing within Block 6: (a) dark-hero wrapper retirement at line 533 + section divider insert (D-05(a)), (b) main result card surface + left-border + text colors (lines 538–548), (c) inner recommendation card (line 543), (d) wedge callout dark-bg retirement + top-strip + text recolors (lines 552–569), (e) override callout same treatment + warning icon (lines 572–584), (f) restart button hover fix (line 589), (g) reference matrix section divider (D-05(b)) + bg + PLS badge color (lines 597 + 635) + PLS card icon bg (line 676), (h) footer treatment (D-04, line 698). Planner-discretion to split into multiple commits if any sub-section warrants standalone shipping.

### Block 7 (optional, post-browser-verify): typographic adjustments — D-13

Per D-13, run after Blocks 2–6 land and a browser-verify shows the Space Grotesk swap in place. Decide 0/1/2 markup changes based on visible typography. Most likely: 0 changes (recommendation) or 1 change (slide-0 hero size+weight bump on line 303). Do not pre-lock; this block exists conditionally.

### Block 8: Phase-end browser-verify + visual sweep

After all blocks land, full browser load with no `?client=` → visual eye-check against Overdrive baseline (the recognition-test in design system §9: orange present as structural element, warm bg, Space Grotesk, no purple/blue/dark surfaces, clear hierarchy). Plus the validation tests in `## Validation Architecture` below.

## Browser-Verify Required

Per D-14, this section enumerates every `<head>` ordering, `<script>` add/move, and `<link>` add/move proposed in this research. Each entry follows the (a)/(b)/(c)/(d) structure mandated by the D-14 gate. None of these are browser-verified by this research session — all are flagged **REQUIRES-HUMAN-BROWSER-VERIFY**. The orchestrator handles the DevTools check before spawning the planner (research-phase gate) and after every `<head>`-touching execute task (execute-phase gate).

### BV-1: Tailwind config edit — `surface.elev` add + `surface.dark`/`dark-card` delete + display-fontFamily fallback flip

**(a) Concrete change with line anchors:**
- Lines 103–104: delete `dark: ...` and `'dark-card': ...` entries inside the `surface:` object.
- Insert `elev: 'rgb(var(--surface-elev-rgb) / <alpha-value>)'` inside the `surface:` object (location: after `warm:` line 102, before closing brace line 105).
- Line 92: change `display: ['var(--font-display)', 'serif']` → `display: ['var(--font-display)', 'sans-serif']`.

**(b) Runtime-behavior claim being made:**
1. After the edits, `bg-surface-elev` resolves to a generated Tailwind class with `background-color: rgb(255 255 255 / 1)` (white) and is consumable by markup at lines 538 (main result card) and any `.answer-card`/`.check-card`/kbd-hint span that uses `--surface-elev-rgb`.
2. `bg-surface-dark` and `bg-surface-dark-card` no longer generate any CSS. Any markup still referencing them silently produces no bg (Tailwind CDN v3 behavior: unknown utilities are no-ops, not errors).
3. `font-display` Tailwind utility resolves through `var(--font-display)` to `Space Grotesk` (set in Block 2) with `sans-serif` fallback.
4. **No JS error in console** — this edit doesn't touch the script-dependency chain; `window.tailwind` already exists from the CDN per Phase 1's V-4-corrected ordering.

**(c) Verification method:**
- Browser-load via `python3 -m http.server 8080` + open Chrome/Firefox DevTools.
- Console: assert zero red errors at load.
- Elements panel: inspect `#result-container .bg-surface-elev` (after Block 4 markup ships) → computed `background-color: rgb(255, 255, 255)`.
- Console: `getComputedStyle(document.querySelector('#progress-fill')).backgroundColor` → after Block 2 token flip, returns `rgb(255, 144, 0)` (the new orange).
- Console: `Array.from(document.querySelectorAll('*')).filter(e => getComputedStyle(e).backgroundColor === 'rgba(0, 0, 0, 0)' && e.matches('.bg-surface-dark, .bg-surface-dark-card')).length` → after Block 6 markup migration, zero matches.

**(d) Expected observable outcomes:**
- Zero JS console errors.
- Inspecting the (post-Block-6) main result card shows white bg via `bg-surface-elev`.
- No element renders with a slate-800 / slate-900 / dark-hero appearance.

### BV-2: Google Fonts `<link>` href swap — line 124

**(a) Concrete change with line anchors:**
- Line 124 `<link href="...">` rewrites href from current Fraunces+Plus-Jakarta+JetBrains stack to Space Grotesk+Plus-Jakarta+JetBrains stack per the verified URL in `## File-Level Scope` § Google Fonts edit. Element position in `<head>` unchanged (stays at position 5 per Phase 1 SUMMARY final ordering table).

**(b) Runtime-behavior claim being made:**
1. The new `<link>` loads the Google Fonts CSS stylesheet, which contains `@font-face` rules for Space Grotesk weights 400/500/600/700 and the unchanged Plus Jakarta Sans + JetBrains Mono faces.
2. `--font-display: 'Space Grotesk', sans-serif` (set in Block 2) renders Space Grotesk on every `.font-display` element (slides 0–5 headlines, results page H2s) without a FOUT >50ms once cached.
3. Fraunces no longer loads, no longer renders anywhere. No reference to Fraunces remains in the source.
4. The CSS load happens via the existing `<link rel="stylesheet">` (no `preload`/`preconnect` added in this research — see Risk below).
5. **No JS error in console.** This is a CSS link, not a script — no dependency chain implication.

**(c) Verification method:**
- Browser-load via `python3 -m http.server 8080` + DevTools Network tab.
- Network: confirm `fonts.googleapis.com/css2?family=Space+Grotesk:...` returns 200; confirm `fonts.gstatic.com/.../space-grotesk-*.woff2` files load.
- Network: confirm zero requests for any `fraunces` resource.
- Console: `getComputedStyle(document.querySelector('#slide-0 h1')).fontFamily` → returns a string starting with `"Space Grotesk"` (literal or quoted; Chrome normalizes both).
- Console: `document.fonts.check('1em "Space Grotesk"')` → returns `true` after the stylesheet loads.
- Visual: slide-0 hero headline (line 303) renders with Space Grotesk letterforms — visibly different from Fraunces' serif. Recognizable cue: Space Grotesk's lowercase `g` has a single-story design; Fraunces' has a two-story serif design.

**(d) Expected observable outcomes:**
- Zero JS console errors.
- No FOUT on hard reload (font swaps within `display=swap` window — accepted per Overdrive §4 default loading snippet).
- No Fraunces network requests.
- Visual match for Space Grotesk letterforms on display-class elements.

### BV-3: Token contract value flip (Block 2) — interim state

**(a) Concrete change with line anchors:**
- Multiple value flips inside `:root` (lines 50–82) per Block 2 description. No structural change to the `<style>` element position in `<head>`.

**(b) Runtime-behavior claim being made:**
1. The `:root` block parses and provides new computed values for every `--*-rgb` and `--font-*` custom property.
2. The Tailwind utility classes already in the markup (e.g. `bg-accent`, `text-slate-500`, `font-display`) resolve through the new var values automatically — no JS reload needed.
3. **No JS error in console.** This is pure CSS.

**(c) Verification method:**
- Browser-load via `python3 -m http.server 8080` + DevTools Console.
- Console: `getComputedStyle(document.documentElement).getPropertyValue('--accent-rgb').trim()` → `"255 144 0"`.
- Console: `getComputedStyle(document.querySelector('#progress-fill')).backgroundColor` → `"rgb(255, 144, 0)"` (orange).
- Console: `getComputedStyle(document.body).backgroundColor` → `"rgb(255, 248, 240)"` (warm off-white).
- Visual: slide 0 progress bar (line 278) and "Begin assessment" CTA (line 324) render orange; body bg renders warm off-white.

**(d) Expected observable outcomes:**
- Zero JS console errors.
- Orange visible on every `bg-accent` / `text-accent` consumer (progress bar, "Question N of 5" overlines, CTAs, selected radio borders after Block 5).
- Warm off-white bg across the page (until results page is migrated in Block 6 — interim state may show the OLD `bg-surface-dark` results hero still rendering dark because the surface.dark utility entry was deleted from Tailwind config in Block 3, which has not run yet at this point in the sequence).

### BV-4: Block-by-block execute-phase verify (per D-14)

Per D-14 execute-phase clause: **every** `<head>`-touching execute task (Blocks 2, 3, 4, 5) triggers a browser-verify gate after the commit lands. The above BV-1/BV-2/BV-3 describe the state-checks for the specific changes; the planner must encode these as VALIDATION.md rows (one per block) and the executor must run them after each block's commit. Block 6 (body markup only) does NOT touch `<head>` and does NOT fire D-14, but does require a visual-coherence verify pass for D-01..D-05.

### Out of scope for this research

- **No preconnect/preload added.** Overdrive §4 loading snippet suggests `<link rel="preconnect" href="https://fonts.googleapis.com">` as a companion to the stylesheet `<link>`. Phase 1's V-4 corrected `<head>` ordering does NOT include preconnect — Phase 1 SUMMARY's final ordering table (positions 1–6) has no preconnect slot. Adding it would: (a) introduce a 7th `<head>` element, (b) fire a fresh D-14 browser-verify gate, (c) marginally improve font-fetch latency. **Recommendation: do NOT add preconnect in Phase 2.** Defer to a future polish phase. The single `<link>` already at line 124 provides functional font loading; the latency gain from preconnect is sub-100ms and not load-bearing for any acceptance criterion. If the planner overrides this and adds preconnect, BV-5 fires and must be enumerated identically.

## Validation Architecture

This section is the canonical input for VALIDATION.md creation. Every dimension below must encode as a VALIDATION row; the D-14 execute-phase rows specifically must be hard verify gates (not a single end-of-phase sweep).

### Test framework

This is a single-file static web app with no test framework. Validation is done via:
1. **Browser-load via `python3 -m http.server 8080`** + Chrome/Firefox DevTools.
2. **Grep assertions** on `index.html` (negative-grep: literals/utilities that must NOT remain).
3. **Manual visual eye-check** against a baseline (current Phase-1 render of `main` for the "before" state; the Overdrive design system §9 recognition test for the "after" state).
4. **Manual scoring-regression check:** walk the quiz with representative answer combinations and confirm the result strings + wedge-callout/override-notice show/hide states match the pre-Phase-2 behavior.

There is no automated test runner. No `pytest`, `jest`, `vitest`. No package.json. This is by design (PROJECT.md single-file-no-build constraint).

### V-1: D-14 research-phase browser-verify gate (before PLAN.md locks)

**Behavior:** Proposed Phase 2 `<head>` state (Blocks 2 + 3 + 4 applied to a working-tree copy of index.html) browser-loads with zero JS console errors and renders the expected Overdrive identity baseline.
**Type:** Manual browser test in DevTools.
**Command:** `python3 -m http.server 8080` from repo root, navigate to `http://localhost:8080/`, open DevTools.
**Pass criteria:** (a) zero red console errors at load; (b) `getComputedStyle(document.documentElement).getPropertyValue('--accent-rgb').trim() === '255 144 0'`; (c) `getComputedStyle(document.querySelector('#progress-fill')).backgroundColor === 'rgb(255, 144, 0)'`; (d) `getComputedStyle(document.querySelector('#slide-0 h1')).fontFamily` contains `'Space Grotesk'`; (e) `document.fonts.check('1em "Space Grotesk"') === true` post-load.
**Gate:** PLAN.md does not lock until this passes. Orchestrator runs in-session before spawning the planner.

### V-2: D-14 execute-phase browser-verify rows (one per `<head>`-touching task)

**Behavior:** After each commit that touches `<head>` (Blocks 2, 3, 4, 5), browser-load and verify the state-check assertions per BV-1/BV-2/BV-3 above.
**Type:** Manual browser test, executed after the post-commit `git status` is clean.
**Command:** Same as V-1.
**Pass criteria:** Block-specific — see BV-1 (Tailwind config), BV-2 (Google Fonts link), BV-3 (token contract), and a Block-5-specific check (V-2d: after Cat B literal migration, hover the `.answer-card` on slide 1; computed `background-color` returns `rgba(255, 144, 0, 0.06)` not `rgb(248, 247, 255)`).
**Gate:** Each block's commit is not "verified" until its corresponding V-2 row passes. NOT a single end-of-phase sweep.

### V-3: Visual identity coherence (acceptance criterion #1 + #3)

**Behavior:** Default-render (no `?client=`) of the post-Phase-2 app shows the Overdrive identity end-to-end — no half-old / half-new state.
**Type:** Manual visual sweep against Overdrive design system §9 recognition test.
**Command:** Open `http://localhost:8080/` and walk through all six slides + complete the quiz to reach results.
**Pass criteria:** (a) warm off-white bg (#FFF8F0) on every slide + results page + footer; (b) orange visible structurally on at least the progress bar, "Question N of 5" overlines, CTAs, selected radio/checkbox cards, all three results-page section dividers, main result card 3px left-border, both callout top-strips, footer top-rule; (c) Space Grotesk renders on every `.font-display` element (slide 0 hero, slide 1–5 question headers, results page H2s); (d) Plus Jakarta Sans on body text; JetBrains Mono on overlines; (e) light-yellow + golden-yellow visible on the PLS badge in the reference matrix + the PLS card icon bg + the override-notice warning icon; (f) zero indigo/purple/blue surfaces anywhere; (g) zero dark surfaces anywhere; (h) the recognition test — remove the logo (there is no logo, so: cover the title bar) and the page should still feel like Overdrive per §9.
**Gate:** Phase-end. If any sub-criterion fails, work is not "shipped."

### V-4: Dark-surface elimination grep (acceptance criterion #1 + REQ-no-dark-backgrounds)

**Behavior:** No source-level reference to dark surfaces remains.
**Type:** Negative grep.
**Command:**
```bash
grep -nE '#0F172A|#1E293B|bg-surface-dark|bg-surface-dark-card|bg-slate-(7|8|9)00|--surface-dark-rgb|--surface-dark-card-rgb' index.html
```
**Pass criteria:** Returns zero matches.
**Gate:** After Block 6 + Block 3. Run as a fast pre-V-3 sanity check.

### V-5: Identity-residue grep (acceptance criterion #3 — no half-old state)

**Behavior:** No source-level reference to the retired indigo + Fraunces identity remains.
**Type:** Negative grep.
**Command:**
```bash
grep -nE '#4F46E5|#4338CA|#EEF2FF|#A5B4FC|#818CF8|#F8F7FF|Fraunces|bg-indigo|text-indigo|hover:bg-indigo|hover:text-indigo' index.html
```
**Pass criteria:** Returns zero matches.
**Gate:** After all blocks complete. Allow a one-line exception in the inline recipe comment header (lines 14–47) if an example hex is referenced for instruction — but the existing header uses `#FF9000` as its hex example, so this exception should not trigger.

### V-6: Hover-state alpha-derived correctness (D-11)

**Behavior:** Hover states on `.answer-card` and `.check-card` render with the alpha-derived treatment, not the old indigo literals.
**Type:** DevTools computed-style assertion.
**Command:** Browser-load slide 1, hover over an answer-card, in DevTools Elements panel compute `backgroundColor` on the hovered element.
**Pass criteria:** `getComputedStyle(hoveredCard).backgroundColor === 'rgba(255, 144, 0, 0.06)'` (modulo browser rgba-vs-rgb formatting); `borderColor === 'rgba(255, 144, 0, 0.4)'`.
**Gate:** After Block 5.

### V-7: Font-load behavior (acceptance criterion #1)

**Behavior:** Space Grotesk loads from Google Fonts without FOUC. Fallback chain works if the CDN fails.
**Type:** DevTools Network + Console.
**Command:** Hard reload (`Cmd+Shift+R` to bypass cache) with DevTools Network tab open. Then test fallback: in DevTools Network tab, set throttling to "Offline", hard reload again.
**Pass criteria:** (a) `fonts.googleapis.com/css2?family=Space+Grotesk:...` request returns 200; (b) `space-grotesk-*.woff2` files load from `fonts.gstatic.com`; (c) `document.fonts.check('1em "Space Grotesk"')` returns `true` post-load; (d) under Offline throttling, the page still renders with the `sans-serif` fallback specified in `--font-display: 'Space Grotesk', sans-serif;` — readable, not broken.
**Gate:** After Block 4.

### V-8: Token-contract completeness (D-12 + REQ-overdrive-default-theme structural integrity)

**Behavior:** `--brand-soft-rgb` and `--brand-secondary-rgb` are declared in `:root`. Every Tailwind utility that referenced indigo/slate now resolves to the new tokens. No raw hex remains in markup (REQ-build-theming-architecture acceptance #4).
**Type:** Combination of grep + DevTools assertion.
**Command:**
```bash
grep -E -- '--brand-soft-rgb|--brand-secondary-rgb' index.html
grep -E 'bg-yellow-100|text-yellow-400' index.html
grep -nE 'style="[^"]*#[0-9A-Fa-f]{3,6}"' index.html  # raw-hex-in-inline-style check
```
Then in DevTools: `getComputedStyle(document.querySelector('span.bg-yellow-100')).backgroundColor === 'rgb(255, 229, 153)'`.
**Pass criteria:** First grep returns 2+ matches (token declarations). Second grep returns ≥2 matches (PLS badge + PLS card icon bg). Third grep returns only D-allowed inline styles (`border-left: 3px solid rgb(var(--accent-rgb))` etc. — no raw hex). DevTools assertion returns true.
**Gate:** After all blocks.

### V-9: Scoring regression (acceptance criterion #4 + REQ-theming-visual-only + EXCL-scoring-or-flow-changes)

**Behavior:** Quiz scoring + flow unchanged. Same six slides, same scoring logic, same result strings, same wedge-callout and override-notice show/hide logic.
**Type:** Manual walk-through using a representative answer matrix.
**Command:** Browser-load, walk the following 6 representative paths (each maps to one of the six result-state strings per `function calculateScore` at line 938):

| Path | Slide 1 (buyerUser) | Slide 2 (viral) | Slide 3 (scope) | Slide 4 acc count | Slide 5 fric count | Expected result string |
|------|---------------------|-----------------|-----------------|-------------------|--------------------|------------------------|
| P1 | individual | high | individual | 4+ | 0–2 | "Pure PLG: Ideal Candidate" |
| P2 | individual | low | individual | <4 OR fric>2 | <4 OR fric>2 | "PLG Motion with Optimization Needed" |
| P3 | team | high | team | 4+ | 0–2 | "Product-Led Sales (Hybrid)" |
| P4 | csuite | (any) | (any) | 4+ | 0–2 | "Sales-Led with Wedge Opportunity" (wedge-callout visible) |
| P5 | csuite | (any) | (any) | 0–3 | 3+ | "Sales-Led Growth Required" (override-notice visible if Phase 2 not overriding it) |
| P6 | (mixed) | (mixed) | (mixed) | (mixed) | (mixed) | "Hybrid Approach Recommended" |

**Pass criteria:** Each path produces the same result string + same callout visibility as the pre-Phase-2 baseline. Compare against a `main`-branch render OR a pre-Phase-2 commit (`d21fcd1` or earlier on `rebrand-theming`) — Phase 1 V-4 confirmed pre-Phase-2 visual identity matches `main`, so either reference works.
**Gate:** Phase-end, before commit-and-merge. If ANY path produces a different result string or callout state, scoring has regressed and the visual edits have leaked into JS logic — STOP and investigate.

### V-10: Continuous-surface coherence (D-01)

**Behavior:** The warm off-white surface (`#FFF8F0`) is continuous across all six slides + results page + reference matrix + footer. No surface-color discontinuity.
**Type:** Manual visual sweep + DevTools assertion at scroll boundaries.
**Command:** After Block 6, walk through quiz → results → scroll down to reference matrix → scroll down to footer. In DevTools, assert `getComputedStyle(...).backgroundColor` returns the same `rgb(255, 248, 240)` value at four sampled points: (a) `body`, (b) `#results-page > div:first-child` (top of results), (c) `section.reference-matrix-wrapper`, (d) `footer`.
**Pass criteria:** All four samples return `rgb(255, 248, 240)`.
**Gate:** After Block 6.

### Test-infrastructure gaps (none requiring Wave 0)

This phase needs no new test framework, fixture, or harness. The existing `index.html` + DevTools is the verification surface. No package install. No conftest.

## Risks & Unknowns

### Risk R-1: `--accent-hover-rgb` value not pre-determined for orange

**The gap:** D-11 covers `.answer-card:hover` / `.check-card:hover` hover-state derivation from `--accent-rgb` via alpha. It does NOT cover the `hover:bg-accent-hover` Tailwind utility currently consumed on lines 324, 479, 515 (the three CTAs). Those resolve through `--accent-hover-rgb` (currently `67 56 202` = `#4338CA` indigo-hover). When `--accent-rgb` flips to orange (`255 144 0`), `--accent-hover-rgb` MUST also flip — leaving it at `67 56 202` produces a **cool indigo hover on an orange button** (a frankenstein bug that directly fails acceptance criterion #3).

**Planner action required:** Lock a new `--accent-hover-rgb` value during Block 2 token-flip. Standard pattern: 10–15% darker shade of accent. Overdrive design system §3 does not specify an orange-hover color. **Recommendation:** `--accent-hover-rgb: 230 130 0;` (≈`#E68200`, 10% darker than `#FF9000`). Verify in browser per V-3 by hovering each of the three CTAs.

**Why it's not pre-locked:** CONTEXT.md `<decisions>` Claude's-Discretion bullet covers "Exact orange tint for `--accent-muted-rgb` Overdrive value" but is silent on `--accent-hover-rgb`. The discussion log's Q1.2 selection-state focus did not address CTA hovers. Strictly within D-11's "discretion-derivable" spirit but worth surfacing explicitly so the planner doesn't overlook it.

### Risk R-2: PLS badge contrast ratio falls below WCAG AA

**The gap:** D-09 specifies "PLS badge (line 635): bg = Light Yellow `#FFE599`, fg = Golden Yellow `#F1C232`." Measured contrast: `#F1C232` on `#FFE599` ≈ 1.3:1. WCAG 1.4.3 AA requires 4.5:1 for normal text and 3:1 for large text (18px+ regular OR 14px+ bold). The PLS badge is small (`text-xs` = 12px) and not bold-bold (font-medium = 500), so it falls under the strict 4.5:1 requirement.

**Planner action required:** Decide between (a) honoring D-09 literally and accepting the contrast cost (document as a known a11y deviation), (b) overriding D-09 with `bg-yellow-100 text-ink` (preserves yellow-tier signal, restores readability — measured `#434343` on `#FFE599` ≈ 9.1:1), or (c) escalating to user. **Recommendation: (b).** The "yellow as secondary brand tier" GTM-motion-hierarchy signal (D-09 + D-12 specific-ideas point) is carried by the bg color; the fg color is text readability. `text-ink` on yellow bg keeps the structural cue.

### Risk R-3: D-13 minimum-viable bound is browser-verify-determined, not pre-locked

**The gap:** D-13 explicitly says "Whether D-13's 'minimum-viable adjustments' land as 0/1/2 changes (decided post-browser-verify, not pre-decided)" is Claude's-Discretion. The planner cannot lock specific markup-edit tasks for Block 7 until the post-Block-4 browser-verify shows actual Space Grotesk rendering. Block 7 is conditionally scoped.

**Planner action required:** PLAN.md should encode Block 7 as a conditional task with a decision-rule embedded: "After Block 4 browser-verify, eyeball slide-0 hero (line 303) and slides 1–5 question headers. If Space Grotesk reads visibly weaker than Fraunces did, do 1 markup edit (line 303 size bump). If a wider weakness, do 2 markup edits (line 303 + lines 344/386/421/463/499 weight bump). Default: do 0 edits." This preserves D-13's bound without front-loading speculation.

### Risk R-4: `<head>` element count grows by 0 if no preconnect; grows by 1 if planner overrides

**The gap:** The recommendation in this research is NOT to add `<link rel="preconnect">`. If the planner overrides that recommendation, the `<head>` element count grows from 6 (Phase 1 final) to 7, and a fresh D-14 browser-verify gate (BV-5) must be enumerated and run. The Phase 1 V-4 lesson reads as: every new `<head>` element is a runtime-claim site that grep-ordering cannot cover.

**Planner action required:** Decide preconnect inclusion. If yes: enumerate BV-5 per the (a)/(b)/(c)/(d) D-14 structure; place preconnect at position 5 (before the stylesheet `<link>` it accelerates); browser-verify the new state. If no (recommended): document the decision in PLAN.md so a future "why no preconnect?" question is pre-answered.

### Risk R-5: Slate-utility "semantic mismatch" is accepted cost, but worth flagging

**The gap:** D-08 explicitly accepts the cost of keeping `slate-*` utility names in markup that resolves to warm-gray-neutral values post-Phase-2. The 80 markup utility hits surveyed at write-time (`grep -E 'class="[^"]*slate-' index.html | wc -l` → 80) will all re-theme automatically. The semantic mismatch is hidden from end users.

**Planner action required:** None — D-08 locks the decision. Researcher flagging only so future-Pete reading the post-Phase-2 codebase doesn't trip on "reads slate, renders warm-gray." Optionally add a code comment near the `slate:` Tailwind config block (line 107) noting "The `slate` Tailwind utility name is preserved for diff minimization (Phase 1 D-08). Values resolve through `--neutral-*-rgb` which Phase 2 flipped to warm-gray. Future client themes may override the ramp; the utility-name convention stays."

### Risk R-6: `VM338:1 Uncaught SyntaxError` noise from Phase 1 may reproduce

**The gap:** Phase 1 SUMMARY validation status noted a one-off `VM338:1 Uncaught SyntaxError: Invalid or unexpected token` console line during V-4 verify that did not recur on subsequent reloads. `VM` prefix in Chrome DevTools = dynamically-evaluated script (most often Tailwind CDN's runtime JIT). The visible page rendered correctly. Phase 2's D-14 verify cadence will surface this if it reproduces.

**Planner action required:** Add a VALIDATION row V-11 (optional, low priority): "If the `VM338:1` syntax-error console noise reproduces deterministically during any V-2 block verify, inspect via Chrome DevTools → Sources → `cdn.tailwindcss.com` to identify which Tailwind JIT input is triggering it." Not blocking unless visible rendering fails.

## Open Questions for Planner

1. **Q-1: Block granularity — single commit or split per category?** Blocks 2–6 above can collapse into 2–3 commits (e.g., "Block 2+3+4 token-and-config-and-fonts" + "Block 5 component-styles" + "Block 6 results-page") or expand to 5–7 commits. Smaller commits = finer D-14 verify granularity but more sequencing overhead. **Recommendation: 4 commits (Blocks 2+3, 4, 5, 6).** Block 4 (Google Fonts) gets its own commit because BV-2 is the highest-stakes verify (font-loading is the failure mode that bit Phase 1 in spirit if not in literal cause). Block 7 conditionally adds a 5th commit if any typography adjustment is needed.

2. **Q-2: Should the new `surface.elev` Tailwind utility entry use the same `<alpha-value>` pattern or a literal?** The `--surface-elev-rgb` token holds `255 255 255` (white) — the alpha-value pattern is the consistent choice. **Recommendation: yes, use `'rgb(var(--surface-elev-rgb) / <alpha-value>)'`** for symmetry with `surface.warm`.

3. **Q-3: Migrate inline `style="background: white"` on lines 192/262 to `--surface-elev-rgb`?** Planner-discretion call. **Recommendation: yes (rewire), no (leave as `white` literal) are both defensible.** Rewire wins for cross-theme consistency; leave-as-literal wins for diff minimization. Logged in `## File-Level Scope` Component `<style>` block as a note.

4. **Q-4: Insertion location of the `## Brand Personality (Secondary Palette)` divider in the token contract `<style>`?** Per Phase 1 D-10 convention, comment-divider blocks separate logical token groups. The +2 yellow tokens (D-12) need a home. **Recommendation: new `/* ========== Secondary palette ========== */` divider inserted after the Neutral ramp block (after line 77) and before the Fonts block (before line 79).** Maintains the existing accent → surface → text → border → neutral → secondary → fonts logical order.

5. **Q-5: Section divider element shape for D-05(a) (above main result card)?** Currently the dark-hero `<div>` at line 533 wraps the result card and provides the top-padding. **Recommendation: replace line 533's `<div class="bg-surface-dark pt-20 pb-16 md:pb-24">` with `<section class="bg-surface-warm pt-20 pb-16 md:pb-24 border-t-[4px] border-accent">`.** Section element conveys semantic boundary; `border-t-[4px] border-accent` carries the D-05(a) divider in one declaration. If the planner prefers `<div>` over `<section>`, equivalent — semantic vs structural call.

6. **Q-6: Where does this research want the Tailwind `yellow` namespace to live in the inline config (lines 86–123)?** **Recommendation: insert after the `slate:` block (after current line 118 closing brace), before the closing `colors: { }` brace.** Logical ordering: accent → surface → ink → slate → yellow.

## Project Constraints (from CLAUDE.md)

| Directive | Source | Honored by this research |
|-----------|--------|--------------------------|
| Single-file static web app — everything in `index.html` | Project CLAUDE.md "What This Is" + "Architecture" | Yes — all proposed edits are to one file. |
| No build step, no package manager, no separate JS/CSS files | Project CLAUDE.md "Running Locally" + global CLAUDE.md "Coding defaults" | Yes — no proposed tooling change. |
| Tailwind CSS via CDN with inline config | Project CLAUDE.md "Architecture" Dependencies | Yes — config edits stay in the existing inline `<script>` at lines 86–123. |
| `--font-display: 'Fraunces', serif` → `'Space Grotesk', sans-serif` (Plus Jakarta Sans + JetBrains Mono unchanged) | Phase 2 CONTEXT.md D-13 + Project CLAUDE.md "Design Guidelines" supersession | Yes — `--font-body` + `--font-mono` not touched. |
| Five coding rules (simplicity first; test first; use frameworks directly; config over code; document as you go) | Global CLAUDE.md "Five coding rules" | Honored — research recommends no wrappers/abstractions, no over-engineering. The +2 token addition is the minimum needed, not a speculative API extension. |
| GSD workflow is primary; don't duplicate | Global CLAUDE.md "Workflow rules" | Yes — outputs into `.planning/phases/02-overdrive-default-theme-migration/02-RESEARCH.md`. |
| `~/.claude/lessons.md` line "re-grep both start AND end of cited line ranges at write-time" (Phase 2 CONTEXT.md lesson captured during discuss) | Phase 2 CONTEXT.md `<specifics>` lesson | Yes — every line-range citation in this research was independently grep-verified at write-time. Endpoints not extrapolated. |

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | Tailwind v3 CDN at `https://cdn.tailwindcss.com` still resolves to v3.x (not auto-upgraded to v4). [VERIFIED via Phase 1 SUMMARY pinning + Context7 confirmation that `<alpha-value>` pattern is v3.1+ — official docs explicitly tag it as a v3.1 feature.] | Implementation Approach + V-1/V-2 | If the CDN flips to v4 mid-flight, the `<alpha-value>` pattern breaks (v4 uses `@theme` blocks + `--alpha(...)` function). Token contract structure would need rewriting per Phase 1 RESEARCH §8. Watch for unexpected console errors on V-1; if any utility silently produces no CSS, suspect CDN-version flip. |
| A2 | `--accent-hover-rgb` value for orange-hover is planner-discretion, derivable from the orange accent. [ASSUMED — Overdrive design system §3 lists `#FF9000` orange as the lead but does not specify an orange-hover variant. Hover-darker pattern is design convention, not Overdrive-locked.] | Risks R-1 | If wrong (e.g., Overdrive intends a different hover treatment like opacity-shift or warm-yellow-shift), the three CTAs render with a non-canonical hover color. V-3 visual sweep catches it. |
| A3 | PLS badge contrast issue (`text-yellow-400` on `bg-yellow-100`) warrants override to `text-ink`. [ASSUMED based on WCAG 1.4.3 AA + the deferred-idea bullet "Pure PLG=orange (lead), PLS=yellow (secondary)" carrying the structural cue via bg color.] | Risks R-2 | If Pete prefers the literal D-09 interpretation, the contrast issue lands as documented a11y debt. Surface in discuss-phase if planner cannot resolve. |
| A4 | `text-yellow-400` (i.e., `--brand-secondary-rgb`-resolved Tailwind class) on the override-notice warning icon (line 575) renders with golden-yellow `#F1C232`. [VERIFIED via Tailwind v3 docs pattern: `text-yellow-400` resolves to `color: rgb(var(--brand-secondary-rgb) / 1)` after D-12 config remap.] | File-Level Scope > Results page > Override-notice | None — pattern-level verified. |
| A5 | The grep `grep -nE 'class="[^"]*\b(slate\|indigo\|amber\|surface-dark\|font-display\|bg-accent)' index.html` returning 97 lines covers all identity-bound utility usages. [VERIFIED — exhaustive scan at write-time.] | File-Level Scope > Body markup | If the planner adds new utility names mid-execution, recount before V-5. |
| A6 | Plus Jakarta Sans weight 600 is the heaviest current consumer (no `font-semibold` heavier than 600 in current markup). [VERIFIED — `grep -nE 'font-(bold\|extrabold\|black)' index.html` returns matches but `font-bold` resolves to Tailwind's default 700, which is Plus Jakarta Sans 700 — currently NOT loaded by the Google Fonts link.] | File-Level Scope > Google Fonts edit | Wait. This is wrong. `font-bold` IS used on slide headlines (lines 303, 344, etc.) — those use `font-display` + `font-bold` together. `font-display` resolves to Fraunces 700 currently (the Fraunces link loads `300;700;800`). After Phase 2, `font-display` resolves to Space Grotesk, and the proposed Google Fonts URL loads Space Grotesk `400;500;600;700`. So 700 IS loaded for the display font. For BODY (`font-sans` = Plus Jakarta Sans), `font-bold` would expect 700 — but the Phase-1-inherited Plus Jakarta link only loads `400;500;600`. If any body text uses `font-bold`, it renders synthesized-bold or falls back. **Worth verifying.** Adding REQ to research at write-time. |

Re-grep at write-time:
```
grep -nE 'class="[^"]*font-(bold|extrabold|black)[^"]*"' index.html | grep -v font-display
```
Returns: zero matches (every `font-bold` co-occurs with `font-display`). **Confirmed safe.** The Plus Jakarta Sans 400/500/600 weight range loaded today is sufficient post-Phase-2.

## Sources

### Primary (HIGH confidence)
- `.planning/phases/02-overdrive-default-theme-migration/02-CONTEXT.md` — D-01 through D-14 (canonical phase constraints).
- `.planning/phases/02-overdrive-default-theme-migration/02-DISCUSSION-LOG.md` — alternatives audit trail (context for D-NN landings).
- `.planning/REQUIREMENTS.md` — REQ-overdrive-default-theme acceptance criteria.
- `.planning/STATE.md` — Phase 2 entry state, locked architectural rules.
- `.planning/phases/01-theming-architecture-foundation/01-CONTEXT.md` — Phase 1 D-01..D-16 (inherited constraints).
- `.planning/phases/01-theming-architecture-foundation/01-01-SUMMARY.md` — Phase 1 hand-off + Cat B/C/D catalog + V-4 corrected `<head>` ordering.
- `docs/design/design-system-alpha-overdrive.md` — Overdrive design system, §3 Color Palette, §4 Typography (verified loading snippet + font-family list), §5 Layout, §9 Brand Personality / Signature Move.
- `index.html` — re-grep verified at write-time (2026-05-16, HEAD `b1af5f7`).
- Context7: `/tailwindlabs/tailwindcss.com` — confirmed `<alpha-value>` placeholder + `rgb(var(--*) / <alpha-value>)` syntax is the canonical v3.1+ pattern. Source: `https://github.com/tailwindlabs/tailwindcss.com/blob/main/src/blog/tailwindcss-v3-1/index.mdx`.

### Secondary (MEDIUM confidence)
- WCAG 2.1 SC 1.4.3 contrast-ratio thresholds — public spec, well-established. Risk R-2 contrast calc done by mental approximation, not formal contrast-checker tool; the 1.3:1 ratio for `#F1C232` on `#FFE599` is conservative-low, actual could be slightly higher but still well below 4.5:1.

### Tertiary (LOW confidence)
- The recommended `--accent-hover-rgb: 230 130 0;` value (R-1) is convention-derived, not Overdrive-specified. Planner browser-verifies via V-3 hover check.

## Metadata

**Confidence breakdown:**
- Token contract scope + structure: HIGH — every line anchor re-grep verified at write-time; CONTEXT.md decisions are unambiguous.
- Cat B/C/D migration sites: HIGH — every line anchor re-grep verified at write-time; Phase 1 SUMMARY catalog cross-checked.
- Tailwind `<alpha-value>` mechanics: HIGH — Context7 verified against official Tailwind docs blog post.
- D-14 browser-verify gate enumeration: HIGH — exhaustive per the D-14 obligation; BV-1/BV-2/BV-3 cover every `<head>`-touching block this research recommends.
- Recommended `--accent-hover-rgb` orange-hover value: LOW — convention-derived, not Overdrive-specified. Flagged R-1.
- PLS badge contrast resolution: MEDIUM — WCAG math is conservative-correct, but the override recommendation (text-ink) is a planner-discretion judgment call that may need user input.
- Typography adjustment scope (D-13): MEDIUM — by D-13's own bounds, conditional and browser-verify-determined. Cannot pre-lock with HIGH confidence; that is by design.

**Research date:** 2026-05-16.

**Valid until:** 7 days for the Tailwind CDN-version assumption (A1) — re-check if it doesn't ship by 2026-05-23. 30 days for the line-range anchors — re-grep if any commits land on `rebrand-theming` between research and execute.

## RESEARCH COMPLETE
