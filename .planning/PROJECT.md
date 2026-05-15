# PLG Readiness Diagnostic

## Core Value

An interactive diagnostic that helps B2B SaaS founders determine the right go-to-market motion for their product — Pure PLG, Product-Led Sales, Sales-Led, or a Wedge strategy. Six questions, one recommendation, with the reasoning shown.

The premise: founders treat product-led growth as a strategic choice, but it isn't. The shape of a sales model is downstream of the problem the founder chose to solve. A problem an individual practitioner can feel, evaluate, and adopt on their own pulls toward PLG. A problem that only a C-suite committee can recognize, with enterprise-wide scope, pulls toward sales — no matter how elegant the product. The tool stops the guessing and replaces "we want to be product-led" with a clear-eyed read of whether the problem they picked will let them.

## Target Users

- B2B SaaS founders evaluating GTM motion for an early-stage product
- Operators and advisors helping founders pick a motion (advisors, accelerator program leaders, accelerator faculty)
- Pete's advisory + workshop clientele across Overdrive, Alchemist, UC Berkeley SkyDeck / L2L, Scale VP

## Current Focus

**Milestone:** Rebrand + Multi-Client Theming

The product is shipped on `main` with a one-off indigo/slate + Fraunces visual identity and a dark results hero. This milestone adopts the Overdrive design system as the default brand and makes the entire visual identity swappable per client (Alchemist, UC Berkeley, Scale VP, etc.) by changing one theme block — not by editing markup.

## Constraints

Project-wide architectural rules. These govern how this product is built from now on, not just this milestone. Any future work — features, themes, content — must respect them.

### Single-file, no build step

The app stays a single `index.html` served as a static file. Theming work must operate inside `index.html` + CDN dependencies only. No bundler, no package manager, no compilation. (Source: `plan.md` "Locked decisions" → REQ-single-file-no-build)

### No dark backgrounds

The dark results hero (`#0F172A`) is dropped. Contrast is carried by orange-as-structure (divider bars, orange-backed callouts) on warm off-white. This is a deliberate deviation from Overdrive's "dark sections for rhythm" guidance and applies to all future client themes too. (Source: REQ-no-dark-backgrounds)

### Theme contract = CSS custom properties

Every brandable token (`--accent`, `--accent-hover`, `--surface`, `--text`, `--font-display`, `--font-body`, etc.) is defined in a single `:root` block. A client theme is a small override block applied via `data-theme="<client>"` on `<html>` (URL `?client=` switch is acceptable too). (Source: REQ-theme-contract-css-vars)

### Tailwind utilities resolve through CSS vars

The inline Tailwind config points at CSS vars (e.g. `accent: 'var(--accent)'`) so utility classes resolve per-theme. Markup references tokens only — never raw hex. (Source: REQ-tailwind-points-at-vars)

### Structure / skin separation

All brand tokens live in one place at the top of the file. This is the load-bearing rule that prevents a "frankenstein" half-old / half-new state on every future client theme. (Source: REQ-structure-skin-separation)

### Theming is visual only

The theming layer is visual. Scoring logic, quiz flow, and copy are shared across all clients. `calculateScore()`, the six-slide structure, and the answer model are off-limits to themes. (Source: REQ-theming-visual-only)

## Out of Scope

Explicitly deferred. Do not pull into phase scope without an explicit re-scope decision.

- **Real per-client themes for every client** — needs each client's brand specs as separate data tasks. Only one stub second theme proves the system in this milestone. (EXCL-real-client-themes)
- **Per-client copy / content variation** — theming is visual only; copy stays shared across clients. (EXCL-per-client-copy)
- **Any change to scoring logic or quiz flow** — the rebrand is a skin change. `calculateScore()`, slide structure, the answer model, and result text are not in scope. (EXCL-scoring-or-flow-changes)

## Reference

- Target design system: `docs/design/design-system-alpha-overdrive.md`
- Current architecture detail: `HOW_IT_WORKS.md` on `main`
- Source PRD for this milestone: `plan.md`
- Codebase intel (read-only): `.planning/codebase/`
