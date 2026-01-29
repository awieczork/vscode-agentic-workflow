---
type: decision-matrix
version: 1.0.0
purpose: Component type selection for agentic workflows
applies-to: [generator, build, inspect, architect]
last-updated: 2026-01-28
---

# Component Matrix

> **When to use Agent vs Skill vs Instruction vs Prompt**

---

## HOW TO USE THIS FILE

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

This matrix provides **unambiguous component selection** for the framework. When building agentic workflows, you must choose between four component types. Each serves a distinct purpose — this guide eliminates guesswork.

**The Framework Approach:** Use the decision flowchart for 90% of cases. Consult the detailed matrices for edge cases and composition patterns.

---

## DECISION RULES (Machine-Parseable)

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

| Component | What It Is | Loading | Invocation |
|-----------|------------|---------|------------|
| **Agent** | Persona-driven chat mode | Persistent (selectable) | `@agent-name` in chat |
| **Skill** | Packaged capability with scripts | On-demand | Referenced when needed |
| **Instruction** | Persistent behavioral rules | Always-loaded | Automatic |
| **Prompt** | Parameterized template | On-demand | `/prompt-name` or play button |

---

## CAPABILITY MATRIX

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

**What can invoke/include what:**

| Component | Can Invoke | Can Include | Can Be Invoked By |
|-----------|------------|-------------|-------------------|
| **Agent** | Other agents (handoffs), Subagents | Instructions (`#file:`), Context files | User selection, Handoffs |
| **Skill** | — | References, Scripts, Assets | User mention |
| **Instruction** | — | Other files (links) | Auto-applied |
| **Prompt** | Agents (`agent:` field) | Context files (links) | `/command`, Play button |

**Composition Patterns:**

```
┌─────────────────────────────────────────────────────────────┐
│ Agent → (handoffs) → Agent                                  │
│ Agent → (runSubagent) → Agent                               │
│ Prompt → (agent: field) → Agent                             │
│ Agent includes → Instruction (via #file: reference)         │
│ Instruction includes → Instruction (via markdown links)     │
└─────────────────────────────────────────────────────────────┘
```

---

## USE-CASE MAPPING

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

When a component outgrows its type:

| From | To | Trigger |
|------|-----|---------|
| Prompt → Skill | Need bundled scripts or assets |
| Prompt → Agent | Need persistent persona or handoffs |
| Instruction → Agent | Need tool configuration for rules |
| Skill → Agent + Skill | Need persona invoking packaged capability |

---

## PLATFORM CONSIDERATIONS

### VS Code Only
- Agent: `model`, `handoffs`, `argument-hint`
- Prompt: Full functionality
- Skill: Experimental (enable `chat.useAgentSkills`)

### GitHub.com
- Agent: Basic functionality only
- Instruction: Full via AGENTS.md
- Skill/Prompt: Not directly supported

### Cross-Platform (agentskills.io)
- Skill: VS Code, Claude Code, Cursor, Goose, Amp, OpenCode, Letta

---

## QUICK REFERENCE

| Component | Mnemonic | One-Liner |
|-----------|----------|----------|
| AGENT | WHO | Persona + capabilities |
| SKILL | WHAT | Packaged capability with assets |
| INSTRUCTION | RULES | Always-on behavioral constraints |
| PROMPT | TEMPLATE | Parameterized reusable action |

---

## CROSS-REFERENCES

| Related File | Relationship | Status |
|--------------|-------------|--------|
| `OUTPUT-FORMAT-SPEC.md` | Format specification this file follows | ✅ Exists |
| [PATTERNS/agent-patterns.md](PATTERNS/agent-patterns.md) | Detailed agent authoring rules | ✅ Complete |
| [PATTERNS/skill-patterns.md](PATTERNS/skill-patterns.md) | Detailed skill authoring rules | ✅ Complete |
| [PATTERNS/instruction-patterns.md](PATTERNS/instruction-patterns.md) | Detailed instruction authoring rules | ✅ Complete |
| [PATTERNS/prompt-patterns.md](PATTERNS/prompt-patterns.md) | Detailed prompt authoring rules | ✅ Complete |
| `[future] RULES.md` | Framework-wide constraints | ⏳ Planned |
| `[future] TEMPLATES/` | Skeleton files for each component | ⏳ Planned |

---

## SOURCES

- [agent-file-format.md](../cookbook/CONFIGURATION/agent-file-format.md) — Agent capabilities and constraints
- [skills-format.md](../cookbook/CONFIGURATION/skills-format.md) — Skill structure and best practices  
- [instruction-files.md](../cookbook/CONFIGURATION/instruction-files.md) — Instruction hierarchy and targeting
- [prompt-files.md](../cookbook/CONFIGURATION/prompt-files.md) — Prompt variables and invocation
- [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
- [GitHub Custom Agents Configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration)
- [agentskills.io Specification](https://agentskills.io/specification)
- [GitHub Blog — AGENTS.md Lessons](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)
