# Phase 2: Overdrive Default Theme Migration - Context

**Gathered:** 2026-05-16
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 2 takes the structural theming contract built in Phase 1 (single `:root` block of brandable tokens, Tailwind utilities resolved through CSS vars, FOUC switch, slate→neutral remap) and flips the **values** in `:root` to deliver the Overdrive identity end-to-end. The contract structure does not change — only token values change, plus 2 net-new tokens for the secondary brand tier (yellow) plus one rewired token consumer (`--surface-elev-rgb` declared in Phase 1, now consumed by the elevated result card).

At the end of Phase 2, with no `?client=` override, the app renders Overdrive end-to-end: warm off-white surface throughout (slides + results + footer), orange as the structural signature (three section dividers, 3px result-card left-border, 4–6px top-strips on conditional callouts, footer top rule), warm-gray neutral ramp, Light Yellow + Golden Yellow for secondary brand tier (PLS badge, PLS card icon, warning icon), Space Grotesk display font, hovers deriving from `--accent-rgb` via alpha, dark surface tokens retired.

In scope: token value flips in `:root` (accent, surface, surface-elev wiring, text, text-muted, border, full neutral-50..900 ramp), retirement of `--surface-dark-rgb` and `--surface-dark-card-rgb`, addition of `--brand-soft-rgb` and `--brand-secondary-rgb`, Tailwind config yellow.* remap + display-font fallback update + retirement of surface-dark / surface-dark-card namespaces, Google Fonts `<link>` swap (Fraunces → Space Grotesk weights), `--font-display` value flip, Category B selected-state literal migration in component `<style>` (lines 178/192/211/221), hover-state rewrite at lines 177/190/210 to alpha-derived from `--accent-rgb`, dark results hero retirement (lines 533–700), three orange section dividers on results page, callout treatments, footer treatment, Cat D utility updates at lines 575/635/676.

Out of scope: scoring logic / slide flow / copy (locked by REQ-theming-visual-only + EXCL-scoring-or-flow-changes), the second client theme (Phase 3), full typographic redesign beyond minimum-viable Space Grotesk adjustments (bounded by D-13), markup rename of `slate-*` utilities to `neutral-*` (kept per D-08), per-client real brand specs sourcing (deferred per EXCL-real-client-themes).

</domain>

<decisions>
## Implementation Decisions

### Surface palette — dark hero retirement
- **D-01:** Continuous warm off-white surface (`#FFF8F0`) across slides + results + footer. One bg across the entire app. `--surface-dark-rgb` and `--surface-dark-card-rgb` retire (declared in Phase 1 with retirement annotation already in place — lines 57–58).
- **D-02:** Main result card sits on white (`#FFFFFF`) elevated surface with a 3px `#FF9000` orange left-border. Wires `--surface-elev-rgb` (declared in Phase 1 with no Tailwind consumer per 01-01-SUMMARY.md line 72 — Phase 2 adds the consumer). Mirrors the current 3px-left-border pattern at line 538, swapping color from `#4F46E5` to `#FF9000`.
- **D-03:** Wedge callout (line 552) + override notice (line 572) treated with a 4–6px solid `#FF9000` top-strip on a white card body. Differentiates visually from the main result card (which carries left-border) — preserves hierarchy: main result is the headline, callouts are auxiliary insights. Per Overdrive Section 3: "callout boxes: orange background strip."
- **D-04:** Footer (line 698) sits on `#FFF8F0` with a full-width `#FF9000` horizontal top rule marking the boundary. Establishes "orange section dividers" as the page-level boundary pattern.
- **D-05:** Three orange section dividers on the results page: (a) above the main result card, (b) at the line 601 boundary (result-card-group → reference matrix, currently `border-t border-slate-200`), (c) above the footer. Delivers Overdrive Section 9 signature ("Orange section dividers between content blocks").

