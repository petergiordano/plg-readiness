# Codebase Concerns

**Analysis Date:** 2026-03-05

## Tech Debt

**Single-file monolith with no separation of concerns:**
- Issue: All HTML, CSS, JS, and data live in one 605-line `index.html`. No modules, no components, no build process.
- Files: `index.html`
- Impact: Adding features, refactoring logic, or updating content requires editing a single file with no isolation. Testing individual units is impossible without extracting to modules.
- Fix approach: Extract JS to a separate `script.js`, CSS to `styles.css`, and data arrays to a `data.js` module. Even without a build step, separate files improve maintainability.

**Hardcoded data arrays in script block:**
- Issue: `accelerators` and `frictionPoints` arrays (lines 444–484) are defined inline inside a `<script>` tag alongside rendering and scoring logic. Content and logic are mixed.
- Files: `index.html` (lines 444–484)
- Impact: Updating copy, labels, or examples requires navigating application logic. No content-only edit path exists.
- Fix approach: Move data arrays to a dedicated `data.js` file or a JSON file so content and logic are independently editable.

**Hardcoded copyright year in footer:**
- Issue: Footer reads `© 2025 Senior GTM Strategy Architect.` with a static year.
- Files: `index.html` (line 437)
- Impact: Will display stale year each January without a manual update.
- Fix approach: Set dynamically via JS: `document.querySelector('footer p').textContent = \`© \${new Date().getFullYear()} ...\``

**`onclick` inline attribute handler:**
- Issue: The "Analyze My Product Strategy" button uses `onclick="calculateScore()"` (line 325), relying on a global function in the global scope.
- Files: `index.html` (line 325)
- Impact: If the script block errors during load, the button silently does nothing. Inline handlers are harder to test and are considered a code smell in modern JS.
- Fix approach: Replace with `addEventListener` attached in the script block or after DOM load.

## Known Bugs

**Scroll-to-result fires even when result is already visible:**
- Symptoms: Clicking "Analyze" a second time (re-running with different selections) triggers `scrollIntoView()` unconditionally, even if the user is already at the result section.
- Files: `index.html` (line 542)
- Trigger: Click "Analyze My Product Strategy" twice with valid Phase 1 selections.
- Workaround: None — user is scrolled away from their current reading position.

**`Hybrid Approach Recommended` result is reachable only by unclear logic gap:**
- Symptoms: The final `else` branch (lines 596–601) catches cases that don't match `requiresSales`, `isPurePLG`, or `scope === 'team' || buyerUser === 'manager'`. The condition for reaching this branch is not documented and may cover edge cases unintentionally (e.g., `buyerUser === 'same'` + `scope === 'team'`).
- Files: `index.html` (lines 596–601)
- Trigger: Select "User and Decider are the same person" (buyerUser=same) + "Siloed usage" (viral=siloed) + "Team/Department Problem" (scope=team).
- Workaround: None — user receives a generic "Hybrid" result that may not be accurate for this combination.

**Wedge callout shown for Product-Led Sales path when `viral === 'organic'`:**
- Symptoms: The wedge callout (designed for enterprise/Sales-Led products) is also revealed in the Product-Led Sales branch when viral is organic (line 593–595). The wedge callout text references Datadog and Slack as enterprise examples, which is misleading for a team-scope product with organic virality.
- Files: `index.html` (lines 587–595)
- Trigger: Select manager approval + any scope + organic viral.
- Workaround: None.

## Security Considerations

**No Content Security Policy (CSP) header or meta tag:**
- Risk: No CSP is declared. Any injected script (via XSS) would execute without restriction.
- Files: `index.html` (lines 1–10)
- Current mitigation: No user-supplied data is rendered to the DOM; `innerHTML` is only used with developer-controlled static strings in `renderCheckboxes()`. The attack surface is low but not zero.
- Recommendations: Add a `<meta http-equiv="Content-Security-Policy">` tag restricting scripts to `self` and trusted CDN origins (`cdn.tailwindcss.com`, `fonts.googleapis.com`).

**`innerHTML` used to render checkbox labels:**
- Risk: `renderCheckboxes()` (lines 487–508) sets `wrapper.innerHTML` using `item.label` and `item.example` values. These values are currently developer-controlled constants, but if the data source ever becomes dynamic (API, user input, CMS), this becomes a stored XSS vector.
- Files: `index.html` (lines 492–505)
- Current mitigation: Data is hardcoded in the same file; no external input path currently exists.
- Recommendations: Replace `innerHTML` template literals with DOM API calls (`createElement`, `textContent`) to eliminate the risk by construction, not by assumption.

**External CDN dependency loaded without Subresource Integrity (SRI):**
- Risk: Tailwind CSS is loaded via `<script src="https://cdn.tailwindcss.com">` (line 7) with no `integrity` attribute. A CDN compromise could deliver malicious JavaScript.
- Files: `index.html` (line 7)
- Current mitigation: None.
- Recommendations: Add `integrity` and `crossorigin` attributes to the Tailwind CDN script tag. Note: The Tailwind Play CDN is explicitly not recommended for production and does not publish stable SRI hashes; migration to a build-time Tailwind bundle is the proper fix.

