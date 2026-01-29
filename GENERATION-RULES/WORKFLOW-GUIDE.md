---
type: workflow
version: 1.1.0
purpose: The definitive workflow for generating agents, skills, prompts, and memory systems
applies-to: [master-generator, generator, interviewer, inspect, architect, brain]
last-updated: 2026-01-28
---

# WORKFLOW-GUIDE

> **The 6-step workflow for generating framework components: Context → Interview → Review → Generate → Inspect → Feedback**

---

## HOW TO USE THIS FILE

**For @master-generator:**
1. Execute steps IN ORDER — no step may be skipped
2. Orchestrate @generator subagents for file creation
3. Collect manifests, validate cross-references before delivery

**For @generator (subagent):**
1. You operate in GENERATE step (Step 4)
2. Read assigned GENERATION-RULES section + spec slice
3. Generate files to staging location

**For @interviewer:**
1. You operate in INTERVIEW step (Step 2)
2. Ask follow-up questions based on GENERATION-RULES choice points
3. Produce complete `project.spec.md`

**For @inspect:**
1. You operate in INSPECT step (Step 5)
2. Run checklists against generated output
3. Report failures with specific rule IDs

**For Users:**
1. You participate in Steps 1, 3, and 6 (Context, Review, Feedback)
2. You approve the spec before generation (Step 3)
3. Provide feedback if iteration needed (Step 6)

---

## THE WORKFLOW

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         GENERATION WORKFLOW                                      │
│                                                                                 │
│  ┌────────────┐    ┌────────────┐    ┌────────────┐    ┌─────────────────────┐ │
│  │  STEP 1    │    │  STEP 2    │    │  STEP 3    │    │      STEP 4         │ │
│  │  CONTEXT   │───►│ INTERVIEW  │───►│  REVIEW    │───►│     GENERATE        │ │
│  │            │    │            │    │  [HUMAN]   │    │                     │ │
│  │ User fills │    │ @interview │    │ User       │    │ @master-generator   │ │
│  │ project-   │    │ asks       │    │ confirms   │    │ orchestrates:       │ │
│  │ context.md │    │ follow-ups │    │ spec       │    │ • spawn subagents   │ │
│  │            │    │            │    │            │    │ • collect manifests │ │
│  │            │    │ Output:    │    │            │    │ • copy core agents  │ │
│  │            │    │ spec.md    │    │            │    │                     │ │
│  └────────────┘    └────────────┘    └────────────┘    └──────────┬──────────┘ │
│                                                                   │            │
│                                                                   ▼            │
│  ┌────────────────────────────────────────────────────────────────────────────┐│
│  │                           STEP 5: INSPECT                                  ││
│  │  @inspect validates generated files against checklists                     ││
│  └────────────────────────────────────────────────────────────────────────────┘│
│                          │                              │                       │
│                     PASS ▼                         FAIL ▼                       │
│  ┌────────────────────────────┐           ┌─────────────────────────────────┐  │
│  │   STEP 6: FEEDBACK         │           │   Re-GENERATE (targeted)        │  │
│  │   [HUMAN]                  │           │   Fix specific files only       │  │
│  │   User reviews, approves   │           │   Return to STEP 5              │  │
│  │   or requests changes      │           └─────────────────────────────────┘  │
│  └────────────┬───────────────┘                                                │
│               │                                                                 │
│               ▼                                                                 │
│         ┌──────────┐                                                           │
│         │   DONE   │  Output: generated/{project-name}/                        │
│         └──────────┘  User copies .github/ to target project                   │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## KEY INSIGHT

> **Interview captures ALL synthesis decisions. Generator executes spec — no autonomous synthesis.**

The @interviewer agent asks questions based on GENERATION-RULES choice points, producing a complete `project.spec.md`. The @master-generator then executes that spec deterministically.

---

## FOLDER CONVENTION

```
projects/                           ← User INPUT (Steps 1-3)
├── {project-name}/
│   ├── project-context.md         # User fills (Step 1)
│   ├── project.spec.md            # Interviewer creates (Step 2)
│   └── (additional context)       # Optional user files
└── _template/                      # Starter template to copy

generated/                          ← Agent OUTPUT (Steps 4-6)
├── {project-name}/
│   ├── .github/                   # Generated components
│   └── manifest.json              # Generation log
└── (other projects)
```

