# Coach state — plg-readiness rebrand

**Last updated:** 2026-05-15
**For:** the next `plg-readiness-coach` Claude Code session after `/clear`.
**Drop into:** read this first, then `cmux read-screen --workspace workspace:29 --surface surface:123` to see where prime is now.

## Role + topology

- You are **plg-readiness-coach**. Peer = **plg-readiness-prime** in cmux `surface:123`, `workspace:29` (workspace name "PLG Readiness").
- No `.cmux-relay.json` exists for this repo — the relay is **not configured here**. You are doing raw `cmux read-screen` (and decidedly NOT `cmux send`) into prime's surface, with Pete acting as the human-in-the-loop carrier of any verdicts.
- Reading prime: `cmux read-screen --workspace workspace:29 --surface surface:123 [--scrollback --lines N]` — **always include `--workspace workspace:29`**; bare `--surface surface:123` errors with `invalid_params: Surface is not a terminal` from a detached coach session.

## Hard rule — never `cmux send` into prime while it's at a menu

Sending text + newline into a Claude Code AskUserQuestion menu does **not** enter the "Type something" freeform field — it discards the text and the newline confirms the **highlighted default option**. Each `cmux send` returns exit 0 the whole time, silently corrupting the menu state. Verified the hard way on 2026-05-15 — prime received two wrong false-premise answers and ran with them until interrupted.

The protocol now models this (cmux-relay.sh SKILL.md §5.3 exit codes 8 + 9, added after the incident), but **the relay is not configured for this repo anyway**. When prime is at a menu and you have a verdict: hand it to Pete here in the coach session as text — Pete carries it into prime's menu. Do not try to drive prime's menu yourself.

Reference: `~/Documents/GitHub/_reusable_resources/cmux-relay/CAPABILITY-GAP-relay-into-interactive-menu.md` — the full writeup of the 4 gaps and 6 recommendations from that incident.

## Where prime is right now

- Repo: `~/Documents/GitHub/plg-readiness-rebrand` (worktree of plg-readiness, branch `rebrand-theming`).
- Workflow: ran `/gsd-discuss-phase 1` → captured CONTEXT.md → cleared → just kicked off `/gsd-plan-phase 1`. Plan-phase is in early research/analysis as of this state save.
- Recent commits on `rebrand-theming`:
  - `dab5797` docs(state): record phase 1 context session
  - `e0a3610` docs(01): capture phase 1 context
  - `b36187d` docs: bootstrap .planning/ from plan.md ingest

## Phase 1 CONTEXT.md — what's locked

Read `.planning/phases/01-theming-architecture-foundation/01-CONTEXT.md` for the canonical list. The 16 decisions D-01 through D-16 cover:
- Switch mechanism: `?client=` URL param → `data-theme` attr; bare URL = Overdrive; unknown = silent fallback (D-01–D-03).
- Brandable token scope: colors + typography only; **semantic single-layer** tokens (D-04–D-06). Exact slug list deferred to planner.
- Slate-utility treatment: `--neutral-50…900` ramp; Tailwind slate palette redirected via CSS-var-resolved entries; **Phase 1 vars hold current slate hex values for zero visual diff** (D-07–D-09).
- Theme storage / DX: single `<style>` at top of `<head>` after the Tailwind config script + before the Tailwind CDN script; comment-divided per-client blocks; inline "how to add a theme" recipe in that `<style>` (D-10–D-11).
- FOUC handling: inline blocking `<script>` as **first child of `<head>`**, sets `data-theme` synchronously from `?client=` before any paint (D-12).
- Tailwind alpha-channel pattern: color tokens declared as **space-separated RGB triplets** (`--accent-rgb: 243 94 31`); Tailwind config resolves via `<alpha-value>` placeholder (`'rgb(var(--accent-rgb) / <alpha-value>)'`) so opacity utilities like `bg-accent/10` keep working (D-13–D-14).
- Missing-token policy: CSS-var cascade only, no JS validation (D-15).
- Font-loading: preload all theme fonts together in the single Google Fonts `<link>` (D-16).

## Coaching contributions already weighed in (so you don't re-litigate)

