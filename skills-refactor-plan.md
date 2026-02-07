This plan fully refactors all 4 skill folders in `.github/skills/` to align with current instruction files, VS Code authoritative documentation, and design heuristics. The governing principle is: XML tags are the exclusive structural system — markdown headings are forbidden everywhere — and skills produce artifacts that follow the grouped format.


<scope>

**In:**
- All files in `.github/skills/skill-creator/` (5 files)
- All files in `.github/skills/agent-creator/` (7 files)
- All files in `.github/skills/instruction-creator/` (5 files)
- All files in `.github/skills/prompt-creator/` (4 files + 1 new)
- Total: ~21 files, all created from scratch

**Out:**
- Instruction files (`.github/instructions/`)
- Agent files (`.github/agents/`)
- Anything outside `.github/skills/`

</scope>


<dependencies>

| Dependency | Status | Evidence |
|-----------|--------|----------|
| Current instruction files (structure, writing, glossary) | [PASS] | Read and verified — XML exclusive structure, grouped format, canonical vocabulary |
| VS Code customization docs (custom-agents.md, agent-skills.md, custom-instructions.md, prompt-files.md) | [PASS] | Read and verified — authoritative frontmatter field tables extracted |
| Design heuristics (design-heuristics.md) | [PASS] | Read and verified — 150-300 line body, FRAME→GUARD→CORE→VERIFY→ENDGAME ordering |
| agent.instructions.md | [PASS] | Read and verified — `<step_N_verb>` naming, `<workflow>` parent wrapper |

</dependencies>


<global_rules>

These rules apply to EVERY file across all 4 steps. @build must enforce these universally.

<structural_rules>

- Remove ALL markdown headings (`#`, `##`, `###`) from every file — XML tags are the exclusive structural system
- Use `snake_case` for all XML tag names
- Limit XML nesting to 3 levels maximum
- Use consistent vertical spacing: one blank line after opening tag, one before closing tag, two blank lines between major sections

</structural_rules>

<content_rules>

- Use imperative voice throughout — "Check input" not "Input should be checked"
- Use canonical vocabulary from glossary.instructions.md — no aliases
- No persona language in skills — no "You are...", no stance words (thorough, cautious, creative)
- Use `[UPPERCASE_PLACEHOLDER]` for required template slots
- Format definitions as `**term** — definition` (em-dash, not hyphen)
- Express prohibitions with "No" or "Never" and include reason after em-dash

</content_rules>

<example_content_rules>

