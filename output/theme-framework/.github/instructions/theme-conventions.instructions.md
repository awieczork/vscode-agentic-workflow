---
description: 'Cross-editor theme format conventions for VS Code JSON, RStudio rstheme CSS, and DBeaver XML color themes'
applyTo: ['*-color-theme.json', '**/*.rstheme', '**/dbeaver-theme*.xml']
---

This file defines cross-editor theme format conventions for VS Code, RStudio, and DBeaver targets. The governing principle is semantic consistency — identical conceptual roles (background, keywords, strings) use the same palette step across every editor, even when the underlying format differs.


<vscode_format>

VS Code themes use JSON with TextMate and semantic token scopes. Every generated theme must include workbench colors, TextMate token colors, and semantic token colors.

**File naming** — `*-color-theme.json`

**Required top-level keys:**

- `name` — theme display name
- `type` — ALWAYS `"dark"`
- `colors` — workbench color overrides (800+ keys across 47 categories)
- `tokenColors` — TextMate scope rules array
- `semanticTokenColors` — semantic token overrides
- `semanticHighlighting` — ALWAYS `true`

**Workbench color categories** — key groups to populate:

- `editor.background`, `editor.foreground` — primary editor surface
- `activityBar.*` — left-edge icon bar
- `sideBar.*` — file explorer and panels
- `tab.*` — editor tab strip
- `statusBar.*` — bottom status bar
- `terminal.ansi*` — 16 ANSI terminal colors
- `list.*` — tree views and list selections
- `input.*` — text input fields
- `button.*` — primary and secondary buttons
- `badge.*` — notification badges
- `dropdown.*` — dropdown menus
- `panel.*` — bottom panels (terminal, output, debug console)
- `titleBar.*` — window title bar

**TextMate token colors** — each entry has `scope` (string or string array) and `settings` (object with `foreground` and optional `fontStyle`). The 11 root scope groups:

- `comment` — code comments
- `constant` — literals and built-in constants
- `entity` — class names, function names, tag names
- `invalid` — illegal or deprecated syntax
- `keyword` — language keywords and operators
- `markup` — markdown and markup constructs
- `meta` — meta-scopes for grouping
- `punctuation` — delimiters, brackets, separators
- `storage` — type annotations and modifiers
- `string` — string literals and regex
- `support` — built-in functions and library types
- `variable` — variable names and parameters

**Semantic token types** — 21 types: `namespace`, `type`, `class`, `enum`, `interface`, `struct`, `typeParameter`, `parameter`, `variable`, `property`, `enumMember`, `event`, `function`, `method`, `macro`, `label`, `comment`, `string`, `keyword`, `number`, `operator`

**Semantic token modifiers** — 10 modifiers: `declaration`, `definition`, `readonly`, `static`, `deprecated`, `abstract`, `async`, `modification`, `documentation`, `defaultLibrary`

**Package manifest** — `package.json` must include:

- `contributes.themes` array with `label`, `uiTheme: "vs-dark"`, and `path`
- `categories: ["Themes"]`

</vscode_format>


<rstudio_format>

RStudio themes use plain CSS targeting the Ace editor component. Dark mode is auto-detected from the background color darkness value.

**File naming** — `*.rstheme`

**Editor chrome selectors:**

- `.ace_editor` — `background`, `color`, `font` (primary surface)
- `.ace_gutter` — `background`, `color` (line number gutter)
- `.ace_cursor` — `color` (caret color)
- `.ace_marker-layer .ace_selection` — `background` (text selection highlight)
- `.ace_marker-layer .ace_active-line` — `background` (current line highlight)

**Syntax class selectors** — approximately 12 classes:

- `.ace_comment` — code comments
- `.ace_keyword` — language keywords
- `.ace_string` — string literals
- `.ace_constant` — general constants
- `.ace_constant.ace_language` — language-specific constants (`TRUE`, `FALSE`, `NULL`)
- `.ace_constant.ace_numeric` — numeric literals
- `.ace_keyword.ace_operator` — operators (`+`, `-`, `<-`, `%>%`)
- `.ace_support.ace_function` — function calls
- `.ace_markup.ace_heading` — section headings (R Markdown)
- `.ace_meta.ace_tag` — tag constructs

**Installation** — `rstudioapi::addTheme("path/to/theme.rstheme")`

**Constraints:**

- NEVER use `!important` unless overriding a built-in theme — Ace applies specificity correctly
- ALWAYS set `.ace_editor` background dark enough for RStudio to auto-detect dark mode (luminance below 0.2)
- ALWAYS include both `.ace_gutter` background and color — omitting either causes visual glitches

</rstudio_format>


<dbeaver_format>

DBeaver themes use Eclipse E4 CSS combined with preference keys for SQL editor syntax highlighting. This format targets plugin inclusion — there is no simple user-facing import mechanism.

