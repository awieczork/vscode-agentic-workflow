---
description: 'OKLCH color derivation rules for palette generation and color manipulation'
applyTo: 'src/**/*.py'
---

This file defines color derivation rules for all palette generation and color manipulation code. The governing principle is perceptual uniformity — every color operation uses OKLCH color space to guarantee that equal numeric steps produce equal perceived changes.


<oklch_first>

All palette colors MUST be derived in OKLCH color space. OKLCH provides perceptual uniformity that HSL cannot — equal lightness steps in OKLCH produce equal perceived brightness changes across the entire hue range.

- NEVER derive colors in HSL or HSV — HSL has non-uniform lightness and produces visible hue shifts at low lightness values, making it unsuitable for dark theme palettes
- NEVER convert to HSL for intermediate manipulation — perform all lightness, chroma, and hue adjustments in OKLCH, then convert directly to sRGB for output
- ALWAYS use the OKLCH components as (L, C, H) where L is perceptual lightness (0.0–1.0), C is chroma (0.0–~0.4), and H is hue angle (0–360)
- ALWAYS apply gamut mapping when converting from OKLCH back to sRGB — OKLCH values may fall outside the sRGB gamut

</oklch_first>


<color_traceability>

Every color in a theme file must trace back to an algorithmic derivation from the primary hex input. No magic hex values.

- NEVER hardcode hex color literals in theme output files — every color must have a derivation path: primary hex → OKLCH decomposition → palette step → semantic role → theme key
- NEVER introduce one-off color values that bypass the palette system — if a theme key needs a color, it maps to a palette step
- ALWAYS document the derivation chain when adding new semantic roles — specify which palette and step the role maps to
- ALWAYS parameterize any color adjustment (lightness offset, chroma scale) as a named constant with a comment explaining its purpose

</color_traceability>


<radix_scale>

All palettes follow the Radix Colors 12-step architecture. Each step has a defined functional role — do not reassign step purposes.

- Steps 1–2: **App backgrounds** — darkest values in dark mode, used for base canvas and subtle surface distinction
- Steps 3–5: **Component backgrounds** — subtle (3), hover (4), and active/selected (5) states for interactive elements
- Steps 6–8: **Borders** — subtle (6), default (7), and strong/focused (8) border treatments
- Steps 9–10: **Solid colors** — primary solid fill (9) and its hover state (10), highest chroma in the scale
- Steps 11–12: **Text colors** — secondary/low-contrast text (11) and primary/high-contrast text (12)

- NEVER skip steps or collapse the 12-step range — each step serves a distinct UI function
- NEVER reuse a step for a purpose outside its functional band — step 3 is a component background, not a border
- ALWAYS maintain monotonic lightness progression from step 1 (darkest) to step 12 (lightest) in dark mode

</radix_scale>


<palette_derivation>

Palette generation converts a single primary hex input into complete 12-step scales for primary, neutral, and accent palettes.

**Primary palette** — Derive 12 steps by adjusting L and C in OKLCH while holding H constant (or near-constant):

- Dark mode lightness range: step 1 targets L ~0.13–0.15, step 12 targets L ~0.93–0.97
- Chroma curve: low for backgrounds (steps 1–2), gradually increasing through mid-range, peak at steps 9–10 (solid fills), moderate reduction for text (steps 11–12)
- ALWAYS keep hue constant across all 12 steps of a single palette — hue variation within a palette breaks color identity

**Neutral palette** — Derive a separate 12-step gray scale with near-zero chroma but the same hue as the primary:

- ALWAYS tint neutrals with the primary hue — use chroma values between 0.005 and 0.02 to give grays a subtle warm/cool cast matching the primary color
- NEVER use pure achromatic grays (C = 0) — untinted grays feel disconnected from the themed palette

**Accent palettes** — Derive additional 12-step scales by rotating hue in OKLCH:

- ALWAYS rotate hue while maintaining similar lightness and chroma profiles to the primary palette — this ensures perceptual consistency across accent colors
- NEVER derive accent palettes independently from scratch — use the primary palette's L/C curve as the template, applying only hue rotation

</palette_derivation>


<coloraide_usage>

Use `coloraide` (pure Python, no compiled dependencies) for all color operations. No other color library.

- ALWAYS use coloraide for color space conversions — hex ↔ sRGB ↔ OKLCH round-trips must go through `coloraide.Color`
- ALWAYS use coloraide's built-in gamut mapping (e.g., `fit('srgb')`) when converting OKLCH values back to sRGB — do not clamp RGB channels manually
- ALWAYS use coloraide for WCAG relative luminance calculation — do not reimplement the luminance formula
- NEVER use manual RGB channel arithmetic for lightness or chroma adjustments — perform adjustments on OKLCH components, then let coloraide handle the conversion

```python
# Correct — derive via OKLCH with coloraide
from coloraide import Color

primary = Color(primary_hex)
oklch = primary.convert('oklch')
base_l, base_c, base_h = oklch['lightness'], oklch['chroma'], oklch['hue']

step = Color('oklch', [target_l, target_c, base_h])
srgb_hex = step.convert('srgb').fit('srgb').to_string(hex=True)
```

```python
# Wrong — manipulating in HSL
import colorsys
r, g, b = hex_to_rgb(primary_hex)
h, l, s = colorsys.rgb_to_hls(r/255, g/255, b/255)
new_l = l * 0.5  # non-uniform perceptual result
```

</coloraide_usage>


<contrast_enforcement>

Every foreground/background pair in a theme must pass both WCAG 2.1 AA and APCA contrast thresholds. Use the `contrast-audit` skill for systematic verification.

- ALWAYS verify WCAG 2.1 AA minimums — 4.5:1 ratio for normal text, 3:1 for large text and UI components
- ALWAYS verify APCA thresholds — Lc 90 for body text, Lc 75 minimum for any readable content
- NEVER ship a theme without running the contrast audit against all foreground/background pairings
- ALWAYS calculate contrast using WCAG relative luminance from sRGB values (after gamut mapping), not from OKLCH lightness — OKLCH L is perceptual, not the W3C luminance formula
- ALWAYS pair high-lightness text steps (11–12) with low-lightness background steps (1–2) to maximize contrast in dark mode

</contrast_enforcement>
