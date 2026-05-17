# ROADMAP — Rebrand + Multi-Client Theming

**Milestone:** Rebrand + Multi-Client Theming
**Granularity:** standard
**Coverage:** 3/3 v1 requirements mapped

## Phases

- [x] **Phase 1: Theming Architecture Foundation** — Scaffold the CSS-variable contract, Tailwind wiring, and theme switch mechanism in `index.html`. (completed 2026-05-15)
- [x] **Phase 2: Overdrive Default Theme Migration** — Convert the existing app end-to-end to the new theming architecture with Overdrive as the default identity. (verified 2026-05-16 — BL-01 closed; all 4 SCs VERIFIED)
- [ ] **Phase 3: Second Theme Stub & Pluggability Proof** — Add one stub second theme to prove the system supports per-client rebrand without touching markup.

## Phase Details

### Phase 1: Theming Architecture Foundation
**Goal**: A theming contract exists in `index.html` — a single `:root` block of brandable tokens, Tailwind utilities that resolve through those tokens, and a working theme switch mechanism — with the app still rendering its current identity unchanged.
**Depends on**: Nothing (first phase)
**Requirements**: REQ-build-theming-architecture
**Success Criteria** (what must be TRUE):
  1. A developer can open `index.html` and find every brandable token defined in one `:root` block at the top of the file (no scattered hex values in markup).
  2. The inline Tailwind config resolves utility classes through CSS vars — changing a token value in `:root` updates the rendered output without editing any markup or any other CSS rule.
  3. A theme switch mechanism is wired and demonstrable — flipping the `data-theme` attribute on `<html>` (and/or visiting with `?client=` per the discuss-phase decision) causes the active token set to switch.
  4. The app, with no `data-theme` set, still renders the existing indigo / slate / Fraunces identity exactly as it did before this phase (no visual regressions while the contract is being built).
**Plans**: 1 plan
- [x] 01-01-PLAN.md — Establish theme contract in `<head>`: token `<style>` (`:root` defaults), Tailwind config rewrite (RGB-triplet + `<alpha-value>`), FOUC `<script>` for `?client=` switch, zero-visual-regression sweep.
**UI hint**: yes

### Phase 2: Overdrive Default Theme Migration
**Goal**: The app's default visual identity is Overdrive end-to-end — every slide, the results page, callouts, and the reference matrix render coherently with no half-old / half-new state, and no dark backgrounds.
**Depends on**: Phase 1
**Requirements**: REQ-overdrive-default-theme
**Success Criteria** (what must be TRUE):
  1. A user opening `index.html` with no theme override sees the Overdrive identity — Space Grotesk display headings, Plus Jakarta Sans body, JetBrains Mono labels, Overdrive accent colors and surface tokens — across all six slides and the results page.
  2. The dark results hero (`#0F172A`) is gone; the results page uses warm off-white surfaces with orange-as-structure (divider bars, orange-backed callouts) for contrast.
  3. The entire app is internally coherent — no surface, control, badge, or card still carries the old indigo / slate / Fraunces identity.
  4. The quiz still behaves exactly as before: same six slides, same scoring, same result strings, same wedge-callout and override-notice logic. A scoring-regression check passes against the existing decision tree.
