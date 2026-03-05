# Testing Patterns

**Analysis Date:** 2026-03-05

## Test Framework

**Runner:** None — no test framework is installed or configured.

**Assertion Library:** None.

**Config files:** None. No `jest.config.*`, `vitest.config.*`, `playwright.config.*`, or equivalent found.

**Run Commands:** None defined. There is no `package.json`, so no npm scripts exist.

## Current Test Coverage

**Coverage:** 0% automated. No test files exist anywhere in the repository.

A search for test file patterns across the project confirms this:
- No `*.test.*` files
- No `*.spec.*` files
- No `__tests__/` directories
- No test runners, assertion libraries, or mocking utilities referenced

## Testing Approach

All verification is currently **manual, browser-based**:
- Open `index.html` directly in a browser, or serve with `python3 -m http.server 8080`
- Interact with Phase 1 radios and Phase 2 checkboxes manually
- Click "Analyze My Product Strategy" and observe result cards

## What Would Need Testing

Given the application is a scoring/decision tool with a finite set of input combinations, the following areas are candidates for automated testing if a test framework were added:

**Scoring logic in `calculateScore()` (highest value):**
- Hard override: `buyerUser === 'csuite'` should always produce Sales-Led regardless of Phase 2
- Hard override: `scope === 'enterprise'` should always produce Sales-Led regardless of Phase 2
- Wedge trigger: `requiresSales === true && accCount >= 4 && fricCount <= 2` → "Sales-Led with Wedge Opportunity"
- Pure PLG ideal: `buyerUser === 'same' && scope === 'individual' && viral === 'organic' && accCount >= 4 && fricCount <= 1` → "Pure PLG: Ideal Candidate"
- PLG with friction: `isPurePLG === true` but friction/viral conditions fail → "PLG Motion with Optimization Needed"
- Hybrid: `scope === 'team' || buyerUser === 'manager'` → "Product-Led Sales (Hybrid)"
- Fallback: unmatched combinations → "Hybrid Approach Recommended"
- Incomplete Phase 1: missing any radio value → alert triggered, no result shown
- Override notice threshold: `accCount >= 3` in Sales-Led context, `accCount >= 5` in Wedge context

**DOM rendering in `renderCheckboxes()` (medium value):**
- Correct number of checkbox items rendered into `#accelerators-list` (9 items)
- Correct number of checkbox items rendered into `#friction-list` (9 items)
- Each rendered item has the correct `name` attribute (`accelerator` or `friction`)
- Each rendered item's label text matches source array

**UI visibility state (lower value):**
- `result-container` is hidden on page load
- `wedge-callout` is hidden on page load
- `override-notice` is hidden on page load
- After `calculateScore()`, `result-container` is visible
- Wedge-only cases show `wedge-callout`; others do not
- Override notice appears only when threshold conditions are met

## Recommended Testing Approach (if tests are added)

**Framework:** Vitest is the natural fit — no bundler required, browser environment simulation via jsdom, and simple configuration.

**Setup pattern:**
```javascript
// Example: test/scoring.test.js
import { describe, it, expect, beforeEach } from 'vitest'

// scoring logic would need to be extracted from inline script
// into a testable module: src/scoring.js

describe('calculateScore', () => {
    it('forces Sales-Led when buyerUser is csuite', () => {
        const result = getScoreResult({ buyerUser: 'csuite', viral: 'organic', scope: 'individual', accCount: 9, fricCount: 0 })
        expect(result.title).toBe('Sales-Led Growth Required')
    })
})
```

**Prerequisite:** The scoring logic in `calculateScore()` (`index.html` lines 513-602) would need to be extracted into a separate importable module before unit testing is feasible. Currently it is tightly coupled to DOM access at the top of the function.

**E2E option:** Playwright could test the full page without any refactoring:
```javascript
// Example: e2e/assessment.spec.js
import { test, expect } from '@playwright/test'

test('Sales-Led result for C-Suite buyer', async ({ page }) => {
    await page.goto('http://localhost:8080')
    await page.click('input[name="buyerUser"][value="csuite"]')
    await page.click('input[name="viral"][value="organic"]')
    await page.click('input[name="scope"][value="individual"]')
    await page.click('button[onclick="calculateScore()"]')
    await expect(page.locator('#result-title')).toHaveText('Sales-Led Growth Required')
})
```

## Test Data / Fixtures

No fixtures exist. The input space is small and enumerable:
- `buyerUser`: 3 values (`same`, `manager`, `csuite`)
- `viral`: 2 values (`organic`, `siloed`)
- `scope`: 3 values (`individual`, `team`, `enterprise`)
- `accCount`: 0–9 (integer)
- `fricCount`: 0–9 (integer)

Total Phase 1 combinations: 18. Key thresholds for Phase 2: 0, 1, 2, 3, 4, 5 for `accCount`; 0, 1, 2 for `fricCount`.

## Coverage Requirements

**Current:** None enforced.

**Recommended minimum (if tests are added):**
- 100% branch coverage of `calculateScore()` scoring logic — it is the core product behavior
- All 6 result states must be reachable by at least one test case
- Both override notice conditions must be covered

---

*Testing analysis: 2026-03-05*
