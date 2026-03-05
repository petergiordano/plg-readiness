# Technology Stack

**Analysis Date:** 2026-03-05

## Languages

**Primary:**
- HTML5 - Application structure and markup (`index.html`)
- CSS3 (inline + Tailwind utility classes) - All styling (`index.html`, `<style>` block and class attributes)
- JavaScript (ES2020+) - All application logic (`index.html`, inline `<script>` block)

**Secondary:**
- None - single-file application with no secondary language files

## Runtime

**Environment:**
- Browser (any modern browser supporting ES2020+)
- No server-side runtime required
- Static file serving only — open `index.html` directly or via any HTTP server

**Package Manager:**
- None - no package manager used
- Lockfile: Not applicable

## Frameworks

**Core:**
- Tailwind CSS (CDN, latest v3 via `https://cdn.tailwindcss.com`) - Utility-first CSS framework for all styling
  - Configured inline in `index.html` with a custom theme extension block (`tailwind.config` object)
  - Extends: `fontFamily.sans` (Inter), `colors.primary` (#4F46E5), `colors.primaryHover` (#4338CA), full `colors.slate` palette override

**Testing:**
- None - no testing framework present

**Build/Dev:**
- None - no build step; no bundler, transpiler, or dev server required
- Development: `python3 -m http.server 8080` (documented in `CLAUDE.md`)

## Key Dependencies

**Critical:**
- `https://cdn.tailwindcss.com` — Tailwind CSS play CDN; required for all layout, spacing, and color rendering; loaded in `<head>` of `index.html`
- `https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap` — Inter typeface; required for typography; loaded as `<link>` in `<head>` of `index.html`

Both dependencies are external CDN resources. The application will partially degrade without network access (no styling, fallback system fonts).

**Infrastructure:**
- None — no server, no database, no backend

## Configuration

**Environment:**
- No environment variables used
- No `.env` files present or required
- All configuration is hardcoded inside `index.html`

**Build:**
- No build config files (no `vite.config`, `webpack.config`, `tsconfig`, etc.)
- Tailwind configuration is an inline `tailwind.config` object in `<head>` of `index.html` (lines 10–34)
- Custom CSS overrides in `<style>` block in `<head>` of `index.html` (lines 36–69) — defines checkbox and radio visual states using CSS sibling selectors

## Platform Requirements

**Development:**
- Any OS with a modern browser
- Optional: Python 3 for local HTTP serving

**Production:**
- Any static file host (GitHub Pages, Netlify, S3, Vercel, etc.)
- No server-side requirements
- Single file deployment: `index.html`

---

*Stack analysis: 2026-03-05*