**Plans**: 6 plans
- [x] 02-01-PLAN.md — Flip :root token values to Overdrive defaults + rewire Tailwind config (add surface.elev + yellow namespace, delete surface.dark/dark-card, flip display fontFamily fallback). Blocks 2+3 per RESEARCH.md.
- [x] 02-02-PLAN.md — Swap Google Fonts <link> from Fraunces to Space Grotesk (single-line edit; high-stakes V-2c + V-7 verify). Block 4.
- [x] 02-03-PLAN.md — Migrate 18 Cat B literal sites in component <style> to var-driven references (resting borders + text colors + hover-state alpha-derived per D-11 + selected-state per Phase 1 catalog). Block 5.
- [x] 02-04-PLAN.md — Retire dark hero + migrate results page region (main result card on white with orange left-border, two callouts with orange top-strips, golden-yellow warning icon, PLS badge/icon Light Yellow, footer warm with orange top-rule, three D-05 orange section dividers). Block 6.
- [x] 02-05-PLAN.md — Conditional D-13 typography decision (R-3 checkpoint, 0/1/2 markup edits) + V-9 6-path scoring regression + V-3/V-7 phase-end gates. Blocks 7+8.
- [x] 02-06-PLAN.md — Gap-closure for BL-01: re-anchor --neutral-50-rgb to 250 243 233 (#FAF3E9) so bg-slate-50 surfaces differentiate from bg-surface-warm parents; amend 02-VALIDATION.md V-11 to assert surface-differentiation (catches this regression class going forward). Per code-review Option A; user-scoped to BL-01 only (WR-01..06 deferred).
**UI hint**: yes

### Phase 3: Second Theme Stub & Pluggability Proof
**Goal**: A second client theme exists as a small override block, and switching to it produces a visibly distinct, internally coherent rendering — proving that a future client rebrand requires only a new theme block, not markup edits.
**Depends on**: Phase 2
**Requirements**: REQ-stub-second-theme
**Success Criteria** (what must be TRUE):
  1. A second theme (e.g. Alchemist) exists as an override block on `data-theme="<client>"` with placeholder token values that are visibly distinct from Overdrive defaults.
  2. Activating the second theme (via attribute and/or URL param per the Phase 1 decision) re-skins all six slides + results + reference matrix coherently — no element falls back to Overdrive defaults mid-page.
  3. Switching back to default cleanly restores the Overdrive identity with no residual state (no stuck colors, no flash of unstyled content).
  4. No markup was edited to add the second theme — the entire change is contained in token overrides at the top of `index.html`.
**Plans**: 2 plans
- [ ] 03-01-PLAN.md — WR-01 fix pre-cursor: flip `background: white;` → `background: rgb(var(--surface-elev-rgb));` at index.html lines 180 + 210 (`.answer-card` + `.check-card` resting). Atomic single-task plan mirroring 02-06 gap-closure shape; eliminates the only known hardcoded-white card surface so the Alchemist theme renders without frankenstein white-on-teal cards. (Wave 1, autonomous)
- [ ] 03-02-PLAN.md — Alchemist override block + Google Fonts `<link>` edit + three URL-load VALIDATION rigs. Insert `[data-theme="alchemist"]` block (full 15-color + 2-font override per CONTEXT D-02) after `:root` close at line 85. Prepend `IBM+Plex+Serif:wght@400;600;700` to the existing combined Google Fonts `<link>` per Phase 1 D-16. Three D-04 VALIDATION scenarios: (a) `?client=alchemist` Alchemist render, (b) bare URL Overdrive zero-regression, (c) switch-back restore. D-14 browser-verify gate after `<link>` edit. (Wave 2, depends on 03-01, has manual-browser-verify checkpoints)
**UI hint**: yes

## Progress

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Theming Architecture Foundation | 1/1 | Complete   | 2026-05-15 |
| 2. Overdrive Default Theme Migration | 6/6 | Verified   | 2026-05-16 |
| 3. Second Theme Stub & Pluggability Proof | 0/2 | Ready to execute | - |

## Project-Wide Constraints

These are NOT phases — they are architectural rules that govern every phase. Full text in `PROJECT.md` under "Constraints":

- REQ-single-file-no-build — stay single-file, no build step
- REQ-no-dark-backgrounds — no dark backgrounds, orange-as-structure on warm off-white
- REQ-theme-contract-css-vars — theme contract = CSS custom properties
- REQ-tailwind-points-at-vars — Tailwind utilities resolve through CSS vars
- REQ-structure-skin-separation — all brand tokens at top of file, in one place
- REQ-theming-visual-only — scoring logic and copy are shared, not themed

## Open Questions (for `/gsd-discuss-phase 1`)

These are intentionally NOT requirements. They are flagged for resolution during discuss-phase on Phase 1 (since they all shape the theming contract itself). Promote answers into Phase 1's `CONTEXT.md` before planning.

1. **Theme switch mechanism** — `data-theme` attribute, `?client=` URL param, or both. (If both, which is canonical and which is a shortcut?)
2. **Where the active theme is selected** — hardcoded default, URL only, build-time, host-based.
3. **Warm-gray treatment** — remap the ~101 `slate-*` utility usages to a warm-neutral scale, or tokenize them as part of the theme contract.
4. **How client themes are stored / documented** — so non-engineers can add one later (inline block at top of `index.html` vs. some lightweight registry pattern).
5. **Minimum viable brandable token set** — colors only, or also fonts / radii / spacing.

## Out of Scope (carried from `PROJECT.md`)

- EXCL-real-client-themes — only the stub second theme is in scope
- EXCL-per-client-copy — theming is visual only
- EXCL-scoring-or-flow-changes — no changes to `calculateScore()`, slide structure, or answer model
