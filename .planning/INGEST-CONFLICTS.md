## Conflict Detection Report

### BLOCKERS (0)

_No blockers detected._

### WARNINGS (0)

_No competing variants detected._

### INFO (2)

[INFO] Single-doc ingest — no cross-doc precedence to apply
  Note: Ingest set contains exactly one document (plan.md, classified as PRD, confidence=medium). With only one source per type and no ADRs/SPECs present, the precedence ordering ADR > SPEC > PRD > DOC produces no contradictions to resolve. Cycle detection on the cross-ref graph completed with no cycles (plan.md has 4 outbound refs, none of which are in the ingest set).
  source: /Users/petergiordano/Documents/GitHub/plg-readiness-rebrand/.planning/intel/classifications/plan-a7f3c2e1.json

[INFO] PRD-embedded "Locked decisions" surfaced as locked-constraint requirements
  Note: plan.md is type=PRD with document-level locked=false, but it contains a "Locked decisions" section that the classifier explicitly flagged (notes field) as hard constraints the project owner intends as settled. Per the user prompt to /gsd-ingest-docs, each bullet in that section was extracted as a separate requirement with kind=locked-constraint in requirements.md (REQ-single-file-no-build, REQ-no-dark-backgrounds, REQ-theme-contract-css-vars, REQ-tailwind-points-at-vars, REQ-structure-skin-separation, REQ-theming-visual-only). These are NOT promoted to formal ADRs — promotion is a separate step downstream of synthesis if the owner chooses.
  source: /Users/petergiordano/Documents/GitHub/plg-readiness-rebrand/plan.md ("Locked decisions" §) and /Users/petergiordano/Documents/GitHub/plg-readiness-rebrand/.planning/intel/classifications/plan-a7f3c2e1.json (notes field)
