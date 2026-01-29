---
type: index
version: 1.0.0
purpose: Entry point and navigation index for the GENERATION-RULES framework
applies-to: [generator, build, inspect, architect, brain, user]
last-updated: 2026-01-28
---

# GENERATION-RULES

> **The prescriptive framework for building VS Code Copilot agents, skills, prompts, and memory systems**

---

## USER QUICK START

> **From project idea → working `.github/` folder in 6 steps**

1. **Copy template:** `projects/_template/` → `projects/{your-project}/`
2. **Fill context:** Edit `project-context.md` with your project details
3. **Run interview:** Invoke `@interviewer` to generate complete spec
4. **Review spec:** Check `project.spec.md` — confirm or request changes
5. **Generate:** Invoke `@master-generator` with spec path
6. **Deploy:** Copy `generated/{project}/.github/` to your target project

**Folder structure:**
```
projects/{name}/          ← Your INPUT (context, spec)
generated/{name}/         ← Agent OUTPUT (ready to copy)
```

See [WORKFLOW-GUIDE.md](WORKFLOW-GUIDE.md) for detailed workflow.

---

## HOW TO USE THIS FILE

**For Users (New to Framework):**
1. Copy [projects/_template/](../projects/_template/) to `projects/{your-project-name}/`
2. Fill out `project-context.md` with your project details
3. Run `@interviewer` to generate complete spec
4. See [WORKFLOW-GUIDE.md](WORKFLOW-GUIDE.md) for full workflow

**For Generator Agents:**
1. Load this README to understand file locations
2. Run [pre-generation-checklist.md](CHECKLISTS/pre-generation-checklist.md) FIRST
3. Use FILE INDEX below to locate patterns, templates, checklists

**For Build Agents:**
1. Use pattern files for authoring rules
2. Use skeleton files as copy-paste starting points
3. Validate against checklists before delivering

**For Inspect Agents:**
1. Use checklist files for validation
2. Cross-reference against pattern files for rule source
3. Report violations with rule IDs

---

## QUICK START

```
┌─────────────────────────────────────────────────────────────────┐
│  1. WHAT ARE YOU BUILDING?                                      │
│     → Read COMPONENT-MATRIX.md to select component type         │
├─────────────────────────────────────────────────────────────────┤
│  2. HOW DO YOU BUILD IT?                                        │
│     → Read PATTERNS/{component}-patterns.md for rules           │
│     → Copy TEMPLATES/{component}-skeleton.md as starting point  │
├─────────────────────────────────────────────────────────────────┤
│  3. IS IT CORRECT?                                              │
│     → Run CHECKLISTS/{component}-checklist.md to verify         │
│     → Run CHECKLISTS/general-quality-checklist.md as final gate │
└─────────────────────────────────────────────────────────────────┘
```

---

## FILE INDEX

### Root Level — Cross-Cutting Rules

| File | Type | Purpose | Read When |
|------|------|---------|-----------|
| [COMPONENT-MATRIX.md](COMPONENT-MATRIX.md) | decision-matrix | Choose Agent vs Skill vs Instruction vs Prompt | Deciding which component type to create |
| [RULES.md](RULES.md) | rules | Universal MUST/NEVER constraints | Before generating ANY component |
| [NAMING.md](NAMING.md) | rules | File, folder, and identifier naming conventions | Creating or validating names |
| [SETTINGS.md](SETTINGS.md) | configuration | VS Code and Copilot settings | Setting up new projects |
| [OUTPUT-FORMAT-SPEC.md](OUTPUT-FORMAT-SPEC.md) | specification | Format specification for GENERATION-RULES files | Format questions or disputes |
| [WORKFLOW-GUIDE.md](WORKFLOW-GUIDE.md) | workflow | The generation workflow: Context → Interview → Review → Generate → Inspect → Feedback | Understanding the overall process |

### PATTERNS/ — How to Build Each Component

| File | Type | Purpose | Read When |
|------|------|---------|-----------|
| [agent-patterns.md](PATTERNS/agent-patterns.md) | patterns | Rules for building `.agent.md` files | Creating or modifying agents |
| [skill-patterns.md](PATTERNS/skill-patterns.md) | patterns | Rules for building skill definitions | Creating portable capabilities |
| [instruction-patterns.md](PATTERNS/instruction-patterns.md) | patterns | Rules for instruction files | Creating global or targeted rules |
| [prompt-patterns.md](PATTERNS/prompt-patterns.md) | patterns | Rules for `.prompt.md` files | Creating reusable workflows |
| [memory-patterns.md](PATTERNS/memory-patterns.md) | patterns | Rules for memory bank structure | Implementing session continuity |
| [mcp-patterns.md](PATTERNS/mcp-patterns.md) | patterns | Rules for MCP server configuration | Adding external tool access |
| [orchestration-patterns.md](PATTERNS/orchestration-patterns.md) | patterns | Rules for multi-agent coordination | Building agent handoffs/workflows |
| [quality-patterns.md](PATTERNS/quality-patterns.md) | patterns | Rules for verification and safety | Embedding quality controls |
| [checkpoint-patterns.md](PATTERNS/checkpoint-patterns.md) | patterns | Rules for approval gates | Implementing human-in-the-loop |

### TEMPLATES/ — Copy-Paste Starting Points

