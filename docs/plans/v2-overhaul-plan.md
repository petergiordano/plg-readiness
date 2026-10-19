# Plan: v2 overhaul — from PLG quiz to sales-model diagnostic

> Intake doc for GSD (`/gsd-new-milestone`, then `/gsd-discuss-phase`). It records intent,
> content, and locked decisions. GSD owns the task breakdown.
>
> **Sources folded in:** the 2026-10-19 founder working session (notes + transcript, now
> archived out of the repo), the Acme / Google Workspace sales-model story Pete presented
> in that session, the GTM methodology folder (`@Methodologies/compact-mece-gtm-context`),
> and the Overdrive Light design system. Appendix A maps every item in the session notes to
> the section that now carries it, so the source file can go.
>
> **Public repo.** This repo and its GitHub Pages site are public. The founder, the
> company, its customers, and its numbers stay out of every committed file, including
> this one. Session examples below are anonymised.

---

## 1. Why

The live tool (six questions, one result) did its job in the session: walking through it
with a founder made the core idea land. It also showed its limits.

1. **It answers one question, at one moment.** It returns a single label. The founder's real
   situation was "self-serve holds for one rep, and breaks the moment the product needs the
   CRM connector, because then the buyer is the VP of Sales." The tool can't say that.
2. **It asks about the product, not the problem.** The founder's own insight was "take the
   words describing the product out and work backwards from the business rules."
3. **It has no path for an existing product.** The founder had a built product and paying
   customers. The useful question was "what do I decouple?", and the tool has no module for it.
4. **It stops at the verdict.** The session went on to the next move: map a role's tasks,
   find the solo, high-friction ones, check what competitors leave open, and run a $50 test.
   None of that is in the tool.
5. **One question was worded wrong.** Pete corrected it live: "Does product usage naturally
   create new customers?" should be "Does it naturally create new **users** who can then be
   turned into customers?"
6. **Look and feel moves to Overdrive Light.** Azure lead, cool-neutral page, no dark
   surfaces, Instrument Sans body.

## 2. The thesis the tool teaches

**The problem picks the sales model.** You don't choose PLG; you choose a problem, and the
problem decides who feels the pain, who has to approve, and how the product spreads.

Supporting principles, each stated in the session and each owned by a module in §4:

| # | Principle | Module |
| :- | :- | :- |
| P1 | Problem first, features last. Describe the problem without naming a feature. | M1 |
| P2 | Self-serve exists only when user, buyer, and decider are the same person. Any approval (manager, IT, legal, data owner) ends self-serve. | M2 |
| P3 | PLG works when the core job creates another user (Zoom invite, Slack channel, shared output). | M3 |
| P4 | Your customer's customer may not be your customer. A loop that creates the wrong users isn't a loop. | M3 |
| P5 | Product design depends on the customer. One segment wants the application, another wants the data, another the API/MCP. Users buy the benefit, not the tech, and their sophistication sets how much to build. | M4 |
| P6 | Start the wedge with a solo, high-friction task, then map who already serves it. Tasks that only pay off at scale or org-wide (forecasting, high-volume SDR email) aren't wedges. | M5 |
| P7 | Decouple, don't scrap. Ask which part of what you've built one person can use alone. Easy expansion revenue from current customers can hide the scalable entry point. | M6 |
| P8 | Product and distribution are one decision. Meet the user where they already work (email, Slack, their AI agent), and let the entry product advertise the full one. | M8 |
| P9 | Expansion changes the problem, and the buyer changes with it. Gmail → Workspace Standard → Enterprise; Zoom free → Zoom admin, security, and compliance. | M9 |

### The teaching story (Acme / Google Workspace)

This becomes the in-app explainer and replaces the current "Problem Scope Matrix" section.

| Stage | Problem | Product | User | Buyer / decider | Buying process | Sales motion |
| :- | :- | :- | :- | :- | :- | :- |
| Individual | Record my own internal meetings and demos | Gmail + Meet recording to Drive | Gabrielle | Gabrielle (unilateral) | None | Self-serve |
| Team | Share videos on an internal site and collect feedback with surveys | Google Workspace Standard (Sites, Forms) | Gabrielle's team | Maya, the manager | Swipe a card, maybe one inside-sales question | Transactional |
| Enterprise | Secure, managed company-wide collaboration | Workspace Enterprise (Vault, DLP, endpoint management, work insights, compliance) | Whole company | Economic buyer + legal, finance, security, IT | Committee | Enterprise sales |

