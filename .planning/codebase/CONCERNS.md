# Codebase Concerns

**Analysis Date:** 2026-03-05

## Tech Debt

**Single-file monolith with no build tooling:**
- Issue: All HTML, CSS, and JS lives in one 605-line `index.html` with no separation of concerns. As features grow, this file will become increasingly difficult to maintain.
- Files: `index.html`
- Impact: Adding new question types, result states, or UI changes requires carefully editing interleaved markup, inline styles, and script blocks. Risk of regressions is high.
- Fix approach: Introduce a minimal build step (Vite or similar) to split into component files. Even splitting into `index.html`, `styles.css`, and `app.js` would significantly reduce edit surface.

**Tailwind loaded via CDN play mode:**
- Issue: `<script src="https://cdn.tailwindcss.com">` uses Tailwind's CDN/play mode, which is explicitly not recommended for production. It ships the entire Tailwind engine (~97KB gzipped) and generates styles at runtime in the browser.
- Files: `index.html` line 7
- Impact: Slower first paint compared to a pre-built CSS file. No purging of unused classes. Not suitable for production traffic or performance-sensitive deployments.
- Fix approach: Add a build step with Tailwind CLI to generate a purged, static CSS file.

**Inline `tailwind.config` block depends on load order:**
- Issue: The `tailwind.config` object at lines 10–34 must execute before any Tailwind classes are applied. If the CDN script loads asynchronously or is blocked, config is silently ignored and custom colors (`primary`, `primaryHover`, slate overrides) fall back to Tailwind defaults.
- Files: `index.html` lines 9–35
- Impact: Custom color tokens (`bg-primary`, `hover:bg-primaryHover`) silently break in degraded network conditions.
- Fix approach: Enforce synchronous load order via build tooling; in play mode, the inline config approach is the intended workaround, but it is fragile.

**Hard-coded copyright year:**
- Issue: Footer reads `© 2025 Senior GTM Strategy Architect.` — year will not auto-update.
- Files: `index.html` line 437
- Impact: Minor credibility issue once the year rolls over.
- Fix approach: `new Date().getFullYear()` injected via JS or a build-time substitution.

**No state persistence:**
- Issue: All assessment state lives in DOM form inputs. A page refresh resets the entire assessment. There is no `localStorage` save or URL-based state encoding.
- Files: `index.html` (entire `<script>` block, lines 443–603)
- Impact: Users who accidentally refresh or share a result URL lose all their answers. The result URL is always identical (`index.html`) regardless of selections.
- Fix approach: Encode selections as URL query params or `sessionStorage` so refresh and sharing work correctly.

## Known Bugs

**Validation uses `alert()` — blocks on mobile and is unstyleable:**
- Symptoms: Clicking "Analyze My Product Strategy" with incomplete Phase 1 triggers a browser-native `alert()` dialog (line 534).
- Files: `index.html` line 534
- Trigger: Submit without completing all three Phase 1 radio groups.
- Workaround: None for end users; they must dismiss the alert manually.
- Fix approach: Replace `alert()` with inline validation UI — highlight unanswered questions, scroll to first missing answer.

**Result section is always in the DOM and visible to search engines:**
- Symptoms: `#result-container` is present in the HTML with `class="hidden"`, meaning its placeholder structure (empty `<h2 id="result-title">`, etc.) is indexed by search engines and accessible to screen readers as empty nodes.
- Files: `index.html` lines 273–322
- Trigger: Any crawler or screen reader parses the page.
- Fix approach: Use `aria-hidden="true"` on the result container while hidden, or render it via JS only after submission.

**Wedge callout shown for `Product-Led Sales` case with organic viral even when friction is high:**
- Symptoms: In the `scope === 'team' || buyerUser === 'manager'` branch (line 587–595), the wedge callout is shown if `viral === 'organic'`, regardless of friction count. A product with 9 friction points and organic virality will show the wedge callout.
- Files: `index.html` lines 593–595
- Trigger: Select Team/Department scope + organic viral + many friction points.
- Fix approach: Add a friction threshold guard: `viral === 'organic' && fricCount <= 3`.

**`scope === 'team'` with `buyerUser === 'csuite'` falls through to Product-Led Sales:**
- Symptoms: Selecting "Team/Department" scope but "C-Suite sign-off" for buyerUser triggers `requiresSales = false` (because `scope !== 'enterprise'`), then falls into the `scope === 'team' || buyerUser === 'manager'` branch. `buyerUser === 'csuite'` is never matched here because `requiresSales` already captured it. However, a combination of `scope === 'team'` and `buyerUser === 'csuite'` would match `requiresSales = true` (from `buyerUser === 'csuite'`), so this specific case is actually handled. The concern is the inverse: `scope === 'team'` and `buyerUser === 'same'` is NOT Pure PLG (`isPurePLG` requires `scope === 'individual'`) and will reach the team branch correctly, but a user selecting "User and Decider same" + "Team/Department" scope is an ambiguous edge case that the scoring logic silently routes to the Hybrid team result.
- Files: `index.html` lines 546–601
- Impact: Edge case produces a result without clear explanation for why a self-service buyer with a team product doesn't qualify for Pure PLG.

## Security Considerations

