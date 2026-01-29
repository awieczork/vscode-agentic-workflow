---
type: decision-matrix
version: 1.0.0
purpose: Component type selection for agentic workflows
applies-to: [generator, build, inspect, architect]
last-updated: 2026-01-28
---

<!-- 
╔══════════════════════════════════════════════════════════════════════════════╗
║  EXEMPLAR: COMPONENT-MATRIX.md (Annotated)                                   ║
║                                                                              ║
║  This is the reference implementation for `type: decision-matrix` files.     ║
║  Comments explain WHY each section exists and HOW to replicate the pattern.  ║
║                                                                              ║
║  Use this as your template when creating any decision-matrix file.           ║
╚══════════════════════════════════════════════════════════════════════════════╝
-->

# Component Matrix

> **When to use Agent vs Skill vs Instruction vs Prompt**

<!-- 
WHY: One-line summary immediately tells agents what this file decides.
PATTERN: Always use blockquote (>) for the summary line.
-->

---

## HOW TO USE THIS FILE

<!-- 
WHY: Different agents parse files differently. Explicit instructions prevent misuse.
PATTERN: Always include sections for Generator, Build, AND Inspect agents.
RULE: Use numbered lists for sequential steps.
-->

**For Generator Agents:**
1. Parse DECISION RULES section for IF-THEN selection logic
2. Validate selections against CAPABILITY MATRIX
3. Check ANTI-PATTERNS before generating
4. Reference CONSTRAINT MATRIX for limits

**For Build Agents:**
1. Consult USE-CASE MAPPING for component selection
2. Follow COMPOSITION MATRIX for multi-component designs
3. Respect CONSTRAINT MATRIX limits

**For Inspect Agents:**
1. Verify component choice against DECISION RULES
2. Flag ANTI-PATTERN violations
3. Check constraints met per CONSTRAINT MATRIX

---

## PURPOSE

<!-- 
WHY: Establishes context and scope. Helps agents understand when to use this file.
PATTERN: Start with what the file provides, end with what problem it solves.
-->

This matrix provides **unambiguous component selection** for the framework. When building agentic workflows, you must choose between four component types. Each serves a distinct purpose — this guide eliminates guesswork.

**The Framework Approach:** Use the decision flowchart for 90% of cases. Consult the detailed matrices for edge cases and composition patterns.

---

## DECISION RULES (Machine-Parseable)

<!-- 
WHY: Machine-parseable rules enable automated selection and validation.
PATTERN: IF-THEN-ELSE pseudocode that agents can execute as logic.
CRITICAL: This is the PRIMARY decision mechanism — flowcharts are secondary.
-->

### Primary Selection Logic

```
IF needs_persona OR needs_tool_restriction OR needs_model_selection OR needs_handoffs
  THEN → AGENT
ELSE IF needs_bundled_scripts OR needs_bundled_assets OR needs_cross_platform_portability
  THEN → SKILL
ELSE IF needs_auto_apply OR needs_file_pattern_targeting OR needs_always_on_rules
  THEN → INSTRUCTION
ELSE
  THEN → PROMPT
```

### Selection Criteria Definitions

<!-- 
WHY: Criteria names must map to specific, testable conditions.
PATTERN: Table with Criterion (backticked) and "True When" (specific condition).
RULE: Every criterion in the IF-THEN logic MUST appear in this table.
-->

| Criterion | True When |
|-----------|----------|
| `needs_persona` | Different behavioral identity required per role |
| `needs_tool_restriction` | Specific tools must be enabled/disabled |
| `needs_model_selection` | Different AI model required per context |
| `needs_handoffs` | Workflow transitions between agents required |
| `needs_bundled_scripts` | Executable scripts must be packaged together |
| `needs_bundled_assets` | Templates/reference docs must be co-located |
| `needs_cross_platform_portability` | Must work across VS Code, Claude, Cursor, etc. |
| `needs_auto_apply` | Rules must apply without explicit invocation |
| `needs_file_pattern_targeting` | Rules apply to specific file types only |
| `needs_always_on_rules` | Constraints cannot be bypassed |

### Visual Flowchart (Human Reference)

<!-- 
WHY: Visual aids help humans; but agents use the IF-THEN rules above.
PATTERN: Keep flowcharts simple. The pseudocode is authoritative.
-->

```
START → Q1: Persona/Tools/Model/Handoffs? → YES → AGENT
                    ↓ NO
        Q2: Bundled scripts/assets?       → YES → SKILL
                    ↓ NO
        Q3: Auto-apply rules?             → YES → INSTRUCTION
                    ↓ NO
                  PROMPT
```

---

## COMPONENT OVERVIEW

<!-- 
WHY: Quick reference table for understanding each option at a glance.
PATTERN: Consistent columns across all options being compared.
-->

| Component | What It Is | Loading | Invocation |
|-----------|------------|---------|------------|
| **Agent** | Persona-driven chat mode | Persistent (selectable) | `@agent-name` in chat |
| **Skill** | Packaged capability with scripts | On-demand | Referenced when needed |
| **Instruction** | Persistent behavioral rules | Always-loaded | Automatic |
| **Prompt** | Parameterized template | On-demand | `/prompt-name` or play button |

