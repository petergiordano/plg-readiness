# Overdrive GTM -- Brand Identity and Design Style Guide

> Visual companion to `writing-style-overdrive.md`. This file governs how Overdrive *looks*. The voice file governs how it *sounds*. Together they form the Overdrive brand standard.

---

## 1. Scope and Quick Reference

### Scope

**This file covers (visual):** logo, color palette, typography, layout and composition, imagery, iconography, diagrams and data viz, AI-assisted visual generation, brand personality.

**See `writing-style-overdrive.md` for (writing):** voice and tone, banned phrases, copy formatting by content type, opening hooks, metaphor rules, pre-publish writing checklist.

**Audience for this guide:** designers, marketers, AI tools (Claude, ChatGPT, DALL-E, Gamma, Midjourney, v0, bolt.new, Cursor, Claude Code), and external vendors producing visuals, decks, web interfaces, illustrations, or collateral for Overdrive.

**Target end-user audience for Overdrive content:** early-stage, venture-backed startup founders (Inception through Series A/B) building B2B SaaS for Mid-Market and Enterprise. The brand centers on product and go-to-market (GTM) expertise.

### Quick Reference

The shortest version of the rules. If you only read this section, you'll get most of it right.

- **Lead color:** Orange (#FF9000), used structurally — section dividers, headlines on dark, callouts. Not a timid accent.
- **Backgrounds:** Warm off-white (#FFF8F0) on web. White in print. Near-black (#1A1A1A) for dark sections.
- **Web fonts:** Space Grotesk (display), Plus Jakarta Sans (body), JetBrains Mono (code). All Google Fonts.
- **Editorial alternate (display):** Syne — for thought leadership content where you want more authority.
- **Print and slide font:** Raleway only.
- **Banned web/app fonts:** Inter, Roboto, Open Sans, Lato, default system fonts. They produce generic AI-default output.
- **Banned aesthetics:** pastel SaaS, purple gradient tech, corporate blue, bubbly 3D illustration, sterile white backgrounds.
- **Recognition test:** if the design could belong to any other B2B SaaS brand, revise.

Consistency builds trust. Distinctiveness builds recognition.

---

## 2. Logo Usage

* **Variants:** Full-color, monochrome, and icon-only formats are approved.

* **Placement:** Consistent usage in top-left or bottom-right corners.

* **Sizing & Clear Space:** Maintain minimum logo sizes for legibility and preserve adequate clear space around the logo to avoid clutter.

---

## 3. Color Palette

### Primary Colors

| Name | Hex | Role |
| :--- | :--- | :--- |
| Orange | #FF9000 | Lead accent: headlines, section dividers, structural elements, icons, callouts |
| White | #FFFFFF | Primary background (slides, print) |
| Warm Off-White | #FFF8F0 | Primary background (web, apps) -- use instead of sterile #FFFFFF for warmth |

### Secondary Colors

| Name | Hex | Role |
| :--- | :--- | :--- |
| Dark Gray | #434343 | Primary text for headings and body |
| Gray 1 | #666666 | Secondary backgrounds, borders |
| Gray 2 | #8A8A8A | Muted text, tertiary backgrounds |
| Golden Yellow | #F1C232 | Secondary highlight, supporting warmth |
| Light Yellow | #FFE599 | Lighter secondary highlight |
| Blue | #55BFFA | Cool contrast accent, used sparingly |
| Muted Blue | #6E9FBA | Soft accent |
| Muted Brown | #A58E6F | Warm tone setter, earthy grounding |

### Dark Mode / Dark Sections

| Name | Hex | Role |
| :--- | :--- | :--- |
| Near Black | #1A1A1A | Dark section backgrounds |
| Dark Surface | #242424 | Card/component surfaces on dark |
| Orange on Dark | #FF9000 | Headlines, dividers, accents on dark backgrounds |
| Light text on Dark | #F5F5F5 | Body text on dark backgrounds |

### CSS Variables (for web projects)

```css
:root {
  --accent-primary: #FF9000;
  --accent-secondary: #F1C232;
  --accent-tertiary: #55BFFA;
  --text-primary: #434343;
  --text-muted: #8A8A8A;
  --surface-light: #FFFFFF;
  --surface-warm: #FFF8F0;
  --surface-dark: #1A1A1A;
  --surface-dark-card: #242424;
  --tone-brown: #A58E6F;
  --tone-muted-blue: #6E9FBA;
  --border-light: #E5E5E5;
}
```

### How Orange Works

Orange is the lead color, not a timid accent. It should feel structural and confident:

- **Headlines on dark backgrounds:** Orange text on #1A1A1A
- **Section dividers:** Full-width orange bars or rules
- **Pull-quote backgrounds:** Orange background with white or dark text
- **Icon fills:** Solid orange icons on light backgrounds
- **Callout boxes:** Orange left border or orange background strip
- **Web UI:** Orange primary buttons, active states, progress indicators

Orange should appear in every major section of a page or deck. If you remove the orange and the design still works, you haven't used it enough.

**Image Color Palette:** Match the above where applicable, especially for iconography, illustrations, and diagrams.

---

## 4. Typography

### Font Families

**For web apps and digital products:**

| Role | Primary Choice | Alternate | Weight | Google Fonts |
| :--- | :--- | :--- | :--- | :--- |
| Display / Headlines | Space Grotesk | Syne | 600-700 | [Space Grotesk](https://fonts.google.com/specimen/Space+Grotesk), [Syne](https://fonts.google.com/specimen/Syne) |
| Body Text | Plus Jakarta Sans | Outfit | 400-500 | [Plus Jakarta Sans](https://fonts.google.com/specimen/Plus+Jakarta+Sans), [Outfit](https://fonts.google.com/specimen/Outfit) |
| Mono (code, data) | JetBrains Mono | Geist Mono | 400-500 | [JetBrains Mono](https://fonts.google.com/specimen/JetBrains+Mono), [Geist Mono](https://fonts.google.com/specimen/Geist+Mono) |
| Accent Text | Same as display | -- | 600+ in #FF9000 | -- |

All fonts are available on Google Fonts for zero-friction loading. No self-hosting or third-party CDNs required.

**When to use each display font:**
- **Space Grotesk** -- Default. Clean, techy, distinctive without being loud. Good weight range. Works for product pages, dashboards, landing pages.
- **Syne** -- Editorial punch. Bolder personality. Use for thought leadership content, blog headers, presentation-style web pages where you want more visual authority.

**For presentations and print:**

| Role | Font | Weight |
| :--- | :--- | :--- |
| Slide Titles | Raleway | SemiBold (600) |
| Body Text | Raleway | Regular (400) |
| Accent Text | Raleway | SemiBold (600) in #FF9000 |

Raleway is acceptable for slides and print where custom font loading is not practical. For any web or app project, use the digital font stack above.

**Banned fonts (web/app context):** Inter, Roboto, Open Sans, Lato, default system fonts. These produce generic output that looks like every other AI-generated interface.

### Font Hierarchy and Sizing

**Web / App:**

| Style | Size | Line Height | Weight | Use |
| :--- | :--- | :--- | :--- | :--- |
| Display | 56-72px | 1.1 | 700-800 | Hero headlines, page titles |
| H1 | 40-48px | 1.2 | 700 | Section headlines |
| H2 | 28-32px | 1.3 | 600 | Subsection headlines |
| H3 | 22-24px | 1.4 | 600 | Card titles, feature headers |
| Body Large | 18-20px | 1.6 | 400 | Lead paragraphs, feature text |
| Body | 16px | 1.6 | 400 | Default body text |
| Body Small | 14px | 1.5 | 400 | Secondary text, captions |
| Mono | 14-16px | 1.5 | 400 | Code, data, metrics |

**Presentations:**

| Style | Size | Notes |
| :--- | :--- | :--- |
| Slide Title | 36pt+ | Bold and attention-grabbing |
| Subheadline | 24-30pt | Semi-bold, lighter than headlines |
| Body Text | 18-20pt | Clear and easy to read |

### Typography Principles

- Use extreme weight contrasts: 200 weight for large display text, 700-800 for emphasis. Not 400 vs 600.
- Size jumps should be 3x+ between headline and body. 56px headline with 16px body, not 24px headline with 16px body.
- One display font used with conviction is better than three fonts used cautiously.
- Avoid all caps except for short labels or overlines (12px, letter-spacing: 0.1em).
- Use consistent line spacing. Body text at 1.6 line-height.
- Limit italics. Use weight or color for emphasis instead.

### Loading Fonts (Web)

```html
<!-- Default stack: Space Grotesk + Plus Jakarta Sans + JetBrains Mono -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
```

```html
<!-- Editorial stack: Syne + Plus Jakarta Sans + JetBrains Mono -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=Plus+Jakarta+Sans:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
```

```css
/* CSS font-family declarations */
--font-display: 'Space Grotesk', sans-serif;   /* or 'Syne' for editorial */
--font-body: 'Plus Jakarta Sans', sans-serif;
--font-mono: 'JetBrains Mono', monospace;
```

---

## 5. Layout & Composition

- **Slide Structure:** Header > Subhead > Body > Visual. Align everything. Respect margins.
- **Content Density:** Limit to 3-5 bullet points per slide.
- **Hierarchy:** Use font size, weight, and color to guide attention.

### Web Layout Principles

- Layouts should feel structured and confident, not cramped or busy.
- Use asymmetry where it creates visual interest. Not everything needs to be centered.
- Generous whitespace between sections. Tight spacing within components.
- One primary action per view. Clear visual hierarchy.
- Use warm off-white (#FFF8F0) as the default light background, not sterile white.
- Dark sections (#1A1A1A) with orange accents create rhythm and contrast across a page.
- Break the grid when it serves the content. An oversized headline that bleeds into a margin is more memorable than one that sits politely in a column.

---

## 6. Imagery and Iconography

### Photographic Style

- **Use real imagery for:**
  - Customer testimonials
  - Lifestyle use cases
  - Product in action
- Apply consistent lighting and grading
- Maintain mood and tone harmony

### Vector Illustration Style

- **Ideal for:**
  - Abstract ideas
  - Conceptual processes
  - Infographics
- Match Overdrive color palette
- Clean lines, modern geometry
- Flat, no 3D effects, no shadows
- Do not include any words, text, numbers, or any copy of any kind

### Combined Use Guidelines

- Use one style per slide or section
- Ensure color harmony across styles
- Anchor to content type (photos for stories, vectors for data/processes)

---

## 7. Diagrams, Tables, and Data Visualization

### Diagrams

- Use linear, uncluttered visuals
- Apply brand accent colors to indicate flow or importance
- Prefer gradient-infused funnel diagrams or minimalist bell curves

### Tables

- Simple grid layout
- Alternate row shading optional
- Limit to 2-3 colors max for clarity

### Charts

- Direct labeling
- Avoid dense legends
- Keep whitespace generous

---

## 8. Presentation Visual Style

This section governs how Overdrive presentations *look*. For voice and copy on slides, follow `writing-style-overdrive.md`.

- **Visual feel:** Editorial authority. Confident typography, structural orange, generous whitespace.
- **Audience match:** Founders, GTM leaders, early execs. Visuals should feel earned, not decorative.
- **Slide rhythm:** Vary slide types — full-bleed image, type-only, dark-section punctuation, data viz. Don't repeat the same layout three slides in a row.
- **Density:** 3–5 bullets max per slide. If you need more, split the slide.
- **Where orange goes on slides:** title underlines, data callouts, section transitions, pull quotes. Every section should have at least one orange element.

---

## 9. Brand Personality -- Visual Identity

This section defines what makes Overdrive look and feel like Overdrive -- not just consistent, but recognizable.

### The Overdrive Aesthetic

**Editorial authority meets startup energy.**

Overdrive content should feel like it comes from someone who has done the work, seen the patterns, and is sharing hard-won insight. The visual tone is warm, bold, and high-contrast. It favors clarity over cleverness and confidence over caution.

### What Overdrive IS

- **Warm:** Orange-led palette, off-white backgrounds, earthy supporting tones. Nothing cold or clinical.
- **Bold:** Large type, strong color contrast, orange used structurally. Not timid or decorative.
- **High-contrast:** Dark text on light, orange on dark, clear visual separation between sections.
- **Typographically driven:** Headlines carry the page. Type hierarchy does the heavy lifting before images or icons add detail.
- **Structurally confident:** Layouts have clear direction. Whitespace is generous but intentional. Every element earns its place.

### What Overdrive is NOT

- Not pastel SaaS (soft purples, light blues, rounded everything)
- Not purple gradient tech (the default AI-generated aesthetic)
- Not corporate blue (safe, cold, forgettable)
- Not bubbly illustration style (3D characters, bouncy shapes, playful for the sake of playful)
- Not cluttered or dense (too many elements competing for attention)
- Not generic (if you remove the logo and the design could belong to anyone, it fails)

### The Signature Move

Orange as a structural element. Most brands use their accent color for a button here, an icon there. Overdrive uses orange to create rhythm across a page or deck:

- Orange section dividers between content blocks
- Orange-backed pull quotes or callout boxes
- Orange headlines on dark (#1A1A1A) backgrounds
- Full-width orange bars to punctuate transitions
- Orange progress indicators and active states in web UI

If you remove the orange and the design still feels complete, you haven't used enough.

### The Recognition Test

Show someone an Overdrive page with the logo removed. They should still recognize it as Overdrive because of:
1. The orange structural presence
2. The warm, high-contrast tone
3. The confident typography
4. The editorial, authority-driven layout

If it could belong to any B2B SaaS brand, revise.

---

## 10. AI-Assisted Visual Generation

### The Problem with Default AI Output

AI tools (Claude, ChatGPT, DALL-E, Gamma, Midjourney, v0, bolt.new) converge toward the statistical average of the web. Without specific direction, they produce: Inter font, purple-to-blue gradients, rounded corners, symmetric grids, evenly distributed pastels. This looks like every other AI-generated interface. It does not look like Overdrive.

### For Web and App Development (Claude Code, Cursor, v0, bolt.new)

Paste the Overdrive design guardrail from `Anti-Slop-Design-Prompt.md` into your CLAUDE.md or system prompt. It contains the full Overdrive palette, font stack, spatial rules, and a brand-specific slop detection checklist.

Reference: `docs/design/Anti-Slop-Design-Prompt.md` -- Overdrive GTM Version

### For Presentations (Gamma.app)

**Custom Prompt:**

```
Editorial-style layouts with strong typographic hierarchy. Core palette: 
vibrant orange (#FF9000) as a dominant structural color, dark charcoal 
gray (#434343) text, golden yellow (#F1C232) secondary highlights, with 
light blue (#55BFFA) used sparingly for cool contrast. Warm off-white 
backgrounds, not sterile white. Bold headlines, generous whitespace, 
clean section dividers. 2D vector illustrations with clean lines and 
modern geometry -- no 3D, no shadows, no text in graphics. Professional 
and confident, not corporate or generic. Think editorial authority, 
not tech startup template.
```

### For Image Generation (DALL-E, Midjourney, etc.)

**Prompt keywords aligned to Overdrive brand:**

```
2D vector art, flat, clean lines, modern geometry, conceptual process 
diagram, data visualization, outline iconography, warm orange and 
charcoal palette, golden yellow accents, editorial feel, confident, 
high-contrast, professional, minimal but warm, no purple, no blue 
gradients, no 3D, no shadows, no text in image
```

**Keywords to AVOID (they produce generic output):**

```
DO NOT USE: minimalist (too vague), sleek (meaningless), corporate 
(produces cold/blue output), innovative (produces purple/gradient), 
polished (too generic), cutting-edge, modern aesthetic (defaults to 
pastel SaaS), clean design (too broad)
```

### For Diagrams and Data Visualization

- Grayscale base with orange (#FF9000) accents to highlight key data points or flow direction
- Golden yellow (#F1C232) for secondary emphasis
- High whitespace, direct labeling, no dense legends
- Outline icons in dark gray; glyph icons in orange on white or dark backgrounds

### AI Output Quality Check

Before accepting any AI-generated visual for Overdrive, verify:

- [ ] Orange is present as a structural element, not just a small accent
- [ ] Background is warm off-white (#FFF8F0) or intentional dark (#1A1A1A), not sterile white
- [ ] Typography uses the Overdrive font stack, not Inter/Roboto/Open Sans
- [ ] Layout has clear hierarchy with generous whitespace
- [ ] The visual could not belong to a generic B2B SaaS brand
- [ ] No purple-to-blue gradients anywhere
- [ ] Illustrations are flat 2D vector with no text, no 3D, no shadows

If the output fails 2+ checks, revise before using.

---

## 11. Version History

| Version | Date | Changes |
| :--- | :--- | :--- |
| 1.0 | Original | Initial brand guide |
| 2.0 | 2025-02-11 | Added: visual personality (Section 9), AI generation rules (Section 10), web typography stack, CSS variables, dark mode palette, warm off-white background, orange-as-structure guidance. Updated: typography to separate web/print stacks, layout principles for web. Archived: generic Gamma keyword list replaced with brand-specific prompts. |
| 2.1 | 2025-02-12 | Typography: replaced Clash Display/General Sans (Fontshare-only) with Space Grotesk/Syne (Google Fonts). All web fonts now load from Google Fonts with zero friction. Added usage guidance for when to use each display font. Added CSS font-family variable declarations. |
| 3.0 | 2026-05-06 | Reframed as visual companion to `writing-style-overdrive.md`. Replaced Section 1 (Introduction) with Scope + Quick Reference. Renamed Section 8 from "Presentation Style and Tone" to "Presentation Visual Style" — voice/tone bullets removed (now solely owned by `writing-style-overdrive.md`); replaced with slide-specific visual rules. Cross-references to `writing-style-overdrive.md` added throughout. |