The point: the customer never "upgraded the product." The **problem** changed, so the buyer
changed, so the sales motion changed. Zoom is the same pattern: free one-to-one meetings
(self-serve) → many users on one domain → an enterprise rep sells admin, security, and
compliance.

The canonical write-up is Example 6 in `FILE_3_GOLD_STANDARD_EXAMPLES.md` (l.190–224), from
Pete's deck "Choosing the Right Sales Model to Unlock Growth" (2024 Q4, slides 15–18). The
in-app version should use the deck's full column set: situation, job, product, user / buyer /
decider, buying requirements, sales motion, buying-group type (Solo → Dual-Role →
Cross-Functional). Two lessons go on screen verbatim in spirit: the trigger for each shift is
the buying group, not account size; and Google runs all three motions at once. A
counter-example sits beside it: **Rhumbix**, where self-serve failed because the foreman who
used the product wasn't the buyer (FILE_3 l.214–224).

## 3. Methodology alignment

The tool should speak the same language as Pete's GTM methodology
(`@Methodologies/compact-mece-gtm-context`), so a founder who uses it and then works with
Pete hears one vocabulary. What carries over:

**Headline rule.** "Product-led growth is a property of a segment, specifically a segment
whose unit of value puts the user and the buyer in the same person" (FILE_2 l.266). So the
tool scores **per segment and per stage**, never "is this company PLG?" FILE_2 calls the
company-level claim a category error.

**One decision seen five ways** (FILE_2 l.268). Job → unit of value → SKU → buying
requirements → buying group → motion. This is the spine of the expansion-path output.

**Output vocabulary.**
- **Four buying-group types** (FILE_1 l.460–467): Solo Buyer, Dual-Role, Single-Department,
  Cross-Functional. Company size compresses them: the same product can meet a Solo Buyer at
  20 people and a Cross-Functional group at 20,000. The founder's "close but different" answer
  is the Dual-Role case.
- **Five sales models** (FILE_1 l.471–477): Freemium (viral), Self-Service, Transactional,
  Enterprise, Enterprise + SE/CE/CS, with AARPA bands and market sizes (mice, rabbits, deer,
  elephants, whales). These replace v1's six result labels as the per-stage verdict.
- **Unit of value** (FILE_1 l.444–454): users (individual / team / company), consumption, or
  actions. The methodology flags consumption and action units as unresolved, which is exactly
  where API and MCP products sit. The tool should ask for it and say so plainly.

**New module the session didn't cover: the economic gate (M10, §4).** The rule-of-thumb table
(FILE_2 l.272–279): self-serve needs more than 10,000 target accounts, AARPA under $10K, a
simple buying group, and a small unit of value. The $10K–$20K AARPA danger zone (FILE_0 §6),
and transactional as "the hardest band to hold." A product can pass user = buyer and still
fail the math, and the tool should say so. When it fails: change the GTM, the product, or the
target customer (FILE_1 l.510–532).

**New result type: "Not yet."** The Premature PLG Trap (FILE_3 l.126): don't build self-serve
checkout or viral loops before the sales-assisted pilot is repeatable. This is the honest
answer for a founder still on the F track with no repeatable pilot.

**Rules that become disqualifiers or warnings.**
- A 90-day-implementation product forced into self-service (FILE_0 l.63) → hard flag in M7.
- Channel–product fit (FILE_0 l.95): if sharing isn't core to the job, a share button is
  useless. This anchors the M3 verdict.
- Borrowed distribution can be pulled back by the platform (COMPANION l.219, l.434) → caution
  on any MCP-marketplace or agent-store entry point in M8.
- Running motions in parallel, not replacing one with another (FILE_2 l.329–341) → the
  expansion output says "add a transactional motion beside self-serve," never "switch."

**Question and wording sources.**
- The 11 buyer roles, each with one identification question (FILE_1 l.85–97, FILE_2
  l.121–133), feed the who-approves picker.
- The founder interview guide's "you're done when" checks and four follow-up moves (why does
  that matter / what has to be true / who else cares / how do you know) become the prompts
  under free-text answers.
- Process maturity (chaotic / manual and breaking / mature, FILE_1 l.159–169) adds a timing
  question to M1.
