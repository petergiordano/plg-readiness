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

## How it's built

Everything lives in `index.html` — markup, styling (Tailwind via CDN), and logic (one inline `<script>`). This is intentional: no build system keeps the tool trivially deployable and editable.

For a deeper walkthrough of the architecture, slide flow, and scoring logic, see [`HOW_IT_WORKS.md`](./HOW_IT_WORKS.md).

## Repository layout

- `index.html` — the entire application
- `docs/design/` — design system references; read before making UI changes
- `reference/` — unrelated structural reference code
- `.planning/` — GSD planning and codebase analysis artifacts
