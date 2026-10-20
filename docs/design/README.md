# Design references

| Theme | Where it applies | Spec |
| :- | :- | :- |
| **Overdrive Light** (default) | Bare URL | `~/.claude/identity/overdrive-light-design-system.md` (Drive master `@APG1-Identity Stack/overdrive-light-design-system.md`); kit at `~/.claude/skills/overdrive-light-design-system/` |
| **Overdrive Alpha** (the v1.0 look) | `?client=alpha` | `design-system-alpha-overdrive.md` in this folder |
| Alchemist (stub) | `?client=alchemist` | Placeholder values, no brand spec |

`Overdrive_Brand-Identity-Design-and-Style-Guide.md` and `Modern-Web-UI-Design-Guidelines.md`
predate both systems and are kept for history only.

## Deliberate deviations from the Light guide

- **Primary button fill is Azure Ink `#0C6FD1`, not Signal Azure `#1F8EFF`.** White text on
  `#1F8EFF` is 3.3:1, which fails WCAG AA for button-size text. White on Azure Ink is 5.0:1.
  Signal Azure still carries the rules, progress bar, and selected borders, which only need 3:1.
- **The "Pure PLG" chip text uses `#0A5DB0`.** Azure Ink on the azure tint is 4.41:1, just
  under AA at 12px.
- **Answer cards keep v1.0's 1.5px border and 10px radius** (the guide's card is 1px / 8px),
  because the answer-card styles are shared with the alpha and alchemist themes.
- **Text on the azure tint is Ink, not Azure Ink.** Azure Ink on `#E8F2FF` is 4.41:1, so the
  "Your row" tag in the highlighted matrix row and the footer's Overdrive Alpha link use Ink.

## Logo

The header lockup is the shipped `logo-mark-azure.svg` plus "Overdrive Alpha" set as type
(Space Grotesk 700, 0.62x the mark height, -0.01em), per the Light guide. The mark is inlined
as a data URI in the `--logo-mark` token so the app stays one file; `?client=alpha` overrides
it with the original `logo-mark.svg`. Alchemist sets `--brand-od-display: none` and carries
no Overdrive branding.