- Agents as users (COMPANION §10, l.392–396): "if an agent became your primary user tomorrow,
  what could it not do?" joins M8.

**Where the session adds content the methodology lacks.** Value loops (only FILE_0 §5c touches
them), the MECE task inventory and friction scoring for the wedge (the methodology's "wedge"
means beachhead segment, via ECP/SIM), decoupling an existing product, and MCP distribution.
These modules are new content and are good candidates to feed back into the methodology later.

## 4. Question set

Track tags: **[F]** founder still defining the customer and use case · **[E]** existing
product looking for a self-serve entry point · **[B]** both. Input types: **text**,
**choice**, **who-approves** (self / manager / IT / legal / executive / data owner),
**range**, **table** (the task inventory).

### M0. Context capture (all tracks)
Track selector (F or E) · target role · segment · current price (E) · current buyer (E).

### M1. Problem first, features last
1. **[B] text** Describe the problem, and who has it, without naming a feature. _Checked for
   feature words; flags "designing from the product outward."_
2. **[B] choice + text** Describe it as one person's normal workday. Can you do it without
   saying "the team" or "the org"? _Individual → self-serve possible; team/org → buying group._
3. **[B] who-approves ×2** Unsolved for a month: who notices first, and who do they escalate to?
   _Who feels pain vs. who holds budget._
4. **[B] text** What does the problem look like at 10× scope? Who owns it, and what would they
   buy? _Maps the individual → team → enterprise ladder up front._

### M2. User = buyer = decider
5. **[B] choice** Could your ideal first user start today without asking anyone (no IT ticket,
   no expense approval, no data-access request)? _"No" opens Q6–Q8._
   - Answer options must include the session's real answer: **"Close, but different people"**
     (e.g. the user is a rep and the decider is the VP of Sales at a small company).
6. **[B] text + who-approves** First permission, integration, or data source the product needs,
   and who can grant it. _Session case: CRM and call-transcript connectors turned a rep's tool
   into a VP of Sales / CRO sale._
7. **[B] text** What value can a user get using only data they personally own?
8. **[B] choice** Does using the product expose anyone else's data (customers, recipients,
   colleagues)? _Privacy review is a hidden approval gate._
9. **[B] range** Price at which this user won't need to ask permission. _Session anchors:
   under $100/month per account; $15–30 per user per month._

### M3. Value loop — does usage create users?
10. **[B] choice + text** When someone does the core job well, who else sees the output?
    _"Someone" opens Q11–Q13._ **Reworded per Pete's live fix:** the scored question is "Does
    using the product naturally create new users who can then be turned into customers?"
11. **[B] choice** Is that recipient someone you'd want as a customer? _(P4)_
12. **[B] text** What would make a recipient think "I want this for myself," not just "nice document"?
13. **[B] choice** Does the output show who made it (e.g. a shared page that says it's hosted by you)?
14. **[B] choice** Network effects: does the product get better for each user as more join?

### M4. Customer characteristics and product shape
15. **[B] text** What does the target customer already own that makes you necessary or redundant?
16. **[B] per-segment choice** For each segment: do they want your application, your data, or
    your API/MCP?
17. **[B] choice** Which segment's usage makes the product better for the next? _(Session: the
    application enriches the data layer.)_
18. **[B] choice** How sophisticated is the user? Packaged benefit vs. raw access.

### M5. Finding the wedge
19. **[F] table** List every task the target role performs, MECE.
20. **[B] table column** Solo / with internal colleagues / with the customer.
21. **[B] table** Which tasks always run in sequence? Could one product action replace several?
22. **[B] table scores** Friction, cost, time, attention, manual effort (1–5 each).
23. **[B] table text** Who already handles each task, and what do they leave unsolved?
24. **[B] table flag** Pays off only at scale or org-wide? _Disqualifies (forecasting,
    high-volume SDR email: "only works with crazy volume")._
25. **[B] choice** Are incumbents horizontal? Is there an unserved vertical or function gap?

### M6. Decoupling an existing product
26. **[E] text** One feature, one person, no integrations: which still delivers real value?
27. **[E] table** Which parts create the most value, which the most friction? Can you separate them?
28. **[E] text** What does one user teach the product that improves the org-wide version later?
29. **[E] who-approves + range** Who signs today's deals, who uses it daily, and what would the
    daily user pay on their own card?