| File | Type | Purpose | Read When |
|------|------|---------|-----------|
| [project-context-template.md](TEMPLATES/project-context-template.md) | template | User entry point for project context | **Users start here** |
| [agent-skeleton.md](TEMPLATES/agent-skeleton.md) | template | Minimal agent file structure | Starting a new agent |
| [skill-skeleton.md](TEMPLATES/skill-skeleton.md) | template | Minimal skill file structure | Starting a new skill |
| [instruction-skeleton.md](TEMPLATES/instruction-skeleton.md) | template | Minimal instruction file structure | Starting instruction files |
| [prompt-skeleton.md](TEMPLATES/prompt-skeleton.md) | template | Minimal prompt file structure | Starting a new prompt |
| [memory-skeleton.md](TEMPLATES/memory-skeleton.md) | template | Memory bank directory structure | Initializing memory bank |

### CHECKLISTS/ — Validation Gates

| File | Type | Purpose | Read When |
|------|------|---------|-----------|
| [pre-generation-checklist.md](CHECKLISTS/pre-generation-checklist.md) | checklist | Validate inputs before starting | **Run FIRST** — blocking gate |
| [agent-checklist.md](CHECKLISTS/agent-checklist.md) | checklist | Validate agent files | After creating/modifying agents |
| [skill-checklist.md](CHECKLISTS/skill-checklist.md) | checklist | Validate skill files | After creating/modifying skills |
| [instruction-checklist.md](CHECKLISTS/instruction-checklist.md) | checklist | Validate instruction files | After creating/modifying instructions |
| [prompt-checklist.md](CHECKLISTS/prompt-checklist.md) | checklist | Validate prompt files | After creating/modifying prompts |
| [memory-checklist.md](CHECKLISTS/memory-checklist.md) | checklist | Validate memory bank | After creating/updating memory |
| [security-checklist.md](CHECKLISTS/security-checklist.md) | checklist | Validate security constraints | For components with edit/execute tools |
| [general-quality-checklist.md](CHECKLISTS/general-quality-checklist.md) | checklist | Final quality gate | **Run LAST** — before delivery |

---

## NAVIGATION BY TASK

### "I need to create an agent"

1. [COMPONENT-MATRIX.md](COMPONENT-MATRIX.md) — Confirm agent is the right choice
2. [PATTERNS/agent-patterns.md](PATTERNS/agent-patterns.md) — Learn the rules
3. [TEMPLATES/agent-skeleton.md](TEMPLATES/agent-skeleton.md) — Copy starting point
4. [CHECKLISTS/agent-checklist.md](CHECKLISTS/agent-checklist.md) — Validate result

### "I need to create a skill"

1. [COMPONENT-MATRIX.md](COMPONENT-MATRIX.md) — Confirm skill is the right choice
2. [PATTERNS/skill-patterns.md](PATTERNS/skill-patterns.md) — Learn the rules
3. [TEMPLATES/skill-skeleton.md](TEMPLATES/skill-skeleton.md) — Copy starting point
4. [CHECKLISTS/skill-checklist.md](CHECKLISTS/skill-checklist.md) — Validate result

### "I need to set up memory persistence"

1. [PATTERNS/memory-patterns.md](PATTERNS/memory-patterns.md) — Learn the structure
2. [TEMPLATES/memory-skeleton.md](TEMPLATES/memory-skeleton.md) — Copy directory structure
3. [CHECKLISTS/memory-checklist.md](CHECKLISTS/memory-checklist.md) — Validate setup

### "I need to understand the whole workflow"

1. [WORKFLOW-GUIDE.md](WORKFLOW-GUIDE.md) — The complete workflow
2. [RULES.md](RULES.md) — Constraints that apply everywhere
3. [SETTINGS.md](SETTINGS.md) — Configure VS Code properly

---

## COMPONENT QUICK REFERENCE

| Component | When to Use | Pattern File |
|-----------|-------------|--------------|
| **Agent** | Named persona with specific role, tools, handoffs | [agent-patterns.md](PATTERNS/agent-patterns.md) |
| **Skill** | Portable capability, reusable across agents | [skill-patterns.md](PATTERNS/skill-patterns.md) |
| **Instruction** | Project-wide or file-targeted rules | [instruction-patterns.md](PATTERNS/instruction-patterns.md) |
| **Prompt** | Reusable workflow, slash-command | [prompt-patterns.md](PATTERNS/prompt-patterns.md) |
| **Memory** | Session continuity, persistent state | [memory-patterns.md](PATTERNS/memory-patterns.md) |

> For detailed selection logic, see [COMPONENT-MATRIX.md](COMPONENT-MATRIX.md)

---

## FILE COUNT

| Category | Count |
|----------|-------|
| Root Level | 7 |
| PATTERNS/ | 9 |
| TEMPLATES/ | 6 |
| CHECKLISTS/ | 8 |
| **Total** | **30** |

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| [WORKFLOW-GUIDE.md](WORKFLOW-GUIDE.md) | The process that uses all these files |
| [OUTPUT-FORMAT-SPEC.md](OUTPUT-FORMAT-SPEC.md) | Format authority for this file |

---

## SOURCES

- [cookbook/](../cookbook/) — Source patterns synthesized into this framework
- [synthesis-reference.md](../workshop/brainstorm/synthesis-reference.md) — Synthesis methodology
- [spec-driven.md](../cookbook/WORKFLOWS/spec-driven.md) — Workflow foundations
- [research-plan-implement.md](../cookbook/WORKFLOWS/research-plan-implement.md) — Phase structure
