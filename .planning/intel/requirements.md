# Requirements (Synthesized Intel)

Extracted from classified PRDs. Each entry includes provenance (`source:`) so downstream consumers can trace back to the original doc. Acceptance criteria are quoted verbatim from the source where possible.

> Synthesizer note: `plan.md` is classified type=PRD with `locked: false` at the document level, but the embedded **"Locked decisions"** section is flagged by the classifier (`notes` field) as hard constraints that the project owner intends to be settled. Each bullet in that section is extracted below as a separate requirement with `kind: locked-constraint`. Downstream (`gsd-roadmapper`) should treat these as non-negotiable; if any later doc contradicts one, surface as a conflict rather than auto-resolve.

---

## Locked constraints (from `plan.md` → "Locked decisions")

### REQ-single-file-no-build
- kind: locked-constraint
- source: plan.md ("Locked decisions" §)
- scope: build/deployment architecture
- description: Theming work must not introduce a build step or change the single-file deployment model.
- acceptance criteria:
  - "Stay single-file, no build step. Theming must work within `index.html` + CDN deps."

### REQ-no-dark-backgrounds
- kind: locked-constraint
- source: plan.md ("Locked decisions" §)
- scope: visual identity / surfaces
- description: The rebrand drops the dark results hero. Contrast is carried by orange-as-structure on warm off-white, deliberately deviating from Overdrive's "dark sections for rhythm" guidance.
- acceptance criteria:
  - "No dark backgrounds. Drop the dark results hero (`#0F172A`)."
  - "Carry contrast with orange-as-structure (divider bars, orange-backed callouts) on warm off-white."
  - "This is a deliberate deviation from Overdrive's 'dark sections for rhythm' guidance."

### REQ-theme-contract-css-vars
- kind: locked-constraint
- source: plan.md ("Locked decisions" §)
- scope: theming architecture / token contract
- description: The brandable surface is a set of CSS custom properties in a single `:root` block. Client themes are override blocks applied via a `data-theme` attribute (URL `?client=` switch acceptable too).
- acceptance criteria:
  - "Theme contract = CSS custom properties."
  - "Every brandable token (`--accent`, `--accent-hover`, `--surface`, `--text`, `--font-display`, `--font-body`, etc.) defined in a single `:root` block."
  - "A client theme is a small override block applied via `data-theme=\"<client>\"` on `<html>` (URL `?client=` switch is acceptable too)."

### REQ-tailwind-points-at-vars
- kind: locked-constraint
- source: plan.md ("Locked decisions" §)
- scope: Tailwind config / utility resolution
- description: Tailwind utilities must resolve through the CSS-variable theme contract. No raw hex values in markup.
- acceptance criteria:
  - "Tailwind config points at the CSS vars (e.g. `accent: 'var(--accent)'`) so utility classes resolve per-theme."
  - "Markup references tokens only — never raw hex."

### REQ-structure-skin-separation
- kind: locked-constraint
- source: plan.md ("Locked decisions" §)
- scope: file structure / token location
- description: All brand tokens live in one place at the top of the file. This is the load-bearing rule that prevents a "frankenstein" half-old/half-new state on future client themes.
- acceptance criteria:
  - "Structure / skin separation. All brand tokens live in one place at the top of the file."
  - "This is the rule that prevents frankenstein on every future client."

### REQ-theming-visual-only
- kind: locked-constraint
- source: plan.md ("Locked decisions" §)
- scope: theming surface (what is/isn't themed)
- description: Theming layer is visual only. Scoring logic and copy stay shared across clients in this milestone.
- acceptance criteria:
  - "Theming is visual only."
  - "Scoring logic and copy stay shared across clients in this scope."

---

## In-scope requirements (from `plan.md` → "Scope for this milestone")

### REQ-build-theming-architecture
- kind: in-scope
- source: plan.md ("Scope for this milestone" §)
- scope: theming architecture
- description: Build the theming architecture: CSS-variable contract + Tailwind wiring + theme switch mechanism.
- acceptance criteria:
  - "Build the theming architecture (CSS-variable contract + Tailwind wiring + switch mechanism)."

### REQ-overdrive-default-theme
- kind: in-scope
- source: plan.md ("Scope for this milestone" §)
- scope: default theme migration
- description: Convert the existing app to the theming architecture with Overdrive as the default theme (replaces current indigo/slate + Fraunces identity).
- acceptance criteria:
  - "Convert the app to that architecture with Overdrive as the default theme."

### REQ-stub-second-theme
- kind: in-scope
- source: plan.md ("Scope for this milestone" §)
- scope: theme-system proof
- description: Add one stub second theme (e.g. Alchemist) to prove the system works. Placeholder values are acceptable in this milestone; sourcing real client brand specs is a separate data task.
- acceptance criteria:
  - "Add one stub second theme (e.g. Alchemist) to prove the system works."
  - "Placeholder values are fine; real client brand specs are a separate data task."

---

## Scope exclusions (from `plan.md` → "Out of scope")

These are explicit non-goals for this milestone. Downstream planning must not pull them into phase scope without an explicit re-scope.

### EXCL-real-client-themes
- source: plan.md ("Out of scope" §)
- note: "building real themes for every client (needs their brand specs)" — only the stub second theme is in-scope; real per-client themes wait on brand-spec data.

### EXCL-per-client-copy
- source: plan.md ("Out of scope" §)
- note: "per-client copy/content variation" — theming is visual only (see REQ-theming-visual-only); copy/content stays shared.

### EXCL-scoring-or-flow-changes
- source: plan.md ("Out of scope" §)
- note: "any change to scoring logic or quiz flow" — the rebrand is a skin change only; `calculateScore()`, slide structure, and answer model are off-limits.
