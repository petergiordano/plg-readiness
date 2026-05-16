# Phase 3: Second Theme Stub & Pluggability Proof - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-16
**Phase:** 3-second-theme-stub-pluggability-proof
**Areas discussed:** Stub theme identity & value source, Override depth, WR-01 handling, Switching mechanism scope

---

## Stub theme identity & value source

| Option | Description | Selected |
|--------|-------------|----------|
| Alchemist — real name, placeholder values | Slug = `alchemist`. Uses Alchemist as the stub identity since they're the most natural 'second client' in Pete's stable (after Overdrive). Values are placeholder/synthetic (planner picks a deliberately-distinct accent + surface + neutral ramp). Sourcing real Alchemist brand specs stays out of scope per EXCL-real-client-themes. Future milestone can replace placeholders with real specs without restructuring the block. | ✓ |
| Generic placeholder — fictional name, fictional values | Slug = `stub` or `demo` or `client-b`. Clearly fictional — no risk of being mistaken for a production Alchemist theme. Values deliberately distinct (e.g., teal accent + cool-gray neutrals + serif display). Trade-off: when a real client theme ships later, you'll likely rename the slug, requiring re-renaming the block divider + URL examples in the recipe comment. | |
| Different real client (SkyDeck / L2L / Scale VP / Berkeley) | Pick a different client from Pete's stable as the stub. Same as Alchemist option but for a different name. | |

**User's choice:** Alchemist — real name, placeholder values (Recommended)
**Notes:** Captured as D-01. Alchemist is the natural second client in Pete's advisory stable. The "real name + placeholder values" hybrid avoids EXCL-real-client-themes scope creep while raising the bar on the placeholder values themselves — they should look brand-plausible enough that the running app at `?client=alchemist` reads as intentional, not demo-cartoony.

---

## Override depth (colors-only vs colors + fonts)

| Option | Description | Selected |
|--------|-------------|----------|
| Colors + fonts (full contract exercise) | Override accent + surface + surface-elev + text + text-muted + border + full neutral ramp + secondary palette + display + body fonts. Adds a new Google Font to the existing `<link>` per D-16 — first time the 'all theme fonts preloaded together' pattern is exercised with two themes. Most complete proof. Trade-off: bigger `<link>`, slightly slower first paint. | ✓ |
| Colors only (lean on D-15 cascade) | Override colors only. Fonts inherit from `:root` per Phase 1 D-15. Proves the cascade explicitly — Alchemist renders 'Overdrive fonts with Alchemist colors.' Smaller diff, no Google Fonts edits. Trade-off: D-16's two-fonts-in-one-link pattern stays unproven. | |
| Both — full Alchemist + minimal cascade-proof stub | Ship two override blocks: full Alchemist AND a tiny second stub (e.g. `accent-only`) that overrides only `--accent-rgb` to prove D-15 cascade explicitly. Most rigorous proof but ~30% more work. | |

**User's choice:** Colors + fonts (full contract exercise) (Recommended)
**Notes:** Captured as D-02. Full contract exercise means every token slot in the Overdrive `:root` gets a matching Alchemist override (15 color tokens + at least `--font-display` and `--font-body`). The new Google Font appends to the existing `<link>` href per Phase 1 D-16 — Phase 3 is the first test of that multi-theme load pattern.

---

## WR-01 handling (hardcoded white card backgrounds)