**Known limitation** — DBeaver requires plugin development for custom themes. There is no `addTheme()` API or user import path. Theme definitions must be structured for inclusion in a DBeaver plugin project that registers color overrides via `IEclipsePreferences` CSS selectors.

**SQL editor preference keys** — under `org.jkiss.dbeaver.sql.editor.color.*`:

- `background` — editor background
- `foreground` — default text color
- `keyword.foreground` — SQL keywords (`SELECT`, `FROM`, `WHERE`)
- `string.foreground` — string literals
- `number.foreground` — numeric literals
- `comment.foreground` — comments
- `command.foreground` — SQL commands
- `parameter.foreground` — query parameters
- `table.foreground` — table name references
- `column.foreground` — column name references
- `schema.foreground` — schema name references
- `composite.foreground` — composite field references
- `datatype.foreground` — data type names
- `delimiter.foreground` — statement delimiters
- `bracket.foreground` — bracket pairs
- `function.foreground` — function calls
- `ai.suggestion.foreground` — AI-generated suggestions

**DBeaver-unique tokens** — these semantic roles exist only in DBeaver and have no direct equivalent in VS Code or RStudio:

- `table.foreground` — table name highlighting
- `column.foreground` — column name highlighting
- `schema.foreground` — schema name highlighting
- `composite.foreground` — composite field highlighting
- `ai.suggestion.foreground` — AI suggestion overlay

**Constraints:**

- ALWAYS structure theme XML for plugin inclusion — no standalone file format exists
- NEVER assume user-facing import — document the plugin integration path
- ALWAYS include all 17 preference keys — partial definitions cause DBeaver to fall back to defaults for missing keys

</dbeaver_format>


<semantic_mapping>

This table defines the canonical mapping from semantic roles to palette steps and editor-specific tokens. Every theme generator must produce consistent colors for the same semantic role across all three editors.

| Semantic Role | Palette Step | VS Code Scope | RStudio Class | DBeaver Key |
|---|---|---|---|---|
| Background | step 1 | `editor.background` | `.ace_editor` background | `color.text.background` |
| Foreground | step 12 | `editor.foreground` | `.ace_editor` color | `color.text.foreground` |
| Comments | step 11 | `comment` | `.ace_comment` | `color.comment.foreground` |
| Keywords | step 9 (primary) | `keyword` | `.ace_keyword` | `color.keyword.foreground` |
| Strings | step 9 (accent-1) | `string` | `.ace_string` | `color.string.foreground` |
| Functions | step 9 (accent-2) | `entity.name.function` | `.ace_support.ace_function` | `color.function.foreground` |
| Constants | step 9 (accent-3) | `constant` | `.ace_constant` | `color.number.foreground` |
| Types | step 11 (accent-4) | `entity.name.type` | N/A | `color.datatype.foreground` |
| Selection BG | step 4 | `editor.selectionBackground` | `.ace_selection` background | N/A |
| Active Line | step 2 | `editor.lineHighlightBackground` | `.ace_active-line` background | N/A |
| Borders | step 6 | `panel.border` | `.ace_gutter` border | N/A |
| Secondary text | step 11 | `editorLineNumber.foreground` | `.ace_gutter` color | N/A |

**Reading the table:**

- **Palette Step** — refers to the algorithmic color pipeline output step, where step 1 is the darkest base and step 12 is the lightest foreground
- **N/A** — the editor has no equivalent token for this semantic role; skip it in that editor's output
- **Accent variants** — steps labeled `(primary)`, `(accent-1)`, etc. derive from the same palette step but use hue rotation to produce distinct colors

**Constraints:**

- NEVER assign different palette steps to the same semantic role across editors — consistency is the governing principle
- ALWAYS map every non-N/A cell in this table when generating a theme for any editor
- ALWAYS use the accent variant specified — accent-1 through accent-4 are algorithmically derived and must not be substituted

</semantic_mapping>


<file_generation_rules>

General rules that apply to all theme file generation regardless of target editor.

- ALWAYS generate hex color values in 6-digit lowercase format (`#1a1b2e`) — no shorthand, no uppercase
- NEVER hardcode color values — all colors must derive from the algorithmic palette pipeline
- ALWAYS include an alpha channel only when the editor format explicitly supports and requires it — VS Code uses `#rrggbbaa`, RStudio and DBeaver do not
- ALWAYS validate generated files against their format schema before writing — JSON parse for VS Code, CSS parse for RStudio, XML well-formedness for DBeaver
- NEVER mix editor-specific tokens across formats — each editor's output file is self-contained
- ALWAYS generate all three editor outputs from a single palette run — partial generation breaks cross-editor consistency

</file_generation_rules>
