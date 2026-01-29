# Brainstorm: Generator Intelligence & Component Selection

> **Topic:** How generator analyzes specs and recommends agentic scaffolding
> **Continues:** brainstorm-001 (spec routing — COMPLETE)
> **Created:** 2026-01-28
> **Status:** IN-PROGRESS

---

## SCOPE CLARIFICATION (Critical Context)

This framework is **exclusively for GENERATING** the `.github/` structure:

| Generated | NOT Generated |
|-----------|---------------|
| `agents/` — Custom agent definitions | Application source code |
| `skills/` — Reusable skill modules | Business logic |
| `instructions/` — Behavioral rules | Data models |
| `copilot-instructions.md` — Main instructions | Infrastructure |
| `memory-bank/` — Initial memory structure | Tests |

**The Shiny app spec confusion:** It describes an app to BUILD. We don't build apps — we generate the agentic scaffolding that HELPS build apps.

---

## QUESTIONS FOR EXPLORATION

| Q# | Question | Status |
|----|----------|--------|
| Q1 | How should generator determine which agents to suggest based on project type? | 🔴 |
| Q2 | What's the decision matrix for skill selection? | 🔴 |
| Q3 | How do we ensure generated components don't conflict with core agents? | 🔴 |
| Q4 | How to ensure generator knows what should be skill / agent / instruction? | 🔴 |

---

## Q1: Agent Suggestion Logic

### Current State (from COMPONENT-MATRIX.md)

Agents are needed when:
- `needs_persona` — Different behavioral identity per role
- `needs_tool_restriction` — Specific tools enabled/disabled
- `needs_model_selection` — Different AI model per context
- `needs_handoffs` — Workflow transitions between agents

### Spec Field → Agent Trigger Mapping

| Spec Field | Value Pattern | Agent Trigger | Confidence |
|------------|---------------|---------------|------------|
| `project.type` | `api-service` | `api-reviewer` | 70% (inferred) |
| `project.type` | `data-pipeline` | `data-validator` | 70% (inferred) |
| `project.frameworks[]` | App framework (shiny, react, fastapi) | `{framework}-dev` | 80% (strong signal) |
| `deployment.containerization` | `Docker` | `docker-deploy` | 70% (inferred) |
| `deployment.target` | Cloud providers | `cloud-deploy` | 70% (inferred) |
| `components.agents[]` | Explicitly listed | As specified | 100% (explicit) |
| `project.goals` | Contains "security", "audit" | `security-auditor` | 60% (heuristic) |
| `project.goals` | Contains "performance" | `perf-analyzer` | 60% (heuristic) |

### Agent Confidence Thresholds

| Confidence | Source | Generator Action |
|------------|--------|------------------|
| ≥100% | Explicit in `components.agents[]` | Generate directly |
| ≥80% | Strong signal (framework match) | Generate with note |
| 60-79% | Weak signal (goals heuristic) | Suggest, wait for confirm |
| <60% | Guessing | Do NOT generate, ask user |

### Open Questions for Q1 — RESOLVED

- ✅ Agents suggested based on confidence threshold
- ✅ Limit: 2-3 custom agents per project (cognitive load)
- ✅ Generator MUST explain rationale for each suggestion

---

## Q2: Skill Selection Matrix

### Current State (from COMPONENT-MATRIX.md)

Skills are needed when:
- `needs_bundled_scripts` — Executable scripts packaged together
- `needs_bundled_assets` — Templates/reference docs co-located
- `needs_cross_platform_portability` — Works across VS Code, Claude, Cursor

### Spec Field → Skill Trigger Mapping

| Spec Signal | Detected Need | Skill Generated | Confidence |
|-------------|---------------|-----------------|------------|
| `deployment.containerization: Docker` | `needs_bundled_assets` | `docker-scaffold` | 80% |
| `structure.pattern: modular-*` | `needs_bundled_assets` | `{pattern}-templates` | 80% |
| `data.storage_format: Arrow/Parquet` | `needs_bundled_scripts` | `data-schema` | 70% |
| `components.skills[]` | Explicit | As specified | 100% |
| `frameworks[]` with scaffolding patterns | `needs_bundled_assets` | `{framework}-scaffold` | 70% |

