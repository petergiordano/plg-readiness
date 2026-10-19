# ROADMAP — PLG Readiness Diagnostic

## Milestones

- ✅ **v1.0 Rebrand + Multi-Client Theming** — Phases 1–3 (shipped 2026-05-17). Full detail: [`milestones/v1.0-ROADMAP.md`](milestones/v1.0-ROADMAP.md).
- 🚧 **v1.1 Overdrive Light Reskin** — Phases 4–5 (in progress). Restyle the live six-question tool in Overdrive Light as the default, keep the v1.0 orange look as `?client=alpha`, fix the viral-question wording, scoring unchanged. Source: `docs/plans/v2-overhaul-plan.md` §10 Phase 1 and §11.

## Phases

<details>
<summary>✅ v1.0 Rebrand + Multi-Client Theming (Phases 1–3) — SHIPPED 2026-05-17</summary>

- [x] Phase 1: Theming Architecture Foundation (1/1 plans) — completed 2026-05-15
- [x] Phase 2: Overdrive Default Theme Migration (6/6 plans) — verified 2026-05-16
- [x] Phase 3: Second Theme Stub & Pluggability Proof (2/2 plans) — verified 2026-05-17

Full phase details and success criteria in [`milestones/v1.0-ROADMAP.md`](milestones/v1.0-ROADMAP.md).

</details>

**🚧 v1.1 Overdrive Light Reskin (Phases 4–5) — IN PROGRESS.** Phase numbering continues from v1.0; it does not reset.

- [ ] **Phase 4: Overdrive Light Reskin** - Bare URL renders the whole tool in Overdrive Light (colours, fonts, structural rules); v1.0 orange look moves intact to `?client=alpha`; Alchemist and unknown-slug behaviour hold; viral question reworded
- [ ] **Phase 5: Verification & Docs** - Six-path scoring regression across three themes, WCAG AA contrast, 375px/desktop layout check, and docs updated for Light

## Phase Details

### Phase 4: Overdrive Light Reskin
**Goal**: A visitor opening the bare URL sees the whole tool in Overdrive Light, colours, fonts, and structure, while `?client=alpha` reproduces the v1.0 orange look, `?client=alchemist` still renders the v1.0 stub, and the viral question asks about new users who can be turned into customers.
**Depends on**: Phase 3 (v1.0 theming contract: `:root` token block, FOUC `?client=` script, Tailwind through CSS vars)
**Requirements**: THEME-01, THEME-02, THEME-03, THEME-04, THEME-05, COPY-01
**Success Criteria** (what must be TRUE):
  1. A visitor opening the bare URL sees welcome, all five question slides, the results page, and the reference matrix on a `#F7F9FC` page with white card surfaces and Signal Azure `#1F8EFF` as the lead accent (hover `#0C79E8`, azure text `#0C6FD1`), set in Instrument Sans (400/600) body, Space Grotesk 700 display, and JetBrains Mono for overlines, labels, and keyboard hints, loaded through the single combined Google Fonts `<link>` with no weight 300 and no italics. Orange is no longer the lead accent anywhere.
  2. In that same default view, every card carries a 4px azure rule across its top edge and never a coloured left border; the progress bar and primary buttons are azure; a selected answer card shows an azure border on the `#E8F2FF` tint; at most two non-adjacent azure-tint bands appear per page; golden yellow `#F1C232` and Overdrive blue `#55BFFA` appear only in supporting roles and orange only in status chips; and there is no dark surface or gradient anywhere, including behind the sticky Continue and See Result bars on slides 4 and 5.
  3. A visitor opening `?client=alpha` sees the v1.0 Overdrive Alpha look (orange on warm off-white, Plus Jakarta Sans body) with no visible difference from v1.0 `main` side by side, including the structural edits above. A visitor opening `?client=alchemist` sees the Alchemist stub (teal, IBM Plex Serif) render as it did in v1.0, and an unknown slug such as `?client=nope` shows exactly what the bare URL shows (Overdrive Light).
  4. A visitor reaching slide 2 reads a question asking whether using the product naturally creates new users who can then be turned into customers, with answer option labels worded to match; choosing the same option as in v1.0 (with the same other answers) leads to the same recommendation, because the values stored in `answers.viral` have not changed.