**Google Fonts loaded over external network:**
- Risk: The Fonts API call (`fonts.googleapis.com`, line 8) reveals the user's IP to Google on every page load. For a tool used by founders evaluating sensitive business strategy, this may be a privacy concern.
- Files: `index.html` (line 8)
- Current mitigation: None.
- Recommendations: Self-host the Inter font or use a system font stack as fallback.

## Performance Bottlenecks

**Tailwind CDN runtime JIT compilation:**
- Problem: The page loads the Tailwind Play CDN (`cdn.tailwindcss.com`), which scans the DOM at runtime and generates CSS on the client. This is 100–300ms of blocking JS execution on first load.
- Files: `index.html` (line 7)
- Cause: Play CDN is a development tool, not a production asset.
- Improvement path: Run `tailwindcss` CLI as a build step to generate a static, purged CSS file. This eliminates the runtime overhead entirely and produces a CSS file under 10KB.

**No resource hints for external assets:**
- Problem: No `<link rel="preconnect">` or `<link rel="dns-prefetch">` tags are present for `cdn.tailwindcss.com` or `fonts.googleapis.com`.
- Files: `index.html` (lines 7–8)
- Cause: Not specified.
- Improvement path: Add `<link rel="preconnect" href="https://fonts.googleapis.com">` and similar tags to reduce connection latency.

## Fragile Areas

**`calculateScore()` logic — undocumented else-branch:**
- Files: `index.html` (lines 596–601)
- Why fragile: The final `else` catches all inputs that don't match explicitly named conditions. Adding a new `buyerUser` or `scope` value silently routes to "Hybrid Approach Recommended" instead of throwing a visible error. There are no unit tests.
- Safe modification: Document every combination in a decision table before changing branching logic. Consider replacing the nested if/else with an explicit lookup table or decision matrix keyed on `(buyerUser, scope, viral)` tuples.
- Test coverage: None. No test files exist anywhere in the repository.

**`renderCheckboxes()` — no container null-guard:**
- Files: `index.html` (lines 487–511)
- Why fragile: `document.getElementById(elementId)` is called without checking for `null`. If the target element ID is renamed in HTML without updating the JS call, `container.appendChild()` throws a TypeError and the entire script block halts, breaking the "Analyze" button silently.
- Safe modification: Add `if (!container) return;` guard after the `getElementById` call.
- Test coverage: None.

**Result display — manual hidden/show with no state abstraction:**
- Files: `index.html` (lines 538–541, 562–565, 573–575, 593–595)
- Why fragile: Each result branch individually adds/removes the `hidden` class on `wedge-callout` and `override-notice`. The reset at the top of `calculateScore()` only hides these elements but does not reset `resultTitle`, `resultDesc`, or `resultRec` text before setting new values. If a branch fails to set one of those elements, stale text from a prior run persists.
- Safe modification: Add explicit resets for all result text elements at the top of `calculateScore()` before the branching logic runs.
- Test coverage: None.

## Test Coverage Gaps

**No tests exist:**
- What's not tested: All scoring logic in `calculateScore()`, checkbox rendering in `renderCheckboxes()`, DOM manipulation, edge case input combinations.
- Files: `index.html` (lines 513–602)
- Risk: Scoring logic bugs (wrong GTM motion returned for a valid input combination) are undetectable without manually exercising all combinations. There are at minimum 3 × 2 × 3 = 18 Phase 1 combinations, each modified by Phase 2 checkbox counts.
- Priority: High — the tool's value proposition is its scoring accuracy. Silent regressions directly undermine trust.

**No accessibility testing:**
- What's not tested: Keyboard navigation, screen reader compatibility, focus management after result reveal, color contrast ratios.
- Files: `index.html` (throughout)
- Risk: The custom radio/checkbox pattern (hidden `<input>` + adjacent `<div>`) may not be announced correctly by screen readers. Focus is not programmatically managed after `scrollIntoView()`.
- Priority: Medium.

## Missing Critical Features

**No URL-shareable results:**
- Problem: There is no way to share or bookmark a specific result. Every visit resets to blank. Users cannot share their assessment outcome with co-founders or advisors.
- Blocks: Collaborative use of the tool.

**No analytics or usage telemetry:**
- Problem: There is no tracking of how users interact with the tool, which results are most common, or where users drop off.
- Blocks: Data-driven iteration on scoring logic and content.

**No reset / retake flow:**
- Problem: After running an analysis, there is no "Retake Assessment" button. Users must manually deselect all inputs or reload the page.
- Blocks: Iterative exploration of different scenarios.

---

*Concerns audit: 2026-03-05*