### Framework → Skill Mapping

| Framework Category | Generates Skill? | Why |
|--------------------|------------------|-----|
| App skeleton (shiny, react, fastapi) | YES — scaffolding templates | Complex boilerplate patterns |
| Data library (arrow, pandas) | YES — validation scripts | Schema/migration scripts |
| UI component (visNetwork, d3) | NO — use PROMPT instead | One-off optimization tasks |
| Utility library (lodash, purrr) | NO — document in instructions | No bundled assets needed |

### What NOT to Generate as Skill

| Spec Signal | Don't Generate | Instead |
|-------------|----------------|---------|
| `testing: pytest` | pytest skill | INSTRUCTION for test conventions |
| One-off task in goals | skill | PROMPT for ad-hoc workflow |
| Generic "help with X" | skill | Clarify scope first |

### Open Questions for Q2 — RESOLVED

- ✅ Skills are GENERATED when templates/scripts needed
- ✅ Skills interact with @build via `#skill:` references
- ✅ Size threshold: 500 lines / 5000 tokens per skill file

---

## Q3: Core Agent Compatibility

### Core Agents — COPIED, Not Generated

| Agent | Role | EXCLUSIVE Responsibilities |
|-------|------|---------------------------|
| `@brain` | Orchestration | Project state, strategic direction, phase decisions |
| `@architect` | Planning | Implementation plans, plan validation, success criteria |
| `@build` | Execution | General-purpose implementation across all technologies |
| `@inspect` | Verification | Quality gates, pass/fail determination, checklist execution |
| `@research` | Information | Web research, fact-checking, source citation |

### Role Boundaries for Generated Agents

```
GENERATED AGENTS MAY:
  ✅ Claim domain expertise (e.g., "Shiny specialist")
  ✅ Provide technology-specific patterns
  ✅ Execute within their domain scope
  ✅ Handoff to other domain agents

GENERATED AGENTS MUST NOT:
  🚫 Claim orchestration role (reserved: @brain)
  🚫 Create implementation plans (reserved: @architect)
  🚫 Issue formal pass/fail verdicts (reserved: @inspect)
  🚫 Perform general web research (reserved: @research)
  🚫 Override P1 safety rules
```

### Required Handoff Patterns

| Trigger Condition | Required Handoff |
|-------------------|------------------|
| Work exceeds domain scope | → @build |
| Plan/spec issues discovered | → @architect |
| Quality verification needed | → @inspect |
| Web research required | → @research |
| Strategic/scope questions | → @brain |

### Generated Agent Handoff Template

```yaml
# REQUIRED in all generated agents
handoffs:
  - when: "planning needed"
    to: "@architect"
  - when: "implementation beyond my domain"
    to: "@build"
  - when: "verification required"
    to: "@inspect"
  - when: "research needed"
    to: "@research"
  - when: "strategic decision"
    to: "@brain"
```

### Naming Rules

| ALLOWED | FORBIDDEN |
|---------|-----------|
| `{domain}-{role}` (e.g., `shiny-dev`) | Core names: `brain`, `architect`, `build`, `inspect`, `research` |
| `{technology}-{action}` (e.g., `docker-deploy`) | System reserved: `workspace`, `terminal`, `vscode`, `github` |
| Descriptive domain terms | Generic: `helper`, `assistant`, `copilot`, `agent` |

### Constraint Inheritance

**Mechanism:** Safety rules propagate via `safety.instructions.md` with `applyTo: "**/*"`

- P1 rules (IRON_001-003) apply to ALL agents automatically
- Generated agents inherit parent's P1 constraints when spawned as subagents
- No explicit inheritance declaration needed — instruction auto-application handles it

### Open Questions for Q3 — RESOLVED

- ✅ Generated agents complement, never override core agents
- ✅ Handoffs to core agents recommended for out-of-scope work
- ✅ Safety rules propagate via instruction file auto-application

---

## Q4: Component Type Selection (Agent vs Skill vs Instruction)

### Master Decision Algorithm