### Neutral ramp
- **D-06:** Warm-gray 10-stop ramp throughout for `--neutral-50` through `--neutral-900`. Planner derives specific hex values from Overdrive anchors: `#FFF8F0` surface (~50), Border Light `#E5E5E5` (~200), Gray 2 `#8A8A8A` (~400–500), Gray 1 `#666666` (~600), Dark Gray `#434343` (~700), extrapolated stops above and below. Slight warm undertone harmonizes with orange accent and `#A58E6F` Muted Brown tone setter. Satisfies REQ-overdrive-default-theme acceptance criterion #3 ("no half-old / half-new state").
- **D-07:** Keep the full 10-stop ramp declared in `:root` (50 through 900) even where post-Phase-2 there is no Tailwind consumer for 700/800/900. Honors Phase 1 D-09 ("neutrals are brandable per client") — future client themes may use the full range.
- **D-08:** Keep `slate-*` Tailwind utility name in markup (no rename to `neutral-*`). Honors Phase 1 D-07's "no markup edits" principle. Semantic mismatch (reads "slate", renders neutral) is accepted cost. ~25–30 markup utility edits avoided; smaller diff; less regression surface.

### Secondary palette — Cat D + hover-state
- **D-09:** Cat D brand-colored utilities map to Overdrive's secondary palette by role. PLS badge (line 635): bg = Light Yellow `#FFE599`, fg = Golden Yellow `#F1C232`. PLS card icon bg (line 676): Light Yellow `#FFE599`. Internally coherent GTM motion hierarchy: Pure PLG = orange (lead), Product-Led Sales = yellow (secondary), Sales-Led = neutral (reserved), Wedge = neutral stronger (emphatic).
- **D-10:** Override-notice warning icon (line 575, currently `text-amber-400`) becomes Golden Yellow `#F1C232` (tokenized via D-12). Warning icon bg (line 574 inline `style="background:rgba(245,158,11,0.15);"`) shifts to a soft golden-yellow tint (planner derives exact value — likely `rgba(241,194,50,0.15)` or equivalent expressed via `rgb(var(--brand-secondary-rgb) / 0.15)`).
- **D-11:** Hover-state hex literals in component `<style>` rewired to derive from `--accent-rgb` via Tailwind alpha pattern. Lines 177, 190, 210 become `rgb(var(--accent-rgb) / 0.4)` for borders and `rgb(var(--accent-rgb) / 0.06)` for backgrounds. Zero new hover tokens. Trade-off: hover intensity locked across themes (always 6% bg / 40% border of accent). Future client themes inherit coherent hovers automatically by overriding only `--accent-rgb`. Honors Phase 1 D-11 (non-engineer-overridable) and D-13 (RGB-triplet + alpha pattern).
- **D-12:** Add **+2 net-new tokens** to `:root`: `--brand-soft-rgb: 255 229 153;` (`#FFE599`) and `--brand-secondary-rgb: 241 194 50;` (`#F1C232`). Tailwind config remaps `yellow.100` → `--brand-soft-rgb` and `yellow.400` → `--brand-secondary-rgb` via the RGB-triplet + `<alpha-value>` pattern. Markup uses `bg-yellow-100 text-yellow-400` (and variants). Brandable per client — extends Phase 1 D-09 to the secondary palette. Net contract growth: ~13 → ~15 color tokens.

### Typography
- **D-13:** Family swap + minimum-viable adjustments. Update Google Fonts `<link href>` (line 124) — drop Fraunces opsz+wght clause, add Space Grotesk weights 400/500/600/700 per Overdrive Section 4 spec. Flip `--font-display: 'Fraunces', serif` → `'Space Grotesk', sans-serif` (line 80). Tailwind config display-font fallback updates from `'serif'` to `'sans-serif'` (line 92). After swap, browser-verify and adjust **only** where the current scale visibly clashes with Space Grotesk's letterform. Likely candidates (planner decides post-verification): slide-0 hero `text-5xl md:text-[3.5rem]` → possibly `text-6xl` for parity with Fraunces' presence; `font-bold` (700) → possibly `font-extrabold` (800) for hero headlines per Overdrive's "extreme weight contrasts" principle. **Not in scope:** full typographic scale tuning to Overdrive Section 4 (deferred — available for future polish phase if needed).

### Verification methodology
- **D-14:** Browser-verification cadence = **BEFORE plan locks AND after every `<head>`-touching execute task**. This is the structural mitigation for HANDOFF.json `blocking_constraints_for_phase_2[0]` (empirical-probes-on-head-element-ordering, severity: blocking — captured from the V-4 Phase 1 failure).
  - **Research phase:** before writing any proposed `<head>` ordering (e.g., where Space Grotesk preconnect/preload goes if added, where the Google Fonts `<link>` sits relative to FOUC + token-style + CDN + inline config) into PLAN.md, browser-load the proposed state via `python3 -m http.server` + DevTools console. Assertion: zero JS errors AND visible identity matches Overdrive baseline. Plan does not lock until this check passes.
  - **Execute phase:** browser-verify after every task that modifies `<head>`, adds/moves a `<script>` or `<link>`, or depends on or mutates globals (e.g., `window.tailwind`, `tailwind.config`). VALIDATION.md must encode each as a hard verify gate row — not a single end-of-phase sweep.
  - Grep-ordering assertions are necessary but **not sufficient** for runtime-behavior claims about `<head>` element ordering. This decision generalizes Phase 1's Pitfall 2b lesson into a phase-level standard.