**Why separate folders?**
- Clear INPUT vs OUTPUT separation
- Multiple projects can coexist
- User-provided context preserved after generation
- Easy to re-generate with same input

---

## PERMISSION MODEL

| Step | Read | Create | Update | Delete | Scope |
|------|:----:|:------:|:------:|:------:|-------|
| **1: CONTEXT** | ✅ | ✅ | ✅ | ❌ | User-owned `project-context.md` only |
| **2: INTERVIEW** | ✅ | ✅ | ❌ | ❌ | Creates `project.spec.md` |
| **3: REVIEW** | ✅ | ❌ | ✅ | ❌ | User may edit spec |
| **4: GENERATE** | ✅ | ✅ | ✅* | ❌ | `generated/{project-name}/` only |
| **5: INSPECT** | ✅ | ❌ | ❌ | ❌ | Generated output, checklist results |
| **6: FEEDBACK** | ✅ | ❌ | ✅ | ❌ | User may request changes |

*Update applies to iteration within GENERATE; generators NEVER update existing user files without explicit approval.

---

## STEP DEFINITIONS

### STEP 1: CONTEXT

```yaml
STEP_1: CONTEXT
  AGENT: @user (with optional @brain assistance)
  PERMISSION: {R: ✓, C: ✓, U: ✓, D: ✗}
  
  INPUT:
    - User's need (what they want to build)
    - Optional: existing project context
  
  PROCESS:
    - Copy projects/_template/ to projects/{project-name}/
    - Fill project-context.md template with basic info
    - Articulate goals, constraints, preferences
    - Identify target components (agent? skill? both?)
  
  OUTPUT:
    - Completed projects/{project-name}/project-context.md
    - Initial component selection
  
  FILES_USED:
    - projects/_template/project-context.md (copy from here)
    - COMPONENT-MATRIX.md (reference)
  
  NEXT: STEP 2 (INTERVIEW)
  
  COMPLETE_WHEN:
    - projects/{project-name}/ folder exists
    - project-context.md has: name, purpose, language
    - At least one target component identified
    - User ready for interview
```

### STEP 2: INTERVIEW

```yaml
STEP_2: INTERVIEW
  AGENT: @interviewer
  PERMISSION: {R: ✓, C: ✓, U: ✗, D: ✗}
  
  INPUT:
    - Completed projects/{project-name}/project-context.md from Step 1
    - GENERATION-RULES choice points
  
  PROCESS:
    - Parse project-context.md for initial answers
    - Ask follow-up questions based on:
      • COMPONENT-MATRIX.md decision criteria
      • Pattern-specific choice points from PATTERNS/*.md
      • Orchestration needs (multi-agent? handoffs?)
      • MCP server requirements
      • Memory persistence needs
    - Produce complete project.spec.md
  
  OUTPUT:
    - Complete projects/{project-name}/project.spec.md with ALL synthesis decisions captured
    - No ambiguity — generator can execute without judgment calls
  
  FILES_USED:
    - projects/{project-name}/project-context.md (input)
    - COMPONENT-MATRIX.md (decision rules)
    - PATTERNS/*.md (choice points)
    - cookbook/TEMPLATES/project-spec-schema.md (output format)
  
  NEXT: STEP 3 (REVIEW)
  
  COMPLETE_WHEN:
    - projects/{project-name}/project.spec.md exists
    - All required spec fields populated
    - No [NEEDS CLARIFICATION] markers
    - All synthesis decisions explicit
```

### STEP 3: REVIEW (Human Checkpoint)

```yaml
STEP_3: REVIEW
  TYPE: Human approval checkpoint
  AGENT: @user
  
  VERIFY:
    - Spec accurately captures user intent
    - Component selections match actual need
    - Scope is bounded (not "generate everything")
    - No unwanted defaults slipped in
  
  PRESENT:
    - Summary of what will be generated
    - Key decisions made during interview
    - Preview of component structure
  
  APPROVAL_QUESTION: |
    "Based on our interview, here's what I'll generate:
     
     Project: {project_name}
     Components: {component_list}
     
     Key decisions:
     {decision_summary}
     
     Confirm to proceed, or adjust the spec."
  
  ON_APPROVE: → STEP 4 (GENERATE)
  ON_REJECT: → STEP 2 (INTERVIEW) with specific feedback
```

### STEP 4: GENERATE

