# External Integrations

**Analysis Date:** 2026-03-05

## APIs & External Services

**Font Delivery:**
- Google Fonts - Serves the Inter typeface (weights 300–700)
  - URL: `https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap`
  - Auth: None required
  - Loaded as: `<link rel="stylesheet">` in `<head>` of `index.html`

**CSS Framework CDN:**
- Tailwind CSS Play CDN - Delivers Tailwind runtime for browser-side utility class generation
  - URL: `https://cdn.tailwindcss.com`
  - Auth: None required
  - Loaded as: `<script src="...">` in `<head>` of `index.html`

No other external services, APIs, or SDKs are used.

## Data Storage

**Databases:**
- None — no database of any kind

**File Storage:**
- None — no file storage; the application is entirely stateless

**Caching:**
- None — browser cache only (standard HTTP caching for CDN assets)

## Authentication & Identity

**Auth Provider:**
- None — no authentication; the application is fully public and anonymous

## Monitoring & Observability

**Error Tracking:**
- None

**Logs:**
- None — browser `console` is not used for logging in production code

## CI/CD & Deployment

**Hosting:**
- Not defined in codebase — no deployment config files present (no `netlify.toml`, `vercel.json`, `.github/workflows/`, etc.)
- Compatible with any static host; deployment is a single file copy of `index.html`

**CI Pipeline:**
- None

## Environment Configuration

**Required env vars:**
- None

**Secrets location:**
- None — no secrets of any kind

## Webhooks & Callbacks

**Incoming:**
- None

**Outgoing:**
- None

## Network Dependency Summary

The application has exactly two external network dependencies, both loaded at page load:

| Resource | URL | Purpose | Failure Impact |
|---|---|---|---|
| Tailwind CSS | `https://cdn.tailwindcss.com` | All layout and styling | Page renders unstyled; fully functional |
| Inter font | `https://fonts.googleapis.com` | Typography | Falls back to system sans-serif |

All application logic (scoring, rendering, DOM manipulation) runs entirely client-side with no outbound network calls after initial page load.

---

*Integration audit: 2026-03-05*
