---
type: rules
version: 1.0.0
purpose: Definitive naming conventions for all framework components
applies-to: [generator, build, inspect, architect]
last-updated: 2026-01-28
---

# Naming Conventions

> **All naming rules for agents, files, folders, and configurations in the VS Code agentic framework**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
1. Reference rules by ID (NAME_RULE_NNN) when creating new components
2. Use validation checklist before finalizing any name
3. Check RESERVED NAMES before creating agents

**For Build Agents:**
1. Apply naming rules when creating files
2. Match agent name to filename exactly
3. Use correct extension for each file type

**For Inspect Agents:**
1. Validate all names against this specification
2. Flag violations with rule ID and SEVERITY
3. Check reserved name conflicts

---

## PRIORITY STACK

When naming conflicts arise:

```
1. RESERVED NAMES (never override)
2. EXTENSION REQUIREMENTS (platform-enforced)
3. FOLDER LOCATIONS (discovery-dependent)
4. CHARACTER RULES (cross-platform safety)
5. DESCRIPTIVE CLARITY (human factors)
```

---

## UNIVERSAL RULES

These rules apply to ALL component names in the framework.

```
NAME_RULE_U001: Lowercase Only
  LEVEL: MUST
  APPLIES_TO: all
  PATTERN: ^[a-z][a-z0-9-]*$
  RULE: All component names MUST be lowercase
  RATIONALE: Filesystem consistency across platforms; Windows is case-insensitive, Unix is case-sensitive
  VIOLATION: Component may be invisible on some platforms or create duplicates
  VALID_EXAMPLES: architect, meta-synthesis, fix-issue
  INVALID_EXAMPLES: Architect, MetaSynthesis, Fix_Issue

NAME_RULE_U002: Hyphen Word Separation
  LEVEL: MUST
  APPLIES_TO: all (except MCP servers)
  PATTERN: Use hyphens (-) between words
  RULE: Multi-word names MUST use hyphens as separators
  RATIONALE: Consistent with URL conventions; readable in terminals
  VIOLATION: Discovery may fail; inconsistent with ecosystem
  VALID_EXAMPLES: meta-synthesis, code-review, fix-issue
  INVALID_EXAMPLES: metaSynthesis, meta_synthesis, meta synthesis

NAME_RULE_U003: Alphanumeric Characters Only
  LEVEL: MUST
  APPLIES_TO: all
  PATTERN: ^[a-z0-9-]+$
  RULE: Names MUST contain only lowercase letters, numbers, and hyphens
  RATIONALE: Cross-platform filesystem safety; URL-safe
  VIOLATION: May cause parsing errors or filesystem issues
  VALID_EXAMPLES: build-v2, test-123
  INVALID_EXAMPLES: build@v2, test#123, build.old

NAME_RULE_U004: No Leading/Trailing Hyphens
  LEVEL: MUST
  APPLIES_TO: all
  PATTERN: ^[a-z0-9].*[a-z0-9]$ (for multi-char names)
  RULE: Names MUST NOT start or end with hyphens
  RATIONALE: URL conventions; shell parsing safety
  VIOLATION: May cause parsing errors in glob patterns
  VALID_EXAMPLES: fix-issue, meta-research
  INVALID_EXAMPLES: -fix-issue, fix-issue-, -research-

NAME_RULE_U005: No Consecutive Hyphens
  LEVEL: MUST
  APPLIES_TO: all
  PATTERN: No -- in name
  RULE: Names MUST NOT contain consecutive hyphens
  RATIONALE: Readability; URL conventions
  VIOLATION: May be parsed incorrectly; looks like typo
  VALID_EXAMPLES: meta-decision-mapper
  INVALID_EXAMPLES: meta--decision--mapper

NAME_RULE_U006: Descriptive Function Names
  LEVEL: SHOULD
  APPLIES_TO: all
  RULE: Names SHOULD clearly indicate component purpose
  RATIONALE: Users identify purpose from name alone; reduces documentation burden
  VALID_EXAMPLES: code-reviewer, test-generator, meta-decision-mapper
  INVALID_EXAMPLES: helper, agent, tool, mapper, util
```

