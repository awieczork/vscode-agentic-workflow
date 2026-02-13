---
name: 'contrast-audit'
description: 'Audits color contrast in editor themes using WCAG 2.1 AA and APCA dual-check. Use when asked to "check contrast", "audit accessibility", "verify color pairs", or "generate contrast report". Validates foreground/background pairs against legal and perceptual thresholds, flags quality gaps, and produces structured pass/fail reports.'
---

This skill audits color contrast across editor theme files using both WCAG 2.1 AA (legal compliance) and APCA (perceptual quality) standards. The governing principle is dual-standard verification — every foreground/background pair must pass both the legally mandated WCAG ratio and the perceptually calibrated APCA lightness contrast. Begin with `<step_1_collect>` to extract all color pairs from the theme.


<use_cases>

- Audit a newly generated Radix 12-step palette against its background colors before export
- Verify a ported theme (RStudio `.rstheme` or DBeaver XML) maintains contrast parity with the VS Code JSON source
- Check individual foreground/background color pairs during iterative palette refinement
- Generate a structured contrast report for theme documentation or review

</use_cases>


<workflow>

Execute steps sequentially. Each step produces data that feeds the next — pairs feed classification, classification drives threshold selection, calculations produce the report.


<step_1_collect>

Extract all foreground/background color pairs from the theme file.

- Parse the theme format: VS Code JSON (`tokenColors`, `colors`), RStudio `.rstheme` CSS (property/value pairs), or DBeaver XML (color attributes)
- Build a pair list — each entry contains: `foreground_hex`, `background_hex`, `token_name`, `source_location`
- Normalize all hex values to 6-digit lowercase with `#` prefix (expand 3-digit shorthand, strip alpha channels)
- Validate each hex string against `^#[0-9a-f]{6}$` after normalization — invalid entries go to the error log

Output: a list of validated color pairs with token metadata.

</step_1_collect>


<step_2_classify>

Classify each pair by its usage context to determine which thresholds apply.

| Classification | Examples | WCAG threshold | APCA threshold |
|---|---|---|---|
| **body_text** | Editor foreground, comment text, string literals | 4.5:1 | Lc 75 |
| **large_text** | Section headings, title bar text, breadcrumb labels | 3:1 | Lc 60 |
| **ui_component** | Button text, badge text, status bar foreground | 3:1 | Lc 60 |
| **non_text** | Icon fills, focus borders, active tab indicators | 3:1 | Lc 45 |
| **decorative** | Selection highlights, indent guides, bracket pair colors | exempt | Lc 30 |

- Map each `token_name` to a classification using the theme format's semantic structure
- When a token cannot be classified, default to `body_text` (strictest thresholds)
- Record the classification alongside each pair for threshold lookup in later steps

</step_2_classify>


<step_3_calculate_wcag>

Calculate the WCAG 2.1 contrast ratio for each pair.

**Relative luminance:**

1. Convert hex to sRGB channels (0–1 range): `R_srgb = R_8bit / 255`
2. Linearize each channel:
   - If `C_srgb <= 0.04045`: `C_lin = C_srgb / 12.92`
   - Else: `C_lin = ((C_srgb + 0.055) / 1.055) ^ 2.4`
3. Compute luminance: `L = 0.2126 * R_lin + 0.7152 * G_lin + 0.0722 * B_lin`

**Contrast ratio:**

- `CR = (L_lighter + 0.05) / (L_darker + 0.05)` where `L_lighter >= L_darker`
- Result is a ratio ≥ 1.0 (e.g., 4.5, 7.2, 21.0)

Record `wcag_ratio` for each pair. Compare against the threshold from `<step_2_classify>`:

- `body_text`: pass if `CR >= 4.5`
- `large_text`, `ui_component`, `non_text`: pass if `CR >= 3.0`
- `decorative`: exempt — always pass

</step_3_calculate_wcag>


<step_4_calculate_apca>

Calculate the APCA Lc (Lightness Contrast) value for each pair, accounting for polarity.

**Luminance (Y) calculation:**

Use the same linearized sRGB values from `<step_3_calculate_wcag>`, then apply APCA coefficients:

- `Y = 0.2126729 * R_lin + 0.7151522 * G_lin + 0.0721750 * B_lin`
- Clamp: if `Y < 0` then `Y = 0`

**Polarity detection and Lc calculation:**

APCA is polarity-aware — dark-on-light and light-on-dark use different exponents.

- Determine polarity: compare `Y_text` vs `Y_background`
- Light text on dark background (dark mode typical): produces positive Lc
- Dark text on light background: produces negative Lc
- Use `abs(Lc)` for threshold comparison

For implementation, use the `coloraide` library's contrast utilities or the APCA-W3 reference algorithm. Do not hand-roll the full APCA formula — it includes soft clamp, output scale, and offset constants that change between specification revisions.

**Dark mode thresholds (absolute Lc values):**