### Claude's Discretion
The user committed to direction; planner/researcher derive specifics within these bounds:
- Specific 10-stop hex values for the warm-gray ramp (D-06 gives anchors and direction).
- Exact orange tint for `--accent-muted-rgb` Overdrive value (currently `#EEF2FF` light indigo; planner derives soft-orange equivalent like `#FFF1E0` or similar that pairs with `--accent` selected state).
- Exact orange divider thickness for D-05's three section dividers (3px? 4px? planner picks within consistent treatment).
- Exact top-strip thickness for D-03 callouts (4–6px range was the discussion).
- Exact soft golden-yellow tint hex for D-10's warning-icon bg.
- Specific values flipped into `--neutral-700` (intended to land on Overdrive Dark Gray `#434343` for body text per D-06).
- Whether D-13's "minimum-viable adjustments" land as 0 changes, 1 change (just hero size), or 2 changes (size + weight) — determined post-browser-verify, not pre-decided.
- Whether the warning icon bg at line 574 inline-style migrates to a utility class or stays inline.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents (researcher, planner) MUST read these before planning or implementing.**

### Project-level
- `.planning/PROJECT.md` — full constraint list (6 locked-constraint REQs governing all phases), Out-of-Scope items, milestone framing
- `.planning/REQUIREMENTS.md` — REQ-overdrive-default-theme (the v1 req this phase delivers), plus the 6 project-wide constraint REQs and the 3 scope-exclusion EXCLs
- `.planning/ROADMAP.md` § "Phase 2: Overdrive Default Theme Migration" — phase goal + 4 success criteria

### Source PRD
- `plan.md` — original milestone intent doc; "Locked decisions" + "Scope for this milestone"

### Design system (load-bearing)
- `docs/design/design-system-alpha-overdrive.md` — Overdrive design system. **Critical sections for Phase 2:**
  - § 3 Color Palette (Primary + Secondary + Dark Mode tables; `:root` CSS vars block)
  - § 4 Typography (font families table; web hierarchy/sizing table; loading patterns)
  - § 5 Layout & Composition (web layout principles — "warm off-white as the default light background"; "orange accents create rhythm and contrast")
  - § 9 Brand Personality / The Signature Move (orange as structural element — drives D-02 through D-05)

