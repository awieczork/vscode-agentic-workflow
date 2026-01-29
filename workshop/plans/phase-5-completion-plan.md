# Phase 5: Completion Plan

> **Status:** Active | **Created:** 2026-01-27 | **Updated:** 2026-01-28

---

## Goal

Finalize the generation pipeline so users can go from project idea → working `.github/` folder.

---

## Prerequisites ✅ COMPLETE

| Item | Status | Notes |
|------|--------|-------|
| Cookbook enriched (52 files) | ✅ | All files have synthesis metadata |
| INDEX.yaml | ✅ | Task → cookbook file mapping |
| Synthesis reference | ✅ | `workshop/brainstorm/synthesis-reference.md` |
| Synthesis prompts | ✅ | `.github/prompts/01-17*.prompt.md` |
| @brain Mode 8 | ✅ | Synthesis execution mode added (2026-01-28) |

---

## Deliverables

| # | Deliverable | Description | Status |
|---|-------------|-------------|--------|
| 1 | Project Structure Alignment | Align this project with OUTPUT_STRUCTURE (add skills/, instructions/) | ✅ COMPLETE |
| 2 | Core Agent Updates | Make existing agents portable + COMPONENT-MATRIX compliant | ✅ COMPLETE |
| 3 | Generator Suite | master-generator + generator (subagent) — **CREATE** | ✅ COMPLETE |
| 4 | Interviewer Agent | `interviewer.agent.md` — **CREATE** | ✅ COMPLETE |
| 5 | Updated @inspect | File-type validation with rule ID reporting | ✅ COMPLETE |
| 6 | `copy-core-components.ps1` | Script to copy portable components | ✅ COMPLETE |
| 7 | User Guide | Quick-start guide for using the framework | ⏳ |
| 8 | End-to-end testing | Validate full 6-step pipeline | ⏳ |

> **Completed:** GENERATION-RULES (30 files) ✅

