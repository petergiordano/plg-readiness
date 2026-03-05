# Codebase Structure

**Analysis Date:** 2026-03-05

## Directory Layout

```
plg-readiness/
├── index.html                        # Entire application (HTML + CSS + JS)
├── CLAUDE.md                         # Project instructions for Claude Code
├── plg-readiness.code-workspace      # VS Code workspace config
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
│       └── frontend-design/
│           └── SKILL.md              # Frontend design skill reference
├── docs/
│   └── design/
│       └── Modern-Web-UI-Design-Guidelines.md  # UI design reference
├── reference/
│   └── cli-tool-template.py          # Python CLI structural reference
└── .planning/
    └── codebase/                     # GSD codebase analysis documents
```

## Directory Purposes

**Root (`/`):**
- Purpose: Holds the application and project-level config
- Contains: `index.html` (the entire app), workspace config, CLAUDE.md instructions
- Key files: `index.html`

**`.claude/agents/`:**
- Purpose: Specialized Claude Code agent definitions for domain-specific tasks
- Contains: Markdown files defining agent behavior for CLI, code review, frontend, etc.
- Key files: `frontend-developer.md`, `ui-designer.md` (most relevant for this project)

**`.claude/skills/frontend-design/`:**
- Purpose: Frontend design skill reference for Claude agents
- Contains: `SKILL.md` with frontend design patterns and guidelines

**`docs/design/`:**
- Purpose: Human-readable design reference documentation
- Contains: UI design guidelines that govern visual decisions in `index.html`
- Key files: `Modern-Web-UI-Design-Guidelines.md` — **must be read before making UI changes**

**`reference/`:**
- Purpose: Structural reference code (not for direct copying)
- Contains: `cli-tool-template.py` — Python CLI pattern with argparse, .env loading, batch processing

**`.planning/codebase/`:**
- Purpose: GSD codebase analysis documents for AI-assisted planning
- Contains: ARCHITECTURE.md, STRUCTURE.md, and other analysis docs
- Generated: Yes (by GSD map-codebase)
- Committed: Yes

## Key File Locations

**Entry Point / Entire Application:**
- `index.html`: Complete app — HTML structure, CSS config, inline styles, JavaScript logic

**Design Reference (read before UI changes):**
- `docs/design/Modern-Web-UI-Design-Guidelines.md`: Color palette, spacing scale, typography rules

**Agent Definitions:**
- `.claude/agents/frontend-developer.md`: Frontend code conventions agent
- `.claude/agents/ui-designer.md`: UI design decisions agent

## Naming Conventions

**Files:**
- Application file: lowercase with hyphens (`index.html`)
- Documentation: Title-Case-With-Hyphens (`Modern-Web-UI-Design-Guidelines.md`)
- Agent files: lowercase with hyphens (`frontend-developer.md`, `code-reviewer.md`)

**HTML IDs (in `index.html`):**
- Kebab-case: `result-container`, `result-title`, `result-description`, `result-recommendation`
- Kebab-case: `accelerators-list`, `friction-list`, `wedge-callout`, `override-notice`
- Kebab-case: `buyer-user-options`, `viral-options`, `scope-options`

**JavaScript:**
- Functions: camelCase (`calculateScore`, `renderCheckboxes`)
- Variables: camelCase (`buyerUser`, `accCount`, `fricCount`, `resultContainer`)
- Data arrays: camelCase (`accelerators`, `frictionPoints`)
- Boolean flags: camelCase with descriptive prefix (`requiresSales`, `isPurePLG`, `hasWedgePotential`)

**CSS Classes:**
- Tailwind utilities everywhere
- Custom component classes use kebab-case: `checkbox-wrapper`, `checkbox-square`, `check-icon`, `radio-wrapper`, `radio-circle`, `radio-dot`, `radio-label`

**Radio Input Values:**
- Short, lowercase, no hyphens: `"same"`, `"manager"`, `"csuite"`, `"organic"`, `"siloed"`, `"individual"`, `"team"`, `"enterprise"`

## Where to Add New Code

**New UI Section (e.g., Phase 3 questions):**
- Add HTML inside `<main id="assessment">` in `index.html`
- Follow existing section pattern: phase badge → `<h2>` → `<p>` description → question cards
- Add corresponding JS logic within or after `calculateScore()`

**New Checkbox Data:**
- Add items to `accelerators` or `frictionPoints` arrays in `index.html` inline script
- Each item must have `{ label: String, example: String }` — `renderCheckboxes()` handles the rest

**New Result State:**
- Add a new `else if` branch in `calculateScore()` before the final `else` fallback
- Set `resultTitle.textContent`, `resultDesc.textContent`, `resultRec.textContent`
- Optionally show `wedgeCallout` or `overrideNotice` by removing `hidden` class

**New Static Reference Section:**
- Add after `</main>` and before `<footer>` in `index.html`
- Follow the Problem Scope Matrix section pattern: `<section class="bg-white border-t border-slate-200 ...">` with `max-w-5xl mx-auto px-6` container

**New Styling:**
- Prefer Tailwind utility classes directly on elements
- Custom CSS states (e.g., `:checked` sibling selectors) go in the `<style>` block in `<head>` (lines 36–69)
- New colors must be added to `tailwind.config` theme extension (lines 10–34)

**New Agent Definition:**
- Add `.md` file to `.claude/agents/` following existing agent format
- Reference in `CLAUDE.md` agents table

## Special Directories

**`.git/`:**
- Purpose: Git version control metadata
- Generated: Yes
- Committed: No

**`.planning/`:**
- Purpose: GSD planning artifacts and codebase analysis
- Generated: Yes (by GSD commands)
- Committed: Yes

---

*Structure analysis: 2026-03-05*
