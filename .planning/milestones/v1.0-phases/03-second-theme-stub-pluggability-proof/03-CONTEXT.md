# Phase 3: Second Theme Stub & Pluggability Proof - Context

**Gathered:** 2026-05-16
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 3 creates the first `[data-theme="..."]` override block in `index.html` — proving the theming contract built in Phase 1 (single `:root` block + Tailwind utilities resolving through CSS vars + `?client=` URL switch + FOUC `<script>`) and migrated to Overdrive defaults in Phase 2 actually supports per-client rebrand without touching markup.

At the end of Phase 3, with `?client=alchemist` in the URL the app renders a visibly distinct, internally coherent Alchemist identity across all six slides + results page + reference matrix; with no `?client=` param the app renders Overdrive exactly as it does today; switching between the two via URL navigation cleanly restores either identity with no residual state. The proof is the milestone-closing capability.

In scope: one D-02-contract-violation fix that surfaces under any non-Overdrive theme (`.answer-card` + `.check-card` resting `background: white` at index.html:180, 210 — pre-cursor Plan 03-01); one new `[data-theme="alchemist"]` override block placed inside the existing theme contract `<style>` per Phase 1 D-10 layout convention; placeholder Alchemist token values covering the full color contract (accent + accent-hover + accent-muted + surface + surface-elev + text + text-muted + border + neutral-50..900 + brand-soft + brand-secondary) plus full font swap (display + body); addition of one new Google Font to the existing `<head>` `<link>` per Phase 1 D-16; VALIDATION rigs covering the three URL-load scenarios (Alchemist render, Overdrive render, switch-back restore).