- Code blocks (` ``` `) inside asset files represent OUTPUT the skill produces
- Our artifacts use XML tags as exclusive structure, so example output inside code blocks must also use XML tags, not markdown headings
- Exception: `<format>` sections in prompt output that describe LLM conversational response shape (not an artifact file) may use headings
- Annotation sections outside code blocks (e.g., "Why This Example Works") must use XML tags

</example_content_rules>

<size_constraints>

- SKILL.md body: 150-300 lines target, ≤300 hard limit
- Reference files: 100-300 lines each
- Every file in `references/` must be referenced from SKILL.md via loading directive
- Every file in `assets/` must be referenced from SKILL.md
- No orphaned files

</size_constraints>

</global_rules>


<step_1>

**Scope:** `.github/skills/skill-creator/` — 5 files, all rewritten from scratch

**Why first:** Skill-creator is the meta-skill that produces skills. Fixing it first establishes the pattern all other skills must follow.


<step_1_file_1>

**File:** `SKILL.md` (currently 186 lines → target ≤250 lines)

**Action:** Rewrite from scratch

**Changes:**

1. Remove `# Skill Creator` heading — replace with opening prose paragraph (2-3 sentences stating purpose and governing principle)

2. Remove `## Defaults` heading inside `<defaults>` tag — flat content under the tag is sufficient

3. Compact the classification gate in `<step_1_classify>`:
   - Current: 4-line decision gate with bold headers
   - Target: Inline decision table, ~5 lines total. One line per artifact type: "Reusable procedure any agent invokes? → Skill ✓ / Needs persona + tools + cross-session behavior? → Agent (stop) / File-pattern rules that auto-apply? → Instruction (stop) / One-shot template with placeholders? → Prompt (stop)"

4. Remove `## Error Handling` heading inside `<error_handling>` — tag name is self-documenting

5. Remove `## Loading Directives` heading inside `<loading_directives>` — tag name is self-documenting

6. In `<step_5_validate>`, remove `### XML Structure (P2)` heading — inline the checks as bullet items

7. In `<step_5_validate>`, REMOVE the line `- [ ] Markdown headings ('##') used inside XML tags for human readability` — this directly contradicts current rules. Replace with: `- [ ] No markdown headings — XML tags are exclusive structure`

8. In `<step_4_draft>`, the "Required sections" list item `2. H1 Title` — REMOVE. Skills use an opening prose paragraph, not an H1 heading

9. Remove `## When to Ask User` heading if any section has one — replace with `<when_to_ask>` tag content directly

10. Remove `## Quality Signals` heading if present — replace with `<quality_signals>` tag content directly

11. All `**Bold label:**` patterns inside steps are acceptable (they're inline emphasis, not headings)

**Verification:**
- [ ] No `#`, `##`, or `###` headings anywhere in file
- [ ] ≤300 lines
- [ ] Frontmatter has only `name` and `description` fields
- [ ] `name` value is `skill-creator`
- [ ] All files in `references/` and `assets/` are referenced via loading directives or cross-references

</step_1_file_1>


<step_1_file_2>

**File:** `references/structure-reference.md` (currently 275 lines → target ≤275 lines)

**Action:** Rewrite from scratch

**Changes:**

1. Remove ALL markdown headings — every `## Frontmatter Schema`, `## Folder Structure`, `## Procedure Design`, `## Progressive Disclosure Patterns`, `## Tool Reference Syntax`, `## Exclusion Rules`, `## Size Limits`, `## Token Budget`, `## Cross-References`

2. Opening prose paragraph instead of `# Structure Reference` heading

3. In `<frontmatter_schema>`:
   - Remove `## Frontmatter Schema` heading
   - Remove `license`, `compatibility`, and `metadata` fields from the schema — VS Code supports ONLY `name` and `description` for SKILL.md
   - Update the YAML example to show only `name` and `description`
   - Add explicit note: "VS Code supports only `name` and `description` for skill frontmatter. No other fields are recognized."

4. In `<exclusion_rules>`:
   - Remove all `## Exclusion Rules`, `### Forbidden XML Tags`, `### Forbidden Language`, `### Forbidden References`, `### Forbidden Frontmatter Fields`, `### Recovery Actions` headings
   - Replace with nested XML tags: `<forbidden_xml_tags>`, `<forbidden_language>`, `<forbidden_references>`, `<forbidden_frontmatter>`, `<recovery_actions>`
   - Add to forbidden frontmatter list: `license`, `compatibility`, `metadata` — none of these are VS Code-supported fields

5. In `<tool_reference_syntax>`:
   - Remove `## Tool Reference Syntax` heading and `### Tool Aliases` subheading
   - Flatten into single tag with inline content

6. In `<progressive_disclosure_patterns>`:
   - Remove `## Progressive Disclosure Patterns` heading
   - Pattern examples use `### Step 3:` etc. — replace with `**Pattern 1:**`, `**Pattern 2:**` bold labels

7. In `<procedure_design>`:
   - Remove `## Procedure Design` heading

8. In `<size_limits>`:
   - Remove `## Size Limits` heading

9. In `<token_budget>`:
   - Remove `## Token Budget` heading

10. In `<cross_references>`:
    - Remove `## Cross-References` heading

**Verification:**
- [ ] No `#`, `##`, or `###` headings anywhere
- [ ] Frontmatter schema shows only `name` and `description`
- [ ] `license`, `compatibility`, `metadata` listed as forbidden frontmatter fields

</step_1_file_2>


<step_1_file_3>

**File:** `references/validation-checklist.md` (currently 205 lines → target ≤205 lines)

**Action:** Rewrite from scratch

**Changes:**

1. Remove ALL headings: `# Validation Checklist`, `## Quick Validation`, `## P1 — Blocking`, `## P1 Recovery Actions`, `## P2 — Required`, `## P3 — Optional`, `## Common Mistakes`, `## Validation by Tools`, `## Cross-References` and all sub-headings

2. Opening prose paragraph instead of H1

3. Each section already has XML tags (`<quick_validation>`, `<p1_blocking>`, `<p1_recovery>`, etc.) — remove the duplicate headings inside them

4. In `<p1_blocking>`, sub-sections `### Naming`, `### Frontmatter`, `### Content` → replace with bold labels or nested XML tags: `<naming>`, `<frontmatter>`, `<content>`

5. In `<p2_required>`, sub-sections use `### Description Quality`, `### Agent-Agnostic Structure`, `### No Persona Language`, `### Self-Sufficiency`, `### Structure Integrity`, `### Procedure Quality` → replace with nested XML tags or bold labels

6. Add P1 check: `- [ ] No unsupported frontmatter fields (license, compatibility, metadata)`

7. Update P2 structure check: change `- [ ] Markdown headings ('##') used inside XML tags for human readability` to `- [ ] No markdown headings — XML tags are exclusive structure`

**Verification:**
- [ ] No `#`, `##`, or `###` headings anywhere
- [ ] Unsupported frontmatter fields listed as P1 violation

</step_1_file_3>


<step_1_file_4>

**File:** `assets/example-skeleton.md` (currently 134 lines → target ≤140 lines)

**Action:** Rewrite from scratch

**Changes:**

1. Remove annotation headings: `# Skill Skeleton`, `## Minimal Template`, `## Placeholder Conventions`, `## Scope Boundaries` → replace with opening prose paragraph and XML tags: `<full_template>`, `<minimal_template>`, `<placeholder_conventions>`, `<scope_boundaries>`

2. Inside the code block (template output), the skill output currently uses `## Error Handling`, `## Reference Files`, `## Validation`, `## Notes` — these represent output the skill-creator produces. Since our skills use XML tags as exclusive structure, replace these with tag-only content:
   - `## Error Handling` → remove heading, content follows `<error_handling>` tag
   - `## Reference Files` → remove heading, content follows `<reference_files>` tag
   - `## Validation` → remove heading, content follows `<validation>` tag
   - `## Notes` → remove heading, content follows `<notes>` tag

3. Remove `license`, `compatibility`, and `metadata` from the example frontmatter YAML — VS Code does not support these fields. The template should show only:
   ```yaml
   ---
   name: 'skill-name'
   description: '[What it does]. Use when [trigger phrases]. [Key capabilities].'
   ---
   ```

4. Remove `# OMIT` comment convention — replace with plain text note in `<placeholder_conventions>` section

**Verification:**
- [ ] No markdown headings in annotation sections
- [ ] No markdown headings inside code block template (output uses XML tags)
- [ ] Frontmatter template shows only `name` and `description`

</step_1_file_4>


<step_1_file_5>

**File:** `assets/example-api-scaffold.md` (currently 132 lines → target ≤140 lines)

**Action:** Rewrite from scratch

**Changes:**

1. Remove `# Example: API Scaffold Skill` heading → opening prose paragraph

2. Inside the code block (example skill output):
   - `## Error Handling` → remove heading, tag `<error_handling>` is self-documenting
   - `## Validation` → remove heading, tag `<validation>` is self-documenting
   - `## Notes` → remove heading, tag `<notes>` is self-documenting

3. The annotation section "Why This Example Works" at end of file (currently uses no heading but is after `---` separator) — wrap in `<why_this_works>` XML tag

4. Remove the `---` horizontal rule separators — use XML tags for section boundaries instead

**Verification:**
- [ ] No markdown headings anywhere (annotation or code block)
- [ ] `<why_this_works>` tag wraps the explanation section

</step_1_file_5>


<step_1_success_criteria>

- [ ] All 5 files have zero markdown headings
- [ ] SKILL.md ≤300 lines with XML-exclusive structure
- [ ] Frontmatter schema shows only `name` + `description` (no `license`, `compatibility`, `metadata`)
- [ ] Every reference file is referenced from SKILL.md
- [ ] Every asset file is referenced from SKILL.md
- [ ] Step naming follows `<step_N_verb>` pattern inside `<workflow>` parent

</step_1_success_criteria>

</step_1>


<step_2>

**Scope:** `.github/skills/agent-creator/` — 7 files, all rewritten from scratch

**Why second:** Agent-creator is the most complex skill with the most reference files. It builds on structural patterns established in Step 1.


<step_2_file_1>

**File:** `SKILL.md` (currently 195 lines → target ≤250 lines)

**Action:** Rewrite from scratch

**Changes:**

1. Remove `# Agent Creator` heading → opening prose paragraph

2. Compact the classification gate in `<step_1_classify>` (same pattern as Step 1)

3. Remove `## When to Ask User` heading inside `<when_to_ask>` tag

4. Remove `## Quality Signals` heading inside `<quality_signals>` tag

5. Remove `## References` and `## Assets` headings inside `<cross_references>` and `<assets>` tags

6. In `<step_4_draft>`, the layer descriptions (L0/L1/L2) are good — keep format but ensure no headings

7. In `<step_5_validate>`, remove `### If tools include edit/execute/delete:` → replace with bold label or conditional format

**Verification:**
- [ ] No `#`, `##`, or `###` headings anywhere
- [ ] ≤300 lines
- [ ] All 4 reference files and 2 asset files referenced from SKILL.md

</step_2_file_1>


<step_2_file_2>

**File:** `references/structure-reference.md` (currently 387 lines → target ≤350 lines)

**Action:** Rewrite from scratch — MOST COMPLEX REFERENCE FILE

**Changes:**

1. Remove ALL headings (19 total): `# Structure Reference`, `## Frontmatter Schema`, `## Body Sections`, `### Identity`, `### <safety>`, `### <iron_law>`, `### <red_flags>`, `### <context_loading>`, `### <update_triggers>`, `### <boundaries>`, `### <modes>`, `### <outputs>`, `### <stopping_rules>`, `### <error_handling>`, `## XML Tags Summary`, `## Domain-Specific XML Tags`, `## Layer Mapping`, `## Size Limits`, `## Reserved Names`, `## Cross-References`

2. Opening prose paragraph instead of H1

3. **Add missing VS Code frontmatter fields to `<frontmatter_schema>`:**

   Add to the YAML schema example:
   ```yaml
   target: 'vscode'              # Optional: "vscode" or "github-copilot"
   mcp-servers:                   # Optional: MCP server configs (for github-copilot target)
     - type: stdio
       command: npx
       args: ['-y', '@example/mcp-server']
   ```

   Add to the field table:
   - `target` — Target environment: `"vscode"` or `"github-copilot"`. Determines where the agent runs.
   - `mcp-servers` — List of MCP server config JSON objects. Used with `target: "github-copilot"` for cloud agents.
   - `infer` — **Deprecated.** Use `user-invokable` and `disable-model-invocation` instead.

   Add field for `handoffs.model`:
   - `handoffs.model` — Optional model override for handoff execution. Format: `Model Name (vendor)`.

4. In `<body_sections>`, replace `### Identity (REQUIRED, no XML tag)`, `### <safety> (REQUIRED)`, etc. with nested XML tags:
   - `<identity_section>` (wrap identity guidance)
   - `<safety_section>` (wrap safety guidance)
   - `<iron_law_section>` (wrap iron law guidance)
   - `<red_flags_section>` etc.

5. In `<domain_specific_xml_tags>`, remove `## Domain-Specific XML Tags` heading

6. In `<layer_mapping>`, remove `## Layer Mapping for Optional Fields` heading and `### L1`, `### L2` sub-headings → use bold labels

7. In `<reserved_names>`, remove `## Reserved Names` heading

8. In `<size_limits>`, remove `## Size Limits` heading

**Verification:**
- [ ] No markdown headings anywhere
- [ ] Frontmatter schema includes `target`, `mcp-servers`, `handoffs.model`
- [ ] `infer` field documented as deprecated
- [ ] Complete field table matching VS Code docs

</step_2_file_2>


<step_2_file_3>

**File:** `references/decision-rules.md` (currently 368 lines → target ≤350 lines)

**Action:** Rewrite from scratch

**Changes:**

1. Remove ALL headings (14 total): `# Decision Rules`, `## Tools Selection`, `## Tool Profile Decision Tree`, `## Safety Requirements`, `## Iron Law Format`, `## Boundaries Derivation`, `## Modes Inclusion`, `## Subagent Pattern`, `## Stopping Rules`, `## Context Loading`, `## Handoff Configuration`, `## Behavioral Steering`, `### Proactive Implementation`, `### Conservative Research`, `### Code Exploration Required`, `### Verbosity Control`, `### Thinking After Tool Use`, `### Subagent Delegation Control`, `## Cross-References`

2. Opening prose paragraph instead of H1

3. In `<behavioral_steering>`, replace `### Proactive Implementation`, `### Conservative Research`, etc. with bold labels: `**Proactive Implementation:**`, `**Conservative Research:**`, etc.

4. All other tags (`<tools_selection>`, `<tool_profile_decision_tree>`, etc.) are properly named — just remove the duplicate headings inside them

**Verification:**
- [ ] No markdown headings anywhere
- [ ] ≤350 lines

</step_2_file_3>


<step_2_file_4>

**File:** `references/ecosystem-integration.md` (currently 236 lines → target ≤236 lines)

**Action:** Rewrite from scratch

**Changes:**

1. Remove ALL headings (12 total): `# Ecosystem Integration`, `## Memory-Bank Structure`, `### Tier Definitions`, `### Context Thresholds`, `### Update Events`, `## Handoff Mechanics`, `### Frontmatter Syntax`, `### Send Behavior`, `### Common Handoff Chains`, `## Instruction Loading`, `## Skill Invocation`, `## MCP Server Integration`, `### Syntax`, `### Error Handling`, `### Rate Limits`, `## Hub-and-Spoke Architecture`, `## Cross-References in Agents`, `## Cross-References`

2. Opening prose paragraph instead of H1

3. In `<memory_bank_structure>`, replace `### Tier Definitions`, `### Context Thresholds`, `### Update Events` with nested XML tags: `<tier_definitions>`, `<context_thresholds>`, `<update_events>`

4. In `<handoff_mechanics>`, replace `### Frontmatter Syntax`, `### Send Behavior`, `### Common Handoff Chains` with nested XML tags: `<frontmatter_syntax>`, `<send_behavior>`, `<common_chains>`

5. In `<mcp_server_integration>`, replace `### Syntax`, `### Error Handling`, `### Rate Limits` with bold labels

**Verification:**
- [ ] No markdown headings anywhere

</step_2_file_4>


<step_2_file_5>

**File:** `references/validation-checklist.md` (currently 220 lines → target ≤220 lines)

**Action:** Rewrite from scratch

**Changes:**

1. Remove ALL headings: `# Validation Checklist`, `## Quick 6-Check`, `## P1 — Blocking`, `### Naming`, `### Frontmatter`, `### Structure`, `### Safety`, `### Size`, `## P2 — Required`, `### Tools`, `### Description Quality`, `### Content`, `### Quality`, `### Memory`, `### Orchestration`, `## P3 — Optional`, `## Tools-Boundaries Alignment Check`, `## Safety Requirements by Tools`, `## Common Mistakes`, `## Cross-References`

2. Opening prose paragraph instead of H1

3. Replace `### Naming`, `### Frontmatter`, `### Structure`, `### Safety`, `### Size` inside `<p1_blocking>` with nested XML tags: `<naming>`, `<frontmatter>`, `<structure>`, `<safety>`, `<size>`

4. Replace `### Tools`, `### Description Quality`, `### Content`, `### Quality`, `### Memory`, `### Orchestration` inside `<p2_required>` with nested XML tags

5. Add to frontmatter checks:
   - `- [ ] If present, 'target' is "vscode" or "github-copilot"`
   - `- [ ] If present, 'mcp-servers' has valid JSON config objects`
   - `- [ ] 'infer' field is NOT used (deprecated — use 'user-invokable' and 'disable-model-invocation')`

**Verification:**
- [ ] No markdown headings anywhere
- [ ] New VS Code fields included in validation checks

</step_2_file_5>


<step_2_file_6>

**File:** `assets/example-skeleton.md` (currently 291 lines → target ≤280 lines)

**Action:** Rewrite from scratch

**Changes:**

1. Remove annotation headings: `# Agent Skeleton`, `## Section Checklist`, `## Minimal Template`, `## Placeholder Conventions`, `## What NOT to Include` → use opening prose paragraph and XML tags: `<full_template>`, `<section_checklist>`, `<minimal_template>`, `<placeholder_conventions>`, `<exclusions>`

2. Inside the code block (example agent output):
   - The comment lines `# IDENTITY (no XML tag)`, `# SAFETY (required)`, etc. are fine — they're comments, not headings
   - These already use XML tags for the body sections — good
   - BUT the agent output currently starts with identity section having no heading, which is correct

3. Add `target` and `mcp-servers` to the frontmatter example inside the code block:
   ```yaml
   target: 'vscode'                # Optional: "vscode" or "github-copilot"
   mcp-servers: []                 # Optional: MCP server configs (github-copilot target)
   ```

4. Add to "What NOT to Include" (now `<exclusions>`): `license`, `compatibility`, `metadata` frontmatter fields

5. Remove `---` horizontal rule separators — use XML tags for section boundaries

**Verification:**
- [ ] No markdown headings in annotation sections
- [ ] Frontmatter example includes `target` and `mcp-servers` fields
- [ ] `<exclusions>` tag replaces "What NOT to Include" heading

</step_2_file_6>


<step_2_file_7>

**File:** `assets/example-devops-deployer.md` (currently 300 lines → target ≤300 lines)

**Action:** Rewrite from scratch

**Changes:**

1. Remove `# Example: DevOps Deployer Agent` heading → opening prose paragraph

2. Inside the code block (example agent output):
   - Already uses XML tags properly for body sections — no changes needed to tag structure
   - Already has proper frontmatter — good
   - No markdown headings inside the agent body sections — verified clean

3. The `## Why This Example Works` annotation section after the code block → wrap in `<why_this_works>` XML tag, remove the heading

4. Remove `---` horizontal rule separators

5. Sub-items under "Why This Example Works" use `**Pattern → Purpose:**` and `**Demonstrates:**` — these are bold labels, acceptable

**Verification:**
- [ ] No markdown headings anywhere (annotation or code block content)
- [ ] `<why_this_works>` replaces the annotation heading

</step_2_file_7>


<step_2_success_criteria>

- [ ] All 7 files have zero markdown headings
- [ ] SKILL.md ≤300 lines with XML-exclusive structure
- [ ] Frontmatter schema in structure-reference.md includes `target`, `mcp-servers`, `infer` (deprecated), `handoffs.model`
- [ ] Every reference file is referenced from SKILL.md
- [ ] Every asset file is referenced from SKILL.md
- [ ] Step naming follows `<step_N_verb>` pattern inside `<workflow>` parent

</step_2_success_criteria>

</step_2>


<step_3>

**Scope:** `.github/skills/instruction-creator/` — 5 files, all rewritten from scratch

**Why third:** This is the CRITICAL step. Instruction-creator must produce instructions in the grouped format. Templates, examples, and validation must all reflect the new structure.


<grouped_format_specification>

The current instruction files use this grouped format. The instruction-creator must teach agents to produce this structure:

```
<named_group>

<rules>

- Rule 1 — imperative voice
- Rule 2 — specific and actionable

</rules>

<justification>

Why these rules exist — what goes wrong without them.

</justification>

<benefit>

What the agent gains by following these rules.

</benefit>

<anti_patterns>

- Wrong: X → Correct: Y

</anti_patterns>

</named_group>
```

**Key properties:**
- Outer tag is a descriptive name for the rule group (e.g., `<voice_and_precision>`, `<formatting_conventions>`)
- `<rules>` is always present — contains the actual directives
- `<justification>` and `<benefit>` are included only for rules that deviate from training defaults (per copilot-instructions.md)
- `<anti_patterns>` is optional — included when common mistakes exist
- No markdown headings at any level

**Repo-Wide format:**
```
Opening prose paragraph (2-5 sentences, purpose and governing principle)

<named_group_1>

<rules>
- Rule 1
- Rule 2
</rules>

<justification>
...
</justification>

<benefit>
...
</benefit>

</named_group_1>


<named_group_2>
...
</named_group_2>
```

**Path-Specific format:**
```
---
applyTo: "[GLOB_PATTERN]"
description: "[PURPOSE]"
---

Opening prose paragraph

<named_group_1>

<rules>
- Rule 1
- Rule 2
</rules>

<justification>
...
</justification>

<benefit>
...
</benefit>

</named_group_1>
```

</grouped_format_specification>


<step_3_file_1>

**File:** `SKILL.md` (currently 376 lines → target ≤280 lines, MUST be ≤300)

**Action:** Rewrite from scratch

**Trimming strategy:** Extract template details to structure-reference.md. Keep SKILL.md focused on the workflow steps with loading directives. Compact decision gate and remove verbose signal tables.

**Changes:**

1. Remove `# Instruction Creator` heading → opening prose paragraph

2. Compact `<step_1_classify>`:
   - Merge Tier 1 and Tier 2 into a single compact decision flow
   - Remove the verbose "Decision signals" table (16 lines) — move to `references/structure-reference.md`
   - Keep: artifact type gate (4 lines) + instruction type gate (3 lines) + "If unclear, ask user" pattern
   - Target: ~15 lines total for Step 1 (down from ~55)

3. In `<step_2_name_and_describe>`:
   - Keep compact — already reasonable
   - Remove any headings

4. In `<step_3_assess_complexity>`:
   - Remove `## ` prefixed L0/L1/L2 headings if any
   - Keep layer descriptions compact

5. **CRITICAL — Rewrite `<step_4_draft>`:**

   a. Remove `### Step 4.5: Stackability Check` heading — merge into step as sub-section `<stackability_check>` tag

   b. Replace Repo-Wide template — OLD format uses `## Project Context`, `## Code Style`, `## Commands`, `## Safety Rules` headings. NEW format must use XML-tagged groups:
   ```
   <if type="repo-wide">

   Location: `.github/copilot-instructions.md`

   **RED FLAG:** If frontmatter detected, HALT. Repo-Wide must NOT have frontmatter.

   Structure: Opening prose paragraph, then named groups:

   <project_context>
   [Project] uses [stack with versions].
   </project_context>

   <code_style>
   <rules>
   - [Rule 1]
   - [Rule 2]
   </rules>
   </code_style>

   <safety_rules>
   <rules>
   - NEVER [constraint]
   - ALWAYS [behavior]
   </rules>
   </safety_rules>

   Include `<justification>` and `<benefit>` only for rules that deviate from training defaults.

   </if>
   ```

   c. Replace Path-Specific template — OLD format uses `## Core Rules`, `## Code Standards`, `## Anti-Patterns` inside `<core_rules>`, `<code_standards>`, `<anti_patterns>` tags. NEW format must use grouped format:
   ```
   <if type="path-specific">

   Location: `.github/instructions/{name}.instructions.md`

   Frontmatter:
   ---
   applyTo: "[GLOB_PATTERN]"
   description: "[PURPOSE_50_150_CHARS]"
   ---

   Structure: Opening prose paragraph, then named groups:

   <[domain]_[concern]>

   <rules>
   - [Imperative rule 1]
   - [Imperative rule 2]
   </rules>

   <justification>
   [Why these rules exist — include only for training-deviant rules]
   </justification>

   <benefit>
   [What the agent gains]
   </benefit>

   <anti_patterns>
   - Wrong: [pattern] → Correct: [pattern]
   </anti_patterns>

   </[domain]_[concern]>

   </if>
   ```

   d. Move detailed template patterns and size thresholds to `references/structure-reference.md` via loading directive:
   `Load [structure-reference.md](references/structure-reference.md) for: glob patterns, section details, size thresholds, and complete template examples.`

6. Remove `## When to Ask User`, `## Quality Signals`, `## Loading Directives`, `## References`, `## Assets` headings — tags are self-documenting

7. Remove `---` horizontal rules between sections

**Verification:**
- [ ] No markdown headings anywhere
- [ ] ≤300 lines (target 280)
- [ ] Step 4 templates produce grouped format (not `<core_rules>` / `<code_standards>` / `<anti_patterns>`)
- [ ] Repo-Wide template uses XML tags instead of `##` headings
- [ ] All reference and asset files referenced

</step_3_file_1>


<step_3_file_2>

**File:** `references/structure-reference.md` (currently 283 lines → target ≤300 lines)

**Action:** Rewrite from scratch

**Changes:**

1. Remove ALL headings: `# Instruction Structure Reference`, `## Two Instruction Types`, `### Repo-Wide`, `### Path-Specific`, `## Frontmatter Schema`, `## Glob Pattern Reference`, `### Operators`, `### Common Patterns`, `### Invalid Patterns`, `## Layer System`, `### L0`, `### L1`, `### L2`, `## Size Thresholds`, `## Section Patterns`, `### Repo-Wide Sections`, `### Path-Specific Sections`, `## XML Tag Guidance`, `## Loading Directives`, `## Cross-References`

2. Opening prose paragraph

3. **CRITICAL — Rewrite `<section_patterns>`:**

   a. Repo-Wide section pattern must use grouped format:
   ```
   <project_context>
   [Project] uses [tech stack with versions].
   </project_context>

   <code_style>
   <rules>
   - [Rule 1]
   - [Rule 2]
   </rules>
   </code_style>

   <commands>
   <rules>
   - Build: `[command]`
   - Test: `[command]`
   </rules>
   </commands>

   <safety_rules>
   <rules>
   - NEVER [constraint]
   - ALWAYS [behavior]
   </rules>
   </safety_rules>
   ```

   b. Path-Specific section pattern must use grouped format:
   ```
   Opening prose paragraph

   <[domain]_[concern]>

   <rules>
   - [Rule 1]
   - [Rule 2]
   - [Rule 3]
   </rules>

   <justification>
   [Why — only for training-deviant rules]
   </justification>

   <benefit>
   [What — practical gains]
   </benefit>

   <anti_patterns>
   - Wrong: [pattern] → Correct: [pattern]
   </anti_patterns>

   </[domain]_[concern]>
   ```

4. In `<xml_tag_guidance>`:
   - Remove `## XML Tag Guidance` heading
   - Update guidance: Tags in instructions SHOULD be named groups. Outer tag = group name, inner tags = `<rules>`, `<justification>`, `<benefit>`, `<anti_patterns>`
   - Update "Avoid" list: `<rules>` alone at top level is too generic — always wrap inside a named group

5. In `<glob_pattern_reference>`, replace sub-headings with bold labels

6. In `<layer_system>`, replace sub-headings with bold labels

7. In `<two_instruction_types>`, replace sub-headings with bold labels

8. Absorb any content moved from SKILL.md (decision signals table, detailed size thresholds)

**Verification:**
- [ ] No markdown headings anywhere
- [ ] Section patterns show grouped format for both Repo-Wide and Path-Specific
- [ ] XML tag guidance recommends named groups with `<rules>`, `<justification>`, `<benefit>`

</step_3_file_2>


<step_3_file_3>

**File:** `references/validation-checklist.md` (currently 184 lines → target ≤190 lines)

**Action:** Rewrite from scratch

**Changes:**

1. Remove ALL headings: `# Instruction Validation Checklist`, `## Priority Definitions`, `## P1 Checks`, `### Location and Filename`, `### Frontmatter Format`, `### Glob Pattern Validation`, `### Security`, `## P2 Checks`, `### Discovery Configuration`, `### Rule Quality`, `### Identity Prohibition`, `### Size Limits`, `### Single Concern`, `### Stackability`, `## P3 Checks`, `### Metadata`, `### Documentation`, `## Contamination Detection`, `### Agent Contamination`, `### Prompt Contamination`, `### Skill Contamination`, `### Allowed Exceptions`, `## Quick Validation`, `## Validation Decision Tree`, `## Cross-References`

2. Opening prose paragraph

3. Replace sub-headings with nested XML tags inside P1/P2/P3 tags

4. **Update P2 structure check:**
   - OLD: `Content sections wrapped in XML tags (e.g., <core_rules>, <code_standards>, <anti_patterns>)`
   - NEW: `Content organized in named groups containing <rules>, <justification>, <benefit>, and optional <anti_patterns>`

5. **Update contamination detection — Allowed Exceptions:**
   - OLD: `<rules> tags — Valid for semantic grouping within instructions`
   - NEW: `<rules> tags within named groups — Valid as part of grouped format`
   - Add: `<justification>, <benefit> tags within named groups — Valid as part of grouped format`

6. Add P2 check: `- [ ] No markdown headings — XML tags are exclusive structure`

**Verification:**
- [ ] No markdown headings anywhere
- [ ] Grouped format referenced in P2 checks
- [ ] Contamination detection updated for grouped format

</step_3_file_3>


<step_3_file_4>

**File:** `assets/example-skeleton.md` (currently 147 lines → target ≤160 lines)

**Action:** Rewrite from scratch

**Changes:**

1. Remove annotation headings: `# Instruction Skeleton`, `## Path-Specific Template (Full)`, `## Path-Specific Template (Minimal)`, `## Repo-Wide Template (Minimal)`, `## What NOT to Include`, `### Agent Patterns`, `### Prompt Patterns`, `### Skill Patterns`, `### Content Exceptions` → replace with opening prose paragraph and XML tags: `<path_specific_full>`, `<path_specific_minimal>`, `<repo_wide_minimal>`, `<exclusions>`

2. **CRITICAL — Rewrite template code blocks:**

   a. Path-Specific Full template must use grouped format:
   ```markdown
   ---
   applyTo: "[GLOB_PATTERN]"
   description: "[PURPOSE_50_150_CHARS]"
   ---

   [ONE_LINE_SUMMARY_OF_PURPOSE]

   <[DOMAIN]_[CONCERN]>

   <rules>

   - Use [PATTERN] for [SITUATION]
   - Prefer [OPTION_A] over [OPTION_B] when [CONDITION]
   - NEVER [DANGEROUS_ACTION] without [SAFEGUARD]
   - ALWAYS [REQUIRED_BEHAVIOR] before [ACTION]

   </rules>

   <justification>

   [Why these rules exist — what goes wrong without them]

   </justification>

   <benefit>

   [What the agent gains by following these rules]

   </benefit>

   <anti_patterns>

   - Wrong: [ANTI_PATTERN] → Correct: [CORRECT_PATTERN]

   </anti_patterns>

   </[DOMAIN]_[CONCERN]>
   ```

   b. Path-Specific Minimal template must use grouped format:
   ```markdown
   ---
   applyTo: "**/*.ts"
   description: "TypeScript type safety and coding conventions"
   ---

   Enforce strict type safety and consistent patterns across all TypeScript code.

   <type_safety>

   <rules>

   - Use `interface` for object shapes
   - Use `type` for unions and intersections
   - Export types alongside their implementations
   - Prefer `unknown` over `any` for untyped values

   </rules>

   </type_safety>
   ```

   c. Repo-Wide Minimal template must use XML-tagged groups instead of `##` headings:
   ```markdown
   [PROJECT_NAME] uses [FRAMEWORK] [VERSION] with [LANGUAGE] [VERSION]. The governing principle is: [CORE_PRINCIPLE].

   <code_style>

   <rules>

   - [STYLE_RULE_1]
   - [STYLE_RULE_2]
   - [STYLE_RULE_3]

   </rules>

   </code_style>

   <commands>

   <rules>

   - Build: `[BUILD_COMMAND]`
   - Test: `[TEST_COMMAND]`
   - Lint: `[LINT_COMMAND]`

   </rules>

   </commands>

   <safety_rules>

   <rules>

   - NEVER commit secrets or API keys to repository
   - NEVER force push to main branch
   - ALWAYS run tests before committing

   </rules>

   </safety_rules>
   ```

3. In `<exclusions>`, replace sub-headings with nested XML tags: `<agent_exclusions>`, `<prompt_exclusions>`, `<skill_exclusions>`

**Verification:**
- [ ] No markdown headings in annotation or template code blocks
- [ ] All templates use grouped format with `<rules>`, `<justification>`, `<benefit>`, `<anti_patterns>`
- [ ] Repo-Wide template uses XML tags instead of `##` headings

</step_3_file_4>


<step_3_file_5>

**File:** `assets/example-typescript-standards.md` (currently 119 lines → target ≤130 lines)

**Action:** Rewrite from scratch — complete rewrite in grouped format

**Changes:**

1. Remove `# Example: TypeScript Standards Instruction` heading → opening prose paragraph

2. **CRITICAL — Rewrite the example instruction in grouped format:**

   The code block currently uses `<core_rules>` / `<code_standards>` / `<anti_patterns>` with `## Core Rules`, `## Code Standards`, `## Anti-Patterns` headings inside them.

   Replace entirely with grouped format:

   ```markdown
   ---
   applyTo: "**/*.ts"
   description: "TypeScript type safety and coding conventions for all TypeScript files"
   ---

   Enforce strict type safety and consistent patterns across all TypeScript code. The governing principle is: explicit types prevent runtime errors — every type boundary must be intentional, never implicit.


   <type_system>

   <rules>

   - Enable `strict: true` in tsconfig.json for all projects
   - Use `interface` for object shapes that may be extended
   - Use `type` for unions, intersections, and mapped types
   - Prefer `unknown` over `any` — narrow types explicitly
   - Export types alongside their implementations
   - Use `readonly` for properties that must not be reassigned
   - Prefer `const` assertions for literal types (`as const`)
   - NEVER use `@ts-ignore` without a linked issue explaining why
   - ALWAYS handle null and undefined explicitly — no implicit any

   </rules>

   <justification>

   TypeScript's type system prevents entire categories of runtime errors, but only when strict mode is enforced and types are explicit. `any` escapes the type system entirely, re-introducing the errors TypeScript exists to prevent. Training data favors `any` for quick fixes, so explicit rules are needed to override that default.

   </justification>

   <benefit>

   Compile-time catches replace runtime debugging. Type narrowing makes impossible states unrepresentable.

   </benefit>

   <anti_patterns>

   - Wrong: Excessive type assertions (`as`) — indicates type system is fighting the code → Correct: Fix the types instead of asserting
   - Wrong: Empty interfaces — Correct: Use `type X = Record<string, never>` or `unknown`
   - Wrong: `Function` type — Correct: Use specific function signatures (`() => void`, `(x: string) => number`)
   - Wrong: Ignoring strict null checks — Correct: Handle null/undefined explicitly
   - Wrong: Nested ternaries in types — Correct: Extract to named type aliases

   </anti_patterns>

   </type_system>


   <code_examples>

   <rules>

   - Include explicit return types on all exported functions
   - Use `readonly` arrays for parameters that must not be mutated
   - Narrow `unknown` types before use — no implicit operations

   </rules>

   <anti_patterns>

   **Wrong:**
   ```typescript
   export function calculateTotal(items: Item[]) {
     return items.reduce((sum, item) => sum + item.price, 0);
   }
   ```
   **Correct:**
   ```typescript
   export function calculateTotal(items: readonly Item[]): number {
     return items.reduce((sum, item) => sum + item.price, 0);
   }
   ```

   **Wrong:**
   ```typescript
   function processInput(input: any): string {
     return input.toUpperCase();
   }
   ```
   **Correct:**
   ```typescript
   function processInput(input: unknown): string {
     if (typeof input === 'string') {
       return input.toUpperCase();
     }
     throw new Error('Expected string input');
   }
   ```

   </anti_patterns>

   </code_examples>
   ```

3. The `## Why This Example Works` annotation section → wrap in `<why_this_works>` XML tag, remove the heading

4. Remove `---` horizontal rule separators

**Verification:**
- [ ] No markdown headings anywhere (annotation or code block)
- [ ] Example uses grouped format with named groups (`<type_system>`, `<code_examples>`)
- [ ] Each group has `<rules>` and appropriate `<justification>`, `<benefit>`, `<anti_patterns>`
- [ ] `<why_this_works>` replaces annotation heading

</step_3_file_5>


<step_3_success_criteria>

- [ ] All 5 files have zero markdown headings
- [ ] SKILL.md ≤300 lines
- [ ] Templates produce grouped format — named groups containing `<rules>`, `<justification>`, `<benefit>`, `<anti_patterns>`
- [ ] Repo-Wide template uses XML tags, not `##` headings
- [ ] example-typescript-standards.md completely rewritten in grouped format
- [ ] Validation checklist references grouped format structure
- [ ] Every reference file is referenced from SKILL.md
- [ ] Every asset file is referenced from SKILL.md

</step_3_success_criteria>

</step_3>


<step_4>

**Scope:** `.github/skills/prompt-creator/` — 4 existing files + 1 new file, all written from scratch

**Why last:** Prompt-creator is the most straightforward refactor after the pattern is established. Main work is extracting inline content to a new reference file.


<step_4_file_1>

**File:** `SKILL.md` (currently 336 lines → target ≤280 lines, MUST be ≤300)

**Action:** Rewrite from scratch

**Trimming strategy:** Extract the entire frontmatter schema, tool aliases, agent modes, and variable syntax sections from Step 4 into a new `references/frontmatter-reference.md`. Replace with loading directive.

**Changes:**

1. Remove `# Prompt Creator` heading → opening prose paragraph

2. Compact `<step_1_classify>`:
   - Merge decision gate into ~8 lines (same pattern as other skills)
   - Keep key discriminators as brief inline list

3. In `<step_4_draft>`, EXTRACT the following sections to `references/frontmatter-reference.md`:
   - **Frontmatter Schema** (~15 lines: field descriptions for `description`, `name`, `argument-hint`, `agent`, `model`, `tools`)
   - **Tools Syntax** (~15 lines: YAML example + tool aliases table)
   - **Agent Modes** (~25 lines: core agents, mode selection heuristic, default behavior)
   - **Variable Syntax** (~20 lines: workspace, file, selection, input variables)

   Replace all of the above with a single loading directive:
   `Load [frontmatter-reference.md](references/frontmatter-reference.md) for: frontmatter field schema, tool aliases, agent field values, and variable syntax.`

   Keep in SKILL.md:
   - Body Structure section (XML tags for `<context>`, `<task>`, `<format>`, `<constraints>`)
   - Drafting by template scope (minimal/standard/full descriptions)
   - Asset reference

4. Remove `## When to Ask User`, `## Quality Signals`, `## Anti-Patterns`, `## Assets`, `## Cross-References` headings — tags are self-documenting

5. Remove `---` horizontal rules between sections (there are 3 in the current file)

6. Create `references/` folder (currently does not exist for prompt-creator)

**Verification:**
- [ ] No markdown headings anywhere
- [ ] ≤300 lines (target 280)
- [ ] Step 4 uses loading directive for frontmatter-reference.md
- [ ] All reference and asset files referenced from SKILL.md
- [ ] `references/frontmatter-reference.md` listed in cross-references

</step_4_file_1>


<step_4_file_2>

**File:** `references/frontmatter-reference.md` (NEW FILE — target ~120 lines)

**Action:** Create from scratch

**Content structure:**

```
Opening prose paragraph — what this file contains and when to load it.

<frontmatter_fields>

Field definitions in a structured list:
- `description` — Short description for `/` menu (50-150 chars, single-line, verb-first). Required for discoverability.
- `name` — Display name (3-50 chars, lowercase-hyphens). Default: filename.
- `argument-hint` — Placeholder text in chat input (10-100 chars).
- `agent` — Execution delegation: `ask` | `edit` | `agent` | custom agent name.
- `model` — Language model override.
- `tools` — Tool whitelist array. Overrides (not merges with) agent tools.

</frontmatter_fields>


<tools_reference>

YAML syntax:
tools: ['read', 'edit', 'search', 'execute']

Tool aliases:
- `read` — readFile, listDirectory
- `edit` — editFiles, createFile
- `search` — codebase, textSearch, fileSearch
- `execute` — runInTerminal
- `agent` — runSubagent
- `web` — fetch, WebSearch
- `todo` — manage_todo_list

MCP tools: Use `server/*` or `server/tool` syntax.

Warning: Unavailable tools are silently ignored — test prompt to verify tool access.

</tools_reference>


<agent_field>

The `agent` field delegates prompt execution to a custom agent.

Core agents in this project:
- `agent: "brain"` — Research, analysis, exploration
- `agent: "architect"` — Planning, decomposition, design
- `agent: "build"` — Implementation, file changes, execution
- `agent: "inspect"` — Quality verification, review, audit

Mode selection heuristic:
- Research/analysis task → `agent: "brain"`
- Planning/decomposition → `agent: "architect"`
- Implementation/file changes → `agent: "build"`
- Quality verification → `agent: "inspect"`
- Custom domain task → `agent: "[domain-agent-name]"`

Default when omitted: VS Code uses the default chat participant. For prompts that modify files or run commands, explicitly specify an agent.

If `tools` specified without `agent`, the default agent depends on current selection. Explicitly set `agent: "agent"` when using tools.

</agent_field>


<variable_syntax>

Workspace variables:
- `${workspaceFolder}` — Full path to workspace root
- `${workspaceFolderBasename}` — Workspace folder name only

File variables:
- `${file}` — Full path to current file
- `${fileBasename}` — Filename with extension
- `${fileDirname}` — Directory containing file
- `${fileBasenameNoExtension}` — Filename without extension

Selection variables:
- `${selection}` — Currently selected text
- `${selectedText}` — Alias for `${selection}`

File context references:
- `[filename](./path/to/file.ext)` — Inject file content as context via markdown link

Inline tool references:
- `#tool:<toolname>` — Reference specific tool inline in prompt body

User input variables:
- `${input:name}` — Prompt user for input at runtime
- `${input:name:placeholder}` — Input with placeholder hint

Critical: Use `${name}` syntax, not `{name}`. Bare braces do not trigger substitution.

</variable_syntax>
```

**Verification:**
- [ ] No markdown headings
- [ ] All frontmatter fields documented with types and constraints
- [ ] Tool aliases complete
- [ ] Agent modes include project-specific agents
- [ ] Variable syntax covers all VS Code-supported variables
- [ ] ~100-150 lines

</step_4_file_2>


<step_4_file_3>

**File:** `assets/example-skeleton.md` (currently 135 lines → target ≤140 lines)

**Action:** Rewrite from scratch

**Changes:**

1. Remove annotation headings: `# Example: Prompt Skeleton`, `## Full Template`, `## Minimal Template`, `## What NOT to Include` → use opening prose paragraph and XML tags: `<full_template>`, `<minimal_template>`, `<exclusions>`

2. Inside the code block templates:
   - Template content uses `# [Title]` — this is the prompt output format. Prompts are invoked as one-shot templates, and their body structure uses XML tags (`<context>`, `<task>`, `<format>`, `<constraints>`). The `# [Title]` is acceptable as a prompt title (similar to how SKILL.md can have a prose title line)
   - Actually, per the XML-exclusive rule, even the prompt template should avoid `#` heading. Replace `# [Title]` with a plain prose title line: `[TITLE]`
   - The comment lines (`# Purpose:`, `# OMIT if:`, `# RULE:`) are annotation comments within the template — these use `#` as a comment marker, not as headings. However, markdown doesn't have a comment syntax — these render as headings. Replace with HTML comments `<!-- Purpose: ... -->` or remove annotations from the template and put them in the surrounding prose

3. In `<exclusions>`, content lists agent/prompt/instruction exclusions — no headings, bullet list format

4. Remove `---` horizontal rules

**Verification:**
- [ ] No markdown headings in annotation sections
- [ ] Template code blocks avoid `#` as headings (use prose title or HTML comments for annotations)
- [ ] `<exclusions>` replaces "What NOT to Include"

</step_4_file_3>


<step_4_file_4>

**File:** `assets/example-code-review.md` (currently 88 lines → target ≤100 lines)

**Action:** Rewrite from scratch

**Changes:**

1. Remove `# Example: Code Review Prompt` heading → opening prose paragraph

2. Inside the code block (example prompt output):
   - `# Code Review` → remove heading, use prose title line
   - The `<format>` section contains `## Review Summary`, `## Issues Found`, `## Security Concerns`, `## Improvements`, `## Related Patterns` — these describe the LLM's conversational output format, not an artifact file structure. However, for consistency and because the prompt IS an artifact, replace these with bold labels: `**Review Summary:**`, `**Issues Found:**`, `**Security Concerns:**`, `**Improvements:**`, `**Related Patterns:**`

3. The `## Why This Example Works` annotation section → wrap in `<why_this_works>` XML tag, remove the heading

4. Remove `---` horizontal rules

**Verification:**
- [ ] No markdown headings in annotation or code block
- [ ] `<format>` section uses bold labels instead of headings
- [ ] `<why_this_works>` replaces annotation heading

</step_4_file_4>


<step_4_success_criteria>

- [ ] All 4 existing files + 1 new file have zero markdown headings
- [ ] SKILL.md ≤300 lines with inline content extracted to frontmatter-reference.md
- [ ] `references/frontmatter-reference.md` exists and contains frontmatter schema, tools, agents, variables
- [ ] SKILL.md references the new reference file via loading directive
- [ ] Every reference file is referenced from SKILL.md
- [ ] Every asset file is referenced from SKILL.md
- [ ] Step naming follows `<step_N_verb>` pattern inside `<workflow>` parent

</step_4_success_criteria>

</step_4>


<execution_order>

| Order | Skill | Files | Complexity | Reason |
|-------|-------|-------|-----------|--------|
| 1 | skill-creator | 5 | Medium | Meta-skill — establishes the pattern; smallest reference set |
| 2 | agent-creator | 7 | High | Most files, most reference content; needs VS Code field updates |
| 3 | instruction-creator | 5 | Critical | Grouped format migration — templates, examples, validation all change |
| 4 | prompt-creator | 5 (1 new) | Medium | Extraction to new reference file; otherwise straightforward |

**Parallelism:** Steps 1-4 are independent (no cross-skill references). @build MAY parallelize if operating across multiple context windows. Within each step, files should be created in this order: SKILL.md first (establishes references), then reference files, then asset files.

</execution_order>


<assumptions>

- All 4 skill folders remain at `.github/skills/[name]/` — no relocation
- The `scripts/` folder (referenced in skill-creator structure-reference.md) is conceptual — no skill currently has one, and none will be added in this refactor
- The `schema.yaml` file referenced in prompt-creator cross-references does not exist and will NOT be created (orphan reference to remove)
- The `name` field in SKILL.md frontmatter must match the parent folder name exactly (VS Code convention)
- `description` field maximum is 1024 characters (VS Code convention)

</assumptions>


<risks>

| Risk | Mitigation |
|------|-----------|
| Grouped format templates may confuse agents that produce simple instructions | Include both minimal (no justification/benefit) and full (with justification/benefit) template variants |
| Removing all headings from reference files may reduce human readability | XML tags with descriptive names provide equivalent navigation; bold labels provide visual emphasis |
| Extracting content from prompt-creator SKILL.md to new reference file may break loading flow | Use explicit loading directive with "for:" list specifying what the reference contains |
| Agent-creator frontmatter changes (target, mcp-servers) are new fields — agents may not understand them yet | Document purpose and format clearly with YAML examples |

</risks>


<final_success_criteria>

- [ ] Zero markdown headings (`#`, `##`, `###`) across all ~21 files
- [ ] All 4 SKILL.md files ≤300 lines
- [ ] All reference files ≤300 lines
- [ ] Instruction-creator produces grouped format (named groups with `<rules>`, `<justification>`, `<benefit>`, `<anti_patterns>`)
- [ ] Skill-creator frontmatter schema shows only `name` + `description` (no `license`, `compatibility`, `metadata`)
- [ ] Agent-creator frontmatter schema includes `target`, `mcp-servers`, documents `infer` as deprecated
- [ ] Prompt-creator has `references/frontmatter-reference.md` with extracted schema content
- [ ] Every file in every `references/` folder is referenced from its parent SKILL.md
- [ ] Every file in every `assets/` folder is referenced from its parent SKILL.md
- [ ] No orphan files or empty folders
- [ ] No cross-skill references

</final_success_criteria>
