# Testing Patterns

**Analysis Date:** 2026-03-05

## Test Framework

**Runner:** None configured

**Assertion Library:** None

**Run Commands:**
```bash
# No test commands exist
# The project has no package.json, no test runner, no test files
```

## Current Test Coverage

**Coverage: 0%** — No automated tests exist in this repository.

No test files were found. No testing dependencies, configuration files, or test runners of any kind are present:
- No `jest.config.*`, `vitest.config.*`, `playwright.config.*`, or `cypress.config.*`
- No `*.test.*` or `*.spec.*` files
- No `__tests__/` or `test/` or `tests/` directories
- No `package.json` (and therefore no devDependencies, no `npm test` script)

## Architecture Context

This is a zero-dependency, zero-build static HTML file (`index.html`). All application logic lives in an inline `<script>` block at line 443. The structure that would need testing:

**Functions in `index.html`:**
- `renderCheckboxes(list, elementId, name)` — DOM rendering function, lines 487–508
- `calculateScore()` — core scoring logic, lines 513–602

**Data in `index.html`:**
- `accelerators` array (9 items) — lines 444–463
- `frictionPoints` array (9 items) — lines 465–484

## What Should Be Tested

Given the scoring logic complexity in `calculateScore()`, these are the cases that matter most:

**Override logic (highest priority):**
- `buyerUser === 'csuite'` always produces Sales-Led result regardless of Phase 2
- `scope === 'enterprise'` always produces Sales-Led result regardless of Phase 2
- Wedge trigger: Sales-Led required AND `accCount >= 4` AND `fricCount <= 2`

**PLG paths:**
- Pure PLG ideal: `buyerUser === 'same'` AND `scope === 'individual'` AND `viral === 'organic'` AND `accCount >= 4` AND `fricCount <= 1`
- PLG with friction: `buyerUser === 'same'` AND `scope === 'individual'` but friction conditions not met
- PLS hybrid: `scope === 'team'` OR `buyerUser === 'manager'`

**Validation:**
- Incomplete Phase 1 (any radio unanswered) should block scoring

**Edge cases:**
- All accelerators checked (9) with Sales-Led scope — override notice threshold
- Zero accelerators with PLG-viable scope — fallback "Hybrid" result
- `fricCount` boundary at exactly 2 for wedge trigger

## Recommended Test Approach (if tests are added)

Since the project is a zero-build static HTML file, the simplest viable testing approach would be browser-based:

**Option 1: Vitest with jsdom (low overhead)**
```bash
npm init -y
npm install -D vitest jsdom
```

Extract scoring logic into a pure function module:
```javascript
// src/scoring.js
export function calculateResult(buyerUser, viral, scope, accCount, fricCount) {
    const requiresSales = buyerUser === 'csuite' || scope === 'enterprise';
    const isPurePLG = buyerUser === 'same' && scope === 'individual';
    const hasWedgePotential = requiresSales && accCount >= 4 && fricCount <= 2;
    // ... return result object
}
```

Test file pattern:
```javascript
// src/scoring.test.js
import { describe, it, expect } from 'vitest';
import { calculateResult } from './scoring.js';

describe('Sales-Led override', () => {
    it('forces Sales-Led when buyerUser is csuite', () => {
        const result = calculateResult('csuite', 'organic', 'individual', 9, 0);
        expect(result.title).toBe('Sales-Led Growth Required');
    });

    it('forces Sales-Led when scope is enterprise', () => {
        const result = calculateResult('same', 'organic', 'enterprise', 9, 0);
        expect(result.title).toBe('Sales-Led Growth Required');
    });
});

describe('Wedge opportunity', () => {
    it('triggers wedge when Sales-Led required and accCount >= 4 and fricCount <= 2', () => {
        const result = calculateResult('csuite', 'organic', 'team', 4, 2);
        expect(result.title).toBe('Sales-Led with Wedge Opportunity');
    });

    it('does not trigger wedge when accCount < 4', () => {
        const result = calculateResult('csuite', 'organic', 'team', 3, 1);
        expect(result.title).toBe('Sales-Led Growth Required');
    });
});
```

**Option 2: Playwright for end-to-end (current structure, no refactor)**
```bash
npm init -y
npm install -D @playwright/test
```

```javascript
// tests/assessment.spec.js
import { test, expect } from '@playwright/test';

test('Sales-Led result for enterprise scope', async ({ page }) => {
    await page.goto('http://localhost:8080');
    await page.click('input[name="scope"][value="enterprise"]');
    await page.click('input[name="buyerUser"][value="same"]');
    await page.click('input[name="viral"][value="organic"]');
    await page.click('button[onclick="calculateScore()"]');
    await expect(page.locator('#result-title')).toHaveText('Sales-Led Growth Required');
});
```

## Test File Placement (if added)

```
plg-readiness/
├── index.html
├── tests/              # E2E tests (Playwright)
│   └── assessment.spec.js
└── src/                # If logic is extracted
    ├── scoring.js
    └── scoring.test.js
```

## Current Risk Assessment

**High-risk untested logic:**
- `calculateScore()` has 6 distinct result branches with complex boolean conditions
- The wedge trigger boundary (`accCount >= 4`, `fricCount <= 2`) has no guard
- The override notice threshold (`accCount >= 3` for Sales-Led, `accCount >= 5` for Wedge) has no guard
- `renderCheckboxes()` generates DOM from data arrays — any data shape change breaks the UI silently

**Lower risk (simpler to verify manually):**
- `renderCheckboxes()` is called once at load with static data — breaks are immediately visible
- Phase 1 validation uses `alert()` — easy to observe manually

---

*Testing analysis: 2026-03-05*