**External CDN dependencies with no subresource integrity (SRI):**
- Risk: Both `https://cdn.tailwindcss.com` (line 7) and `https://fonts.googleapis.com` (line 8) are loaded without `integrity` attributes. A compromised CDN could inject malicious scripts.
- Files: `index.html` lines 7–8
- Current mitigation: None. The browser will execute whatever is returned by these URLs.
- Recommendations: Add `integrity="sha384-..."` SRI hashes to both tags. For Tailwind specifically, switching to a self-hosted build eliminates this vector entirely.

**No Content Security Policy (CSP):**
- Risk: No `Content-Security-Policy` header or `<meta http-equiv="Content-Security-Policy">` tag is present. The inline `<script>` and `<style>` blocks would require `'unsafe-inline'` in any CSP, weakening it.
- Files: `index.html` (no CSP present)
- Current mitigation: None.
- Recommendations: Add a restrictive CSP meta tag; refactor inline scripts/styles to external files to enable hash-based or nonce-based CSP.

**`innerHTML` used for user-data-adjacent content:**
- Risk: `renderCheckboxes()` (line 492–505) uses `wrapper.innerHTML = \`...\`` with `item.label` and `item.example` interpolated directly. These values come from the static `accelerators` / `frictionPoints` arrays, not user input, so there is no current XSS vector. However, if the data source is ever made dynamic (e.g., fetched from an API or a CMS), this becomes an XSS risk immediately.
- Files: `index.html` lines 492–505
- Current mitigation: Data is hardcoded, not user-supplied.
- Recommendations: Replace `innerHTML` with `textContent` assignments or use DOM construction APIs (`document.createElement`) so the pattern is safe regardless of data source.

## Performance Bottlenecks

**Full Tailwind engine loaded at runtime:**
- Problem: Tailwind CDN play mode ships the complete engine (~97KB gzipped), parses all classes in the DOM, and generates a `<style>` block at runtime on every page load.
- Files: `index.html` line 7
- Cause: CDN play mode is a development convenience, not a production pattern.
- Improvement path: Compile Tailwind at build time via `tailwindcss` CLI with `--minify`; this reduces shipped CSS to only used classes, typically 5–15KB.

**Google Fonts blocking render:**
- Problem: `<link href="https://fonts.googleapis.com/...">` in `<head>` without `rel="preconnect"` or `font-display: swap` means the browser waits for the font before rendering text, causing visible layout shift or blank text (FOIT).
- Files: `index.html` line 8
- Cause: Default font loading behavior without display hints.
- Improvement path: Add `<link rel="preconnect" href="https://fonts.googleapis.com">` before the font link; append `&display=swap` to the fonts URL (already present — this is partially mitigated); add a `rel="preconnect"` for `fonts.gstatic.com`.

## Fragile Areas

**`calculateScore()` scoring logic is one large if/else block:**
- Files: `index.html` lines 513–602
- Why fragile: All scoring conditions, result strings, and UI side-effects are interleaved in a single 90-line function. Adding a new result state or modifying thresholds requires editing multiple nested conditions simultaneously. The `requiresSales` / `isPurePLG` / `hasWedgePotential` flags interact in ways that are not immediately obvious.
- Safe modification: Trace all flag combinations in a truth table before adding conditions. Extract result text into a `results` data object keyed by outcome string to separate logic from content.
- Test coverage: No automated tests exist. All logic is manually tested via browser interaction only.

**DOM IDs as the only coupling between HTML and JS:**
- Files: `index.html` lines 524–530 (JS) and lines 273–321 (HTML)
- Why fragile: JS selects result elements by ID (`result-title`, `result-description`, `result-recommendation`, `wedge-callout`, `override-notice`, `override-explanation`). Renaming or removing any of these IDs in HTML silently breaks the corresponding JS without any error thrown at load time.
- Safe modification: Any HTML ID used in JS must be cross-referenced before renaming.
- Test coverage: None.

**Checkbox rendering depends on `#accelerators-list` and `#friction-list` IDs existing at script execution time:**
- Files: `index.html` lines 510–511
- Why fragile: `renderCheckboxes()` is called immediately (not in a `DOMContentLoaded` listener). This works only because the `<script>` tag is at the bottom of `<body>`. Moving the script tag to `<head>` without adding `defer` would silently produce empty checkbox lists.
- Safe modification: Wrap calls in `document.addEventListener('DOMContentLoaded', ...)` to make execution order explicit.

## Test Coverage Gaps

**No automated tests of any kind:**
- What's not tested: Scoring logic edge cases, DOM rendering, checkbox/radio state management, result display toggling.
- Files: `index.html` (entire `<script>` block, lines 443–603)
- Risk: Any change to `calculateScore()` can introduce silent regressions. No regression protection exists.
- Priority: High — the scoring logic is the core value proposition of this tool.

**No cross-browser/device testing infrastructure:**
- What's not tested: Mobile viewport behavior, Safari-specific CSS rendering, touch interactions with custom radio/checkbox components.
- Files: `index.html` (CSS sibling selector patterns, lines 42–68)
- Risk: The custom CSS checkbox/radio states use `input:checked + div` sibling selectors which are broadly supported, but have not been validated on older mobile browsers.
- Priority: Medium.

---

*Concerns audit: 2026-03-05*
