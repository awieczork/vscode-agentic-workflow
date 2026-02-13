---
description: 'Generate a 12-step OKLCH palette with contrast audit from a primary hex color'
argument-hint: 'Enter a primary hex color (e.g., #008080)'
---

<!-- Accepts a single hex color and produces a complete 12-step Radix-architecture palette in OKLCH with WCAG 2.1 AA and APCA contrast verification. -->

Generate a complete 12-step OKLCH color palette and contrast audit report from the primary hex color `${input:primaryHex}`.


<palette_context>

Load the color derivation rules: [color-derivation.instructions.md](../instructions/color-derivation.instructions.md)

Load the contrast verification process: [contrast-audit SKILL.md](../skills/contrast-audit/SKILL.md)

Use the `coloraide` Python library for all color conversions and contrast calculations. Convert `${input:primaryHex}` to OKLCH as the starting point — extract the hue (H) and use it as the hue anchor for both the accent and neutral scales.

</palette_context>


<accent_scale>

Derive a 12-step accent scale from `${input:primaryHex}` following Radix architecture. Each step targets a specific role and lightness band in OKLCH:

- **Steps 1–2 (app backgrounds)** — L ~0.13–0.18, very low C. Darkest surface colors for editor and panel backgrounds
- **Steps 3–5 (component backgrounds)** — L ~0.20–0.30, low C. Subtle surfaces for hover states, active selections, sidebars
- **Steps 6–8 (borders)** — L ~0.35–0.50, moderate C. Separators, input borders, focus rings
- **Steps 9–10 (solid/accent)** — L ~0.55–0.70, peak C derived from the primary color. Buttons, badges, active indicators
- **Steps 11–12 (text)** — L ~0.80–0.97, moderate C. Primary and secondary text, headings

Preserve the hue (H) from `${input:primaryHex}` across all 12 steps. Adjust lightness (L) and chroma (C) per step — chroma peaks at steps 9–10 and tapers toward both ends of the scale.

</accent_scale>


<neutral_scale>

Derive a 12-step neutral scale using the same hue as `${input:primaryHex}` but with near-zero chroma to provide a tinted gray ramp:

- Same lightness bands as the accent scale (steps 1–12 map to the same roles)
- Chroma values at ~0.005–0.015 — enough for a subtle hue tint, not enough to read as colored
- The hue tint creates visual cohesion between accent and neutral surfaces

</neutral_scale>


<contrast_verification>

Compute contrast ratios for these critical pairs using both WCAG 2.1 and APCA methods:

| Pair | Foreground | Background | Minimum WCAG CR | Minimum APCA Lc |
|---|---|---|---|---|
| Text on app bg | Step 12 | Step 1 | 7.0 (AAA) | 75 |
| Text on app bg | Step 11 | Step 1 | 4.5 (AA) | 60 |
| Text on surface | Step 11 | Step 2 | 4.5 (AA) | 60 |
| Accent on app bg | Step 9 | Step 1 | 3.0 (AA large) | 45 |

Run the same pairs for the neutral scale (neutral step 12 vs neutral step 1, etc.).

Flag any pair that fails either WCAG or APCA thresholds. If a pair fails, suggest an adjusted L or C value that would pass while staying within the step's target lightness band.

</contrast_verification>


<output_format>

Return two tables and a summary.

**Accent palette table:**

```
| Step | Role             | Hex     | L     | C     | H     |
|------|------------------|---------|-------|-------|-------|
| 1    | App background   | #XXXXXX | 0.XXX | 0.XXX | XXX.X |
| ...  | ...              | ...     | ...   | ...   | ...   |
| 12   | Primary text     | #XXXXXX | 0.XXX | 0.XXX | XXX.X |
```

**Neutral palette table:** Same format as the accent table.

**Contrast audit report:**

```
| Pair (fg/bg)          | WCAG CR | WCAG Pass? | APCA Lc | APCA Pass? |
|-----------------------|---------|------------|---------|------------|
| Accent 12 / Accent 1  | XX.XX   | Yes/No     | XX      | Yes/No     |
| ...                    | ...     | ...        | ...     | ...        |
```

Mark failing pairs with `FAIL` and include the suggested fix inline. End with a one-line summary: total pairs checked, passes, and failures.

</output_format>