---

## CAPABILITY MATRIX

<!-- 
WHY: Shows what each option CAN and CANNOT do — critical for selection.
PATTERN: Use ✅/❌/⚠️ symbols for quick scanning. Add footnotes for nuance.
-->

| Capability | Agent | Skill | Instruction | Prompt |
|------------|:-----:|:-----:|:-----------:|:------:|
| **Tool configuration** | ✅ `tools:` | ⚠️ `allowed-tools`* | ❌ | ✅ `tools:` |
| **Model selection** | ✅ `model:` | ❌ | ❌ | ✅ `model:` |
| **Runtime variables** | ❌ | ❌ | ❌ | ✅ `${input:}` |
| **Handoffs/chaining** | ✅ `handoffs:` | ❌ | ❌ | ❌ |
| **Auto-apply to files** | ❌ | ❌ | ✅ `applyTo:` | ❌ |
| **Bundle scripts** | ❌ | ✅ `scripts/` | ❌ | ❌ |
| **Bundle assets** | ❌ | ✅ `assets/` | ❌ | ❌ |
| **Context loading** | Via `#file:` | `references/` | Via links | Via links |
| **Cross-platform** | ⚠️ Limited | ✅ agentskills.io | ✅ AGENTS.md | ❌ VS Code |

*\* `allowed-tools` is experimental and NOT supported in VS Code*

---

## CONSTRAINT MATRIX

<!-- 
WHY: Hard limits that must be respected regardless of selection logic.
PATTERN: Include limits, locations, required fields, platform support.
RULE: Distinguish hard limits (⛔) from recommendations (🟡).
-->

| Constraint | Agent | Skill | Instruction | Prompt |
|------------|-------|-------|-------------|--------|
| **Size limit** | 30,000 chars ⛔ | 500 lines / 5000 tokens ⛔ | ~300 lines 🟡 | No documented limit |
| **Location** | `.github/agents/` | `.github/skills/` | `.github/instructions/` | `.github/prompts/` |
| **Required fields** | None (name from filename) | `name`, `description` | None | None |
| **Platform support** | VS Code + GitHub.com* | VS Code (experimental) | VS Code + GitHub.com | VS Code |

**Legend:** ⛔ = Hard limit (enforced) | 🟡 = Recommendation (best practice)

*\* Agent features `model`, `handoffs`, `argument-hint` are ignored on GitHub.com*

---

## COMPOSITION MATRIX

<!-- 
WHY: Shows how components can work together — what can invoke/include what.
PATTERN: Only include for decision-matrices where composition matters.
RULE: This section is OPTIONAL — include when the decision involves composable elements.
-->

**What can invoke/include what:**

| Component | Can Invoke | Can Include | Can Be Invoked By |
|-----------|------------|-------------|-------------------|
| **Agent** | Other agents (handoffs), Subagents | Instructions (`#file:`), Context files | User selection, Handoffs |
| **Skill** | — | References, Scripts, Assets | User mention |
| **Instruction** | — | Other files (links) | Auto-applied |
| **Prompt** | Agents (`agent:` field) | Context files (links) | `/command`, Play button |

---

## USE-CASE MAPPING

<!-- 
WHY: Concrete scenarios help when decision rules feel abstract.
PATTERN: Use Case (specific) → Component → Why (references decision criteria).
-->

| Use Case | Component | Why |
|----------|-----------|-----|
| **Safety guardrails** (never commit secrets) | Instruction | Always-loaded, cannot be bypassed |
| **Project conventions** (coding style) | Instruction | Auto-applied to all interactions |
| **File-type rules** (TypeScript patterns) | Instruction | `applyTo: "**/*.ts"` targeting |
| **Repeated workflow** (code review) | Prompt | Parameterized template, explicit invoke |
| **Database migration** (with validation scripts) | Skill | Needs bundled `scripts/` |
| **Specialized role** (researcher, implementer) | Agent | Persona + tool configuration |
| **Workflow handoffs** (research → plan → build) | Agent | `handoffs:` field |
| **API endpoint creation** (boilerplate) | Prompt | Variables `${input:endpointPath}` |
| **Cross-tool workflow** (Claude + VS Code) | Skill | agentskills.io portable |

---

## VALIDATION RULES

<!-- 
WHY: Enable inspect agents to verify selections are valid.
PATTERN: REQUIRE (at least one criterion) + REJECT_IF (anti-patterns).
RULE: Every REJECT_IF points to the correct alternative.
-->

### Agent Selection Validation

```
VALID_AGENT_SELECTION:
  REQUIRE at_least_one_of:
    - needs_tool_restriction
    - needs_model_selection
    - needs_handoffs
    - needs_subagent_orchestration
    - needs_argument_hint
  REJECT_IF:
    - only_need_is_different_model  → use PROMPT with model: field
    - only_need_is_scripts          → use SKILL
    - only_need_is_auto_apply_rules → use INSTRUCTION
```

### Skill Selection Validation