```
COMPONENT_SELECTION(spec_signal):
  
  # Step 1: Check explicit declarations
  IF signal IN components.agents[] → AGENT (100% confidence)
  IF signal IN components.skills[] → SKILL (100% confidence)
  IF signal IN components.instructions[] → INSTRUCTION (100% confidence)
  
  # Step 2: Apply decision flowchart
  IF needs_persona OR needs_tool_restriction OR needs_handoffs
    → AGENT
  ELSE IF needs_bundled_scripts OR needs_bundled_assets
    → SKILL  
  ELSE IF needs_auto_apply OR needs_file_pattern_targeting
    → INSTRUCTION
  ELSE
    → (don't generate)
```

### Spec Signal → Needs Mapping

| Spec Signal | Detected Need | Component |
|-------------|---------------|-----------|
| `project.type` = framework-specific | `needs_persona` | AGENT |
| `frameworks[]` = app skeleton | `needs_persona` | AGENT |
| `frameworks[]` = any framework | `needs_file_pattern_targeting` | INSTRUCTION |
| `project.languages[]` | `needs_auto_apply` | INSTRUCTION |
| `deployment.containerization: Docker` | `needs_bundled_assets` | SKILL |
| `structure.pattern: modular-*` | `needs_bundled_assets` | SKILL |
| `goals` mentions "security/audit" | `needs_persona` + `needs_auto_apply` | AGENT + INSTRUCTION |
| `goals` mentions role name | `needs_persona` | AGENT |

### Overlap Resolution: When Both Agent AND Instruction