> **Note:** Project Context Template moved into GENERATION-RULES (prompt #15-project-context).

---

## Steps

### 5.1 Project Structure Alignment ✅ COMPLETE (2026-01-28)

**Goal:** Align THIS project's structure with what generator will produce — "eat our own dog food."

**Why This Matters:**
- Generator outputs `generated/{project}/.github/` with specific folder structure
- This project's `.github/` should match that structure BEFORE we build the generator
- Ensures the generator design is validated against a real example
- Core agents become true exemplars that match generated output format

**Expected OUTPUT_STRUCTURE (per WORKFLOW-GUIDE.md):**
```
.github/
├── agents/           ✅ EXISTS
├── prompts/          ✅ EXISTS
├── skills/           ❌ MISSING — create empty or with core skill
├── instructions/     ❌ MISSING — create with safety.instructions.md
├── memory-bank/      ✅ EXISTS
└── copilot-instructions.md  ✅ EXISTS
```

**Actions Required:**

| Action | Target | Rationale |
|--------|--------|-----------|
| Create `.github/skills/` | Empty folder or with 1 exemplar skill | Structure alignment |
| Create `.github/instructions/` | With `safety.instructions.md` | P1 guardrails should be Instructions per COMPONENT-MATRIX |
| Extract P1 guardrails from agents | → `safety.instructions.md` | COMPONENT-MATRIX: "Put guardrails in Instruction, not Agent" |
| Validate structure against OUTPUT_STRUCTURE | All 6 folders/files present | Pre-generator validation |

**P1 Guardrails Extraction:**

Per COMPONENT-MATRIX.md Anti-Patterns:
> "❌ Put guardrails in Agent → ✅ Put in Instruction — Agent isn't always-loaded; guardrails need auto-apply"

Current agents (brain, build, etc.) have `<safety>` sections with P1 rules. These SHOULD be:
1. **Kept in agent** as behavioral guidance (what agent does when it encounters issue)
2. **Also extracted to** `safety.instructions.md` for auto-apply (ensures P1 even when agent not selected)

**safety.instructions.md content (extract from RULES.md IRON_001-003):**
```markdown
---
applyTo: "**/*"
---

# Safety Rules (P1 — Cannot Be Overridden)

These rules apply to ALL Copilot interactions in this project.

## IRON_001: Never Expose Secrets
NEVER commit, log, transmit, or display secrets, credentials, or API keys.

## IRON_002: Never Fabricate
NEVER fabricate sources, facts, or capabilities. Say "I don't know" when uncertain.

## IRON_003: Never Bypass Security
NEVER disable security controls without explicit security team approval.
```

**Acceptance Criteria:**
- [x] `.github/skills/` folder exists
- [x] `.github/instructions/` folder exists
- [x] `safety.instructions.md` in instructions folder with P1 rules (IRON_001-003)
- [x] Structure matches WORKFLOW-GUIDE OUTPUT_STRUCTURE (6 items)
- [x] Validated by running structure check (2026-01-28)

**Depends on:** GENERATION-RULES complete ✅ — needs COMPONENT-MATRIX decision logic

---

### 5.2 Core Agent Updates ✅ COMPLETE (2026-01-28)

**Goal:** Create portable, copy-paste-ready core agents that work in ANY project.

**Agents to make portable:**
- `brain.agent.md` — strategic thought partner
- `build.agent.md` — execution agent
- `inspect.agent.md` — verification agent
- `research.agent.md` — research agent
- `architect.agent.md` — planning agent

**Output locations:**
- `GENERATION-RULES/_EXEMPLAR/agents/` — portable templates (source for copy script)
- `.github/agents/` — this project's working versions (may have extensions)

**Portability Requirements:**

| Requirement | Portable Version | This Project's Version |
|-------------|------------------|------------------------|
| Paths | `.github/memory-bank/`, `.github/agents/` only | May include `workshop/`, `cookbook/` |
| Output folders | Parameterized: `{project-output}/` | Hardcoded: `workshop/brainstorm/` |
| Modes | Standard modes only | May have project-specific modes |
| Tool refs | Generic tool categories | May include MCP-specific tools |
| Skills | Standard skill refs | May include project-specific skills |

**What to REMOVE for portable version:**
- [x] `workshop/` path references → use `.github/memory-bank/` or parameterized
- [x] `cookbook/` path references → remove (project-specific)
- [x] Mode 6 (Synthesis Execution) → remove (project-specific to this workspace)
- [x] `INDEX.yaml` references → remove (project-specific)
- [x] `synthesis-reference.md` references → remove (project-specific)
- [x] Project-specific state file naming → use generic convention

**What to KEEP for portable version:**
- [x] Standard modes (1-5 for brain, equivalents for others)
- [x] Safety rules (P1 — cannot be overridden)
- [x] Handoff patterns to other core agents
- [x] Generic context loading (`.github/memory-bank/` files)
- [x] Tool categories (not specific MCP servers)
- [x] YAML frontmatter structure

**Process:**
1. For each agent, validate against `COMPONENT-MATRIX.md`:
   - Confirm agent is correct component type (DECISION RULES)
   - Verify meets VALID_AGENT_SELECTION criteria
   - Check size < 30,000 chars (CONSTRAINT MATRIX)
   - Verify no ANTI-PATTERN violations
2. Create portable version in `GENERATION-RULES/_EXEMPLAR/agents/`
3. Run through `CHECKLISTS/agent-checklist.md`
4. Verify structure against `PATTERNS/agent-patterns.md`
5. Verify naming against `NAMING.md`
6. Test: agent should work if copied to empty `.github/agents/` folder

**COMPONENT-MATRIX Validation Checklist:**
- [x] Agent has at least one of: tool restriction, model selection, handoffs, subagent orchestration, argument-hint
- [x] Agent is NOT just for different model (should use Prompt instead)
- [x] Agent is NOT just for scripts (should use Skill instead)
- [x] Agent is NOT just for auto-apply rules (should use Instruction instead)
- [x] Size under 30,000 characters (max: 6,056 chars)
- [x] Located in `.github/agents/`
- [x] No guardrails that should be in Instructions instead (IRON rules in safety.instructions.md)

**⚠️ If Mismatches Found:**
If COMPONENT-MATRIX validation identifies violations, we must:
1. **Split components** — Extract misplaced content into correct component type:
   - Guardrails/safety rules → `.github/instructions/` (auto-apply, cannot be bypassed)
   - Bundled scripts/assets → `.github/skills/` (packaged capabilities)
   - File-type rules → `.github/instructions/` with `applyTo:` targeting
2. **Update BOTH versions:**
   - This project's working agents (`.github/agents/`)
   - Portable templates (`_EXEMPLAR/agents/`)
3. **Create companion files** — If agent content splits, create corresponding:
   - `_EXEMPLAR/instructions/` for extracted instructions
   - `_EXEMPLAR/skills/` for extracted skills
4. **Update copy script** — `copy-core-agents.ps1` must copy ALL component types, not just agents

**Example splits:**
| Agent Content | Should Be | Action |
|---------------|-----------|--------|
| Safety rules (P1 guardrails) | Instruction | Extract to `safety.instructions.md` |
| Always-on project conventions | Instruction | Extract to `conventions.instructions.md` |
| Bundled validation scripts | Skill | Extract to `validation.skill.md` |
| Persona + tools + handoffs | Agent | Keep in agent |

**Acceptance Criteria:**
- [x] All 5 portable agents in `_EXEMPLAR/agents/`
- [x] All agents pass `agent-checklist.md` GATE 1-4:
  - GATE 1: CHECK_S001-S004 (Structure & Naming) ✅
  - GATE 2: CHECK_R001-R004 (Required Sections: safety, context_loading, boundaries) ✅
  - GATE 3: CHECK_T001-T002 (Tool Configuration, handoffs `send: false`) ✅
  - GATE 4: CHECK_C001-C004 (Size ≤25,000 chars, ≤300 lines, 3-10 step tasks) ✅
- [x] Structure matches `agent-skeleton.md` template
- [x] Naming per NAMING.md: NAME_RULE_U001-U006, NAME_RULE_A001-A004
- [x] COMPONENT-MATRIX validation: DECISION_RULES flowchart passed
- [x] agent-patterns.md rules: RULE_001-008 (frontmatter, tools, handoffs, P1 safety)
- [x] Any extracted instructions in `_EXEMPLAR/instructions/` (safety.instructions.md)
- [x] Any extracted skills in `_EXEMPLAR/skills/` (README.md placeholder)
- [x] No `workshop/` or `cookbook/` references in portable versions
- [x] Each agent is self-contained (no external dependencies beyond `.github/`)
- [ ] copy-core-components.ps1 can copy from `_EXEMPLAR/` to `generated/{project}/` *(Step 5.6)*

**Why before Generator Suite?**
- Portable agents serve as **exemplars** for generator
- Generator references these when creating domain-specific agents
- Ensures consistency: generated agents match core agent structure

**Depends on:** GENERATION-RULES complete ✅, 5.1 complete (structure aligned)

### 5.3 Generator Suite ✅ COMPLETE (2026-01-28)

**Goal:** Create master-generator + subagent architecture from scratch.

**Agents to create:**
- `master-generator.agent.md` — orchestrates subagents, validates output
- `generator.agent.md` — subagent, creates ONE file per spawn

**WORKFLOW-GUIDE.md Integration:**
- master-generator executes **Step 4 (GENERATE)** — see WORKFLOW-GUIDE.md STEP_4
- generator subagent operates within Step 4 scope only
- Follows **Hub-and-Spoke** orchestration (orchestration-patterns.md RULE_001)
- Constraint: ONE-level depth — subagents CANNOT spawn other subagents
- Handoffs use `send: false` per agent-patterns.md RULE_003

**master-generator requirements (per orchestration-patterns.md):**
| Requirement | Rule ID |
|-------------|--------|
| Hub-and-spoke architecture | RULE_001 |
| `send: false` on subagent returns | RULE_002 |
| Loop exit condition (max 3 Re-GENERATE) | RULE_003 |
| Subagent output constraint in request | RULE_004 |
| `tools: ["read", "search", "edit", "agent"]` | agent-patterns.md |

**generator requirements (subagent):**
| Requirement | Rule ID |
|-------------|--------|
| `tools: ["read", "edit"]` — NO "agent" | RULE_001 |
| `infer: true` — allow as subagent | agent-patterns.md |
| Bounded scope (generate ONE file) | RULE_008 |
| Return: file content + manifest entry | orchestration-patterns.md |
| CANNOT spawn additional subagents | Platform constraint |

**Process:**
1. Create agents per `agent-skeleton.md` template
2. Apply orchestration-patterns.md Hub-and-Spoke model
3. Validate against `agent-checklist.md` GATE 1-4
4. Verify handoff structure per agent-patterns.md RULE_003-004

**Required Outputs (per WORKFLOW-GUIDE OUTPUT_STRUCTURE):**
- `copilot-instructions.md` — Project-wide rules (REQUIRED for every generated project)
- `manifest.json` — Generation log at `generated/{project-name}/manifest.json`

**Depends on:** GENERATION-RULES complete ✅, 5.2 complete (core agents as exemplars)

### 5.4 Interviewer Agent ⏳ AFTER GENERATION-RULES — CREATE NEW

**Goal:** Create interviewer agent that captures ALL synthesis decisions via conversation.

**Agent to create:**
- `interviewer.agent.md` — executes WORKFLOW-GUIDE.md **Step 2 (INTERVIEW)**

**WORKFLOW-GUIDE.md Integration:**
- Questions derive from COMPONENT-MATRIX.md DECISION_RULES choice points
- Additional questions from PATTERNS/*.md choice points
- Output: Complete `project.spec.md` with no [NEEDS CLARIFICATION] markers

**Question categories (from COMPONENT-MATRIX.md):**
| Category | Question Pattern | Decision |
|----------|-----------------|----------|
| Component Type | "Does this need persona/tools/model/handoffs?" | AGENT vs SKILL vs INSTRUCTION vs PROMPT |
| Agent Validation | "Does it have at least one of: tool restriction, model selection, handoffs?" | Validates AGENT choice |
| Skill Validation | "Does it need bundled scripts, assets, or cross-platform portability?" | Validates SKILL choice |
| Instruction Validation | "Are these rules that must auto-apply or target specific file patterns?" | Validates INSTRUCTION choice |
| Orchestration | "Will multiple agents need to hand off to each other?" | handoffs: field |
| MCP Servers | "Does this need external tools (GitHub, search, filesystem)?" | mcp-patterns.md |
| Memory Needs | "What project state must persist across sessions?" | memory-patterns.md |

**Files interviewer references:**
- COMPONENT-MATRIX.md (decision flowchart)
- PATTERNS/*.md (pattern-specific choices)
- TEMPLATES/project-spec-schema.md (output format)

**Process:**
1. Create agent per `agent-skeleton.md` template
2. Define modes for each GENERATION-RULES area
3. Questions map to DECISION_RULES criteria
4. Validate against `agent-checklist.md` GATE 1-4

**"User Doesn't Know" Handling:**
| Field Type | Behavior |
|------------|----------|
| Required (name, type, goals) | Re-ask with examples, then fail if still unclear |
| Component decision | Apply DECISION_RULES default → PROMPT |
| Optional preferences | Apply language-standard default, mark as `[defaulted]` |

**Depends on:** GENERATION-RULES complete ✅ (derives questions from patterns)

### 5.5 Updated @inspect ✅ COMPLETE (2026-01-28)

**Goal:** Update @inspect to execute WORKFLOW-GUIDE.md **Step 5 (INSPECT)** with file-type checklists.

**Updates required:**
- Add mode for generated output validation
- Reference GENERATION-RULES/CHECKLISTS/*.md for validation criteria
- Report failures with specific rule IDs (CHECK_*, NAME_RULE_*, RULE_*)

**Checklist execution order (per WORKFLOW-GUIDE.md STEP_5):**
| Phase | Checklist | When |
|-------|-----------|------|
| 1 | `pre-generation-checklist.md` | Before GENERATE (blocking gate) |
| 2 | `agent-checklist.md` | For each `.agent.md` generated |
| 2 | `skill-checklist.md` | For each `.skill.md` generated |
| 2 | `instruction-checklist.md` | For each `.instructions.md` generated |
| 2 | `prompt-checklist.md` | For each `.prompt.md` generated |
| 2 | `memory-checklist.md` | For each memory-bank file generated |
| 3 | `security-checklist.md` | If any tools include edit/execute |
| 4 | `general-quality-checklist.md` | Always run last (final gate) |

**Inspection report must include:**
- File path + checklist used
- PASS/FAIL status per check
- Failure rule IDs (e.g., "CHECK_R001", "NAME_RULE_U003")
- Recommendation: PASS | FAIL

**On FAIL:** Hand off to @master-generator with specific rule IDs for Re-GENERATE

**Severity Handling:**
| Severity | Action |
|----------|--------|
| BLOCKING | FAIL entire file — must fix before PASS |
| WARNING | Flag in report — does not block PASS |

**Pre-Generation Failure:**
- If `pre-generation-checklist.md` FAILS → Return to @interviewer (NOT @master-generator)

**Skip-When-Empty:**
- No skills generated → SKIP `skill-checklist.md`, note "N/A"
- No instructions generated → SKIP `instruction-checklist.md`, note "N/A"
- No edit/execute tools → SKIP `security-checklist.md`, note "N/A"

**Retry Policy:**
- Re-GENERATE attempts: max 3 (already documented)
- On 3rd failure: HALT, output `GENERATION_FAILURES.md` with all attempts

**Manifest Validation:**
- `manifest.json` exists at `generated/{project}/manifest.json`
- Valid JSON (parser doesn't throw)
- Contains list of generated files
- No formal schema required — generator creates, inspect validates structure

**Acceptance Criteria:**
- [x] Mode 4: Generated Output Validation added to inspect.agent.md
- [x] File-type-specific checklist mapping (8 types)
- [x] Rule ID reporting format (CHECK_*)
- [x] BLOCKING vs WARNING severity handling
- [x] Skip-when-empty rules for component types
- [x] Manifest validation (CHECK_M001-M003) before file checklists
- [x] Handoff to @master-generator on FAIL with rule IDs
- [x] Max 3 Re-GENERATE iterations documented
- [x] Agent passes size constraints (229 lines, 7.3K chars — well under 300/25K limits)

**Depends on:** CHECKLISTS/*.md from GENERATION-RULES ✅ (all 8 files)

---

**⚡ PARALLELIZATION:** After 5.2 completes, steps **5.3, 5.4, and 5.6** can run in parallel — they have no cross-dependencies. Then 5.5, then 5.7.

---

### 5.6 Core Components Script ✅ COMPLETE (2026-01-28)

**Goal:** Script to copy ALL portable core components to generated output.

**Source:** `GENERATION-RULES/_EXEMPLAR/` (agents, instructions, skills, memory-bank)
**Target:** `generated/{project-name}/.github/`

**Script behavior:**
1. Copy all `.agent.md` files from `_EXEMPLAR/agents/`
2. Copy all `.instructions.md` files from `_EXEMPLAR/instructions/` (if exists)
3. Copy all skill folders from `_EXEMPLAR/skills/` (if exists)
4. Copy all memory-bank templates from `_EXEMPLAR/memory-bank/`
5. Preserve file structure
6. Log copied files to manifest (JSON output)

**Output:** `_user-utils/copy-core-components.ps1`

**Acceptance Criteria:**
- [x] Script exists at `_user-utils/copy-core-components.ps1`
- [x] Copies all 4 component folders (agents, instructions, skills, memory-bank)
- [x] Copies 9 files total (5 agents + 1 instruction + 1 skill README + 2 memory)
- [x] Skips non-component files (decision-matrix-exemplar.md)
- [x] Creates target folder structure if not exists
- [x] Outputs JSON with copied file list for manifest integration
- [x] Idempotent (running twice = same result)
- [x] Tested with `./copy-core-components.ps1 -ProjectName "test-project"`

> **Note:** Script name reflects copying ALL component types, not just agents.

### 5.7 User Guide & Projects Folder ⏳ BEFORE END-TO-END

**Goal:** Create a dedicated folder for user input files and a simple guide for using the framework.

**Problem Solved:**
- Currently `project-context.md` and `project.spec.md` have no defined home
- User input (BEFORE generation) vs generated output (AFTER) should be clearly separated
- Multiple projects need isolated workspaces

**Folder Structure:**
```
projects/                           ← User INPUT (before generation)
├── {project-name}/
│   ├── project-context.md         # User fills (Step 1)
│   ├── project.spec.md            # Interviewer creates (Step 2)
│   └── (additional context files)  # Optional user-provided files
└── README.md                       # Instructions for projects folder

generated/                          ← Agent OUTPUT (after generation)
├── {project-name}/
│   ├── .github/                   # Generated components
│   └── manifest.json              # Generation log
└── (other projects)
```

**Deliverables:**

1. **`projects/` folder** with README.md explaining purpose
2. **`projects/_template/`** with starter files:
   - `project-context.md` (copy of TEMPLATES/project-context-template.md)
3. **Updated WORKFLOW-GUIDE.md** with explicit paths:
   - Step 1: User creates `projects/{name}/project-context.md`
   - Step 2: Interviewer writes `projects/{name}/project.spec.md`
   - Step 4: Generator writes to `generated/{name}/`
4. **User Guide** in `GENERATION-RULES/README.md` (enhanced How to Use section)

**Files to Update:**
| File | Change |
|------|--------|
| `WORKFLOW-GUIDE.md` | Add explicit `projects/{name}/` paths for Steps 1-3 |
| `GENERATION-RULES/README.md` | Add Quick Start with projects/ workflow |
| `master-generator.agent.md` | Reference `projects/{name}/project.spec.md` as input |
| `interviewer.agent.md` | Write spec to `projects/{name}/project.spec.md` |

**User Guide Content:**

1. **What This Framework Does** (2-3 sentences)
   - Generates `.github/` folder with agents, prompts, instructions, skills, memory-bank
   - From project idea → working agentic workflow

2. **Quick Start** (numbered steps)
   - Step 1: Copy `projects/_template/` to `projects/{your-project}/`
   - Step 2: Fill `project-context.md` with your project details
   - Step 3: Run `@interviewer` to generate spec
   - Step 4: Review and approve spec
   - Step 5: Run `@master-generator` to generate files
   - Step 6: Copy `generated/{project}/.github/` to your target project

3. **What Gets Generated** (folder structure)
   - agents/ — Core + domain-specific agents
   - prompts/ — Task-specific workflow starters
   - instructions/ — Auto-applied rules
   - skills/ — Portable instruction packages
   - memory-bank/ — Project state files

4. **Key Agents** (table)
   - @brain, @architect, @build, @inspect, @research
   - @interviewer, @master-generator
   - @interviewer, @master-generator

5. **Customization** (brief)
   - Edit spec before generation
   - Add domain-specific agents post-generation
   - Extend memory-bank as needed

**Acceptance Criteria:**
- [x] `projects/` folder exists with README.md ✅
- [x] `projects/_template/` contains starter `project-context.md` ✅
- [x] WORKFLOW-GUIDE.md references `projects/{name}/` for user input ✅
- [x] WORKFLOW-GUIDE.md references `generated/{name}/` for output ✅
- [x] GENERATION-RULES/README.md has clear Quick Start section ✅
- [x] Quick-start fits on one screen (~30 lines) ✅
- [x] No jargon — user can follow without reading all docs ✅
- [x] master-generator.agent.md updated with projects/ input path ✅
- [x] interviewer.agent.md updated with projects/ output path ✅

**Depends on:** Steps 5.1-5.6 complete ✅

**Status:** ✅ COMPLETE (2026-01-28)

---

### 5.8 End-to-End Testing ⏳ FINAL

**Goal:** Validate full 6-step pipeline per WORKFLOW-GUIDE.md.

**Test flow (maps to WORKFLOW-GUIDE.md steps):**
| Step | Agent | Input | Output | Validation |
|------|-------|-------|--------|------------|
| 1. CONTEXT | @user (+@brain) | User need | `project-context.md` | Has name, purpose, language, ≥1 component |
| 2. INTERVIEW | @interviewer | project-context.md | `project.spec.md` | No [NEEDS CLARIFICATION], all decisions explicit |
| 3. REVIEW | @user | project.spec.md | Approval or edits | User confirms before GENERATE |
| 4. GENERATE | @master-generator | Approved spec | `generated/{project}/` | Copy script runs + subagents spawn |
| 5. INSPECT | @inspect | Generated files | Inspection report | All checklists pass with rule IDs |
| 6. FEEDBACK | @user | Inspection report | Approval or changes | User accepts output |

**Handoff validation:**
| Handoff | Test |
|---------|------|
| CONTEXT → INTERVIEW | @interviewer can parse project-context.md |
| INTERVIEW → REVIEW | Spec summary presented to user |
| REVIEW → GENERATE | Spec path passed to @master-generator |
| GENERATE → INSPECT | File manifest passed to @inspect |
| INSPECT → FEEDBACK | Report presented to user |
| INSPECT → Re-GENERATE | Failure rule IDs passed back (max 3 iterations) |

**Test scenarios:**
1. **Happy path:** Full flow, all steps pass
2. **Spec revision:** User rejects at REVIEW, returns to INTERVIEW
3. **Generation failure:** Subagent error, master retries
4. **Inspection failure:** File fails checklist, triggers Re-GENERATE
5. **Iteration limit:** 3 Re-GENERATE failures, escalates to human

---

## Success Criteria

**GENERATION-RULES Deliverables:**
- [x] All 17 GENERATION-RULES deliverables complete
- [x] All 4 checkpoints pass

**Component Validation (rule IDs):**
- [ ] All agents pass `agent-checklist.md` GATE 1-5:
  - GATE 1: CHECK_S001-S004 (Structure & Naming)
  - GATE 2: CHECK_R001-R004 (Required Sections: safety, context_loading, boundaries)
  - GATE 3: CHECK_T001-T002 (Tool Configuration, handoffs `send: false`)
  - GATE 4: CHECK_C001-C004 (Size ≤25,000 chars, ≤300 lines, 3-10 step tasks)
  - GATE 5: CHECK_A001-A004 (Anti-Patterns)
- [ ] Naming per NAMING.md:
  - NAME_RULE_U001-U006 (Universal rules)
  - NAME_RULE_A001-A005 (Agent naming including reserved names)
  - NAME_RULE_F001-F006 (File naming)
  - NAME_RULE_D001-D003 (Directory structure)
- [ ] COMPONENT-MATRIX validation passed (DECISION_RULES flowchart)
- [ ] agent-patterns.md rules: RULE_001-005 (frontmatter, tools, handoffs, safety, context)
- [ ] orchestration-patterns.md rules: RULE_001-006 (hub-spoke, human gate, loop exit, output constraint, fast path, chain depth)

**Pipeline Agents:**
- [ ] 5 portable core agents in `_EXEMPLAR/agents/` (no project-specific paths)
- [ ] 3 new agents created: master-generator, generator, interviewer
- [ ] All new agents follow `agent-skeleton.md` template

**Project Structure Alignment (5.1):**
- [ ] `.github/skills/` folder exists
- [ ] `.github/instructions/` folder exists
- [ ] `safety.instructions.md` with P1 guardrails (IRON_001-003)
- [ ] This project's structure matches WORKFLOW-GUIDE OUTPUT_STRUCTURE

**Required Outputs:**
- [ ] `copilot-instructions.md` generated for each project
- [ ] `manifest.json` at `generated/{project}/manifest.json`

**Integration:**
- [x] copy-core-components.ps1 copies from `_EXEMPLAR/` to `generated/` ✅ (9 files, 4 folders)
- [ ] Generator suite produces working `.github/` folder
- [x] @inspect validates with rule ID reporting ✅ (Mode 4 with CHECK_* IDs)
- [x] Re-GENERATE loop works (max 3 iterations) ✅ (documented in Mode 4)
- [ ] End-to-end test: copied agents work in fresh project

**WORKFLOW-GUIDE Step Validation:**
- [ ] Step 1 (CONTEXT): project-context.md has name, purpose, language
- [ ] Step 2 (INTERVIEW): spec has no [NEEDS CLARIFICATION] markers
- [ ] Step 3 (REVIEW): User approval documented
- [x] Step 5 (INSPECT): All checklists run, rule IDs reported ✅ (Mode 4 added 2026-01-28)
- [ ] Step 6 (FEEDBACK): User accepts or requests changes

---

## Current State (2026-01-28)

**Completed:**
- GENERATION-RULES synthesized (30 files) ✅
- All 17 synthesis prompts in `.github/prompts/`
- Cookbook fully enriched with metadata
- Step 5.1: Project Structure Alignment ✅
- Step 5.2: Core Agent Updates ✅
- Step 5.3: Generator Suite ✅
- Step 5.4: Interviewer Agent ✅
- Step 5.5: Updated @inspect ✅ (Mode 4: Generated Output Validation)
- Step 5.6: copy-core-components.ps1 ✅ (9 files copied, JSON output)

**Ready:**
- @brain has Mode 8 (synthesis execution)
- Synthesis reference with hard rules

**Next action:** Step 5.7 (User Guide), then 5.8 (End-to-end testing)

---

## Rule ID Reference

Quick lookup for validation rule IDs used throughout this plan.

| Rule ID Pattern | Source File | Purpose |
|-----------------|-------------|---------|
| `CHECK_S001-S004` | agent-checklist.md | Structure & Naming (GATE 1) |
| `CHECK_R001-R004` | agent-checklist.md | Required Sections (GATE 2) |
| `CHECK_T001-T002` | agent-checklist.md | Tool Configuration (GATE 3) |
| `CHECK_C001-C004` | agent-checklist.md | Size & Complexity (GATE 4) |
| `NAME_RULE_U001-U006` | NAMING.md | Universal naming rules |
| `NAME_RULE_A001-A004` | NAMING.md | Agent-specific naming |
| `RULE_001-008` | agent-patterns.md | Authoring rules (frontmatter, tools, handoffs, safety) |
| `RULE_001-006` | orchestration-patterns.md | Hub-and-spoke, handoffs, loop exits |
| `DECISION_RULES` | COMPONENT-MATRIX.md | Component type selection flowchart |
| `STEP_1-6` | WORKFLOW-GUIDE.md | Generation pipeline steps |

---

## Reference

| Resource | Location |
|----------|----------|
| Synthesis Reference | `workshop/brainstorm/synthesis-reference.md` |
| Synthesis Prompts | `.github/prompts/01-*.prompt.md` |
| Checkpoint Prompts | `.github/prompts/checkpoint-*.prompt.md` |
| Cookbook Index | `cookbook/INDEX.yaml` |
| State Files | `workshop/synthesis-state/` |
| Discoveries Log | `workshop/brainstorm/synthesis-discoveries.md` |
| Portable Agents | `GENERATION-RULES/_EXEMPLAR/agents/` |
| Working Agents | `.github/agents/` |
