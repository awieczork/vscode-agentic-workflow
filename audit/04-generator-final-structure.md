# D4: Generator Folder Final Structure

Final proposal for generator/ folder structure based on prior audit analysis.

---

## 1. Folder Purpose

### What generator/ IS

**Documentation hub for the VS Code framework generation system.**

Contains:
- User-facing guides (how to USE the system)
- Orientation material (what exists, where to start)
- Pipeline specifications (when future agents are built)

### What generator/ is NOT

- NOT runtime artifacts (agents, prompts, skills live in `.github/`)
- NOT templates (templates live inside skills)
- NOT workspace-level configuration (that's copilot-instructions.md)
- NOT architectural decisions (those belong in .github/ or root)

---

## 2. Final Structure

```
generator/
├── README.md           # Orientation and entry points
└── user-manual.md      # Full user guide for /interview
```

**Token budget:** ~1,500 tokens (down from ~2,500)

---

## 3. File Inventory

### README.md (NEW)

**Responsibility:** Quick orientation for generator/ folder

**Audience:** Anyone discovering the folder (users, developers, agents)

**Contains:**
- 2-sentence purpose statement
- Entry point: "Run /interview to start"
- What you get: project brief + artifact manifest
- Link to user-manual.md for full guide
- Link to .github/agents/interview.agent.md for implementation details

**Does NOT contain:**
- Full usage instructions (that's user-manual.md)
- Implementation details (that's agent files)
- Pipeline specs (deferred until Master/Creator exist)

### user-manual.md (KEEP)

**Responsibility:** Complete user guide for /interview workflow

**Audience:** End users running the interview

**Contains:**
- How to start
- Questionnaire field documentation
- Validation rules
- Examples
- What you receive (outputs)

**Does NOT contain:**
- Agent implementation details
- Pipeline architecture
- Future agent specs

---

## 4. File Disposition

| Current File | Action | Destination |
|--------------|--------|-------------|
| architecture.md | **MERGE then DELETE** | Artifact type table → copilot-instructions.md |
| generator.md | **SLIM then DELETE** | Three-agent overview → README.md mention only |
| user-manual.md | **KEEP** | No changes needed |

### Content Migration

**From architecture.md:**
- Artifact types table → copilot-instructions.md (new `<artifact_selection>` section)
- Decision order rule → copilot-instructions.md
- Folder structure → DELETE (implicit from actual structure)
- Knowledge-base references → DELETE (stale)

**From generator.md:**
- Three-agent table → README.md (as brief mention of planned architecture)
- Questionnaire format → DELETE (duplicated in user-manual.md)
- Agent responsibilities → DELETE (will live in agent files when created)
- Generation flow → DELETE (will live in Master agent when created)

---

## 5. Relationship to .github/

### Links TO generator/

| Source | Link | Purpose |
|--------|------|---------|
| .github/prompts/interview.prompt.md | → generator/user-manual.md | "See full guide" |
| .github/agents/interview.agent.md | → generator/user-manual.md | "User documentation" |

### Links FROM generator/

| Source | Link | Purpose |
|--------|------|---------|
| generator/README.md | → .github/prompts/interview.prompt.md | "Entry point" |
| generator/README.md | → .github/agents/interview.agent.md | "Implementation" |
| generator/user-manual.md | → .github/prompts/interview.prompt.md | "How to start" |

### Relationship Diagram

```
.github/ (RUNTIME)                    generator/ (DOCUMENTATION)
┌──────────────────────────┐          ┌────────────────────────┐
│                          │          │                        │
│  prompts/                │          │  README.md             │
│   └─ interview.prompt.md ◄──────────┤   Orientation          │
│       (entry point)      │          │   Entry points         │
│            │             │          │        │               │
│            │ links to    │          │        │ links to      │
│            ▼             │          │        ▼               │
│  agents/                 │          │  user-manual.md        │
│   └─ interview.agent.md ◄───────────┤   Full user guide      │
│       (implementation)   │          │                        │
│                          │          └────────────────────────┘
│  copilot-instructions.md │
│   (artifact selection)   │
│                          │
└──────────────────────────┘
```

---

## 6. Future State

### When Master/Creator Are Built

**New files:**

```
generator/
├── README.md               # Update with full pipeline overview
├── user-manual.md          # No changes
└── pipeline-spec.md        # NEW: Technical spec for 3-agent flow
```

**Alternative:** Pipeline spec could live in Master agent's context or a dedicated skill. Evaluate when implementing.

### Placeholder Files

**Do NOT create placeholders now.** Reasons:
- Speculative content goes stale quickly
- Actual implementation will inform structure
- Audit artifacts capture planning for reference

### Migration Triggers

Create pipeline-spec.md WHEN:
- Master agent file is created
- Creator agent file is created
- Pipeline spans multiple agents requiring coordination docs

---

## 7. Migration Steps

### Phase 1: Content Migration (Before Deletion)

1. Extract artifact selection rules from architecture.md:
   - Artifact types table
   - Decision order: Instruction → Skill → Prompt → Agent

2. Add to copilot-instructions.md as `<artifact_selection>` section

### Phase 2: Create README.md

Create generator/README.md with:

```markdown
# Generator

Documentation for the VS Code agentic framework generator. 
Run `/interview` to create a `.github/` framework for your project.

---

## Quick Start

1. Open VS Code chat
2. Type `/interview` and press Enter
3. Fill the XML questionnaire
4. Follow the agent's clarifying questions

**Full guide:** [user-manual.md](user-manual.md)

---

## What You Get

After completing the interview:
- **Project brief** — Synthesized requirements
- **Execution manifest** — Artifact recommendations with specs

The manifest feeds into `@architect` for planning or `@build` for generation.

---

## Architecture

| Agent | Role | Status |
|-------|------|--------|
| Interview | Clarify requirements, produce manifest | Implemented |
| Master | Validate decisions, orchestrate creation | Planned |
| Creator | Read skills, produce artifacts | Planned |

**Implementation:** [.github/agents/interview.agent.md](../.github/agents/interview.agent.md)

**Entry point:** [.github/prompts/interview.prompt.md](../.github/prompts/interview.prompt.md)
```

### Phase 3: Delete Obsolete Files

1. Delete generator/architecture.md
2. Delete generator/generator.md

### Phase 4: Update Cross-References

Check and update any files linking to deleted content:
- .github/copilot-instructions.md (has stale link to knowledge-base/)
- Any agent or skill files referencing generator/architecture.md

---

## 8. Validation Checklist

After migration:

- [ ] generator/ contains only README.md and user-manual.md
- [ ] README.md links to .github/prompts/interview.prompt.md
- [ ] README.md links to .github/agents/interview.agent.md
- [ ] user-manual.md links work correctly
- [ ] copilot-instructions.md contains artifact selection rules
- [ ] No broken links to deleted files
- [ ] Total token count < 2,000

---

## Summary

**Final structure:**
```
generator/
├── README.md           # Orientation (NEW)
└── user-manual.md      # User guide (KEEP)
```

**Deletions:**
- architecture.md (content migrated to copilot-instructions.md)
- generator.md (content deferred to agent files)

**Key principle:** generator/ documents HOW TO USE the system; .github/ contains WHAT RUNS in the system.
