# D3: Generator Folder Architecture

## Current State

```
generator/
├── architecture.md    # Workspace structure, artifact types (STALE)
├── generator.md       # Generation pipeline docs (MIXED: implemented + planned)
└── user-manual.md     # Interview usage guide (GOOD)
```

---

## Analysis Summary

### architecture.md Assessment

**Valuable content:**
- Artifact types table (Instruction, Skill, Prompt, Agent)
- Decision order: Instruction → Skill → Prompt → Agent
- File responsibilities

**Stale content (80% of file):**
- knowledge-base/ references (folder archived)
- Folder structure diagram (includes deleted folders)
- Knowledge-Base Organization section (entire section obsolete)
- Cross-references to deleted xml-tags.md

**Recommendation:** MERGE valuable content into copilot-instructions.md, then DELETE

### generator.md Assessment

**Implemented content (keep):**
- Overview (3 sentences)
- Three-Agent Architecture table
- Generation Flow (7 steps)

**Duplicated content (remove):**
- Questionnaire Format (exists in interview.prompt.md)
- Reference Processing (exists in interview.agent.md)
- Interview Agent section (IS interview.agent.md)

**Planned content (defer):**
- Master Agent spec
- Creator Agent spec

**Recommendation:** SLIM DOWN to ~40 lines (orchestration overview only)

### user-manual.md Assessment

**Status:** GOOD — comprehensive end-user guide
**Recommendation:** KEEP unchanged

---

## Final Proposed Structure

```
generator/
├── README.md           # Orientation (NEW)
└── user-manual.md      # User guide (KEEP)
```

### Files Removed
- architecture.md — Content merged to copilot-instructions.md
- generator.md — Slimmed content merged to README.md

---

## File Responsibility Matrix

| File | Purpose | Audience | Lines |
|------|---------|----------|-------|
| README.md | Quick orientation, entry points, architecture overview | Anyone discovering folder | ~60 |
| user-manual.md | Complete /interview usage guide | End users | ~200 |

---

## generator/ Purpose Statement

> Documentation folder for the VS Code agentic framework generator. Contains user guides and orientation material. Runtime artifacts (agents, prompts, skills) live in `.github/`.

**What generator/ IS:**
- Documentation about the generation system
- User guides for the /interview workflow
- Orientation material for new users

**What generator/ is NOT:**
- Runtime artifacts (those go in .github/)
- Agent specifications (those go in .github/agents/)
- Skills (those go in .github/skills/)

---

## Relationship to .github/

```
.github/                           generator/
─────────                          ──────────
agents/interview.agent.md    ←──   README.md (links to)
prompts/interview.prompt.md  ←──   README.md (entry point)
                             ←──   user-manual.md (explains usage)
skills/*-creator/                  (no direct link, internal)
```

---

## Migration Steps

1. **Extract** artifact selection rules from architecture.md → copilot-instructions.md
2. **Extract** Three-Agent overview from generator.md → new README.md
3. **Create** generator/README.md with:
   - Purpose statement
   - Quick start (run /interview)
   - Architecture overview (3-agent diagram)
   - Links to actual artifacts
4. **Delete** architecture.md
5. **Delete** generator.md
6. **Update** cross-references in .github/ files

---

## Future State

When Master/Creator agents are implemented:
- Specs move INTO agent files (master.agent.md, creator.agent.md)
- README.md updated to reference new agents
- NO placeholder files created before implementation

---

## Open Questions

1. Should slimmed generator.md content become README.md or remain separate?
2. Is there value in keeping generator.md as historical reference?
3. When Master/Creator are built, should pipeline-spec.md be created?

---

## Iterations Completed: 4/4-5
- [x] D3.1: Generator folder purpose definition
- [x] D3.2: Architecture.md fate analysis
- [x] D3.3: Generator.md fate analysis
- [x] D3.4: Final structure proposal
