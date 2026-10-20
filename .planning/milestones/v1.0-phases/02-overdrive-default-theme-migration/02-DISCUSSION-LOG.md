# Phase 2: Overdrive Default Theme Migration - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-16
**Phase:** 2-overdrive-default-theme-migration
**Areas discussed:** Dark hero replacement & orange-as-structure, Warm-neutral ramp, Cat D + hover-state literals, Display-font swap depth

---

## Dark hero replacement & orange-as-structure

### Q1.1 — Surface replacing dark results hero (lines 533, 538, 698)

| Option | Description | Selected |
|--------|-------------|----------|
| Same warm off-white as slides (#FFF8F0 throughout) | One continuous surface; maximum coherence; relies on type + orange dividers to differentiate the results section. | ✓ |
| Differentiated elevated surface (e.g. pure white #FFFFFF for results) | Real surface change signals "this is the deliverable, not the form." | |
| Same warm off-white + subtle elevated card surface | Page bg stays warm; result card sits on white elevated with border/shadow. | |

**User's choice:** Same warm off-white as slides (#FFF8F0 throughout).
**Notes:** Locks `--surface-dark-rgb` and `--surface-dark-card-rgb` for retirement. Result card cannot rely on bg contrast — needs explicit border/elevation/orange-edge.

### Q1.2 — Main result card structural treatment (line 538)

| Option | Description | Selected |
|--------|-------------|----------|
| 3px orange left-border on white card | Mirrors current indigo-left-border pattern, swaps color to #FF9000. Card on white with thin neutral border + 3px orange left edge. | ✓ |
| Full-width orange divider bar ABOVE the card | Card becomes clean white; orange bar above spans column width. Most explicit Overdrive "section divider." | |
| Orange-backed top accent strip on the card | Card carries orange as 6–8px band along its top edge. Hybrid of left-border and section-divider. | |

**User's choice:** 3px orange left-border on white card.
**Notes:** Wires `--surface-elev-rgb` (declared in Phase 1 with no Tailwind consumer until now). Lets page-level orange section dividers carry the bigger signature.

### Q1.3 — Wedge + override callout treatment (lines 552, 572)

| Option | Description | Selected |
|--------|-------------|----------|
| Orange-backed top strip on each callout | 4–6px solid #FF9000 band along top edge; white card body below. Differentiated from main card. | ✓ |
| Same 3px orange left-border as main result card | Consistent pattern across all 3 cards. Risk: flattens hierarchy. | |
| Soft-orange-tinted background | Full callout bg in very light orange-warm fill (~#FFF1E0). No border/strip. Most subdued. | |

**User's choice:** Orange-backed top strip on each callout.
**Notes:** Differentiated treatment preserves visual hierarchy — main result is headline, callouts are auxiliary.

### Q1.4 — Footer treatment (line 698)

| Option | Description | Selected |
|--------|-------------|----------|
| Warm bg + orange top rule | Full-width #FF9000 horizontal rule marks the boundary. Sets up orange-section-dividers as page-level pattern. | ✓ |
| Warm bg + thin neutral top divider | Footer dissolves into the page; only a thin neutral hairline marks the boundary. Most minimal. | |
| Slight warm-elevation surface (no divider) | Footer bg shifts to ~5% darker warm tone (#F5EFE5 or similar). Surface change marks the boundary. | |

**User's choice:** Warm bg + orange top rule.
**Notes:** Establishes orange-section-dividers as the page-level boundary signature.

### Q1.5 — Orange section divider at line 601 boundary

| Option | Description | Selected |
|--------|-------------|----------|
| Yes — orange section divider at line 601 too | Consistent page-level pattern: orange dividers at all major content-block boundaries. | ✓ |
| No — only the footer gets the orange rule | Footer-only treatment keeps signature as ceremonial close, not repeating motif. | |
| Yes for line 601, but skip "above result card" | Two orange dividers total: at line 601 and above footer. Avoids redundancy with result-card left-border. | |

**User's choice:** Yes — orange section divider at line 601 too.
**Notes:** Three orange section dividers on results page: above main result card, at line 601 boundary, above footer.

---

## Warm-neutral ramp for --neutral-50..900

### Q2.1 — Ramp direction

| Option | Description | Selected |
|--------|-------------|----------|
| Warm-gray 10-stop ramp throughout | Derive from Overdrive anchors (#FFF8F0, #E5E5E5, #8A8A8A, #666666, #434343). Slight warm undertone. | ✓ |
| Cool slate kept (pragmatic compromise) | Leave Phase 1's slate values as-is. Risk: warm-vs-cool clash fails acceptance #3. | |
| Hybrid — warm 50–300, cool 400–900 | Surfaces warm, text cool. Risk: warm/cool boundary at borders. | |

**User's choice:** Warm-gray 10-stop ramp throughout.
**Notes:** Planner derives specific 10-stop hex values from Overdrive anchors with warm undertone harmonizing with orange accent + #A58E6F brown.

### Q2.2 — Keep full ramp or trim

| Option | Description | Selected |
|--------|-------------|----------|
| Keep full 10-stop ramp | All 10 stops declared in :root even where 700–900 have no current Tailwind consumer. Future-proofs per D-09. | ✓ |
| Trim to actually-used stops (50, 100, 200, 300, 400, 500, 600) | Smaller contract; less to maintain. Risk: future client themes lose darker neutrals. | |
| Keep full ramp but mark 700–900 "reserved" with comment | All 10 stops with inline comment separating "active use" from "reserved." Self-documenting. | |

**User's choice:** Keep full 10-stop ramp.
**Notes:** Honors Phase 1 D-09 ("neutrals are brandable per client"). ~3 unused declarations is negligible cost.

### Q2.3 — Slate utility rename

| Option | Description | Selected |
|--------|-------------|----------|
| Keep `slate-*` utility name in markup | Honors D-07 "no markup edits." Semantic mismatch (reads slate, renders neutral) accepted. | ✓ |
| Rename `slate-*` → `neutral-*` in markup + Tailwind config | ~25–30 markup edits; removes semantic drift; bloats phase scope. | |
| Rename only in component <style> (selective) | No-op — component <style> has no slate-* mentions. | |

**User's choice:** Keep `slate-*` utility name in markup.
**Notes:** ~25–30 markup edits avoided; smaller diff; less regression surface.

---

## Non-tokenized brand-colored utilities (Cat D) + hover-state literals

### Q3.1 — Cat D utilities Overdrive mapping

| Option | Description | Selected |
|--------|-------------|----------|
| Map to Overdrive secondary palette by role | PLS badge bg = Light Yellow #FFE599, fg = Golden Yellow #F1C232. PLS card icon bg = #FFE599. Internally coherent GTM hierarchy. | ✓ |
| Map indigo → accent (orange) everywhere | Flattens GTM motion hierarchy (PLG and PLS both orange). Dilutes orange-as-structural. | |
| Add semantic tokens (--brand-soft, --info, --warning) to :root | Three new tokens; bloats contract significantly. | |
| Hybrid — map indigo to yellow per role + keep amber literal | Same as Recommended for indigo; amber stays as raw Tailwind utility. | |

**User's choice:** Map to Overdrive secondary palette by role.
**Notes:** Internally coherent GTM hierarchy: Pure PLG=orange (lead), PLS=yellow (secondary), Sales-Led=neutral (reserved), Wedge=neutral stronger.

### Q3.2 — Warning icon equivalent (line 575)

| Option | Description | Selected |
|--------|-------------|----------|
| Golden Yellow #F1C232 | Tokenized; same color as PLS badge fg. Internally coherent "caution-flag" color. | ✓ |
| Keep `text-amber-400` as raw Tailwind utility | Decouples warning from brand; future themes don't redefine warning. Less coherent. | |
| Use accent (#FF9000 orange) | Visually consistent with brand. Dilutes orange-as-structural meaning. | |

**User's choice:** Golden Yellow #F1C232.
**Notes:** Warning icon bg (line 574 inline rgba) shifts to soft golden-yellow tint.

### Q3.3 — Hover-state literal handling (lines 177, 190, 210)

| Option | Description | Selected |
|--------|-------------|----------|
| Derive from --accent-rgb via alpha | Replace literals with rgb(var(--accent-rgb) / 0.4) border + rgb(var(--accent-rgb) / 0.06) bg. Zero new tokens; auto-coherent per theme. | ✓ |
| Add semantic tokens (--accent-hover-soft-rgb, --accent-hover-border-rgb) | +2 tokens; each theme tunes hover intensity independently. | |
| Hex literals flipped to orange-tints in component <style> | Keeps literals; doesn't extend contract. Violates D-11. | |

**User's choice:** Derive from --accent-rgb via alpha.
**Notes:** Hover intensity locked across themes (always 6% bg / 40% border of accent). Acceptable trade-off for ≤5–10 client count.

### Q3.4 — Yellow token delivery mechanism

| Option | Description | Selected |
|--------|-------------|----------|
| Add --brand-soft-rgb + --brand-secondary-rgb tokens, remap Tailwind yellow.100/yellow.400 | +2 tokens; brandable per client; uses RGB-triplet + <alpha-value> pattern. | ✓ |
| Add semantic-named tokens (--brand-soft, --brand-secondary) + new "secondary" Tailwind namespace | +2 tokens + new utility name pattern; more vocabulary. | |
| Use Tailwind's default yellow palette (no token, not brandable) | No tokens added; secondary palette NOT brandable per client — violates D-09. | |

**User's choice:** Add --brand-soft-rgb + --brand-secondary-rgb tokens, remap Tailwind yellow.100/yellow.400.
**Notes:** Contract grows from ~13 to ~15 color tokens. Markup uses bg-yellow-100 text-yellow-400.

---

## Display-font swap depth

### Q4.1 — Font swap depth

| Option | Description | Selected |
|--------|-------------|----------|
| Family swap + minimum-viable adjustments | Browser-verify post-swap; adjust ONLY where current scale visibly clashes with Space Grotesk's letterform. Bounded scope. | ✓ |
| Family-only swap (minimal, lowest risk) | Update <link> + flip --font-display. Nothing else changes. Risk: may read less authoritative. | |
| Tune full typographic scale to Overdrive Section 4 | Adjust full scale (Display 56–72px, H1 40–48px, H2 28–32px, H3 22–24px). Bump weights. Risk: typographic redesign. | |

**User's choice:** Family swap + minimum-viable adjustments.
**Notes:** Likely candidates: slide-0 hero text-5xl → text-6xl, font-bold → font-extrabold. Decided post-browser-verify, not pre-locked.

### Q4.2 — Browser-verification cadence

| Option | Description | Selected |
|--------|-------------|----------|
| BEFORE plan locks AND after every <head>-touching execute task | Strict structural mitigation per HANDOFF.json blocking constraint. Research-phase + execute-phase gates. | ✓ |
| Browser-verify after every sub-step that touches <head> | Execute-phase only; skips research-phase gate. Less strict. | |
| Browser-verify ONCE at end of Phase 2 execution (Phase 1 baseline) | Same approach Phase 1 used. Caught V-4 bug but required 3 commits to land first. Does NOT satisfy HANDOFF.json's "before the plan locks" mitigation. | |

**User's choice:** BEFORE plan locks AND after every <head>-touching execute task.
**Notes:** Satisfies HANDOFF.json blocking_constraints_for_phase_2[0] structural mitigation text verbatim. VALIDATION.md must encode as hard verify gate rows, not single end-of-phase sweep.

---

## Claude's Discretion

Captured in CONTEXT.md `<decisions>` under "Claude's Discretion." Summary:
- Specific 10-stop hex values for warm-gray ramp (direction locked in D-06).
- Exact orange tint for `--accent-muted-rgb` Overdrive value.
- Exact orange section divider thickness (D-05).
- Exact callout top-strip thickness within 4–6px range (D-03).
- Exact soft golden-yellow tint hex for warning-icon bg (D-10).
- Whether D-13's "minimum-viable adjustments" land as 0/1/2 changes (decided post-browser-verify).
- Whether the warning-icon bg at line 574 inline-style migrates to utility class or stays inline.

## Deferred Ideas

Captured in CONTEXT.md `<deferred>`. Summary:
- Body weight contrast tuning (400 vs 700 → 200 vs 700–800).
- Full typographic scale redesign to Overdrive Section 4 exact sizes.
- Markup rename `slate-*` → `neutral-*` utility names.
- Per-client tunable hover intensity (semantic hover tokens).
- PLS card icon stroke shift (line 677, currently text-accent).
- Wedge callout inner card bg migration (line 543 inline).
- Phase 3 second theme stub (separate phase scope).
- Per-client real brand specs sourcing (EXCL-real-client-themes).
- Per-client copy variation (EXCL-per-client-copy).
- Scoring / flow / copy changes (EXCL-scoring-or-flow-changes).
- Dark-mode variants (REQ-no-dark-backgrounds).