30. **[E] choice** Is easy expansion revenue from current customers hiding a more scalable entry
    point? _(Session: an easy upsell to one customer was named as the wrong signal.)_

### M7. Onboarding and time to value
_Carried from the current tool's accelerator screen._
31. **[B]** Sign up and get value without talking to anyone?
32. **[B] range** Time to first value (under 15 minutes is the bar).
33. **[B]** Free tier or trial?
34. **[B]** Integrates easily with what the user already uses?

The remaining current accelerators and friction points (clear upfront value prop, guided
activation, scalable pricing, self-serve docs; implementation effort, data-collection lag,
multiple stakeholders, domain expertise, per-customer customization, compliance, complex
explanation, setup fees, infrequent use) are folded into M2, M7, and M8 rather than kept as
two long checklists. Each one maps to a friction gate in the output.

### M8. Distribution
35. **[B] text** If you designed distribution first, what would the product look like? Is that
    different from what you've built?
36. **[B] choice** Where does the user already work (email, Slack, an AI agent)? Could the
    product live there first?
37. **[B] choice** Can the user bring their own compute (their own Claude subscription)? _Cuts
    cost to serve; heavy per-account infrastructure works against a low-price tier._
38. **[B] choice** Can the entry product advertise the full product from inside the workflow
    (e.g. in a tool-call response, or a "paste into your agent" setup block)?
39. **[B] text** Cheapest test that shows strangers want this ($50 ad, public MCP listing,
    landing-page sign-up).

### M9. Expansion path
40. **[B] text** At 10 users in one account, what new problem appears that only the full
    product solves? _(Zoom: admin, security, compliance.)_
41. **[B] text** When does the buying group change? Does pricing and packaging support the handoff?
42. **[E] choice** Will the entry product feed enterprise deals or compete with them?

### M10. Economic gate (from the methodology, §3)
43. **[B] range** How many accounts in the target segment could buy this? (<1K / ~10K / ~100K / millions)
44. **[B] range** Expected annual revenue per account (AARPA), per stage.
45. **[B] choice** Unit of value: per user, per team, per company, consumption, or actions?
46. **[F] choice** Is a sales-assisted pilot repeatable yet? _"No" → the "Not yet" result._

Also added from the methodology: a process-maturity question in M1 (chaotic / manual and
breaking / mature) and the agents-as-users question in M8.

