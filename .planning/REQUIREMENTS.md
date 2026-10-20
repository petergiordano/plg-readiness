# Requirements: v1.1 Overdrive Light Reskin

Source: `docs/plans/v2-overhaul-plan.md` §8, §10 (Phase 1), §11. Design spec:
`~/.claude/identity/overdrive-light-design-system.md` (the "Light guide" below).

Project-wide constraints (single file, no dark backgrounds, CSS-var theme contract, Tailwind
through vars, structure/skin separation, theming visual only) live in `PROJECT.md` and are not
repeated here.

## v1.1 Requirements

### Theme

- [x] **THEME-01**: A visitor opening the bare URL (no `?client=`) sees the whole tool (welcome, five question slides, results page, reference matrix) in Overdrive Light: page `#F7F9FC`, white card surfaces, Signal Azure `#1F8EFF` as the lead accent (hover `#0C79E8`, azure text `#0C6FD1`), ink scale `#16202B` / `#3B4A58` / `#4A5866` / `#5B6B7A`, borders `#E2E8F0` / `#D6DFEA`.
- [x] **THEME-02**: A visitor sees Instrument Sans (400/600) for body text, Space Grotesk 700 for display, and JetBrains Mono for overlines, labels, and keyboard hints, loaded through the single combined Google Fonts `<link>`. No weight 300, no italics.
- [x] **THEME-03**: A visitor sees Light's structural rules applied: cards carry a 4px azure rule across the top edge (never a coloured left border), the selected answer card shows an azure border on the azure tint `#E8F2FF`, the progress bar and primary buttons are azure, at most two non-adjacent azure-tint bands appear per page, golden yellow `#F1C232` and Overdrive blue `#55BFFA` appear only in supporting roles, orange appears only in status chips, and there is no dark surface or gradient anywhere.
- [x] **THEME-04**: A visitor opening `?client=alpha` sees the v1.0 Overdrive Alpha look (orange on warm off-white, Plus Jakarta Sans body) with no visible difference from v1.0 `main`.
- [x] **THEME-05**: A visitor opening `?client=alchemist` sees the Alchemist stub render as it did in v1.0, and an unknown `?client=` slug falls through to Overdrive Light.

### Copy

- [x] **COPY-01**: A visitor reading the viral question (slide 2) sees it ask whether using the product naturally creates new users who can then be turned into customers, with answer option labels worded to match. Answer values stored in `answers.viral` do not change.

### Flow (added 2026-10-19 after Pete's review)

- [x] **FLOW-01**: A visitor answers the 9 accelerators and 9 friction points one question per screen, instead of two checkbox grids. The answers mirror each question: yes/no, or A/B/C where there's a real middle, such as pricing model, setup time and usage frequency. Keys Y/N or A/B/C; auto-advance. Each answer maps to the original accelerator or friction threshold, so scoring is unchanged.
- [x] **FLOW-02**: A visitor sees, below every question, a segment bar and an "n of N · k to go" label for the current part. The top progress bar and the "n / 21" counter cover all 21 questions.

### Quality

- [x] **QA-01**: For each of the six v1.0 scoring paths, the result title, description, wedge callout, and override notice are identical to v1.0 `main` (V-9 regression, run against Light, `?client=alpha`, and `?client=alchemist`).
- [x] **QA-02**: Every text/background pair in the Light theme meets WCAG AA contrast (4.5:1 body, 3:1 large text and UI components). Any of the deferred v1.0 warnings WR-02..06 that still apply under Light are resolved or explicitly closed as not applicable.
- [x] **QA-03**: Each slide and the results page render with no horizontal scroll at 375px width and at desktop width, in Light.

### Docs

- [x] **DOCS-01**: A contributor reading `README.md` (themes section), `CLAUDE.md` (design guidelines), and `docs/design/` finds Overdrive Light documented as the default, `?client=alpha` documented as the v1.0 look, and the PROJECT.md constraint text matching what shipped.

## Future Requirements (v2.0 overhaul)

Tracked in `docs/plans/v2-overhaul-plan.md` §4–§10 (plan Phases 2–6): content and logic spec,
question engine with tracks and branching, Quick Read, Full Diagnostic modules M0–M10, the ten
outputs and export, the "close but different" Dual-Role answer option, the single-file
relaxation, and dropping Tailwind.

## Out of Scope

- **New questions, answer options, or scoring changes.** These belong to v2.0. COPY-01 changes wording only. FLOW-01 changes how the existing 18 items are asked; the items, their count and the scoring are unchanged.
- **Dropping Tailwind or splitting files.** Decided for v2.0 (§11 decisions 3–4). The v1.1 reskin points the existing token contract at Light values so the markup is not rewritten twice.
- **Real client themes beyond the stub.** Still needs brand specs (EXCL-real-client-themes).
- **Self-hosting Instrument Sans.** The Light kit itself loads it from Google Fonts, and no binary is supplied.

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| THEME-01 | Phase 4 | Complete |
| THEME-02 | Phase 4 | Complete |
| THEME-03 | Phase 4 | Complete |
| THEME-04 | Phase 4 | Complete |
| THEME-05 | Phase 4 | Complete |
| COPY-01 | Phase 4 | Complete |
| QA-01 | Phase 5 | Complete |
| QA-02 | Phase 5 | Complete |
| QA-03 | Phase 5 | Complete |
| DOCS-01 | Phase 5 | Complete |
| FLOW-01 | Phase 4 (added) | Complete |
| FLOW-02 | Phase 4 (added) | Complete |

Coverage: 10/10 v1.1 requirements mapped, each to exactly one phase (Phase 4: 6, Phase 5: 4).

## Verification record (2026-10-19)

- **THEME-04, THEME-05:** computed-style fingerprints (colour, background, borders, radius, fonts, shadow, opacity on every element) for 7 states (6 slides + results) match v1.0 `main` exactly for `?client=alpha` and `?client=alchemist`. Motion values for alpha match v1.0. `?client=nonexistent` matches the bare URL.
- **QA-01:** 11 scoring scenarios covering all six result types, with the wedge and override toggles, give an identical hash (`2b2d0f97`) in v1.0, Light, alpha and alchemist.
- **QA-02:** 165 Light text elements across all states meet AA. One failure (the Pure PLG chip, 4.41:1) was fixed.
  - Primary buttons use Azure Ink `#0C6FD1`, because white on `#1F8EFF` is 3.3:1.
  - WR-02 and WR-03 (text contrast) pass under Light.
  - WR-05 (sticky gradient) is gone in Light.
  - WR-06 (warning icon) is fixed with Golden Ink, now 6.84:1.
  - WR-04 (hairline card borders under 3:1) is closed as not applicable. Light specifies `#E2E8F0` borders, and every card is identified by its text.
  - Alpha keeps the v1.0 WR findings by design (THEME-04).
- **QA-03:** no element overflows at 375px or at 1024px on any slide or the results page. One pre-existing overflow ("regulatory/compliance" on slide 5 at 375px) was fixed for every theme.