---

## AGENT NAMING RULES

```
NAME_RULE_A001: Core Agent Names
  LEVEL: MUST
  APPLIES_TO: agent
  PATTERN: {function}
  RULE: User-facing workflow agents MUST use unprefixed function names
  RATIONALE: Simplifies user invocation; clear workflow identity
  VALID_EXAMPLES: brainstorm, architect, build, inspect, research
  INVALID_EXAMPLES: core-architect, workflow-build, user-inspect

NAME_RULE_A002: Meta Agent Prefix
  LEVEL: MUST
  APPLIES_TO: agent
  PATTERN: meta-{function}
  RULE: Framework development agents MUST use meta- prefix
  RATIONALE: Clear separation from user-facing agents; prevents namespace collision
  VALID_EXAMPLES: meta-synthesis, meta-research, meta-decision-mapper
  INVALID_EXAMPLES: synthesis, framework-synthesis, internal-research

NAME_RULE_A003: Model Variant Suffix
  LEVEL: MUST
  APPLIES_TO: agent
  PATTERN: {agent-name}-{model}
  RULE: Agents with model variants MUST suffix with -model identifier
  RATIONALE: Enables parallel agents with different capabilities
  VALID_EXAMPLES: meta-synthesis-reader-opus, meta-synthesis-reader-gemini
  INVALID_EXAMPLES: meta-synthesis-reader-opus-4, opus-meta-synthesis

NAME_RULE_A004: Agent File Naming
  LEVEL: MUST
  APPLIES_TO: agent
  PATTERN: {agent-name}.agent.md
  RULE: Agent filename MUST match agent name with .agent.md extension
  RATIONALE: Enables handoff by name; VS Code auto-discovery
  VALID_EXAMPLES: architect.agent.md, meta-synthesis.agent.md
  INVALID_EXAMPLES: architect.md, Architect.agent.md, architect.agent.txt

NAME_RULE_A005: Reserved Names
  LEVEL: MUST_NOT
  APPLIES_TO: agent
  RULE: Agent names MUST NOT match VS Code built-in participants
  RATIONALE: Prevents conflicts with platform functionality
  VIOLATION: Agent may be hidden or cause unpredictable behavior
```

### Reserved Names (Never Use)

| Name | Reason |
|------|--------|
| `workspace` | VS Code built-in `@workspace` |
| `terminal` | VS Code built-in `@terminal` |
| `vscode` | VS Code built-in `@vscode` |
| `github` | VS Code built-in `@github` |
| `azure` | VS Code built-in `@azure` |
| `plan` | Conflicts with `@Plan` command |
| `copilot` | Reserved for GitHub Copilot |
| `chat` | VS Code chat system |

---

## FILE NAMING RULES

### Extension Requirements

| File Type | Required Extension | Exact/Pattern |
|-----------|-------------------|---------------|
| Agent | `.agent.md` | Pattern |
| Instruction | `.instructions.md` | Pattern |
| Prompt | `.prompt.md` | Pattern |
| Skill | `SKILL.md` | **Exact** |
| MCP Config | `mcp.json` | **Exact** |
| Global Instructions | `copilot-instructions.md` | **Exact** |
| Universal Rules | `AGENTS.md` | **Exact** |

