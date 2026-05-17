# Context (Synthesized Intel)

Running notes from classified DOC-type docs and from supplemental sections of higher-precedence docs that aren't themselves requirements/decisions/constraints. Keyed by topic, appended verbatim with source attribution.

---

## Topic: Why the rebrand exists

source: plan.md ("Why" §)

The PLG Readiness Diagnostic currently uses a one-off indigo/slate visual identity with a serif display font (Fraunces) and a dark results hero. Three things changed:

1. Adopt the Overdrive design system as the default brand (`docs/design/design-system-alpha-overdrive.md`), which supersedes the old `Overdrive_Brand-Identity-Design-and-Style-Guide.md`.
2. The tool needs to be re-brandable per client — Alchemist, UC Berkeley, Scale VP, and others — without editing markup each time.
3. The rebrand must be coherent end to end (no half-old / half-new "frankenstein" state) and must not use dark backgrounds.

---

## Topic: Goal statement (project north star)

source: plan.md ("Goal" §)

A single-file static app (`index.html`, no build step) where the entire visual identity is driven by a swappable theme layer. Default theme = Overdrive. Adding a new client = adding one theme block, not touching structure or markup.

---

## Topic: Open questions for /gsd-discuss-phase

source: plan.md ("Open questions for GSD discuss-phase" §)

These are explicitly NOT requirements. The project owner has flagged them for resolution during `/gsd-discuss-phase`. Downstream planning must surface and resolve each before promoting to PLAN.md.

- Theme switch mechanism: `data-theme` attribute vs. `?client=` URL param vs. both.
- Where the active theme is selected (hardcoded default, URL, build-time, host-based).
- Warm-gray treatment: remap the ~101 `slate-*` utility usages to a warm-neutral scale, or tokenize them as part of the theme contract.
- How client themes are stored/documented so non-engineers can add one later.
- Minimum viable set of brandable tokens (colors only, or also fonts / radii / spacing).

---

## Topic: Current-state reference

source: plan.md ("Current-state reference" §)

- App: single `index.html` (~924 lines) — markup + inline Tailwind config + inline CSS + inline `<script>`.
- Current accent `#4F46E5`, surfaces `#FAFAF8` / `#0F172A`, fonts Fraunces / Plus Jakarta Sans / JetBrains Mono.
- Note: Plus Jakarta Sans + JetBrains Mono already match Overdrive; only the display font (Fraunces → Space Grotesk) changes.
- Architecture detail: see `HOW_IT_WORKS.md` on the `main` branch.
- Target design system: `docs/design/design-system-alpha-overdrive.md`.

---

## Topic: Cross-references declared by the source PRD

source: plan.md (classifier `cross_refs`)

Documents `plan.md` references but that are NOT in the ingest set. Downstream tooling may pull these in later via a separate ingest pass if needed:

- `docs/design/design-system-alpha-overdrive.md` — target design system (supersedes the older brand guide)
- `Overdrive_Brand-Identity-Design-and-Style-Guide.md` — older/superseded brand guide; reference only
- `HOW_IT_WORKS.md` — architecture detail of the current app
- `index.html` — the codebase target itself (already indexed in `.planning/codebase/`)
