# Project Retrospective

*A living document updated after each milestone. Lessons feed forward into future planning.*

## Milestone: v1.0 — Rebrand + Multi-Client Theming

**Shipped:** 2026-05-17
**Phases:** 3 | **Plans:** 9 | **Tasks:** 17
**Timeline:** 2026-05-15 → 2026-05-17 (3 days)
**Commits:** 87 (`index.html` diff: +190 / −68)

### What Was Built

- CSS-variable theme contract in `index.html` `<head>` — 23 brandable tokens in one `:root` block, FOUC `<script>` applying `?client=<slug>` before paint, Tailwind utilities resolving through vars.
- Overdrive identity end-to-end — orange-on-warm-off-white across all 6 slides + results + reference matrix; dark hero retired; Space Grotesk swapped for Fraunces via single-line Google Fonts edit.
- Alchemist stub second theme — `[data-theme="alchemist"]` override block with full 15-color + 2-font swap; IBM Plex Serif added to combined Google Fonts `<link>`; three D-04 VALIDATION rigs all PASS.

### What Worked

- **Atomic gap-closure pattern** (first surfaced in Plan 02-06, mirrored in Plan 03-01) — single task, single commit, single source file, single grep gate. Clean way to close a code-review WARNING without conflating with feature scope.
- **Phase 1 D-15 cascade fallback** — making `:root` IS the Overdrive default (no `[data-theme="overdrive"]` placeholder block) eliminated a whole class of bugs where an unknown `?client=` slug would fall into an empty rule block. Worth keeping as a project-wide pattern.
- **Three-rig D-04 validation in Phase 3** — alchemist render + bare-URL zero-regression + switch-back restore caught the full surface that "switching themes" actually involves. Generalize this rig shape for any future theme.
- **Coach-Prime topology in Phase 3** — Pete-as-prime + Claude-as-coach + executor split with coach D-NN audit on Phase 3 added rigor beyond automated checks. Worth re-running on phases with visual/runtime risk.
- **GSD's human-verify gate** (V-4) caught a runtime ReferenceError that grep ordering assertions + plan-checker iterations both missed. The system worked as designed: structural checks are necessary but not sufficient for runtime claims.

### What Was Inefficient

- **REQUIREMENTS.md traceability table never synced** as phases shipped — table still said "Not started" for all 3 at milestone close. Either need a hook that updates the table on phase-verify, or the table should be dropped in favor of pulling status from `STATE.md` / `ROADMAP.md` at archive time.
- **Empirical-probes-on-head-element-ordering anti-pattern** (Phase 1 V-4) — RESEARCH §5 made a present-tense empirical claim ("CDN is defer-equivalent") that was structurally verified via grep ordering but never browser-verified. Cost 1 extra fix commit (00a6b21) + 1 docs correction (a9e5b35). Already codified in `~/.claude/lessons.md` and structurally mitigated for Phase 2 (`<head>`-touching plans require browser-verify in `<verify>` before plan-checker signs off).
- **Plan-verify regex drift from plan-action** (Phase 1 Task 2) — verify regex used literal single space where the prescribed AFTER-shape used multi-space padding; executor's correct implementation under-counted as 0 against the literal regex. Plan-checker iteration 2 didn't catch the inconsistency. Already codified in `~/.claude/lessons.md` (advisory).
- **Pause-WIP commit on rebrand-theming** (commit 334e891) — added `HANDOFF.json` + Phase-3 `.continue-here.md` for resume; commit landed on the branch but the planning files were never merged to main. Not load-bearing (the milestone shipped fine) but it's a small janitorial loose end. Consider whether pause/handoff artifacts should be `.gitignored` or auto-cleaned on ship.

### Patterns Established

- **Atomic gap-closure plan shape** (02-06, 03-01) — single task, single commit, single grep gate. Codify as the standard shape for code-review WARNING follow-ups inside an already-shipped phase.
- **Cascade-fallback semantics for theme switch** (D-15) — `:root` IS the default theme; unknown slugs fall through. No placeholder `[data-theme="<default>"]` block. Project-wide rule from now on.
- **Combined Google Fonts `<link>`** (D-16) — every new theme that adds a font extends the existing single combined `<link>` rather than adding a second `<link>` tag. Keeps `<head>` parsing simple and avoids font-load race conditions.
- **VALIDATION rig as load-bearing future-proofing** — V-11 (surface-differentiation guard) caught a regression class the original gate missed; rigs added during gap-closure stay in the validation suite, they don't go away after the immediate gap closes.

### Key Lessons

1. **Empirical probes must cover the actual claim, not a related claim.** Already in `~/.claude/rules/empirical-probes.md`. Verified again in Phase 1: a probe that exercises grep ordering ≠ a probe that exercises runtime script-load behavior. Worse than no probe — false-confidence signal stops further questioning.
2. **Grep ordering assertions are necessary but NOT sufficient for runtime-behavior claims.** Phase 1 V-4 caught it; Phase 2 plans now require browser-verify for any `<head>` reordering. Codified in `~/.claude/lessons.md` as the empirical-probes-on-head-element-ordering rule.
3. **Verify regex must derive from the plan's prescribed character sequence verbatim.** Use `\s+` for whitespace the plan allows to be aligned/multi-space. Don't author the regex from memory or from analogous-but-different RESEARCH excerpts.
4. **The pre-close artifact audit catches state drift.** This milestone's `gsd-sdk query audit-open` was clear, but the REQUIREMENTS.md trace-table-sync issue should be added to the audit's scope so it surfaces before close, not after.
5. **Two-worktree workflow held up.** `plg-readiness/` (main) + `plg-readiness-rebrand/` (rebrand-theming) ran the entire milestone without a single cross-session collision. Worktree-per-session is the right default.

### Cost Observations

- Model mix: Opus 4.7 (1M context) — primary across all phases. No model switching for this milestone.
- Sessions: ~10+ across discuss → plan → execute → verify → ship for 3 phases. Several pause/resume cycles via `/cstack-pause` / `/gsd-resume-work`.
- Notable: pause/resume protocol via `HANDOFF.json` + `.continue-here.md` worked reliably across context resets. The structured handoff (machine-readable JSON) saved meaningful re-orientation time vs. prose-only continuation notes.

---

## Cross-Milestone Trends

### Process Evolution

| Milestone | Phases | Plans | Key Change |
|-----------|--------|-------|------------|
| v1.0 | 3 | 9 | First full GSD milestone on this project. Established discuss → plan → execute → verify → ship rhythm. |

### Cumulative Quality

| Milestone | V-Hooks | Coverage | Zero-Dep Additions |
|-----------|---------|----------|--------------------|
| v1.0 | V-1 through V-11 (all green) | 3/3 requirements | 0 (no new deps; CDN-only) |

### Top Lessons (Verified Across Milestones)

_Cross-milestone verification requires at least 2 milestones. Promote here when v1.1 ships and a v1.0 lesson recurs._
