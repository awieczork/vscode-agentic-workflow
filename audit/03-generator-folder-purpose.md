# D3: Generator Folder Purpose and Structure

## Current State

```
generator/
├── architecture.md    # Workspace structure, artifact type decisions
├── generator.md       # 3-agent pipeline documentation
└── user-manual.md     # Interview usage guide for end users
```

**Token totals:** ~2,500 tokens across 3 files

---

## Analysis

### What generator/ Currently Contains

- **architecture.md** — Workspace-level decisions (folder structure, artifact type selection)
- **generator.md** — Technical spec for 3-agent generation pipeline
- **user-manual.md** — User-facing guide for /interview prompt

### Audience Analysis

| File | Primary Audience | Content Type |
|------|------------------|--------------|
| architecture.md | AI agents, developers | Architecture decisions |
| generator.md | AI agents (planned agents) | Implementation spec |
| user-manual.md | End users | Usage guide |

### Relationship to .github/

```
.github/
├── agents/interview.agent.md    ← Runtime artifact (what Interview IS)
├── prompts/interview.prompt.md  ← User entry point (starts Interview)
└── skills/*-creator/            ← Creation procedures

generator/
├── generator.md                 ← System design (how Interview WORKS)
└── user-manual.md               ← Usage guide (how to USE Interview)
```

**Key distinction:**
- `.github/` = Runtime artifacts (agents, prompts, skills that execute)
- `generator/` = Documentation ABOUT the generation system

---

## Questions Answered

### 1. What is generator/ for?

**Purpose:** Documentation hub for the generation pipeline system.

- NOT runtime artifacts (those live in .github/)
- NOT templates (those live in skills)
- IS system documentation for understanding and maintaining the generator

**Audience:**
- End users (user-manual.md)
- Developers maintaining the generator (generator.md)
- AI agents needing workspace context (architecture.md)

### 2. Why separate from .github/?

**Separation rationale:**
- `.github/` files are VS Code Copilot artifacts with specific formats and behaviors
- `generator/` files are freeform documentation without VS Code-specific semantics
- Keeps runtime artifacts clean; documentation lives separately

**Alternative considered:** Move everything to .github/
- Problem: user-manual.md is not an agent, prompt, skill, or instruction
- Problem: architecture.md describes workspace structure, not a Copilot artifact
- Problem: Pollutes .github/ with non-executable documentation

### 3. What should generator/ contain?

**Should contain:**
- System architecture documentation
- User-facing guides for the generation workflow
- Pipeline specifications for planned components

**Should NOT contain:**
- Runtime artifacts (agents, prompts, skills)
- Templates for generated output (belong in skills)
- Configuration (belongs in .github/ artifacts)

### 4. File responsibilities (clarified)

| File | Responsibility | Does NOT Contain |
|------|----------------|------------------|
| architecture.md | Workspace structure, artifact type decisions, folder organization | Implementation details, user guides |
| generator.md | Technical specification for 3-agent pipeline, agent responsibilities | User-facing instructions, folder structure |
| user-manual.md | Step-by-step user guide for /interview | Technical specs, architecture decisions |

**Overlap found:** architecture.md duplicates folder structure that could be derived from .github/

### 5. Naming and structure

**Current name "generator/"** — Accurate but generic

**Alternatives considered:**
- `docs/` — Too generic, conflicts with common conventions
- `pipeline/` — Only describes one aspect
- `generator-docs/` — Redundant

**Recommendation:** Keep `generator/` — clear enough, short, matches content

---

## Identified Issues

### Issue 1: architecture.md is misplaced

**Problem:** architecture.md describes the ENTIRE workspace, not just generator.
- References knowledge-base/ (archived)
- Defines artifact type selection (belongs in copilot-instructions or a reference)
- Contains folder structure (should be authoritative source, not duplicated)

**Options:**
- A) Move to root as ARCHITECTURE.md
- B) Move relevant content into copilot-instructions.md
- C) Delete — content is scattered across other files anyway

### Issue 2: Stale content

**architecture.md contains:**
- `knowledge-base/` reference — folder no longer exists
- Folder structure showing `knowledge-base/` — stale
- `memory-bank/` reference — not implemented in current workspace

### Issue 3: Duplication with .github/

**generator.md duplicates:**
- Agent descriptions partially overlap with actual agent files
- Questionnaire format duplicated in interview.prompt.md and user-manual.md

---

## Recommendation

### Minimal Structure

```
generator/
├── README.md           # Purpose, entry points, quick start
└── user-manual.md      # Full user guide for /interview
```

### File Disposition

| Current File | Action | Rationale |
|--------------|--------|-----------|
| architecture.md | **DELETE** | Content is stale; artifact selection rules belong in copilot-instructions.md; folder structure is implicit |
| generator.md | **DELETE** | Planned agents not implemented; pipeline spec should live with actual agents when created |
| user-manual.md | **KEEP** | Necessary user guide, appropriate location |

### New File: generator/README.md

Purpose: Quick orientation for generator/ folder

Content:
- 2-sentence purpose statement
- Entry point: "Run /interview to start"
- Link to user-manual.md for full guide
- Link to .github/agents/interview.agent.md for implementation

---

## Relationship Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                     Workspace Structure                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ .github/  (Runtime Artifacts)                            │   │
│  │                                                          │   │
│  │  copilot-instructions.md ─────┐                         │   │
│  │                               │ references               │   │
│  │  agents/                      ▼                         │   │
│  │   └─ interview.agent.md ◄──── IS the Interview agent    │   │
│  │                                                          │   │
│  │  prompts/                                               │   │
│  │   └─ interview.prompt.md ──── STARTS the Interview      │   │
│  │                                                          │   │
│  │  skills/                                                │   │
│  │   └─ *-creator/ ─────────────┐                         │   │
│  │                               │ used by                  │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                   │                             │
│                                   ▼                             │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ generator/  (Documentation)                              │   │
│  │                                                          │   │
│  │  README.md ──────────────── Orientation, entry points    │   │
│  │                                                          │   │
│  │  user-manual.md ─────────── How to USE /interview        │   │
│  │       │                                                  │   │
│  │       └─ links to .github/prompts/interview.prompt.md    │   │
│  │                                                          │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ audit/  (Working Documents)                              │   │
│  │                                                          │   │
│  │  Decision logs, analysis, temporary artifacts            │   │
│  │                                                          │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Migration Checklist

- [ ] Extract artifact type decision rules from architecture.md → copilot-instructions.md (if not already present)
- [ ] Verify user-manual.md links are correct
- [ ] Create generator/README.md with orientation content
- [ ] Delete architecture.md
- [ ] Delete generator.md
- [ ] Update any cross-references in .github/ files

---

## Summary

**Purpose statement for generator/:**
> Documentation folder for the VS Code agentic framework generator. Contains user guides and orientation material. Runtime artifacts (agents, prompts, skills) live in `.github/`.

**Recommended structure:**
```
generator/
├── README.md           # Orientation and entry points
└── user-manual.md      # Full user guide for /interview
```

**Relationship to .github/:**
- generator/ documents HOW TO USE the system
- .github/ contains WHAT RUNS in the system
- No duplication — each serves distinct purpose