### Phase 1 artifacts (load-bearing carry-over)
- `.planning/phases/01-theming-architecture-foundation/01-CONTEXT.md` — Phase 1 D-01 through D-16. Phase 2 inherits especially D-02 (default is Overdrive), D-04 (colors + typography brandable), D-05 (single-layer semantic tokens), D-08 (Phase 1 vars hold current hex; Phase 2 changes values only), D-09 (neutrals brandable per client), D-11 (non-engineer ergonomics), D-13 (RGB-triplet + `<alpha-value>` pattern), D-15 (forgiving cascade)
- `.planning/phases/01-theming-architecture-foundation/01-01-SUMMARY.md` § "Hand-off to Phase 2" — Category B/C/D hex catalogs with post-Phase-1 line numbers (re-grep at Phase 2 start per advisory_constraints; line numbers verified current at discuss time)
- `.planning/phases/01-theming-architecture-foundation/01-01-SUMMARY.md` § "Research-level correction" — the V-4 Pitfall 2b correction text (RESEARCH §5's "CDN is defer-equivalent" claim was wrong)
- `.planning/phases/01-theming-architecture-foundation/01-RESEARCH.md` § Pitfall 2b — the corrected `<head>` ordering rationale + browser-verify mandate
- `.planning/phases/01-theming-architecture-foundation/01-PATTERNS.md` — corrected with the Pitfall 2b note (a9e5b35)

### Carry-over from Phase 1 paused state
- `.planning/HANDOFF.json` — `blocking_constraints_for_phase_2[0]` (empirical-probes-on-head-element-ordering, severity: blocking — drives D-14); `advisory_constraints[0]` (claude-code-worktree-spawn-base-quirk); `advisory_constraints[1]` (summary-line-numbers-shifted-by-+78 — re-grep at start per planner instruction)

### Codebase intel (note staleness)
- `.planning/codebase/STACK.md`, `STRUCTURE.md`, `CONVENTIONS.md` — dated 2026-03-05, **pre-Phase-1**. STACK.md mentions `primary`/`primaryHover` and Inter (both stale — Phase 1 D-05/D-07 changed). STRUCTURE.md and CONVENTIONS.md describe pre-Phase-1 file layout. **Phase 2 should grep current `index.html` rather than trust these maps for line numbers, token names, or current usage.**

### App entry
- `index.html` (1002 lines, post-Phase-1 on `rebrand-theming` branch) — the single file all changes happen in. Line ranges grep-verified at write-time (open + close anchors):
  - Lines 7–12: FOUC `<script>` (open `<script>` line 7, close `</script>` line 12)
  - Lines 13–84: token contract `<style>` with `:root` defaults (open `<style>` line 13, close `</style>` line 84)
  - Line 85: CDN `<script>` (single-line, self-closing)
  - Lines 86–123: inline Tailwind config `<script>` (open line 86, close line 123)
  - Line 124: Google Fonts `<link>` (Fraunces / Plus Jakarta Sans / JetBrains Mono — Phase 2 swaps Fraunces)
  - Lines 125–272: component `<style>` block (open line 125, close line 272) — slide system, answer-card, check-card, results-page reveal animations, kbd-hint. Category B hex literals here per Phase 1 SUMMARY catalog.
  - Lines 533–700: results page region (dark hero → warm hero per D-01 through D-05)
  - Line 575: warning icon (D-10)
  - Line 635: PLS badge (D-09)
  - Line 676: PLS card icon bg (D-09)

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- **Token contract `<style>` block** (lines 13–84): Phase 2 flips values inside `:root` from current indigo/slate/Fraunces hex to Overdrive equivalents. Structure stays. `--surface-dark-rgb` and `--surface-dark-card-rgb` declarations remove (lines 57–58). Two new tokens insert (D-12). The "HOW TO ADD A CLIENT THEME" inline comment header (lines 14–47) does not need to change — its instructions remain accurate.
- **Inline Tailwind config block** (lines 86–123): Phase 2 adds a `yellow:` extension namespace mapping `yellow.100` → `--brand-soft-rgb` and `yellow.400` → `--brand-secondary-rgb` (D-12). Removes the `surface.dark` / `surface.dark-card` entries (lines 103–104). Display fontFamily fallback changes `'serif'` → `'sans-serif'` (line 92).
- **FOUC `<script>`** (lines 7–12): unchanged in Phase 2. No URL param logic changes.
- **Google Fonts `<link>`** (line 124): Phase 2 rewrites the `href` to drop Fraunces (`Fraunces:opsz,wght@9..144,300;9..144,700;9..144,800`) and add Space Grotesk weights per Overdrive spec (`Space+Grotesk:wght@400;500;600;700`). Plus Jakarta Sans + JetBrains Mono clauses unchanged.
- **Component `<style>` block** (lines 125–272): Phase 2 migrates Category B hex literals to var-driven per the catalog in 01-01-SUMMARY.md (covers lines 137, 169, 177, 178, 182, 186, 190, 192, 201, 210, 211, 215, 221, 240, 246, 251, 258, 262). Hover-state rules at 177, 190, 210 rewrite to alpha-derived per D-11.

### Established Patterns
- **RGB-triplet + `<alpha-value>` pattern** (Phase 1 D-13) — D-11 (hovers) and D-12 (yellow tokens) extend this pattern. Every new color token in Phase 2 uses it.
- **Single source of truth** (Phase 1 D-11) — `:root` + Tailwind config remain the only place that needs editing per token; the inline "HOW TO ADD A CLIENT THEME" recipe stays accurate post-Phase-2.
- **No raw hex in markup** (REQ-build-theming-architecture acceptance #4) — D-09's Tailwind-utility-rename approach (`bg-indigo-100 text-indigo-800` → `bg-yellow-100 text-yellow-400`) preserves this; markup edits swap utility class names, not hex values. Inline `style="..."` on lines 538, 543, 574 needs migration to utility classes or var-backed `style="background:rgb(var(--accent-rgb) / X);"` form.
- **Forgiving cascade** (Phase 1 D-15) — unchanged; client themes overriding only some tokens still render Overdrive-with-overrides.
- **Comment dividers** (`/* ========== HEADER ========== */`) — Phase 1 D-10 established this in the token contract `<style>`. Phase 2's value flips don't touch dividers; the +2 token additions (D-12) fit under the existing `Accent colors` / `Surfaces` / `Text` / `Border` / `Neutral ramp` / `Fonts` divider scheme — likely under a new `Secondary palette` divider or appended to an existing block (planner picks).

### Integration Points
- **Lines 13–84 (token contract `<style>` containing `:root` block)** — value flips for accent, surface, text, text-muted, border, neutral-50..900; addition of `--brand-soft-rgb`, `--brand-secondary-rgb`; removal of `--surface-dark-rgb`, `--surface-dark-card-rgb`; flip of `--font-display`.
- **Lines 86–123 (inline Tailwind config `<script>`)** — yellow namespace addition, surface-dark/dark-card removal, display font fallback update.
- **Line 124 (Google Fonts `<link>`)** — href rewrite. Triggers D-14 browser-verify gate (depends on globals? No — but it's a `<head>`-modifying change and Space Grotesk must load correctly before any `font-display` consumer renders, which is a runtime claim).
- **Lines 533–700 (results page)** — markup changes for dark-hero retirement, addition of three section dividers (D-05), result-card surface + left-border (D-02), callout top-strips (D-03), footer top rule (D-04). Largest concentrated diff.
- **Lines 178, 192, 211, 221 (Cat B selected-state literals)** — migrate from literal `#4F46E5` / `#EEF2FF` to `rgb(var(--accent-rgb))` / `rgb(var(--accent-muted-rgb))`. Planner-implicit per Phase 1 SUMMARY catalog.
- **Lines 177, 190, 210 (hover-state literals)** — rewrite to alpha-derived per D-11.
- **Line 575 (warning icon utility)** — `text-amber-400` → `text-yellow-400` (resolves through `--brand-secondary-rgb` per D-12). Inline bg at line 574 migrates per D-10.
- **Line 635 (PLS badge)** — `bg-indigo-100 text-indigo-800` → `bg-yellow-100 text-yellow-400` (resolves through D-12 tokens).
- **Line 676 (PLS card icon bg)** — `bg-indigo-50` → `bg-yellow-100` (D-12).

</code_context>

<specifics>
## Specific Ideas

- **The "no frankenstein" rule takes its full meaning in Phase 2.** Phase 1's D-08 zero-visual-diff guarantee held current values in the contract. Phase 2 makes the values move. REQ-overdrive-default-theme acceptance #3 ("no half-old / half-new state") is the load-bearing constraint — every surface, control, badge, card, divider, and font must coherently render Overdrive. A single residual `bg-slate-800` reference, a stray `font-display: 'Fraunces'`, or one missed `text-indigo-800` breaks the criterion.
- **Orange-as-structure is the visual load-bearing signature** (Overdrive Section 9). Three orange section dividers on the results page (D-05), 3px orange left-border on the main result card (D-02), 4–6px orange top-strips on the two conditional callouts (D-03), and the orange top rule on the footer (D-04) collectively deliver this. If you remove the orange and the page still feels complete, the Overdrive identity is underdelivered.
- **Yellow as the secondary brand tier** (D-09 + D-12) is the second load-bearing pattern. It carries the GTM motion hierarchy in the badges and card icons — without it, the page reads as one-color (orange + neutral) which flattens the four-motion distinction the diagnostic depends on (PLG / PLS / Sales-Led / Wedge).
- **Net contract growth is small: +2 tokens** (`--brand-soft-rgb`, `--brand-secondary-rgb`). Phase 1's contract slots `--accent-muted-rgb`, `--surface-elev-rgb`, `--text-muted-rgb`, `--border-rgb` were declared with no Tailwind consumer yet (per 01-01-SUMMARY.md line 72) — Phase 2 wires `--surface-elev-rgb` (D-02). `--surface-dark-rgb` and `--surface-dark-card-rgb` retire.
- **Hover treatment intensity is locked across themes** by D-11's alpha-derived approach (always accent at 6% bg / 40% border). This is a deliberate trade-off: zero new hover tokens, automatic coherence per theme, but no per-client tuning of hover loudness. Acceptable for the ≤5–10 client count this milestone anticipates; revisit if a client demands distinct hover energy.
- **D-14 generalizes the V-4 lesson into a phase-level standard.** Phase 1's V-4 caught a runtime `ReferenceError: tailwind is not defined` only at end-of-execution; structural grep-ordering assertions had passed plan-checker iter 2. D-14 requires browser-verify both at research time (before PLAN.md locks proposed `<head>` ordering) AND at execute time (after every `<head>`-touching task). Without this, Phase 2 could land Space Grotesk loading bugs (e.g., FOUT, missing weight, fallback chain quirk) only at end-of-phase. The empirical-probes rule (`~/.claude/rules/empirical-probes.md`) is the underlying principle: probes must cover the EXACT claim, not a related one. Grep-ordering checks the static `<head>` order; only browser-load checks the runtime font-loading + JS-execution claims.
- **Re-grep at Phase 2 start.** HANDOFF.json `advisory_constraints[1]` plus 01-01-SUMMARY.md explicitly call this out: Category B/C/D line numbers in Phase 1 SUMMARY are post-Phase-1 but may drift if Phase 2 makes ordering changes early. At discuss time, all listed Cat B/D lines verified current. Researcher should re-verify before planner locks line-anchored tasks.
- **Codebase maps in `.planning/codebase/` are stale** (2026-03-05, pre-Phase-1). They reference `primary`/`primaryHover` and Inter font — both no longer current. Phase 2 must grep `index.html` directly for current state, not trust the maps for line numbers, token names, or current Tailwind config shape.

</specifics>

<deferred>
## Deferred Ideas

- **Body weight contrast tuning** (currently `font-sans` 400 vs `font-display font-bold` 700; Overdrive Section 4 prefers 200 vs 700–800 "extreme weight contrasts"). Discussed in Area 4 wrap-up; not adopted in Phase 2 per D-13's "minimum-viable adjustments" bound. Available for a future polish phase if the Space Grotesk swap exposes underweight body type.
- **Full typographic scale redesign** to Overdrive Section 4 exact sizes (Display 56–72px, H1 40–48px, H2 28–32px, H3 22–24px). Explicitly bounded out by D-13. Available for a future polish phase if REQ acceptance criterion #1 ("Overdrive identity coherent end-to-end") feels underdelivered post-Phase-2.
- **Markup rename `slate-*` → `neutral-*` utility names** (~25–30 markup edits). Deferred per D-08 to honor Phase 1's "no markup edits" principle. Available for a future cleanup pass if the semantic mismatch becomes load-bearing for non-engineer client-theme authors.
- **Per-client tunable hover intensity** (each theme defines its own hover loudness independent of accent). Deferred per D-11's "intensity locked across themes" trade-off. Add `--accent-hover-soft-rgb` / `--accent-hover-border-rgb` semantic tokens if a future client demands distinct hover energy.
- **PLS card icon stroke** (line 677, currently `text-accent`/orange — does it shift to Golden Yellow to match badge/bg consistency, or stay accent). Not discussed; planner decides at implementation time within D-09's "internally coherent secondary palette" spirit.
- **Wedge callout's inner card bg** (line 543 inline `style="background:rgba(15,23,42,0.5);"`). Currently dark-on-dark; Phase 2 retires dark surfaces (D-01) so this inline style needs migration. Direction: a soft warm-tinted bg consistent with the new white card body — planner derives.
- **Wedge icon bg** (line 574 inline `style="background:rgba(245,158,11,0.15);"`, orange-tinted) covered by D-10 (soft golden-yellow tint).
- **Phase 3 second theme stub** — out of scope per ROADMAP (Phase 3 owns it).
- **Real per-client themes for every client** — out of scope per EXCL-real-client-themes (milestone-wide deferred).
- **Per-client copy / content variation** — out of scope per EXCL-per-client-copy (project-wide constraint).
- **Any change to scoring logic, slide flow, or copy** — out of scope per EXCL-scoring-or-flow-changes (project-wide constraint).
- **Per-theme media queries / dark-mode variants** — out of scope per REQ-no-dark-backgrounds (project-wide constraint). Future themes do not get dark-mode opt-ins.

</deferred>

---

*Phase: 2-Overdrive Default Theme Migration*
*Context gathered: 2026-05-16*