```
NAME_RULE_F001: Agent File Extension
  LEVEL: MUST
  APPLIES_TO: agent
  PATTERN: *.agent.md
  RULE: Agent files MUST use .agent.md extension
  RATIONALE: VS Code auto-discovery depends on extension matching
  VIOLATION: Agent will not be discovered; @mentions fail
  VALID_EXAMPLES: architect.agent.md, meta-synthesis.agent.md
  INVALID_EXAMPLES: architect.md, architect.agent.txt, architect.agent

NAME_RULE_F002: Instruction File Extension
  LEVEL: MUST
  APPLIES_TO: instruction
  PATTERN: *.instructions.md
  RULE: Instruction files MUST use .instructions.md extension
  RATIONALE: Settings-driven discovery requires exact extension
  VIOLATION: Instructions not auto-applied
  VALID_EXAMPLES: frontend.instructions.md, testing.instructions.md
  INVALID_EXAMPLES: frontend.md, frontend.rules.md

NAME_RULE_F003: Prompt File Extension
  LEVEL: MUST
  APPLIES_TO: prompt
  PATTERN: *.prompt.md
  RULE: Prompt files MUST use .prompt.md extension
  RATIONALE: Settings-driven discovery requires exact extension
  VIOLATION: Prompt not available as / command
  VALID_EXAMPLES: code-review.prompt.md, feature-spec.prompt.md
  INVALID_EXAMPLES: code-review.md, code-review.template.md

NAME_RULE_F004: Skill Filename
  LEVEL: MUST
  APPLIES_TO: skill
  PATTERN: SKILL.md (exact, case-sensitive)
  RULE: Skill definition files MUST be named exactly SKILL.md
  RATIONALE: Hardcoded discovery path; no flexibility
  VIOLATION: Skill invisible to VS Code
  VALID_EXAMPLES: .github/skills/fix-issue/SKILL.md
  INVALID_EXAMPLES: skill.md, Skill.md, SKILL.MD

NAME_RULE_F005: MCP Config Filename
  LEVEL: MUST
  APPLIES_TO: mcp
  PATTERN: mcp.json (exact)
  RULE: MCP configuration MUST be named exactly mcp.json
  RATIONALE: Fixed discovery path in .vscode/
  VIOLATION: MCP servers not configured
  VALID_EXAMPLES: .vscode/mcp.json
  INVALID_EXAMPLES: .vscode/mcp-config.json, mcp.json (wrong location)

NAME_RULE_F006: Global Instructions Filename
  LEVEL: MUST
  APPLIES_TO: instruction
  PATTERN: copilot-instructions.md (exact)
  RULE: Global instructions MUST be named exactly copilot-instructions.md
  RATIONALE: Auto-loaded for every request; fixed path
  VIOLATION: Global rules not applied
  VALID_EXAMPLES: .github/copilot-instructions.md
  INVALID_EXAMPLES: .github/instructions.md, copilot-rules.md
```

---

## FOLDER NAMING RULES

### Required Folder Locations

| Content | Location | Configurable |
|---------|----------|--------------|
| Agents | `.github/agents/` | No |
| Instructions | `.github/instructions/` | Yes |
| Prompts | `.github/prompts/` | Yes |
| Skills (project) | `.github/skills/` | No |
| Skills (personal) | `~/.copilot/skills/` | No |
| MCP Config | `.vscode/` | No |
| Memory Bank | `.github/memory-bank/` | No |
| Global Instructions | `.github/` | No |

```
NAME_RULE_D001: Agent Folder
  LEVEL: MUST
  APPLIES_TO: agent
  PATTERN: .github/agents/
  RULE: Agent files MUST be placed in .github/agents/
  RATIONALE: VS Code auto-discovers agents from this fixed path
  VIOLATION: Agent not discoverable
  VALID_EXAMPLES: .github/agents/architect.agent.md
  INVALID_EXAMPLES: agents/architect.agent.md, .vscode/agents/architect.agent.md

NAME_RULE_D002: Skill Folder Structure
  LEVEL: MUST
  APPLIES_TO: skill
  PATTERN: .github/skills/{skill-name}/SKILL.md
  RULE: Each skill MUST be in its own folder with matching name
  RATIONALE: Supports skill resources, templates alongside definition
  VIOLATION: Skill not discovered
  VALID_EXAMPLES: .github/skills/fix-issue/SKILL.md
  INVALID_EXAMPLES: .github/skills/SKILL.md, .github/skills/fix-issue.md

NAME_RULE_D003: Memory Bank Location
  LEVEL: SHOULD
  APPLIES_TO: memory
  PATTERN: .github/memory-bank/
  RULE: Memory bank files SHOULD be in .github/memory-bank/
  RATIONALE: Consistent with .github/ convention; explicit Copilot context
  VALID_EXAMPLES: .github/memory-bank/projectbrief.md
  INVALID_EXAMPLES: memory-bank/projectbrief.md (legacy, still works)
```