```yaml
STEP_4: GENERATE
  AGENT: @master-generator (orchestrator)
  PERMISSION: {R: ✓, C: ✓, U: ✓, D: ✗}
  
  INPUT:
    - Approved project.spec.md
    - GENERATION-RULES/ framework
  
  PROCESS:
    1. Parse spec for complete file manifest
    2. Run copy-core-agents.ps1 for static core agents (brain, build, inspect, etc.)
    3. For EACH DOMAIN-SPECIFIC FILE to generate, spawn dedicated @generator subagent:
       • One subagent per domain agent file (e.g., spawn for api-reviewer.agent.md)
       • One subagent per skill file (e.g., spawn for git-ops.skill.md)
       • One subagent per instruction file (e.g., spawn for typescript.instructions.md)
       • One subagent per prompt file (e.g., spawn for deploy-pipeline.prompt.md)
       • One subagent per memory file (e.g., spawn for projectbrief.md)
    4. Each subagent receives ONLY:
       • Pattern file for that file type
       • Spec slice for THIS ONE FILE
       • RULES.md + NAMING.md
    5. Each subagent returns: ONE generated file + manifest entry
    6. Master collects all manifests, validates cross-references
    7. Stage complete output in generated/{project-name}/
  
  SUBAGENT_SPAWNING:
    # Note: Core agents (brain, build, inspect, research, architect) are COPIED, not generated
    # Subagents generate DOMAIN-SPECIFIC files only
    
    # Example: Spec calls for 2 domain agents, 2 skills, 2 instructions, 1 memory file
    # Result: 7 separate subagent spawns
    spawn_1: api-reviewer.agent.md (agent patterns + api-reviewer spec slice)
    spawn_2: data-validator.agent.md (agent patterns + data-validator spec slice)
    spawn_3: git-ops.skill.md (skill patterns + git-ops spec slice)
    spawn_4: api-testing.skill.md (skill patterns + api-testing spec slice)
    spawn_5: typescript.instructions.md (instruction patterns + typescript spec slice)
    spawn_6: react-components.instructions.md (instruction patterns + react spec slice)
    spawn_7: projectbrief.md (memory patterns + projectbrief spec slice)
  
  OUTPUT:
    - Generated component files in generated/{project-name}/
    - Generation manifest (what was created, decisions made)
  
  OUTPUT_STRUCTURE:
    generated/{project-name}/
    ├── .github/
    │   ├── agents/           # Core (copied) + domain-specific (generated)
    │   ├── prompts/          # Task-specific workflow starters
    │   ├── skills/           # Portable instruction packages
    │   ├── instructions/     # Scoped rules (file-pattern specific)
    │   ├── memory-bank/      # Initialized project context files
    │   └── copilot-instructions.md  # Project-wide rules
    └── manifest.json         # Generation log
  
  FILES_USED:
    - project.spec.md (input)
    - GENERATION-RULES/*.md (all rules)
    - TEMPLATES/*.md (skeletons)
    - copy-core-agents.ps1 (script)
  
  NEXT: STEP 5 (INSPECT)
  
  COMPLETE_WHEN:
    - All spec components generated
    - No blocking errors during generation
    - Manifest validates cross-references
```

### STEP 5: INSPECT

```yaml
STEP_5: INSPECT
  AGENT: @inspect
  PERMISSION: {R: ✓, C: ✗, U: ✗, D: ✗}
  
  INPUT:
    - Generated components from GENERATE
    - Checklist files for each component type
  
  PROCESS:
    1. For each generated component:
       a. Run {component}-checklist.md
       b. Record pass/fail per check
       c. If fail: note specific rule ID violated
    2. Run security-checklist.md (if tools include edit/execute)
    3. Run general-quality-checklist.md (final gate)
    4. Compile inspection report
  
  OUTPUT:
    - Inspection report with pass/fail per check
    - List of failures with rule IDs
    - Recommendation: PASS | FAIL
  
  FILES_USED:
    - CHECKLISTS/{component}-checklist.md (per component)
    - CHECKLISTS/security-checklist.md (if applicable)
    - CHECKLISTS/general-quality-checklist.md
  
  NEXT: STEP 6 (FEEDBACK) if PASS | Re-GENERATE if FAIL
  
  COMPLETE_WHEN:
    - All checklists executed
    - Inspection report compiled
    - Clear PASS or FAIL determination
```

### Re-GENERATE (Iteration Path)

