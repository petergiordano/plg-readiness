# Technology Stack

**Analysis Date:** 2026-03-05

## Languages

**Primary:**
- HTML5 - Entire application structure and markup (`index.html`)
- CSS3 - Styling via Tailwind utility classes and inline `<style>` block (`index.html` lines 36–69)
- JavaScript (ES2020+) - All application logic in inline `<script>` block (`index.html` lines 443–603)

**Secondary:**
- None

## Runtime

**Environment:**
- Browser (static file, no server required)
- Development: any static file server or direct `file://` open
- No Node.js, Python, or server runtime required

**Package Manager:**
- None — no package manifest (`package.json`, `requirements.txt`, etc.)
- No lockfile

## Frameworks

**Core:**
- Tailwind CSS (CDN, latest v3 via `https://cdn.tailwindcss.com`) - Utility-first CSS framework for all styling
  - Config block at `index.html` line 9–34 extends default palette with `primary`, `primaryHover`, and custom `slate` shades
  - Loaded via `<script src="https://cdn.tailwindcss.com">` — NOT installed locally

**Testing:**
- None

**Build/Dev:**
- None — no build system, bundler, or transpiler
- Development server option: `python3 -m http.server 8080` (documented in `CLAUDE.md`)

## Key Dependencies

**Critical:**
- Tailwind CSS (CDN) — all visual layout and spacing relies on Tailwind utility classes; removing CDN breaks all styling
- Inter (Google Fonts CDN) — `https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap`; fallback is generic `sans-serif`

**Infrastructure:**
- None (no backend, no database, no server dependencies)

## Configuration

**Environment:**
- No environment variables
- No `.env` files
- No secrets or API keys required

**Build:**
- No build config files
- Tailwind config is inline in `index.html` at lines 9–34 (not a separate `tailwind.config.js`)
- VS Code workspace file: `plg-readiness.code-workspace` (minimal, just sets root folder)

## Platform Requirements

**Development:**
- Any modern browser to open `index.html` directly
- Optional: Python 3 for `python3 -m http.server 8080`
- No Node.js, no package installs, no build step

**Production:**
- Any static file host (GitHub Pages, Netlify, Vercel, S3, etc.)
- Single file deployment: `index.html` is the entire application
- Requires outbound internet access at runtime for CDN resources (Tailwind CSS and Google Fonts)

---

*Stack analysis: 2026-03-05*