| Concept | Resolution |
|---------|------------|
| **Security** | Generate BOTH: `security.instructions.md` (rules) + `security-auditor.agent.md` (review persona) |
| **Code Review** | Generate BOTH: `style.instructions.md` (patterns) + domain agent handles review workflow |
| **Testing** | Generate: `test-patterns.instructions.md` only (test execution is @build's job) |

**Rule:** When overlap detected, generate INSTRUCTION for passive rules, AGENT for active work.  
Agent references instruction via `#file:` to stay consistent.

### What NOT to Generate

| Spec Signal | Don't Generate | Why |
|-------------|----------------|-----|
| `testing: pytest` | Skill | Use instruction for conventions, @build runs tests |
| `frameworks: [react]` alone | Agent | Too generic — use targeted instructions |
| One-off task mentioned | Skill | Use prompt for one-off tasks |
| Generic "help with X" | Agent | Too vague — clarify scope first |
| Utility library (lodash, purrr) | Any | Document in instructions, no component needed |

### Decision Summary Table

| Component | When To Generate | When NOT To Generate |
|-----------|------------------|---------------------|
| **AGENT** | Persona needed, handoffs required, domain specialist | Generic roles, one-off tasks |
| **SKILL** | Scripts/templates to bundle | One-off scripts, prompts suffice |
| **INSTRUCTION** | Always-on rules, file patterns | Parameterized tasks, agent-only rules |
| **PROMPT** | *(Not generated)* | Ad-hoc user creation |

### Open Questions for Q4 — RESOLVED

- ✅ Component type determined by decision flowchart + spec signal mapping
- ✅ Overlaps resolved by generating BOTH when persona + rules needed
- ✅ Generator uses confidence thresholds to decide generate vs suggest

---

## SYNTHESIS: Generator Analysis Pipeline

### Input → Output Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    project.spec.md                          │
│  ├── project.type, languages, frameworks                    │
│  ├── project.goals                                          │
│  ├── components.agents[], skills[], instructions[]          │
│  └── deployment, data, structure                            │
└─────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│              SIGNAL EXTRACTION LAYER                        │
│  • Map spec fields → needs_* criteria                       │
│  • Calculate confidence per component                       │
│  • Detect overlaps requiring both AGENT + INSTRUCTION       │
└─────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│              COMPONENT SELECTION LAYER                      │
│  • Apply decision flowchart                                 │
│  • Resolve overlaps (AGENT + INSTRUCTION when needed)       │
│  • Filter by confidence threshold (≥80% generate, else ask) │
└─────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│              GENERATION LAYER                               │
│  • Generate components using PATTERNS/*                     │
│  • Add required handoffs to core agents                     │
│  • Include constraint inheritance                           │
└─────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                    OUTPUT                                   │
│  .github/                                                   │
│  ├── agents/      # Core (copied) + Custom (generated)      │
│  ├── skills/      # Generated when scripts/assets needed    │
│  ├── instructions/# Generated for file patterns + rules     │
│  ├── copilot-instructions.md  # Always generated            │
│  └── memory-bank/ # Always generated                        │
└─────────────────────────────────────────────────────────────┘
```

### Generator Recommendation Format

```markdown
## Generated Components Recommendation

### Agents (N suggested)

| Agent | Rationale | Confidence | Action |
|-------|-----------|------------|--------|
| `shiny-dev` | Primary framework is Shiny | 80% | ✅ Generate |
| `docker-deploy` | Docker deployment specified | 70% | ⚠️ Confirm? |

### Skills (N suggested)

| Skill | Rationale | Confidence | Action |
|-------|-----------|------------|--------|
| `shiny-modules` | Modular pattern specified | 80% | ✅ Generate |

### Instructions (N suggested)

| Instruction | ApplyTo | Rationale | Action |
|-------------|---------|-----------|--------|
| `r-code.instructions.md` | `**/*.R` | R language | ✅ Generate |
| `shiny-patterns.instructions.md` | `**/R/*.R` | Shiny conventions | ✅ Generate |
| `security.instructions.md` | `**/*` | Security in goals | ⚠️ Confirm? |

### Memory Bank

| File | Purpose |
|------|---------|
| `projectbrief.md` | Core project context (always) |
| `activeContext.md` | Current work focus (always) |
```

### Validation Gates

Before generating, verify:
1. ☑️ No generated agent claims core agent responsibilities
2. ☑️ All generated agents have handoffs to relevant core agents
3. ☑️ No naming conflicts with reserved names
4. ☑️ Safety instruction inheritance preserved
5. ☑️ Component count within cognitive limits (≤3 agents, ≤5 skills, ≤10 instructions)

---

## BLOCKING QUESTIONS — RESOLVED

| BQ# | Question | Resolution |
|-----|----------|------------|
| BQ1 | Generate when >80% confidence, else ask | ✅ Threshold-based approach |
| BQ2 | Fixed handoff patterns to core agents | ✅ Required handoffs defined |
| BQ3 | Use GENERATION-RULES/PATTERNS/ for framework mappings | ✅ Documented in research |

---

## DECISIONS SUMMARY

| ID | Decision | Confidence |
|----|----------|------------|
| D1 | Signal extraction maps spec fields → needs_* criteria | 90% ✅ |
| D2 | Confidence thresholds: ≥80% generate, 60-79% ask, <60% skip | 85% ✅ |
| D3 | Overlaps resolved by generating BOTH agent + instruction | 90% ✅ |
| D4 | Core agents COPIED, custom agents GENERATED | 95% ✅ |
| D5 | Required handoffs to core agents in all generated agents | 90% ✅ |
| D6 | Safety rules propagate via instruction auto-application | 95% ✅ |

---

## NEXT STEPS

| Step | Agent | Task |
|------|-------|------|
| 1 | @architect | Create implementation plan for generator analysis pipeline |
| 2 | @build | Implement signal extraction layer |
| 3 | @build | Implement component selection layer with confidence scoring |
| 4 | @inspect | Verify generated outputs against this spec |

---

## SOURCES

- [COMPONENT-MATRIX.md](GENERATION-RULES/COMPONENT-MATRIX.md) — Component selection rules
- [RULES.md](GENERATION-RULES/RULES.md) — Constraint hierarchy, safety rules
- [NAMING.md](GENERATION-RULES/NAMING.md) — Reserved names, naming patterns
- [agent-patterns.md](GENERATION-RULES/PATTERNS/agent-patterns.md) — Agent authoring rules
- [skill-patterns.md](GENERATION-RULES/PATTERNS/skill-patterns.md) — Skill authoring rules
- [instruction-patterns.md](GENERATION-RULES/PATTERNS/instruction-patterns.md) — Instruction authoring rules