```yaml
RE_GENERATE:
  TRIGGER: INSPECT returns FAIL
  
  INPUT:
    - Inspection failure report
    - Specific rule IDs violated
    - Original generated component
  
  PROCESS:
    1. Parse failure report for specific issues
    2. @master-generator spawns targeted @generator subagent
    3. Subagent loads only relevant pattern rules
    4. Apply corrections to failed files only
    5. Update manifest with iteration log
  
  OUTPUT:
    - Corrected component(s)
    - Updated manifest with iteration log
  
  NEXT: STEP 5 (INSPECT) — re-run validation
  
  ITERATION_LIMIT: 3 attempts
  ON_LIMIT_EXCEEDED: Escalate to human with failure details
```

### STEP 6: FEEDBACK (Human Checkpoint)

```yaml
STEP_6: FEEDBACK
  TYPE: Human approval checkpoint
  AGENT: @user
  
  VERIFY:
    - All inspections passed
    - Output matches original scope
    - User accepts generated components
  
  PRESENT:
    - Summary of generated components
    - Inspection report (all ✅)
    - Preview of generated content
    - Instructions for copying to target project
  
  APPROVAL_QUESTION: |
    "Generation complete. Created in generated/{project-name}/:
     {component_list with locations}
     
     All inspections passed.
     
     Copy .github/ folder to your target project to use."
  
  ON_APPROVE: → DONE
  ON_REQUEST_CHANGES: → Re-GENERATE with specific feedback
  ON_ABORT: Delete staging folder
```

---

## AGENT ARCHITECTURE

### Master/Subagent Model

```
                              ┌──────────────────────┐
                              │  @master-generator   │
                              │  (orchestrator)      │
                              └──────────┬───────────┘
                                         │
         ┌─────────────┬─────────────┬───┴───┬─────────────┬─────────────┐
         │             │             │       │             │             │
         ▼             ▼             ▼       ▼             ▼             ▼
   ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
   │@gen      │  │@gen      │  │@gen      │  │@gen      │  │@gen      │  │@gen      │
   │api-      │  │data-     │  │git-ops   │  │typescript│  │react-    │  │project   │
   │reviewer  │  │validator │  │skill     │  │instruct  │  │instruct  │  │brief     │
   └──────────┘  └──────────┘  └──────────┘  └──────────┘  └──────────┘  └──────────┘
         │             │             │             │             │             │
         ▼             ▼             ▼             ▼             ▼             ▼
     agent-        agent-        skill-       instruct-     instruct-     memory-
     patterns      patterns      patterns     patterns      patterns      patterns
     + api-rev     + data-val    + git-ops    + typescript  + react       + brief
     spec          spec          spec         spec          spec          spec

   ─────────────────────────────────────────────────────────────────────────────────
   Note: Core agents (brain, build, inspect, research, architect) are COPIED via
         copy-core-agents.ps1, not generated. Subagents handle domain-specific only.
```

**Why one subagent per FILE?** Maximum context isolation. Each subagent focuses on generating ONE specific file with ONLY the patterns and spec slice for that file. No cross-contamination, no context bloat.

### Agent Roles

| Agent | Role | Operates In |
|-------|------|-------------|
| @user | Fills context, reviews spec, provides feedback | Steps 1, 3, 6 |
| @brain | Assists user with context (optional) | Step 1 |
| @interviewer | Asks follow-ups, produces complete spec | Step 2 |
| @master-generator | Orchestrates subagents, validates cross-refs | Step 4 |
| @generator | Subagent — creates ONE file per spawn | Step 4 (spawned N times) |
| @inspect | Validates against checklists | Step 5 |

---

## HANDOFF PATTERNS

### CONTEXT → INTERVIEW

```yaml
handoff:
  from: user
  to: interviewer
  prompt: |
    Project context ready. Begin INTERVIEW.
    Context location: projects/{project_name}/project-context.md
    
    Parse context, then ask follow-up questions
    based on GENERATION-RULES choice points.
    
    Output spec to: projects/{project_name}/project.spec.md
  files_to_load:
    - projects/{project_name}/project-context.md
    - COMPONENT-MATRIX.md
```

### INTERVIEW → REVIEW

```yaml
handoff:
  from: interviewer
  to: user
  prompt: |
    Interview complete. Spec ready for review.
    
    Location: projects/{project_name}/project.spec.md
    
    Key decisions made:
    {decision_summary}
    
    Please review and confirm, or request changes.
```

### REVIEW → GENERATE