| Topic | Where it landed | Source |
|---|---|---|
| Push back on prime pre-classifying plan.md as `type=DOC` — let `gsd-doc-classifier` decide; structure reads as **PRD** | Classifier picked PRD; all 6 plan.md "Locked decisions" surfaced as `kind: locked-constraint` REQs in PROJECT.md (REQ-single-file-no-build, REQ-no-dark-backgrounds, REQ-theme-contract-css-vars, REQ-tailwind-points-at-vars, REQ-structure-skin-separation, REQ-theming-visual-only) | Round 1 verdict relayed via Pete |
| Map 4 discuss-phase items → 5 ROADMAP open questions (prime consolidated #1+#2); flag the bundled "switch mechanism + selection" item to make sure both halves get explicit answers | Both halves answered separately in the area-1 sub-turns | Round 2 |
| Pick "Explore more gray areas" (option 2) when prime offered to lock CONTEXT.md after 4 areas | Pete picked option 2 before the full verdict arrived; prime then surfaced 4 more | Round 3 |
| Of prime's 4 additional gray areas: all real, all worth locking. Verified `bg-slate-800/50` exists in `index.html` so the alpha-channel concern (prime's #2) is concrete, not speculative — drove D-13's RGB-triplet pattern | All 4 locked as D-12, D-13/14, D-15, D-16 | Round 4 |
| Recommended adding two prime missed via "Type something": (A) Phase 1's `data-theme` value when only Overdrive theme exists yet, (B) complete utility-family redirect enumeration | (A) handled implicitly by D-08's "zero visual diff" + D-12's FOUC script behavior on missing param; (B) D-06 explicitly defers the slug list to the planner, with D-13/14 establishing the convention. Watch this in PLAN.md — if the planner doesn't enumerate every Tailwind family currently in use (slate, indigo, the 3 font families), that's a coaching catch. | Round 4 |

## Verified environment facts (do not re-verify unless reason to suspect drift)

- `gsd-sdk` → v1.42.1 on PATH; `query <argv...>` works. (Prime's initial "hard blocker" reading was false — an early lesson; if anyone resurrects that premise, it's wrong.)
- `~/.claude/commands/gsd/` legitimately absent — GSD is skills-based now per Pete's global CLAUDE.md.
- `docs/design/design-system-alpha-overdrive.md` is tracked on `rebrand-theming` (18KB, on disk).
- `index.html` alpha modifiers in use: `bg-slate-800/50` (2 instances). This is why D-13's RGB-triplet pattern matters.
- `index.html` non-slate color utilities in use: `bg-indigo-50`, `bg-indigo-100`, `text-indigo-800` (the current accent). Phase 1's Tailwind config must redirect indigo to `--accent-*` too, not just slate to `--neutral-*`.

## What to do on resume

1. Read prime: `cmux read-screen --workspace workspace:29 --surface surface:123 --scrollback --lines 200`.
2. If prime is mid-plan-phase (researcher, pattern-mapper, planner, plan-checker running) — stand by, no coaching needed until PLAN.md surfaces or prime asks a question.
3. If prime asks a question (AskUserQuestion menu visible): **do not `cmux send`** — read carefully, form a verdict, give it to Pete here as text, Pete carries it.
4. When PLAN.md is committed, trust-but-verify against CONTEXT.md's D-01 through D-16. Specifically watch:
   - **The Tailwind-family redirect list** in the plan's Tailwind-config-edit task. If the planner only handles `slate → --neutral-*` and forgets `indigo → --accent-*` + the 3 font families, that's a coaching catch.
   - **D-12 FOUC script ordering** — the inline `<script>` must be the **first child of `<head>`**, before the Tailwind config script. If the plan places it later, the FOUC contract breaks.
   - **D-08 zero-visual-diff invariant** — Phase 1's `--neutral-*` (and `--accent-rgb`, etc.) must hold *current* values. If the plan introduces Overdrive hex anywhere in Phase 1, it's reaching into Phase 2's scope ("frankenstein" risk that the whole milestone exists to prevent).
   - **Single-file / no-build constraint** — any plan task that adds a `package.json`, build step, or external file violates the locked constraint REQs in PROJECT.md.
5. After verifying PLAN.md, if all checks pass, sign off; if any fail, surface specific concrete violations to Pete as a coaching note, citing the D-NN decision the plan violates.

## Capability gap referenced

`~/Documents/GitHub/_reusable_resources/cmux-relay/CAPABILITY-GAP-relay-into-interactive-menu.md` — read once for context if you're going to interact with prime's surface; otherwise the rule above ("never `cmux send` into a menu") is sufficient.
