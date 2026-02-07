Validation ensures instruction files meet structural requirements before delivery. P1 checks are blocking (must pass), P2 checks signal quality issues, P3 checks are optional improvements. Run `<quick_validation>` for 5 essential checks first, then expand to full P1/P2 if needed.


<priority_definitions>

- **P1 (Blocking)** — Instruction will error or cause incorrect behavior if violated
- **P2 (Required)** — Instruction will work but effectiveness compromised
- **P3 (Optional)** — Improvements that enhance quality

</priority_definitions>


<p1_checks>

All must pass. Any P1 error blocks delivery.

<location_and_filename>

- [ ] Repo-Wide file is exactly `.github/copilot-instructions.md`
- [ ] Path-Specific files are in `.github/instructions/` folder
- [ ] Path-Specific filename ends with `.instructions.md`

</location_and_filename>

<frontmatter_format>

- [ ] Repo-Wide has NO frontmatter (first non-whitespace is NOT `---`)
- [ ] Path-Specific frontmatter is valid YAML (if present)
- [ ] No syntax errors in YAML block
- [ ] No unsupported frontmatter fields — only `description`, `applyTo`, `name` are valid

</frontmatter_format>

<glob_pattern_validation>

- [ ] `applyTo` is NOT `**` alone (matches all files)
- [ ] `applyTo` is NOT `*` alone (too broad)
- [ ] `applyTo` includes file extension OR path constraint
- [ ] Pattern uses valid glob syntax (no regex)

</glob_pattern_validation>

<security>

- [ ] No secrets, credentials, API keys in content
- [ ] No internal URLs or sensitive paths
- [ ] No placeholder text remaining (`[PLACEHOLDER]`, `{placeholder}`, `TODO`)

</security>

<structure_format>

- [ ] No markdown headings (`#`, `##`, `###`) — XML tags are exclusive structure
- [ ] Content sections use named groups with grouped format
- [ ] Each named group contains `<rules>` section

</structure_format>

</p1_checks>


<p2_checks>

Should pass. Errors compromise effectiveness.

<discovery_configuration>

- [ ] Path-Specific has `description` field (required for discovery)
- [ ] Description contains ≥2 domain-specific keywords for matching
- [ ] If file-triggered: `applyTo` pattern matches intended file types
- [ ] If on-demand: Description uses "Use when [TASK]. [SUMMARY]." pattern

</discovery_configuration>

<rule_quality>

- [ ] Rules use imperative voice ("Use X" not "You should use X")
- [ ] Rules are specific and actionable (not "be helpful")
- [ ] Safety-critical rules use ALWAYS/NEVER keywords
- [ ] Rules include versions where relevant ("React 18+")

</rule_quality>

<identity_prohibition>

- [ ] No persona language ("You are a...", "As a...", "Your role is...")
- [ ] No stance words (thorough, cautious, creative, helpful)
- [ ] No identity assertions

</identity_prohibition>

<size_limits>

- [ ] Path-Specific is ≤150 lines
- [ ] Repo-Wide is ≤200 lines
- [ ] If exceeds 100/150 lines, split was evaluated

</size_limits>

<single_concern>

- [ ] File addresses one domain (testing OR styling OR API design, not multiple)

</single_concern>

<stackability>

- [ ] Rules do not contradict existing instructions with overlapping `applyTo`
- [ ] No duplicate rules across instruction files
- [ ] Rules are self-contained (no cross-instruction dependencies)

</stackability>

</p2_checks>


<p3_checks>

Nice to have. Improve quality when present.

<metadata>

- [ ] `name` field provides clear display name
- [ ] `description` field is 50-150 characters, single-line
- [ ] Description explains purpose and scope

</metadata>

<documentation>

- [ ] Wrong/Correct example pairs for ambiguous rules
- [ ] Anti-patterns section lists common mistakes
- [ ] Examples use realistic, non-trivial code

</documentation>

</p3_checks>


<contamination_detection>

Instructions must NOT contain patterns from other artifact types.

<agent_contamination>

Reject if found:
- [ ] No `<identity>` tags
- [ ] No `<safety>` tags (as structural element)
- [ ] No `<boundaries>` tags
- [ ] No `<modes>` tags
- [ ] No `<iron_law>` tags
- [ ] No `tools:` in frontmatter
- [ ] No `handoffs:` in frontmatter
- [ ] No "You are a..." identity statements

</agent_contamination>

<prompt_contamination>

Reject if found:
- [ ] No `${input:}` variable syntax
- [ ] No `${selection}` or `${file}` variables
- [ ] No `<task>` tags (as structural element)

</prompt_contamination>

<skill_contamination>

Reject if found:
- [ ] No `scripts/` folder references
- [ ] No shebang lines (`#!/bin/bash`, `#!/usr/bin/env`)
- [ ] No `references/` folder in instruction output

</skill_contamination>

<allowed_exceptions>

These ARE valid when discussing topics (not as structure):
- Mentioning agents, prompts, skills as subjects
- Code examples that happen to include these patterns

</allowed_exceptions>

</contamination_detection>


<quick_validation>

Run these first. If any error, full validation will also error.

1. [ ] Correct location and filename pattern
2. [ ] Frontmatter matches type (none for Repo-Wide, valid YAML for Path-Specific)
3. [ ] `applyTo` specified with valid glob (Path-Specific only)
4. [ ] All rules are specific and actionable
5. [ ] No placeholders, secrets, or persona language
6. [ ] No markdown headings — XML tags are exclusive structure

</quick_validation>


<validation_decision_tree>

```
P1 error? ──────────────────────────────────► REJECT (blocking)
     │
     ▼ (all P1 pass)
P2 errors ≥2? ──────────────────────────────► REVISE (effectiveness compromised)
     │
     ▼ (≤1 P2 error)
Contamination detected? ───────────────────► REJECT (wrong artifact type)
     │
     ▼ (clean)
P3 only? ──────────────────────────────────► ACCEPT (can improve later)
```

</validation_decision_tree>


<references>

- [SKILL.md](../SKILL.md) — Parent skill entry point
- [structure-reference.md](structure-reference.md) — Format and syntax

</references>