---

## MCP SERVER NAMING RULES

```
NAME_RULE_M001: MCP Server Names
  LEVEL: MUST
  APPLIES_TO: mcp
  PATTERN: camelCase
  RULE: MCP server names MUST use camelCase (JSON convention)
  RATIONALE: Consistent with JSON naming conventions; different namespace from files
  VALID_EXAMPLES: github, braveSearch, fileSystem
  INVALID_EXAMPLES: brave-search, brave_search, BraveSearch

NAME_RULE_M002: MCP Server Descriptive Names
  LEVEL: SHOULD
  APPLIES_TO: mcp
  RULE: MCP server names SHOULD indicate service or capability
  RATIONALE: Users identify server purpose when selecting tools
  VALID_EXAMPLES: github, filesystem, microsoftDocs
  INVALID_EXAMPLES: server1, mcp1, external
```

---

## MEMORY BANK NAMING RULES

### Fixed Filenames (Core 6)

| File | Purpose | Exact Name |
|------|---------|------------|
| Project Brief | Project overview | `projectbrief.md` |
| Product Context | Product goals | `productContext.md` |
| System Patterns | Architecture patterns | `systemPatterns.md` |
| Tech Context | Technology stack | `techContext.md` |
| Decisions | ADRs | `decisions.md` |
| Active Context | Current focus | `activeContext.md` |

```
NAME_RULE_MB001: Core Memory Files
  LEVEL: MUST
  APPLIES_TO: memory
  RULE: Core memory bank files MUST use exact fixed names
  RATIONALE: Agents reference by exact path; consistency across projects
  VIOLATION: Memory not loaded automatically
  VALID_EXAMPLES: projectbrief.md, activeContext.md
  INVALID_EXAMPLES: project-brief.md, active-context.md, brief.md

NAME_RULE_MB002: Session Archive Files
  LEVEL: SHOULD
  APPLIES_TO: memory
  PATTERN: {YYYY-MM-DD}-{topic-slug}.md
  RULE: Archived sessions SHOULD use date-topic naming
  RATIONALE: Chronological sorting; topic identification
  VALID_EXAMPLES: 2026-01-28-auth-feature.md, 2026-01-27-api-design.md
  INVALID_EXAMPLES: session1.md, auth.md, Jan28-auth.md

NAME_RULE_MB003: Feature Folder Names
  LEVEL: MUST
  APPLIES_TO: memory
  PATTERN: {feature-id} following skill naming rules
  RULE: Feature folders MUST use lowercase-hyphenated identifiers
  RATIONALE: Consistency with skill naming; URL-safe paths
  VALID_EXAMPLES: auth-refresh, payment-v2, user-onboarding
  INVALID_EXAMPLES: AuthRefresh, auth_refresh, auth refresh
```

---

## VALIDATION CHECKLIST

### Agent Name Validation

```
VALIDATE_AGENT_NAME:
  □ NAME_RULE_U001: Is lowercase only?
  □ NAME_RULE_U002: Uses hyphens for word separation?
  □ NAME_RULE_U003: Contains only alphanumeric + hyphens?
  □ NAME_RULE_U004: No leading/trailing hyphens?
  □ NAME_RULE_U005: No consecutive hyphens?
  □ NAME_RULE_A001/A002: Correct prefix (none for core, meta- for framework)?
  □ NAME_RULE_A005: Not in reserved names list?
  □ NAME_RULE_A004: Filename matches {name}.agent.md?
  □ NAME_RULE_D001: Located in .github/agents/?
```