```yaml
handoff:
  from: user
  to: master-generator
  prompt: |
    Spec approved. Begin GENERATE.
    Spec location: projects/{project_name}/project.spec.md
    
    Target components: {component_list}
    Output to: generated/{project_name}/
  files_to_load:
    - projects/{project_name}/project.spec.md
    - CHECKLISTS/pre-generation-checklist.md
```

### Master → Subagent (internal)

```yaml
subagent_spawn:
  from: master-generator
  to: generator
  prompt: |
    Generate ONE file: {file_name}
    File type: {file_type}
    
    Spec slice for this file ONLY:
    {spec_slice_for_this_one_file}
    
    Pattern file:
    PATTERNS/{file_type}-patterns.md
    
    Template:
    TEMPLATES/{file_type}-skeleton.md
    
    Output to: generated/{project_name}/.github/{file_type}/{file_name}
    Return: manifest entry for this file
  context_isolation: true
  inherit_tools: [read, create, edit]
  
# Note: Core agents are COPIED, not generated
# Example: 2 domain agents + 2 skills + 1 instruction = 5 subagent spawns:
#   spawn 1: api-reviewer.agent.md
#   spawn 2: data-validator.agent.md  
#   spawn 3: git-ops.skill.md
#   spawn 4: api-testing.skill.md
#   spawn 5: typescript.instructions.md
```

### GENERATE → INSPECT

```yaml
handoff:
  from: master-generator
  to: inspect
  prompt: |
    GENERATE complete. Begin INSPECT.
    
    Generated components:
    {list_of_generated_files}
    
    Manifest location: generated/{project_name}/manifest.json
    
    Run checklists:
    {list_of_applicable_checklists}
```

### INSPECT → FEEDBACK (or Re-GENERATE)

```yaml
handoff_on_pass:
  from: inspect
  to: user
  prompt: |
    INSPECT passed. All checks ✅.
    
    Ready to deliver:
    {component_summary}
    
    Output location: generated/{project_name}/
    
    Copy .github/ folder to your target project.

handoff_on_fail:
  from: inspect
  to: master-generator
  prompt: |
    INSPECT failed. Issues found:
    
    {failure_list_with_rule_ids}
    
    Spawn targeted subagent to fix specific files.
  iteration_count: {current_iteration}
  max_iterations: 3
```

---

## ERROR RECOVERY

| Error | Step | Recovery |
|-------|------|----------|
| Context incomplete | CONTEXT | @brain assists user to fill gaps |
| Interview stalls | INTERVIEW | User provides direct answers; skip to REVIEW |
| User rejects spec | REVIEW | → INTERVIEW with specific feedback |
| Pre-generation checklist fails | GENERATE | Return to INTERVIEW with missing items |
| Pattern file missing | GENERATE | HALT — report missing file, do not proceed |
| Subagent generation error | GENERATE | Master logs error, respawns subagent |
| Cross-reference validation fails | GENERATE | Re-spawn affected subagents |
| Inspection fails | INSPECT | → Re-GENERATE with specific failures |
| 3 Re-GENERATE iterations fail | INSPECT | Escalate to human with failure details |
| User requests changes | FEEDBACK | → Re-GENERATE with feedback or ABORT |

---

## CONTEXT MANAGEMENT

### Subagent Context Isolation (Per-File)

Each @generator subagent receives ONLY:
- Pattern file for that file type (e.g., `agent-patterns.md`)
- Skeleton template for that file type (e.g., `agent-skeleton.md`)
- Spec slice for THIS ONE FILE ONLY (not all files of that type)
- RULES.md (universal constraints)
- NAMING.md (naming rules)

**NOT loaded:** Other file specs, other file type patterns, full spec, full cookbook.

**Example:** Generating `api-reviewer.agent.md`:
- Loads: agent-patterns.md, agent-skeleton.md, spec section for api-reviewer agent only
- Does NOT load: data-validator agent spec, skill patterns, instruction patterns, memory patterns

### Compaction Points

| Point | Action |
|-------|--------|
| Before subagent spawn | Extract spec slice for that ONE file only |
| During subagent generation | Subagent maintains minimal context (~100 lines) |
| After subagent completes | Context fully discarded before next spawn |
| Before INSPECT | Clear GENERATE context, load only generated output |

### What to Compact

