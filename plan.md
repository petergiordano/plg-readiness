# Plan: Rebrand + Multi-Client Theming

> Lightweight intent + architecture doc. Meant to be ingested by GSD (`/gsd-import` or
> `/gsd-ingest-docs`) and formalized into phases. Not a task breakdown — GSD owns that.

## Why

The PLG Readiness Diagnostic currently uses a one-off indigo/slate visual identity with a
serif display font (Fraunces) and a dark results hero. Three things changed:

1. **Adopt the Overdrive design system** as the default brand
   (`docs/design/design-system-alpha-overdrive.md`), which supersedes the old
   `Overdrive_Brand-Identity-Design-and-Style-Guide.md`.
2. **The tool needs to be re-brandable per client** — Alchemist, UC Berkeley, Scale VP,
   and others — without editing markup each time.
3. The rebrand must be **coherent end to end** (no half-old / half-new "frankenstein"
   state) and must **not use dark backgrounds**.

## Goal

A single-file static app (`index.html`, no build step) where the entire visual identity
is driven by a swappable theme layer. Default theme = Overdrive. Adding a new client =
adding one theme block, not touching structure or markup.

## Locked decisions

These are settled. GSD should treat them as constraints, not open questions.

- **Stay single-file, no build step.** Theming must work within `index.html` + CDN deps.
- **No dark backgrounds.** Drop the dark results hero (`#0F172A`). Carry contrast with
  orange-as-structure (divider bars, orange-backed callouts) on warm off-white. This is a
  deliberate deviation from Overdrive's "dark sections for rhythm" guidance.
- **Theme contract = CSS custom properties.** Every brandable token (`--accent`,
  `--accent-hover`, `--surface`, `--text`, `--font-display`, `--font-body`, etc.) defined
  in a single `:root` block. A client theme is a small override block applied via
  `data-theme="<client>"` on `<html>` (URL `?client=` switch is acceptable too).
- **Tailwind config points at the CSS vars** (e.g. `accent: 'var(--accent)'`) so utility
  classes resolve per-theme. Markup references tokens only — never raw hex.
- **Structure / skin separation.** All brand tokens live in one place at the top of the
  file. This is the rule that prevents frankenstein on every future client.
- **Theming is visual only.** Scoring logic and copy stay shared across clients in this
  scope.

## Scope for this milestone

- Build the theming architecture (CSS-variable contract + Tailwind wiring + switch
  mechanism).
- Convert the app to that architecture with **Overdrive as the default theme**.
- Add **one stub second theme** (e.g. Alchemist) to prove the system works — placeholder
  values are fine; real client brand specs are a separate data task.

Out of scope: building real themes for every client (needs their brand specs),
per-client copy/content variation, any change to scoring logic or quiz flow.

## Open questions for GSD discuss-phase

- Theme switch mechanism: `data-theme` attribute vs. `?client=` URL param vs. both.
- Where the active theme is selected (hardcoded default, URL, build-time, host-based).
- Warm-gray treatment: remap the ~101 `slate-*` utility usages to a warm-neutral scale,
  or tokenize them as part of the theme contract.
- How client themes are stored/documented so non-engineers can add one later.
- Minimum viable set of brandable tokens (colors only, or also fonts / radii / spacing).

## Current-state reference

- App: single `index.html` (~924 lines) — markup + inline Tailwind config + inline CSS +
  inline `<script>`.
- Current accent `#4F46E5`, surfaces `#FAFAF8` / `#0F172A`, fonts Fraunces / Plus Jakarta
  Sans / JetBrains Mono. Note: Plus Jakarta Sans + JetBrains Mono already match Overdrive;
  only the display font (Fraunces → Space Grotesk) changes.
- Architecture detail: see `HOW_IT_WORKS.md` on the `main` branch.
- Target design system: `docs/design/design-system-alpha-overdrive.md`.