### File Name Validation

```
VALIDATE_FILE_NAME:
  □ NAME_RULE_U001: Is lowercase only?
  □ NAME_RULE_F00X: Uses correct extension for type?
  □ NAME_RULE_D00X: In correct folder location?
  □ For skills: NAME_RULE_F004 exact SKILL.md?
  □ For MCP: NAME_RULE_F005 exact mcp.json?
```

### Skill Name Validation

```
VALIDATE_SKILL_NAME:
  □ NAME_RULE_U001-U005: Passes universal rules?
  □ Length: 1-64 characters?
  □ NAME_RULE_F004: Definition file is SKILL.md (exact)?
  □ NAME_RULE_D002: Folder name matches skill name?
  □ NAME_RULE_D002: Structure is .github/skills/{name}/SKILL.md?
```

---

## ANTI-PATTERNS

| ❌ Don't | ✅ Instead | Why |
|----------|-----------|-----|
| `MyAgent.agent.md` | `my-agent.agent.md` | Case-sensitive platforms may not find file |
| `metaSynthesis` | `meta-synthesis` | Violates hyphen separation rule |
| `workspace.agent.md` | `codebase-explorer.agent.md` | `workspace` is reserved |
| `helper.agent.md` | `code-reviewer.agent.md` | Non-descriptive; unclear purpose |
| `arch.agent.md` | `architect.agent.md` | Abbreviations are ambiguous |
| `agent-v2.agent.md` | Use git versioning | Version belongs in VCS, not filename |
| `react-agent.agent.md` | `frontend-builder.agent.md` | Tech-specific limits reusability |
| `skill.md` | `SKILL.md` | Exact case required |
| `brave-search` (MCP) | `braveSearch` | MCP uses camelCase |
| `.github/skills/fix-issue.md` | `.github/skills/fix-issue/SKILL.md` | Skills need folder structure |

---

## IRON LAWS

```
IRON_001: Reserved Names
  RULE: VS Code built-in participant names are NEVER valid for custom agents
  RATIONALE: Platform behavior is undefined; may shadow or conflict

IRON_002: Extension Matching
  RULE: File type extensions (.agent.md, .instructions.md, .prompt.md) are NEVER optional
  RATIONALE: Discovery depends entirely on extension matching

IRON_003: SKILL.md Case
  RULE: Skill definition filename is ALWAYS exactly SKILL.md (case-sensitive)
  RATIONALE: Hardcoded discovery; no flexibility in platform
```

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [COMPONENT-MATRIX.md](COMPONENT-MATRIX.md) | Component types this naming applies to |
| [OUTPUT-FORMAT-SPEC.md](OUTPUT-FORMAT-SPEC.md) | File format requirements |
| [PATTERNS/agent-patterns.md](PATTERNS/agent-patterns.md) | Agent structure patterns |
| [PATTERNS/skill-patterns.md](PATTERNS/skill-patterns.md) | Skill structure patterns |

---

## SOURCES

- [agent-naming.md](../cookbook/CONFIGURATION/agent-naming.md) — Agent naming categories, reserved names, model variants
- [file-structure.md](../cookbook/CONFIGURATION/file-structure.md) — File locations, extensions, folder conventions
- [agent-file-format.md](../cookbook/CONFIGURATION/agent-file-format.md) — Agent file structure, handoff naming
- [skills-format.md](../cookbook/CONFIGURATION/skills-format.md) — Skill naming constraints (1-64 chars, no consecutive hyphens)
- [mcp-servers.md](../cookbook/CONFIGURATION/mcp-servers.md) — MCP server naming (camelCase)
- [memory-bank-schema.md](../cookbook/CONFIGURATION/memory-bank-schema.md) — Memory bank file naming