Out of scope: real Alchemist brand specs (deferred per EXCL-real-client-themes — placeholder values are the milestone's chosen abstraction); markup rename `slate-*` → `neutral-*` utility names (deferred per Phase 2 D-08); runtime `document.documentElement.setAttribute('data-theme', X)` toggle validation (not validated per D-04; CSS-var cascade handles re-paint mechanically); WR-02..06 from 02-REVIEW.md (Overdrive-internal contrast/cosmetic issues; not D-02 violations; not second-theme frankenstein risks); a theme-switcher UI affordance (its own future phase if needed); any change to scoring logic, slide flow, or copy (locked by EXCL-scoring-or-flow-changes).

</domain>

<decisions>
## Implementation Decisions

### Stub theme identity & value source
- **D-01:** Slug = `alchemist`. Real client name from Pete's advisory stable, but token values are deliberately placeholder/synthetic — sourcing real Alchemist brand specs stays out of scope per EXCL-real-client-themes. The stub's purpose is to prove the contract is pluggable, not to ship a production Alchemist theme. A future milestone can replace placeholder values with real specs without restructuring the block.

### Override depth
- **D-02:** Full contract exercise — colors + fonts. The Alchemist override block sets every color token slot (accent + accent-hover + accent-muted + surface + surface-elev + text + text-muted + border + neutral-50..900 + brand-soft + brand-secondary) AND swaps `--font-display` and `--font-body` to a font distinct from Space Grotesk + Plus Jakarta Sans. Adds one new Google Font to the existing `<head>` `<link>` per Phase 1 D-16. This is the first time D-16's "all theme fonts preloaded together in a single `<link>`" pattern is exercised with two themes — Phase 3 validates that the `<link>` can carry multi-theme font weight without breaking Overdrive's load behavior.

### WR-01 placement
- **D-03:** WR-01 fix (lines 180 + 210 in index.html — `.answer-card` and `.check-card` hardcode `background: white;` on resting state, violating Phase 1 D-02 structure-skin separation) lands as **Plan 03-01**, a 1-task pre-cursor plan BEFORE the Alchemist override block is added. Flip `background: white;` → `background: rgb(var(--surface-elev-rgb));` at both lines. Mirrors the 02-06 atomic gap-closure pattern. Rationale: SC #2 requires "no element falls back to Overdrive defaults mid-page" — a hardcoded white card stuck on top of Alchemist's surface would break SC #2 directly. Fix-first sequencing keeps the Alchemist plan a clean "add an override block" diff without bundling a contract-violation fix.

### Switching validation scope
- **D-04:** URL-load only. VALIDATION rigs cover three scenarios:
  - (a) Load `?client=alchemist` → full Alchemist render across all six slides + results + reference matrix
  - (b) Load bare URL → full Overdrive render (zero regression vs current main)
  - (c) Load `?client=alchemist` → navigate to bare URL → Overdrive restored with no residual state (no stuck colors, no FOUC, no stale font)
  Runtime `document.documentElement.setAttribute('data-theme', X)` toggle (mid-session JS swap) is **not** validated. CSS-var cascade re-paints mechanically on `data-theme` attribute change in all modern browsers — it's browser behavior, not a project-specific risk. If a future dev-mode UI affordance (theme-switcher dropdown) is built, it owns its own runtime-toggle validation rigs.

### Claude's Discretion
The user committed to direction; planner/researcher derive specifics within these bounds:
- Exact Alchemist placeholder hex values for every color token. Constraints: visibly distinct from Overdrive orange-on-warm-off-white (different hue family); internally coherent (accent + neutrals + secondary palette read as one brand); brand-plausible (looks like a real B2B brand could ship it, not neon, not safety-orange). Suggestion direction: deep saturation like burgundy, deep teal, indigo, or slate-blue paired with a cool neutral ramp — but planner has full discretion within "visibly distinct from Overdrive."
- Choice of new Google Font for `--font-display` (and optionally `--font-body`). Constraints: visibly distinct feel from Space Grotesk's geometric-sans aesthetic — could be a slab serif (e.g., Fraunces, Roboto Slab), a humanist serif (e.g., Source Serif), a transitional serif, or a distinctly different sans (e.g., DM Serif Display, IBM Plex Serif). Must support weights needed by existing markup (`font-bold` minimum; `font-extrabold` if any current usage). Within Google Fonts roster only (no self-hosted).
- Whether the Alchemist `--font-body` swaps too, or only `--font-display`. Recommended: swap both (more complete proof per D-02); planner can stay with display-only if Google Fonts payload cost becomes a concern.
- Exact plan count + split for the Alchemist work (Plan 03-02, 03-03, etc.). Plan 03-01 = WR-01 fix is locked first per D-03. The remaining work (override block authoring + Google Fonts `<link>` edit + VALIDATION rigs running) can be 1 plan or 2 — planner decides based on commit-atomicity preferences.
- Exact `<link>` href format for adding the new Alchemist font alongside the existing three fonts. Per Phase 1 D-16, single `<link>` with all fonts; planner picks query-string concatenation pattern.
- Whether to add an in-file comment under the existing "HOW TO ADD A CLIENT THEME" recipe (lines 14–45) that calls out the new Alchemist block as a worked example. Recommended yes (turns the abstract recipe into a concrete-precedent doc); planner derives wording.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents (researcher, planner) MUST read these before planning or implementing.**

### Project-level
- `.planning/PROJECT.md` — full constraint list (6 locked-constraint REQs governing all phases), Out-of-Scope items including EXCL-real-client-themes (load-bearing for D-01's placeholder-values choice)
- `.planning/REQUIREMENTS.md` — REQ-stub-second-theme (the v1 req this phase delivers; explicitly permits placeholder values) + the 6 project-wide constraint REQs + the 3 scope-exclusion EXCLs
- `.planning/ROADMAP.md` § "Phase 3: Second Theme Stub & Pluggability Proof" — phase goal + 4 success criteria

### Source PRD
- `plan.md` — original milestone intent doc; "Locked decisions" + "Scope for this milestone"

### Design system (reference for "feels like a real brand" direction)
- `docs/design/design-system-alpha-overdrive.md` — Overdrive design system. Phase 3 needs to be visibly distinct from this. Critical sections for comparison:
  - § 3 Color Palette (Overdrive's orange-on-warm-off-white identity — Alchemist must NOT echo this)
  - § 4 Typography (Overdrive uses Space Grotesk display — Alchemist's font choice must contrast)

### Phase 1 artifacts (load-bearing carry-over)
- `.planning/phases/01-theming-architecture-foundation/01-CONTEXT.md` — Phase 1 D-01 through D-16. Phase 3 inherits especially:
  - **D-01** (canonical switch is `?client=<slug>` URL param + FOUC inline `<script>` — Phase 3 does NOT rewire this)
  - **D-02** (default render is Overdrive; bare URL = Overdrive)
  - **D-03** (unknown `?client=` falls back to Overdrive silently — covers typo'd Alchemist slug)
  - **D-04** (brandable = colors + typography only; D-02's full-contract scope honors this)
  - **D-05** (single-layer semantic tokens — Alchemist override uses the same slug list as Overdrive `:root`)
  - **D-09** (neutrals brandable per client — Alchemist overrides the full `--neutral-*` ramp)
  - **D-10** (all theme code in single `<style>` near top of `<head>`; new block uses `/* ========== ALCHEMIST ========== */` divider per existing convention)
  - **D-11** (inline "HOW TO ADD A CLIENT THEME" comment is the recipe — Alchemist block becomes a worked example reference)
  - **D-13** (RGB-triplet + `<alpha-value>` pattern — every Alchemist color override uses this format)
  - **D-15** (forgiving missing-token cascade — D-02 deliberately does NOT lean on this; full override exercise)
  - **D-16** (all theme fonts preloaded together in single Google Fonts `<link>` — Phase 3's font addition exercises this for the first time with two themes)

### Phase 2 artifacts (load-bearing carry-over)
- `.planning/phases/02-overdrive-default-theme-migration/02-CONTEXT.md` — Phase 2 D-01 through D-14. Phase 3 inherits especially:
  - **D-08** (keep `slate-*` Tailwind utility names in markup — Alchemist's `--neutral-*` overrides flow through the same `slate-*` utilities)
  - **D-11** (hover intensity locked across themes via alpha-derived `--accent-rgb` — Alchemist hovers automatically derive from Alchemist accent; no per-theme hover tuning)
  - **D-12** (yellow tokens `--brand-soft-rgb` + `--brand-secondary-rgb` — Alchemist must override these too OR explicitly leave them yellow if Alchemist's "secondary palette" concept is undefined)
  - **D-14** (browser-verify after every `<head>`-touching task — applies to the Google Fonts `<link>` edit in Plan 03-02+)
- `.planning/phases/02-overdrive-default-theme-migration/02-VERIFICATION.md` — Phase 2 round 2 VERIFIED, all 4 SCs green. The methodology Phase 3 should mirror.
- `.planning/phases/02-overdrive-default-theme-migration/02-VALIDATION.md` — V-11 (surface-differentiation guard for `bg-slate-50` inside `bg-surface-warm`) is a regression guard Phase 3 must continue to pass under Alchemist (Alchemist's `--neutral-50-rgb` must also differ from its `--surface-rgb` if it overrides both).
- `.planning/phases/02-overdrive-default-theme-migration/02-REVIEW.md` — WR-01 source-of-truth (lines 180 + 210); also confirms WR-02..06 are Overdrive-internal contrast/cosmetic issues (not second-theme frankenstein risks; stay deferred).
- `.planning/phases/02-overdrive-default-theme-migration/02-06-PLAN.md` + `02-06-SUMMARY.md` — atomic gap-closure pattern Plan 03-01 mirrors.

### Codebase intel
- `.planning/codebase/STACK.md`, `STRUCTURE.md`, `CONVENTIONS.md` — dated 2026-03-05 (pre-Phase-1); flagged stale for token/font/line-number references. Phase 3 should grep `index.html` directly rather than trust the maps for line numbers.

### App entry
- `index.html` (1007 lines, post-Phase-2-verified on `rebrand-theming` branch) — the single file all changes happen in. Line ranges verified at write-time of this CONTEXT:
  - Lines 7–12: FOUC `<script>` (unchanged from Phase 1)
  - Lines 13–86: theme contract `<style>` (`HOW TO ADD A CLIENT THEME` comment 14–45; `:root` defaults 47–85). **Alchemist override block inserts inside this `<style>`, after the `:root` close brace at line 85 and before the closing `</style>` at line 86.**
  - Line 87: Tailwind CDN `<script>` (unchanged)
  - Lines 88–125 (approx): inline Tailwind config `<script>` — **no edits in Phase 3** (utilities already resolve through vars; Alchemist override doesn't add new utility names)
  - Line 126 (approx): Google Fonts `<link>` — **single edit in Phase 3** to add Alchemist's font family
  - Lines 180 + 210: WR-01 violation sites (`.answer-card` resting bg + `.check-card` resting bg — Plan 03-01 target)
  - Lines 178/186/189/192/197/210/220/240 region: existing `.answer-card`/`.check-card` selector rules (Plan 03-01 reads these for context but does not edit beyond lines 180 + 210)

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- **Theme contract `<style>` block** (lines 13–86) — Alchemist's override block inserts here as the new `[data-theme="alchemist"] { ... }` rule, placed after the `:root` close (line 85) and before `</style>` (line 86). Use the established comment-divider pattern: `/* ========== ALCHEMIST ========== */` (per Phase 1 D-10 + project convention).
- **Inline "HOW TO ADD A CLIENT THEME" comment** (lines 14–45) — already documents the recipe. Phase 3's Alchemist block becomes a concrete worked example, validating the recipe end-to-end. Optionally extend the comment to cite Alchemist as the canonical example.
- **`:root` defaults** (lines 47–85, 15 color tokens + 3 font tokens) — Alchemist override mirrors this slug list 1:1 (D-02 = full contract exercise, no partial-override per D-15). Token slugs Alchemist must declare: `--accent-rgb`, `--accent-hover-rgb`, `--accent-muted-rgb`, `--surface-rgb`, `--surface-elev-rgb`, `--text-rgb`, `--text-muted-rgb`, `--border-rgb`, `--neutral-50-rgb` through `--neutral-900-rgb` (10 stops), `--brand-soft-rgb`, `--brand-secondary-rgb`, `--font-display`, `--font-body`. `--font-mono` (JetBrains Mono) can stay inherited or be re-declared — planner decides.
- **Google Fonts `<link>` in `<head>`** — current href carries Space Grotesk + Plus Jakarta Sans + JetBrains Mono. Phase 3 appends Alchemist's chosen font family to the existing href (per Phase 1 D-16). Single edit to one element.
- **FOUC `<script>`** (lines 7–12) — unchanged in Phase 3. Already handles `?client=alchemist` → sets `data-theme="alchemist"` on `<html>` before first paint. The contract already supports any slug; Phase 3 just adds a slug-matching CSS block for `[data-theme="alchemist"]` to consume.

### Established Patterns
- **RGB-triplet + `<alpha-value>` pattern** (Phase 1 D-13) — every Alchemist color override uses `--<token>-rgb: R G B;` (space-separated channel triplets, no commas, no hex). Tailwind utilities pick up the new values automatically via `rgb(var(--<token>-rgb) / <alpha-value>)` consumers (defined in the inline Tailwind config, untouched in Phase 3).
- **Single source of truth** (Phase 1 D-11) — `:root` + `[data-theme="alchemist"]` block are the only places Alchemist's identity is encoded. No JS, no separate config file. Recipe stays the doc.
- **Forgiving cascade** (Phase 1 D-15) — Phase 3 deliberately does NOT lean on partial-override per D-02 (full contract exercise). But the cascade is still the safety net: if Alchemist omits a token by mistake during authoring, that token cascades from `:root` (Overdrive default). Useful during planner iteration; not a shipped runtime behavior expectation.
- **Comment dividers** (`/* ========== HEADER ========== */`) — Phase 1 D-10 established for theme blocks. Plan 03-02+ uses `/* ========== ALCHEMIST ========== */` immediately above the Alchemist block.
- **Atomic gap-closure plan pattern** (02-06) — Plan 03-01 mirrors this exactly: 1-task fix for a known D-contract violation, 1-2 commits, no scope creep.

### Integration Points
- **Lines 180 + 210 (Plan 03-01 — WR-01 fix)** — change `background: white;` → `background: rgb(var(--surface-elev-rgb));` on `.answer-card` resting (line 180) and `.check-card` resting (line 210). Under Overdrive (`--surface-elev-rgb: 255 255 255`), zero visual delta. Under Alchemist, cards render Alchemist's surface-elev color. Atomic single-commit plan.
- **Lines 13–86 token contract `<style>` (Plan 03-02+ — Alchemist override block)** — insert new `[data-theme="alchemist"] { ... }` block after `:root` close (line 85). Approximately 20 declaration lines (15 colors + 3 fonts + 2 comment dividers) plus opening/closing braces.
- **Google Fonts `<link>` in `<head>` (Plan 03-02+ — font load)** — single href edit. Triggers Phase 2 D-14 browser-verify gate (font load is a runtime claim; grep-ordering is not sufficient per `~/.claude/rules/empirical-probes.md`).
- **VALIDATION rigs (Plan 03-final — verification)** — three URL-load scenarios per D-04. Each requires `python3 -m http.server 8080` + browser navigation + DevTools assertion (`getComputedStyle` checks on representative elements per slide + results page). Mirror V-11 pattern from Phase 2.

</code_context>

<specifics>
## Specific Ideas

- **The "no frankenstein" rule reaches its final form in Phase 3.** Phase 1's D-08 zero-visual-diff guarantee held current values; Phase 2 moved the values to Overdrive and exposed BL-01 (`--neutral-50-rgb` collapsing onto `--surface-rgb`) which required gap closure. Phase 3 is the first time the rule is tested against a *different* set of values entirely. SC #2 ("no element falls back to Overdrive defaults mid-page") is the load-bearing constraint. WR-01 fix (D-03) is the most obvious frankenstein risk; the planner / researcher should grep for any other hardcoded color or hardcoded font literal in `index.html` that bypasses the contract (look for `#[0-9A-Fa-f]{3,6}`, `rgb(`, `rgba(`, `'Space Grotesk'`, `'Plus Jakarta Sans'`, `'JetBrains Mono'`, `'Fraunces'` literals outside the `:root` and `[data-theme=...]` blocks). Any hits beyond WR-01 are pre-existing D-02 violations and become Phase 3 sub-tasks.
- **D-16's "all fonts preloaded together" pattern is exercised for the first time.** Phase 3 must validate that adding Alchemist's font to the existing `<link>` doesn't break Overdrive's render (FOUT, weight mismatch, fallback chain quirk). Phase 2 D-14 browser-verify mandate applies — `<link>`-touching changes require a runtime check, not just grep-ordering.
- **VALIDATION rig (c) "switch-back restore" is the trickiest of the three.** Tests that no JS or CSS state persists across URL navigation. The current contract has no JS state (FOUC just reads URL param and sets attribute on `<html>`) so this *should* be free. But: cached Google Fonts, cached CSS, browser memory of `data-theme` value — these are all real surfaces a careful rig should poke. Recommend the rig open Overdrive cold (incognito), navigate to `?client=alchemist`, navigate back to bare URL, assert full Overdrive identity via `getComputedStyle` on accent + surface + a font-render check.
- **Placeholder values must be "brand-plausible" not "demo-cartoony."** D-01 puts Alchemist's name on the block, which raises the bar slightly: if someone glances at the running app under `?client=alchemist`, the visual identity should look intentional (deep purple + cream + serif feels intentional; neon-magenta + lime + comic-sans does not). This is part of the proof — the contract supports real-feeling brand swaps.
- **The codebase maps are stale; grep `index.html` directly for line numbers.** Phase 2 noted this; Phase 3 inherits it. The `index.html` line ranges in `<canonical_refs>` are write-time verified for this CONTEXT but may drift by ±5 lines if Plan 03-01 lands first (single-line edits at lines 180 + 210 won't shift downstream line numbers; planner should re-grep `:root` close brace + Google Fonts `<link>` line number after Plan 03-01 ships before locking Plan 03-02 task line numbers).

</specifics>

<deferred>
## Deferred Ideas

- **Real Alchemist brand specs sourcing** — explicitly out of scope per EXCL-real-client-themes. Future milestone (post-v1) when real client themes are commissioned. Alchemist's placeholder values from Phase 3 are easy to swap out without restructuring the override block.
- **Additional client theme stubs** (SkyDeck, L2L, Scale VP, Berkeley, etc.) — out of scope per EXCL-real-client-themes for v1. Phase 3 proves the system with one stub; same pattern applies to any future client.
- **A third "minimum-viable" stub theme** (e.g., accent-only override to prove D-15 cascade explicitly) — considered in Area 2; rejected in favor of D-02's full-override approach. Cascade is implicitly proved by Plan 03-01's WR-01 fix (under Alchemist, every other token cascades correctly even if Alchemist forgot to set `--surface-elev-rgb`).
- **Runtime `setAttribute('data-theme', X)` toggle validation** — deferred per D-04. CSS-var cascade handles re-paint mechanically; future dev-mode UI affordance owns its own runtime-toggle rigs if built.
- **Theme-switcher UI affordance** (in-app dropdown / debug menu for swapping themes mid-session) — out of scope. Would be its own future phase.
- **Markup rename `slate-*` → `neutral-*` utility names** — deferred per Phase 2 D-08 (~25–30 markup edits avoided; semantic mismatch accepted cost). Future cleanup pass if it becomes load-bearing for non-engineer client-theme authors.
- **WR-02..06 from 02-REVIEW.md** — Overdrive-internal contrast/cosmetic issues (text-slate-500 WCAG, slate-400 captions, border contrast, sticky-footer gradients, yellow-on-yellow icon contrast). Confirmed NOT second-theme frankenstein risks (all flow through tokens or are intra-Overdrive cosmetic). Stay deferred for a future polish phase.
- **Per-client tunable hover intensity** (each theme defines its own hover loudness independent of accent) — deferred per Phase 2 D-11. Add `--accent-hover-soft-rgb` / `--accent-hover-border-rgb` semantic tokens if a future client demands distinct hover energy. Alchemist inherits the locked 6%-bg / 40%-border intensity from D-11.
- **Per-theme media queries / dark-mode variants** — out of scope per REQ-no-dark-backgrounds (project-wide constraint). Alchemist does not get a dark-mode opt-in.
- **Build-time per-client deploys** — out of scope per REQ-single-file-no-build (project-wide). One `index.html` URL serves all themes; client selection via `?client=` URL param only.
- **`localStorage`-based theme persistence** — considered and rejected in Phase 1. Shared workshop links must render deterministically; no stateful behavior.
- **Any change to scoring logic, slide flow, or copy** — out of scope per EXCL-scoring-or-flow-changes (project-wide constraint). Alchemist re-skins the visual identity; it does NOT touch `calculateScore()`, the six-slide structure, the answer model, or result text.

</deferred>

---

*Phase: 3-Second Theme Stub & Pluggability Proof*
*Context gathered: 2026-05-16*
