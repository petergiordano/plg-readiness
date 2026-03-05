# Codebase Structure

**Analysis Date:** 2026-03-05

## Directory Layout

```
plg-readiness/
├── index.html                        # Entire application (HTML + CSS + JS)
├── CLAUDE.md                         # Project instructions for Claude Code
├── plg-readiness.code-workspace      # VS Code workspace file
├── .claude/
│   ├── agents/                       # Specialized Claude agent definitions
│   │   ├── cli-developer.md
│   │   ├── code-reviewer.md
│   │   ├── data-analyst.md
│   │   ├── data-engineer.md
│   │   ├── debugger.md
│   │   ├── documentation-engineer.md
│   │   ├── frontend-developer.md
│   │   ├── python-pro.md
│   │   ├── qa-expert.md
│   │   └── ui-designer.md
│   └── skills/
│       └── frontend-design/          # Frontend design skill files
├── .planning/
│   └── codebase/                     # GSD codebase analysis documents
│       ├── ARCHITECTURE.md
│       └── STRUCTURE.md
├── docs/
│   └── design/
│       └── Modern-Web-UI-Design-Guidelines.md   # UI design reference
└── reference/
    └── cli-tool-template.py          # Python CLI structural reference
```

## Directory Purposes

**Root (`/`):**
- Purpose: Project root; the application itself is a single file
- Contains: `index.html` (the entire app), workspace config, project instructions
- Key files: `index.html` — this IS the application

**`.claude/agents/`:**
- Purpose: Claude Code agent persona definitions for specialized tasks
- Contains: Markdown files defining agent behavior for specific domains
- Key files: `frontend-developer.md`, `ui-designer.md` (most relevant to this project)

**`.claude/skills/frontend-design/`:**
- Purpose: Skill reference files for frontend design patterns
- Contains: Design pattern guidance

**`.planning/codebase/`:**
- Purpose: GSD codebase analysis documents consumed by planning/execution commands
- Contains: ARCHITECTURE.md, STRUCTURE.md, and other analysis docs
- Generated: Yes (by `gsd:map-codebase`)
- Committed: Yes

**`docs/design/`:**
- Purpose: Design system reference documentation
- Contains: `Modern-Web-UI-Design-Guidelines.md` — authoritative UI rules
- Key files: Read this before making any visual changes

**`reference/`:**
- Purpose: Code pattern references (not used by the app at runtime)
- Contains: `cli-tool-template.py` — Python CLI structural reference
- Generated: No
- Committed: Yes

## Key File Locations

**Entry Points:**
- `index.html`: The entire application — open directly in browser or serve via `python3 -m http.server 8080`

**Configuration:**
- `index.html` lines 9–34: Tailwind CSS config (color palette, font family extension)
- `CLAUDE.md`: Project-level instructions for Claude Code agents
- `plg-readiness.code-workspace`: VS Code workspace settings

**Core Logic:**
- `index.html` lines 443–603: All JavaScript — data arrays, `renderCheckboxes()`, `calculateScore()`

**Styles:**
- `index.html` lines 9–34: Tailwind CDN + config
- `index.html` lines 36–69: Custom CSS (checkbox/radio sibling-selector states)
- `docs/design/Modern-Web-UI-Design-Guidelines.md`: Design system rules

**Testing:**
- None — no test files exist in this project

## Naming Conventions

**Files:**
- Single lowercase with hyphens: `index.html`, `cli-tool-template.py`
- Agent/doc files: kebab-case with `.md` extension

**HTML IDs (used by JavaScript):**
- Section containers: `assessment`, `accelerators-list`, `friction-list`
- Result elements: `result-container`, `result-title`, `result-description`, `result-recommendation`
- Conditional elements: `wedge-callout`, `override-notice`, `override-explanation`

**HTML names (form inputs):**
- Radio groups: `buyerUser`, `viral`, `scope`
- Checkbox groups: `accelerator`, `friction`

**CSS classes (custom):**
- Component wrappers: `checkbox-wrapper`, `radio-wrapper`
- Inner elements: `checkbox-square`, `check-icon`, `radio-circle`, `radio-dot`, `radio-label`

**JavaScript:**
- Functions: camelCase — `renderCheckboxes()`, `calculateScore()`
- Variables: camelCase — `accCount`, `fricCount`, `buyerUser`, `requiresSales`, `isPurePLG`, `hasWedgePotential`
- Data arrays: camelCase — `accelerators`, `frictionPoints`

## Where to Add New Code

**New assessment question (Phase 1 radio group):**
- Add HTML radio group inside `<section class="mb-16">` following the existing `radio-wrapper` pattern
- Add new `const questionName = document.querySelector(...)?.value` in `calculateScore()`
- Update scoring conditionals in `calculateScore()`

**New Phase 2 checkbox item:**
- Add `{ label: "...", example: "e.g., ..." }` object to `accelerators` or `frictionPoints` array at `index.html` lines 444–484
- No other changes needed — `renderCheckboxes()` handles rendering automatically

**New result state:**
- Add new `else if` branch in `calculateScore()` (lines 554–601)
- Reuse existing DOM elements: set `resultTitle.textContent`, `resultDesc.textContent`, `resultRec.textContent`
- Show/hide `wedgeCallout` and `overrideNotice` as needed

**New static content section:**
- Add HTML section inside `<body>` following existing card/section patterns
- Use `max-w-5xl mx-auto px-6` container class for consistent width
- Reference `docs/design/Modern-Web-UI-Design-Guidelines.md` for spacing and color rules

**New styles:**
- Extend Tailwind config in `index.html` lines 10–34 for new design tokens
- Add custom CSS in `<style>` block (lines 36–69) only for patterns Tailwind cannot handle (e.g., sibling selectors)

## Special Directories

**`.planning/`:**
- Purpose: GSD planning artifacts — codebase maps, phase plans
- Generated: Yes, by GSD commands
- Committed: Yes

**`.claude/`:**
- Purpose: Claude Code configuration — agents and skills
- Generated: No (manually authored)
- Committed: Yes

**`reference/`:**
- Purpose: Structural code templates for Claude to reference
- Generated: No
- Committed: Yes

---

*Structure analysis: 2026-03-05*