| Classification | Minimum Lc | Preferred Lc |
|---|---|---|
| `body_text` | Lc 75 | Lc 90 |
| `large_text` | Lc 60 | Lc 75 |
| `ui_component` | Lc 60 | Lc 75 |
| `non_text` | Lc 45 | Lc 60 |
| `decorative` | Lc 30 | Lc 45 |

Record `apca_lc` for each pair. Compare against the minimum Lc from the classification.

</step_4_calculate_apca>


<step_5_detect_gaps>

Identify pairs that pass WCAG but fail APCA — the perceptual quality gap.

- Filter pairs where `wcag_result == pass` AND `apca_result == fail`
- These are legally compliant but perceptually poor — text may be technically readable but visually strained in dark mode
- Flag each gap pair with severity `warn` and note the Lc deficit: `"WCAG pass (CR {ratio}) but APCA fail (Lc {value}, needs Lc {threshold})"`
- Also flag the inverse (APCA pass, WCAG fail) as `error` — legal compliance is mandatory

</step_5_detect_gaps>


<step_6_check_radix_scale>

Validate the Radix Colors 12-step scale relationships if the theme uses a Radix-derived palette.

- **Step 11 vs step 2** (high-contrast text on app background): must achieve `Lc >= 60` APCA
- **Step 12 vs step 2** (highest-contrast text on app background): must achieve `Lc >= 90` APCA
- **Step 12 vs step 1** (highest-contrast text on deepest background): must achieve `Lc >= 90` APCA
- **Step 11 vs step 1**: must achieve `Lc >= 75` APCA

If the theme does not use a Radix scale, skip this step and note `"Radix scale check: skipped — non-Radix palette"` in the report.

</step_6_check_radix_scale>


<step_7_report>

Generate the contrast audit report. Structure:

```
Contrast Audit Report
Theme: {theme_name}
Date: {ISO 8601 date}
Pairs audited: {count}

Summary:
  WCAG pass: {count}  |  WCAG fail: {count}
  APCA pass: {count}  |  APCA fail: {count}
  Quality gaps (WCAG pass / APCA fail): {count}

Details:
  {token_name}
    FG: {fg_hex}  BG: {bg_hex}  Class: {classification}
    WCAG: {ratio}:1 — {PASS|FAIL} (need {threshold}:1)
    APCA: Lc {value} — {PASS|FAIL|WARN} (need Lc {threshold})

Radix Scale:
  Step 11 vs 2: Lc {value} — {PASS|FAIL}
  Step 12 vs 2: Lc {value} — {PASS|FAIL}

Failures:
  {list of all FAIL pairs with remediation hint}

Quality Gaps:
  {list of WCAG-pass/APCA-fail pairs with Lc deficit}
```

- Sort details by severity: `FAIL` first, then `WARN`, then `PASS`
- Include remediation hints for failures: suggest minimum lightness adjustment direction (lighter foreground or darker background)
- If all pairs pass both standards: `"All {count} pairs pass WCAG 2.1 AA and APCA dual-check."`

</step_7_report>

</workflow>


<error_handling>

- If a hex color is invalid after normalization, then log the error with token name and source location, exclude the pair from calculations, and include it in the report under a `Skipped` section
- If a color is out of sRGB gamut (channel values after conversion fall outside 0–1), then clamp to sRGB bounds before luminance calculation and append a `"clamped from out-of-gamut"` note to that pair's report entry
- If expected theme keys are missing foreground or background mappings, then emit a warning: `"Missing pair: {key} has no {foreground|background} — cannot audit"` and list in the report
- If the theme format is unrecognized, then return BLOCKED with the file extension and first 20 lines of content for manual classification
- If `coloraide` is unavailable, then fall back to manual sRGB linearization for WCAG; for APCA, return BLOCKED — hand-rolling APCA is error-prone

</error_handling>


<validation>

**P1 (blocking):**

- Every `body_text` pair achieves CR >= 4.5 WCAG AND abs(Lc) >= 75 APCA
- Every `large_text` pair achieves CR >= 3.0 WCAG AND abs(Lc) >= 60 APCA
- Every `ui_component` pair achieves CR >= 3.0 WCAG AND abs(Lc) >= 60 APCA
- Zero pairs fail WCAG while passing APCA (legal compliance is non-negotiable)

**P2 (quality):**

- Radix scale step 11 vs step 2 achieves abs(Lc) >= 60
- Radix scale step 12 vs step 2 achieves abs(Lc) >= 90
- Zero quality gaps (WCAG pass / APCA fail) in `body_text` classification
- All `non_text` pairs achieve CR >= 3.0 WCAG AND abs(Lc) >= 45 APCA

**P3 (polish):**

- Body text pairs reach preferred Lc 90 (not just minimum Lc 75)
- Report includes remediation hints for every failure
- No skipped pairs due to invalid hex colors

</validation>


<resources>

- [coloraide documentation](https://facelessuser.github.io/coloraide/) — Python library for color space conversions and contrast calculations
- [WCAG 2.1 contrast requirements](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html) — W3C specification for contrast ratio thresholds
- [APCA documentation](https://readtech.org/ARC/) — Accessible Reading Technologies, APCA contrast algorithm and Lc lookup tables

</resources>
