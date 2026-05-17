# PLG Readiness Diagnostic

An interactive diagnostic that helps B2B SaaS founders determine the right go-to-market motion for their product — Pure PLG, Product-Led Sales, Sales-Led, or a Wedge strategy. Six questions, one recommendation, with the reasoning shown.

## Abstract

Founders treat product-led growth as a strategic choice. It isn't. The shape of your sales model is downstream of a decision you made much earlier — **the problem you chose to solve.**

The problem carries its own gravity. It determines who feels the pain, who controls the budget, how the product spreads, and how much has to be true before someone will pay. A problem that an individual practitioner can feel, evaluate, and adopt on their own pulls toward PLG. A problem that only a committee can recognize — where the buyer is the C-suite and the scope is enterprise-wide — pulls toward sales, no matter how elegant the product or how badly the founder wants a self-serve motion.

So you don't get to *choose* PLG. You either chose a problem that requires it, or you didn't. The motion is a consequence, not a strategy.

This tool makes that consequence visible. It asks about the problem — the buyer, the spread mechanics, the scope — and surfaces what those answers already imply about the motion. Some answers act as hard overrides: a C-suite buyer or enterprise-wide scope forces a sales-led recommendation regardless of everything else, because no amount of product polish changes who has to say yes. The remaining signals (accelerators and friction points) only modify the result within the range the problem actually allows.

The goal isn't to talk a founder into or out of PLG. It's to stop the guessing — to replace "we want to be product-led" with a clear-eyed read of whether the problem they picked will let them.

## What it does

A founder answers six questions across two phases:

- **Phase 1 (three questions)** — who buys and uses the product, whether it spreads virally, and the scope of the problem. These answers can force a result on their own.
- **Phase 2 (two questions)** — accelerators that favor PLG and friction points that resist it. These only refine the result within a PLG-viable range.

The output is a recommended motion with reasoning, plus a callout when the answers signal a wedge opportunity — a case where the broader problem demands sales, but a narrow entry point could still be product-led.

## Running it

No build step, no package manager. It's a single static `index.html`.

```bash
# Serve it
python3 -m http.server 8080
# then visit http://localhost:8080

# Or just open the file
open index.html
```

## Themes

The app's entire visual identity is swappable per client via a CSS-variable theme contract. Changing one override block re-skins everything — no markup edits.

### Built-in themes

- **Overdrive** (default, no flag) — `http://localhost:8080`
  Orange accent on warm off-white. Space Grotesk display, Plus Jakarta Sans body, JetBrains Mono labels.
- **Alchemist** (stub demo) — `http://localhost:8080/?client=alchemist`
  Deep teal accent on cool near-white. IBM Plex Serif for both display and body. Placeholder values — not from real Alchemist brand specs.

### How theme switching works

The URL `?client=<slug>` is read by an inline FOUC `<script>` (first executable child of `<head>`, lines 7–12 of `index.html`) that sets `data-theme=<slug>` on `<html>` synchronously **before first paint** — no flash of unstyled content, no server-side rendering. Tailwind utilities then resolve through `var(--<token>-rgb)` lookups that match the active `data-theme` block (or fall through to `:root` if none is set).

Unknown or missing slug silently falls through to the `:root` Overdrive defaults. No error, no broken state.

**The `?client=` switch requires serving over HTTP.** Opening `index.html` directly via `file://` works but the query string isn't parsed by some browsers — you'll always see Overdrive. Run `python3 -m http.server 8080` (per "Running it" above) to use theme switching.

### How to add a new theme

The theme contract `<style>` block lives at lines 13–125 of `index.html`. Inside it:

- The `:root` block (lines 48–85) is the Overdrive default — don't edit this unless you're changing Overdrive.
- The `[data-theme="alchemist"]` block (lines 88–124) is the template to copy.

Steps:

1. Copy the entire `[data-theme="alchemist"]` block.
2. Change the selector to your slug — e.g. `[data-theme="acme"]`. Slug is lowercase, dash-separated.
3. Override the tokens you want to change. Anything you leave out inherits from `:root`.
4. If your theme needs a new font, extend the combined Google Fonts `<link>` at line 168 — add `&family=Your+Font:wght@400;600;700` to the existing `href`. **Do not add a second `<link>` tag.**
5. Visit `http://localhost:8080/?client=<your-slug>` to test.

#### Critical: color tokens must be space-separated RGB triplets

```css
/* Correct — works with Tailwind alpha utilities */
--accent-rgb:      13 148 136;
--neutral-800-rgb: 30 41 59;

/* Wrong — silently breaks every bg-accent/10, bg-slate-800/50, etc. */
--accent-rgb: #0D9488;
```

Tailwind utilities like `bg-accent/10` expand to `rgb(var(--accent-rgb) / 0.1)`. The `var()` substitution only produces valid CSS if the value is three space-separated integers. Using hex strings silently breaks every alpha modifier in the app — the page still renders, but `/10`, `/50`, etc. produce no fill. Visual UAT won't necessarily catch this if the test page doesn't exercise an alpha-on-accent surface, so verify alpha modifiers explicitly when adding a new theme.

For fonts, use full CSS font stacks — e.g. `'IBM Plex Serif', serif`.

### Project-wide rules

The theming system rests on a small set of load-bearing invariants (single-file no-build, no dark backgrounds, theming visual only, structure/skin separation, cascade-fallback for unknown slugs, single combined Google Fonts `<link>`). All of them live in [`.planning/PROJECT.md`](./.planning/PROJECT.md) under "Constraints" — that's the source of truth. Don't restate the rules in a theme; reference them from there.

For depth on the original design decisions (16 decisions locked during Phase 1, covering token naming, RGB triplet rationale, cascade fallback, `<head>` ordering, font-link consolidation, etc.), see [`.planning/phases/01-theming-architecture-foundation/01-CONTEXT.md`](./.planning/phases/01-theming-architecture-foundation/01-CONTEXT.md).

## How it's built

Everything lives in `index.html` — markup, styling (Tailwind via CDN), and logic (one inline `<script>`). This is intentional: no build system keeps the tool trivially deployable and editable.

For a deeper walkthrough of the architecture, slide flow, and scoring logic, see [`HOW_IT_WORKS.md`](./HOW_IT_WORKS.md).

## Repository layout

- `index.html` — the entire application
- `docs/design/` — design system references; read before making UI changes
- `reference/` — unrelated structural reference code
- `.planning/` — GSD planning and codebase analysis artifacts