```yaml
COMPACT_RULES:
  KEEP:
    - Active pattern rules (RULE_NNN format)
    - Project-specific values from spec slice
    - Current component structure
  
  DISCARD:
    - Examples (already applied)
    - Rationale text (decision made)
    - Cross-references to unused components
  
  SUMMARIZE:
    - Multiple rules → rule ID list
    - Long descriptions → one-line summaries
```

---

## WORKFLOW VARIANTS

### Single Component Generation

Standard workflow, but GENERATE only spawns one subagent.

### Multi-Component Generation (Standard)

```
CONTEXT → INTERVIEW → REVIEW → GENERATE
                                    │
                    ┌───────────────┼───────────────┐
                    ▼               ▼               ▼
           @gen(api-reviewer) @gen(data-validator)  ...     ← domain agents
                    │               │
           @gen(git-ops)      @gen(api-testing)     ...     ← skills  
                    │               │
           @gen(typescript)   @gen(react-components) ...    ← instructions
                    │               │
           @gen(projectbrief) @gen(activeContext)   ...     ← memory
                    │               │
                    └───────────────┼───────────────┘
                                    ▼
                           Master collects manifests
                           Cross-reference validation
                                    │
                                    ▼
                               INSPECT → FEEDBACK

# Each box = ONE subagent spawn = ONE file generated
# Core agents (brain, build, inspect) are COPIED, not shown here
# 2 domain agents + 2 skills + 2 instructions + 2 memory = 8 subagent spawns
```

### Quick Start (Minimal Interview)

For simple projects, interviewer may complete in 2-3 questions:

```
CONTEXT (minimal) → INTERVIEW (short) → REVIEW → GENERATE → INSPECT → FEEDBACK
```

### Full Pipeline with Core Agents

When generating a complete project setup:

```
GENERATE includes:
  1. Spawn subagents for domain-specific files
  2. Run copy-core-agents.ps1 for static core agents
  3. Combine into final generated/{project-name}/
```

---

## ANTI-PATTERNS

| ❌ Don't | ✅ Instead | Why |
|----------|-----------|-----|
| Skip INTERVIEW step | Always run interviewer | Incomplete specs cause generation failures |
| Skip REVIEW step | Always get user approval before GENERATE | Prevents wasted generation |
| Generator makes synthesis decisions | All decisions in spec via interview | "Generator executes, doesn't decide" |
| Generate directly to target project | Generate to `generated/{project}/` first | Enables rollback if validation fails |
| Load all patterns into one context | Subagent isolation — each gets its patterns only | Context bloat kills accuracy |
| One subagent for multiple files | One subagent per file | Maximum focus and context isolation |
| Ignore inspection failures | Fix or escalate | Uncaught errors compound |
| Re-GENERATE indefinitely | Limit to 3 iterations | Prevents infinite loops |
| Subagent accesses full spec | Spec slicing — each file gets its section only | Prevents cross-contamination |

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [README.md](README.md) | File index — which files exist |
| [COMPONENT-MATRIX.md](COMPONENT-MATRIX.md) | Component selection logic (INTERVIEW uses this) |
| [RULES.md](RULES.md) | Universal constraints loaded by subagents |
| [NAMING.md](NAMING.md) | Naming rules loaded by subagents |
| [OUTPUT-FORMAT-SPEC.md](OUTPUT-FORMAT-SPEC.md) | Format for this file |
| [pre-generation-checklist.md](CHECKLISTS/pre-generation-checklist.md) | Blocking gate in GENERATE |
| [general-quality-checklist.md](CHECKLISTS/general-quality-checklist.md) | Final gate in INSPECT |
| [projects/_template/](../projects/_template/) | User starting point (Step 1) |
| [project-spec-schema.md](../cookbook/TEMPLATES/project-spec-schema.md) | Interview output format (Step 2) |

---

## SOURCES

- [spec-driven.md](../cookbook/WORKFLOWS/spec-driven.md) — Phase structure, human gates, validation gates
- [research-plan-implement.md](../cookbook/WORKFLOWS/research-plan-implement.md) — Context compaction, ~200 line targets
- [riper-modes.md](../cookbook/WORKFLOWS/riper-modes.md) — Permission model (CRUD per stage)
- [wrap-task-decomposition.md](../cookbook/WORKFLOWS/wrap-task-decomposition.md) — Task quality, human-agent pairing
- [synthesis-reference.md](../workshop/brainstorm/synthesis-reference.md) — Synthesis methodology
- [projectbrief.md](../.github/memory-bank/projectbrief.md) — Master/subagent architecture, 6-step flow
