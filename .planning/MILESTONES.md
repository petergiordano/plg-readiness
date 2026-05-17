# Milestones

## v1.0 — Rebrand + Multi-Client Theming

**Shipped:** 2026-05-17
**Branch merged:** `rebrand-theming` → `main` (PR #1, merge commit `730da5d`)
**Stats:** 3 phases · 9 plans · 17 tasks · 87 commits · 52 files changed · +11,528 / −102 LOC
**Timeline:** 2026-05-15 → 2026-05-17 (3 days)
**`index.html` diff:** +190 / −68

### Key accomplishments

1. **Theming contract (Phase 1)** — Single `:root` block with 23 brandable tokens, FOUC `<script>` that applies `?client=<slug>` before paint, Tailwind config rewritten to resolve every utility through CSS vars (zero raw hex in markup; `<body>` untouched).
2. **Overdrive default identity (Phase 2)** — `:root` flipped to Overdrive orange-on-warm-off-white across all 6 slides + results + reference matrix; dark hero retired in favor of orange-as-structure; Space Grotesk swapped in for Fraunces via single-line Google Fonts edit; V-9 6-path scoring regression confirms `calculateScore()` byte-identical to pre-rebrand.
3. **Theme pluggability proven (Phase 3)** — `[data-theme="alchemist"]` override block delivers full 15-color + 2-font swap via URL `?client=alchemist`; IBM Plex Serif added to combined Google Fonts `<link>` per Phase 1 D-16; three D-04 VALIDATION rigs (alchemist render, bare-URL zero-regression, switch-back restore) all PASS via Chrome MCP.
4. **Architectural rules locked in `PROJECT.md`** — single-file no-build, no dark backgrounds, theme contract = CSS vars, Tailwind via vars, structure/skin separation, theming visual-only. Govern every future phase.
5. **Verification rigor** — V-1 through V-11 all green; Phase 3 added prime UAT + coach D-NN audit on top of automated checks. One V-4 runtime ReferenceError caught + corrected with the empirical-probes lesson captured in `~/.claude/lessons.md`.

### Requirements satisfied

- ✓ REQ-build-theming-architecture → Phase 1
- ✓ REQ-overdrive-default-theme → Phase 2
- ✓ REQ-stub-second-theme → Phase 3

### Archives

- `.planning/milestones/v1.0-ROADMAP.md`
- `.planning/milestones/v1.0-REQUIREMENTS.md`

### Known carry-forward (deferred WR-02..06)

Overdrive-internal contrast/cosmetic warnings logged in Phase 2's `02-REVIEW.md` were intentionally deferred — not D-02 violations, not second-theme frankenstein risks (confirmed by Phase 3 context scout). Candidates for a future polish phase.

---