```
VALID_SKILL_SELECTION:
  REQUIRE at_least_one_of:
    - needs_bundled_scripts
    - needs_bundled_assets
    - needs_cross_platform_portability
    - needs_progressive_disclosure
    - needs_on_demand_loading
  REJECT_IF:
    - one_off_script_execution      → use PROMPT with terminal tool
    - needs_persistent_persona      → use AGENT
```

### Instruction Selection Validation

```
VALID_INSTRUCTION_SELECTION:
  REQUIRE at_least_one_of:
    - needs_auto_apply
    - needs_file_pattern_targeting
    - needs_non_negotiable_boundaries
    - needs_project_wide_conventions
  REJECT_IF:
    - needs_runtime_parameters      → use PROMPT
    - needs_tool_configuration      → use AGENT
```

### Prompt Selection Validation

```
VALID_PROMPT_SELECTION:
  REQUIRE at_least_one_of:
    - needs_runtime_parameters
    - needs_repeated_workflow_template
    - needs_tool_override
    - needs_validation_gates
  REJECT_IF:
    - needs_persistent_persona      → use AGENT
    - needs_always_on_rules         → use INSTRUCTION
    - needs_bundled_scripts         → use SKILL
```

---

## ANTI-PATTERNS

<!-- 
WHY: Learn from common mistakes. "Why" column is REQUIRED.
PATTERN: ❌ Don't | ✅ Instead | Why (consequence of the anti-pattern).
-->

| ❌ Don't | ✅ Instead | Why |
|----------|-----------|-----|
| Put guardrails in Agent | Put in Instruction | Agent isn't always-loaded; guardrails need auto-apply |
| Use Skill for one-off scripts | Use Prompt with terminal tool | Skills are for packaged, versioned workflows |
| Create Agent just for different model | Use Prompt with `model:` field | Agents are for personas, not model selection |
| Put all rules in copilot-instructions.md | Split by file type with `applyTo` | Long files dilute focus; targeting improves relevance |
| Create Prompt for persistent persona | Create Agent | Prompts are templates; Agents are personas |
| Use Instruction for parameterized task | Use Prompt | Instructions cannot accept runtime variables |

---

## MIGRATION PATHS

<!-- 
WHY: Components evolve. Show when to upgrade/change.
PATTERN: From → To | Trigger (what condition indicates migration).
-->

When a component outgrows its type:

| From | To | Trigger |
|------|-----|---------|
| Prompt → Skill | Need bundled scripts or assets |
| Prompt → Agent | Need persistent persona or handoffs |
| Instruction → Agent | Need tool configuration for rules |
| Skill → Agent + Skill | Need persona invoking packaged capability |

---

## QUICK REFERENCE

<!-- 
WHY: Mnemonics help humans remember distinctions.
PATTERN: Component | Mnemonic (one word) | One-Liner (≤5 words).
-->

| Component | Mnemonic | One-Liner |
|-----------|----------|----------|
| AGENT | WHO | Persona + capabilities |
| SKILL | WHAT | Packaged capability with assets |
| INSTRUCTION | RULES | Always-on behavioral constraints |
| PROMPT | TEMPLATE | Parameterized reusable action |

---

## CROSS-REFERENCES

<!-- 
WHY: Enable navigation to related files without hardcoded paths.
PATTERN: Related File | Relationship (how they connect).
RULE: Every file mentioned should have a corresponding entry.
RULE: Use [future] prefix for planned but not-yet-created files.
-->

| Related File | Relationship | Status |
|--------------|-------------|--------|
| `OUTPUT-FORMAT-SPEC.md` | Format specification this file follows | ✅ Exists |
| `[future] PATTERNS/agent-patterns.md` | Detailed agent authoring rules | ⏳ Planned |
| `[future] PATTERNS/skill-patterns.md` | Detailed skill authoring rules | ⏳ Planned |
| `[future] PATTERNS/instruction-patterns.md` | Detailed instruction authoring rules | ⏳ Planned |
| `[future] PATTERNS/prompt-patterns.md` | Detailed prompt authoring rules | ⏳ Planned |
| `[future] RULES.md` | Framework-wide constraints | ⏳ Planned |
| `[future] TEMPLATES/` | Skeleton files for each component | ⏳ Planned |

---

## SOURCES

<!-- 
WHY: Traceability. Every rule should trace to a source.
PATTERN: [source](path) — What was extracted from it.
RULE: Include both internal cookbook files AND external official docs.
-->

- [agent-file-format.md](../cookbook/CONFIGURATION/agent-file-format.md) — Agent capabilities and constraints
- [skills-format.md](../cookbook/CONFIGURATION/skills-format.md) — Skill structure and best practices  
- [instruction-files.md](../cookbook/CONFIGURATION/instruction-files.md) — Instruction hierarchy and targeting
- [prompt-files.md](../cookbook/CONFIGURATION/prompt-files.md) — Prompt variables and invocation
- [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
- [GitHub Custom Agents Configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration)
- [agentskills.io Specification](https://agentskills.io/specification)
- [GitHub Blog — AGENTS.md Lessons](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)