| Option | Description | Selected |
|--------|-------------|----------|
| First plan inside Phase 3 (pre-cursor) | Plan 03-01 = WR-01 fix as a 1-task plan: flip `background: white` → `rgb(var(--surface-elev-rgb))` at lines 180 + 210. Lands BEFORE the Alchemist override block is added. Mirrors the 02-06 gap-closure pattern. Clean separation: one commit fixes the contract violation, the next plan starts the Alchemist work on a clean slate. | ✓ |
| Folded into the Alchemist override plan | WR-01 fix happens inline as part of the same plan that adds the Alchemist block. One commit (or two atomic commits inside the same plan). Saves one plan-level orchestration step. Trade-off: bundles a D-02-violation fix with a new-feature add — harder to revert independently. | |
| Surface as visible defect (renegotiates SC #2) | Ship the violation visibly under Alchemist as concrete proof that WR-01-class violations get caught by the second-theme proof itself. Requires editing SC #2 in ROADMAP.md. Not recommended — contradicts the milestone's 'no frankenstein' load-bearing principle. | |

**User's choice:** First plan inside Phase 3 (pre-cursor) (Recommended)
**Notes:** Captured as D-03. SC #2 forces the fix; the only real choice was placement. The 02-06 atomic-commit precedent makes the pre-cursor pattern natural. Plan 03-01 is a 1-task plan with single-line edits at lines 180 + 210; subsequent plans handle the Alchemist override block on a clean D-02-compliant slate.

---

## Switching mechanism scope (URL-load vs runtime toggle)

| Option | Description | Selected |
|--------|-------------|----------|
| URL-load only — matches D-01 | VALIDATION rigs cover three URL-load scenarios: (a) `?client=alchemist` → Alchemist render, (b) bare URL → Overdrive render, (c) `?client=alchemist` then bare URL → Overdrive restored. Matches Phase 1 D-01 exactly. Runtime `setAttribute('data-theme', X)` toggle not validated. CSS-var cascade re-paints mechanically on attribute change in all modern browsers — future dev-mode UI should 'just work.' | ✓ |
| URL-load + runtime toggle (broader scope) | All the URL-load rigs above PLUS a runtime test: open Overdrive, run `document.documentElement.setAttribute('data-theme', 'alchemist')` in DevTools, confirm full re-skin without FOUC; toggle back, confirm full Overdrive restore. Validates the runtime claim explicitly so future dev-mode UI work has a proven foundation. More VALIDATION rigs to write + run. | |

**User's choice:** URL-load only — matches D-01 (Recommended)
**Notes:** Captured as D-04. Three rigs anchor SC #3 validation. Runtime toggle is mechanically browser-handled (CSS-var cascade); explicit validation deferred to whatever future phase introduces a theme-switcher UI affordance (out of scope for this milestone).

---

## Claude's Discretion

The user committed to direction; planner/researcher derive specifics within bounds:

- Exact Alchemist placeholder hex values for every color token. Constraints: visibly distinct from Overdrive orange-on-warm-off-white (different hue family); internally coherent; brand-plausible (looks like a real B2B brand could ship it, not neon/safety-orange). Suggested direction: deep saturation like burgundy / deep teal / indigo / slate-blue paired with a cool neutral ramp.
- Choice of new Google Font for `--font-display` (and optionally `--font-body`). Must be visibly distinct from Space Grotesk's geometric-sans aesthetic. Within Google Fonts roster only.
- Whether Alchemist's `--font-body` swaps too, or only `--font-display`. Recommended: swap both for completeness; display-only acceptable if payload becomes a concern.
- Exact plan count + split for the Alchemist work (Plan 03-02, 03-03, etc.). Plan 03-01 = WR-01 fix is locked first per D-03. Remaining work split is planner discretion.
- Exact `<link>` href format for adding the new Alchemist font alongside the existing three fonts.
- Whether to add an in-file comment under the existing "HOW TO ADD A CLIENT THEME" recipe (lines 14–45) citing the Alchemist block as a worked example. Recommended yes.

## Deferred Ideas

Captured in CONTEXT.md `<deferred>` section. Highlights:

- Real Alchemist brand specs sourcing (EXCL-real-client-themes; future milestone)
- A third "minimum-viable" stub theme to prove D-15 cascade explicitly (rejected in favor of D-02 full-override approach; cascade implicitly proved by D-15 safety net during authoring)
- Runtime `setAttribute('data-theme', X)` toggle validation (deferred per D-04; CSS-var cascade is mechanical)
- Theme-switcher UI affordance (out of scope; future phase if built)
- Additional client theme stubs (SkyDeck, L2L, Scale VP, Berkeley) — out of scope per EXCL-real-client-themes for v1
- Markup rename `slate-*` → `neutral-*` utility names (deferred per Phase 2 D-08)
- WR-02..06 from 02-REVIEW.md (Overdrive-internal contrast/cosmetic; not second-theme frankenstein risks)
- Per-client tunable hover intensity (deferred per Phase 2 D-11)
- Per-theme media queries / dark-mode variants (REQ-no-dark-backgrounds project-wide)
- Build-time per-client deploys (REQ-single-file-no-build project-wide)
- `localStorage` theme persistence (rejected in Phase 1; deterministic-render constraint)
- Any change to scoring logic, slide flow, or copy (EXCL-scoring-or-flow-changes project-wide)