### Branching
- Q5 "no" or "close but different" → Q6–Q8.
- Q10 "someone sees it" → Q11–Q13.
- Track F skips M6 and Q42; track E skips Q19 (pre-seeded from the product's current users).

## 5. Outputs

Replaces the single result label. Each output names the questions that feed it.

1. **Readiness by stage** (Q2–Q9, Q40–Q41). Where self-serve holds and where it breaks, e.g.
   "Self-serve holds for one rep. It breaks at the CRM connector, where the buyer becomes the
   VP of Sales."
2. **Buying-group map** (M1, M2, M9). User, buyer, decider at individual / team / enterprise,
   drawn in the same shape as the Acme table in §2.
3. **Friction list** (M2, M7, carried friction points). Each approval gate (permission, data,
   privacy, price, cost to serve) with a suggested way around it.
4. **Value-loop verdict** (M3). Does usage create users, and are they the right users?
5. **Wedge shortlist** (M5). Top tasks by pain × solo × gap, minus disqualified tasks.
6. **Entry-point recommendation** (M4, M6, M8). What to decouple, starting price, distribution surface.
7. **Expansion path** (M9). Where the buyer changes and what you sell then.
8. **Test plan** (Q39). One cheap experiment to validate the wedge.
9. **Export.** A one-page brief for founders and investors (print-to-PDF + copy as Markdown).

10. **Economic check** (M10). Accounts × AARPA against the rule-of-thumb bands, with the
    danger-zone warning and the three moves when the math fails.

The headline result becomes **"Your sales model by stage"**: per segment, each stage gets a
buying-group type and one of the five sales models (§3), with "Not yet" available. PLG is one
possible result, not the goal. The Quick Read headline uses the same vocabulary.

## 6. Experience

About forty-five questions with free text and a task table make a 30–45 minute working session, not a
quiz. The tool offers two depths on one engine:

- **Quick Read (about 5 minutes).** The current flow, upgraded: track selector, about ten
  scored choice questions drawn from M1, M2, M3, M7, and M9, and the stage-based headline.
  Ends with "Go deeper" into the full diagnostic, answers carried over.
- **Full Diagnostic (30–45 minutes).** All modules for the chosen track, free text, the task
  inventory table, all nine outputs, and the export. Progress saves in the browser
  (`localStorage`) so it can run across sittings or live in a working session.

Interaction carries over from v1 where it fits: one question per screen for choice questions,
keyboard shortcuts, the progress bar. Free text and the task table get full-width work screens.

## 7. Scoring and result logic

Written as a spec and approved **before** code, per the test-first rule:

- A rules table: which answer combinations produce which stage verdicts, gates, and
  recommendations. Hard overrides stay (an executive or committee decider at a stage makes
  that stage sales-led, whatever else is true).
- Wedge score: pain (sum of the five Q22 scores) × solo weight (solo 1.0, internal 0.5,
  customer-facing 0.75, to be tuned) × gap (Q23), with Q24 disqualifiers removed.
- Feature-word check for Q1: a word list (platform, dashboard, AI-powered, integration,
  workflow, …). No model call; the app stays static.
- 8–12 named founder scenarios (pure self-serve tool, rep tool that needs a CRM connector,
  enterprise system of record, existing product with an upsell trap, …) with expected outputs.
  These become the regression suite, replacing v1's six-path check.

## 8. Look and feel: Overdrive Light

Source of truth: `~/.claude/identity/overdrive-light-design-system.md`. Kit:
`~/.claude/skills/overdrive-light-design-system/` (tokens, 16 components, specimens).

| Token / rule | v1 (Overdrive Alpha) | v2 (Overdrive Light) |
| :- | :- | :- |
| Lead accent | Orange `#FF9000` | Signal Azure `#1F8EFF`; hover Azure Press `#0C79E8`; azure text Azure Ink `#0C6FD1` |
| Page | Warm off-white | Page `#F7F9FC`; cards Surface `#FFFFFF` |
| Rhythm band | — | Azure Tint `#E8F2FF` (never two adjacent, max two per page) |
| Text | Ink scale | Ink `#16202B`, Ink 2 `#3B4A58`, Ink 3 `#4A5866`, Ink 4 `#5B6B7A` |
| Body font | Plus Jakarta Sans | Instrument Sans 400/600 (no 300, no italics) |
| Display / mono | Space Grotesk / JetBrains Mono | unchanged |
| Bridge colors | Light + golden yellow | Golden Yellow `#F1C232`, Overdrive Blue `#55BFFA` in supporting roles |
| Orange | Lead | Status chips and form-error borders only |
| Selected card | Elevated surface + orange border | Azure border + azure tint, 4px azure top rule on cards |
| Charts (buying-group map, wedge scores) | — | Series azure, green `#12B886`, golden, Overdrive blue |

Inherited rules that still apply: solid 2/4/8px rules, card with accent rule across the top
edge (never a coloured left border), 8px grid, radii 4–10px, motion
`cubic-bezier(0.22, 1, 0.36, 1)` at 120/160/220ms with no bounce or reveal-on-scroll, flat
backgrounds, no gradients, Lucide icons, no emoji, sentence case except 12px overlines.

**Theming contract stays.** Overdrive Light becomes `:root` (the default). The Alchemist stub
keeps working. Overdrive Alpha becomes an optional `?client=alpha` theme so the current look
isn't lost. The v1 lock "no dark backgrounds" is already Light's rule.

## 9. Architecture

- Static site on GitHub Pages, no backend, no build step. Stays.
- **Proposed change to a v1 lock:** allow a handful of files (`index.html`, `app.js`,
  `questions.js`, `scoring.js`, `styles.css`). A 42-question engine with branching, a task
  table, nine outputs, and export won't stay readable in one file, and splitting the
  question bank and rules out makes them editable without touching UI code. Still no build step.
- **Proposed:** drop the Tailwind CDN in favour of the Light kit's CSS tokens. Tailwind's CDN
  build is not meant for production, and the kit already ships the tokens and components.
- Question bank as data (id, module, track, type, options, branching rule, outputs fed), so
  adding or rewording a question never touches engine code.
- Scoring as pure functions over an answers object, testable from the command line against
  the §7 scenarios.

## 10. Proposed phases

| Phase | Ships | Depends on |
| :- | :- | :- |
| 1. Overdrive Light reskin of the current tool | The live six-question tool in Light, Alpha kept as a theme, Pete's Q-wording fix. Shippable alone (a v1.1). | — |
| 2. Content and logic spec | Final question bank as data, rules table, wedge formula, 8–12 approved scenarios | — (parallel with 1) |
| 3. Engine | Question schema, tracks, branching, input types (text, who-approves, range, table), save and resume | 2 |
| 4. Quick Read | Upgraded short flow on the new engine, stage-based headline | 3 |
| 5. Full Diagnostic modules | M0–M9 screens incl. task inventory | 3 |
| 6. Results and export | Nine outputs, Acme teaching story, one-page brief | 4, 5 |

## 11. Decisions (locked 2026-10-19)

Pete accepted the recommendations. GSD treats these as constraints.

1. **Name and framing.** Keep the "PLG Readiness" name. The result is "your sales model by
   stage," with PLG as one possible outcome.
2. **Depth.** Quick Read and Full Diagnostic, both on one engine.
3. **Single-file lock relaxed.** Replace it with a few static files (`index.html`, `app.js`,
   `questions.js`, `scoring.js`, `styles.css`). There is still no build step. This supersedes
   the v1 "single-file" constraint in `.planning/PROJECT.md`.
4. **Tailwind dropped** in favour of the Overdrive Light kit's CSS tokens. Timing: the Phase 1
   reskin keeps Tailwind and points the existing token contract at the Light values, so the
   current markup isn't rewritten twice. Tailwind comes out in Phase 3, when the engine and
   markup are rebuilt.
5. **Phase 1 first.** The Light reskin of the current tool, with the Q-wording fix, ships as
   v1.1 before the overhaul starts.
6. **Granola-added items are kept as planned.** These are the F/E track split, the input
   types, the output designs, Q13, Q35, and the sales-model reframe. §11 offered no
   recommendation on this one, so "keep" is the default. Revisit during
   `/gsd-discuss-phase` for Phase 2 if any of them feel wrong.

---

## Appendix A. Coverage of the session notes

| Session item | Lands in |
| :- | :- |
| Notes Part A, Q1–Q42 and module principles | §4 (verbatim intent, tightened wording), §2 principles |
| Track tags F / E / B | §4 |
| Part B inputs: track selector, context capture, mixed answer types, task table, branching | §4 M0, input types, Branching |
| Part B outputs 1–9 | §5 |
| Part C, PLG → sales-model tool | §5 headline, §11 decision 1 |
| "Ideas from Granola" provenance list | §11 decision 6 |
| "Write the result logic next" | §7, Phase 2 |
| Pete's live fix: "create new users who can become customers" | §1 item 5, Q10 |
| Founder's answer "user and decider are close but different" | Q5 answer option |
| Acme / Google Workspace story (Gabrielle, Maya, enterprise) and Zoom | §2 teaching story |
| "You don't get to choose PLG; the problem picks it" | §2 thesis |
| "Self-serve is a component of PLG; user = buyer = decider" | P2, M2 |
| Customer's customer may not be your customer | P4, Q11 |
| App vs data vs MCP by segment; users buy the benefit; sophistication | P5, M4 |
| MECE task inventory by role; solo / internal / customer; sequence; friction scoring; competitor map | M5 |
| Forecasting and high-volume SDR email as non-wedges | Q24 |
| Horizontal incumbents, vertical gap | Q25 |
| Decouple, don't scrap; easy upsell as the wrong signal | P7, M6, Q30 |
| Price anchors under $100/month, $15–30/user/month | Q9 |
| Cost to serve; bring your own Claude subscription | Q37 |
| MCP tool response advertising the full product; "paste into agent" setup block | Q38 |
| $50 ad / MCP listing / landing page test | Q39, output 8 |
| Data privacy for shared-output viewers | Q8 |
| Product and distribution as one decision | P8, M8 |
| Current tool's onboarding screens | M7 |
| Customer-first naming on shared output (put the recipient's name first) | Not a diagnostic question; a design note for founders. Captured here only. |
| Personal and scheduling chat (travel, in-person day, new hire start date) | Dropped; not product content |