**Plans**: TBD
**Notes**:
- **Sequencing is load-bearing.** Create `[data-theme="alpha"]` by moving today's `:root` values (index.html lines 47–85) into it verbatim BEFORE `:root` is repointed to Light, so `?client=alpha` stays byte-faithful to v1.0. Keep Plus Jakarta Sans in the combined Google Fonts `<link>` for Alpha. Natural internal order: Alpha block, then Light tokens and fonts (criterion 1), then structural rules (criterion 2), then copy (criterion 4). Verify Alpha and Alchemist after each step, not only at the end.
- **Open question (new-token fall-through).** Alchemist overrides every token `:root` defines today (20 colour tokens, display and body fonts) but not `--font-mono`. Any NEW Light-only token (azure tint, status orange, etc.) needs a value that leaves Alchemist and Alpha unchanged. Settle in `/gsd-discuss-phase 4`.
- **Open question (token-driven vs default-scoped structure).** THEME-03 bans gradients and adds 4px azure card rules, while THEME-04 requires Alpha to be indistinguishable from v1.0. Today the sticky bars on slides 4 and 5 use `bg-gradient-to-t` (index.html lines 520 and 556) and section top rules use `border-accent`. Decide whether each structural rule is expressed through a token that Alpha sets back to its v1.0 value, scoped to the default theme only, or confirmed visually identical in Alpha. Settle in `/gsd-discuss-phase 4`.
- COPY-01 is wording only: `data-value` attributes and `calculateScore()` are not touched.
**UI hint**: yes

### Phase 5: Verification & Docs
**Goal**: Light is proven safe to ship: the scoring results are unchanged in all three themes, the Light palette is accessible, the layout holds on a phone, and a contributor can learn the theme setup from the docs.
**Depends on**: Phase 4
**Requirements**: QA-01, QA-02, QA-03, DOCS-01
**Success Criteria** (what must be TRUE):
  1. For each of the six v1.0 scoring paths, the result title, description, wedge callout, and override notice match v1.0 `main` exactly, in Light (bare URL), in `?client=alpha`, and in `?client=alchemist` (18 path-and-theme runs, all passing).
  2. Every text/background pair in the Light theme meets WCAG AA (4.5:1 for body text, 3:1 for large text and UI components), and each of the deferred v1.0 warnings WR-02..06 that still applies under Light is resolved, with the rest recorded as closed, not applicable.
  3. Each of the six slides and the results page shows no horizontal scroll at 375px width and at desktop width, in Light.
  4. A contributor reading `README.md` (themes section), `CLAUDE.md` (design guidelines), and `docs/design/` finds Overdrive Light documented as the default and `?client=alpha` documented as the v1.0 look, and the `PROJECT.md` constraint text matches what shipped.
**Plans**: TBD
**Notes**: Verification-and-docs phase; it builds no new UI, so no `**UI hint**` annotation. Fixes found by QA-02 or QA-03 land here, not as a new phase.

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 1. Theming Architecture Foundation | v1.0 | 1/1 | Complete | 2026-05-15 |
| 2. Overdrive Default Theme Migration | v1.0 | 6/6 | Verified | 2026-05-16 |
| 3. Second Theme Stub & Pluggability Proof | v1.0 | 2/2 | Verified | 2026-05-17 |
| 4. Overdrive Light Reskin | v1.1 | 0/TBD | Not started | - |
| 5. Verification & Docs | v1.1 | 0/TBD | Not started | - |

## Project-Wide Constraints

Architectural rules that govern every phase. Full text in `PROJECT.md` under "Constraints":

- REQ-single-file-no-build — stay single-file, no build step. Holds through v1.1; relaxes in v2.0 to a handful of static files (`index.html`, `app.js`, `questions.js`, `scoring.js`, `styles.css`), still no build step, with Tailwind dropped for the Light kit CSS (`docs/plans/v2-overhaul-plan.md` §11, decisions 3–4)
- REQ-no-dark-backgrounds — no dark backgrounds; azure-as-structure in the default Light theme
- REQ-theme-contract-css-vars — theme contract = CSS custom properties
- REQ-tailwind-points-at-vars — Tailwind utilities resolve through CSS vars
- REQ-structure-skin-separation — all brand tokens at top of file, in one place
- REQ-theming-visual-only — scoring logic and copy are shared, not themed

## Out of Scope (carried from `PROJECT.md`)

- EXCL-real-client-themes — building real themes for every client (needs brand specs as separate data tasks)
- EXCL-per-client-copy — per-client copy / content variation; theming is visual only
- EXCL-scoring-or-flow-changes — no changes to `calculateScore()`, slide structure, or answer model. Single v1.1 exception: COPY-01 rewords the viral question and its option labels; answer values and scoring stay identical.
