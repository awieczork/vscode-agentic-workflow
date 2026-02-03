# D8: Onboarding Experience

## User Personas

### Persona 1: Generator User
**Goal:** Create a .github/ framework for their project

**Current journey gaps:**
- No README.md at workspace root
- No prerequisites documentation
- No end-to-end walkthrough
- Stale references to knowledge-base/

**Quick-start path:**
```
/interview → fill questionnaire → approve → artifacts generated
```

### Persona 2: Framework Developer
**Goal:** Modify or extend the generator itself

**Current journey gaps:**
- No CONTRIBUTING.md
- No guide for adding artifact types
- Stale architecture documentation
- Audit findings not tracked as action items

**Reading order:**
1. copilot-instructions.md (rules)
2. architecture.md (structure)
3. generator.md (pipeline)
4. skill folders (implementations)

---

## Prerequisites Defined

### Required

| Requirement | Version/Value |
|-------------|---------------|
| VS Code | ≥1.106 |
| GitHub Copilot extension | Latest |
| GitHub Copilot Chat extension | Latest |
| Setting: useInstructionFiles | true |
| Setting: useAgentSkills | true |

### Recommended

| Requirement | Notes |
|-------------|-------|
| Claude 4.x model | Prompting optimized for Claude |
| Execute tool | Enables test running, dependency install |
| Web tool | Enables @brain research mode |

### Environment Compatibility

| Environment | Status |
|-------------|--------|
| VS Code Desktop | ✅ Full support |
| GitHub Codespaces | ✅ Full support |
| VS Code Web | ⚠️ Partial (no terminal) |
| Remote SSH/WSL | ✅ Full support |

---

## Quick-Start Path

### For Generator Users

```markdown
## Quick Start

1. Open this workspace in VS Code
2. Ensure Copilot Chat is active (Ctrl+Alt+I / Cmd+Alt+I)
3. Type `/interview` and press Enter
4. Fill the XML questionnaire:
   - `<name>` — your-project-name
   - `<description>` — What it does
   - `<tech>` — Languages and frameworks
   - `<workflows>` — Tasks you repeat
5. Review recommendations and approve
6. Artifacts are generated in `.github/`
```

### For Framework Developers

```markdown
## Development Guide

### Understanding the Codebase
1. `.github/copilot-instructions.md` — Project rules
2. `generator/architecture.md` — Artifact types and structure
3. `generator/generator.md` — Pipeline overview
4. `.github/skills/*-creator/` — Creator implementations

### Adding New Artifact Types
1. Create `.github/skills/{type}-creator/SKILL.md`
2. Add `references/` for JIT-loaded guidance
3. Add `assets/` for templates
4. Register in interview agent for recommendations
```

---

## Documentation Gaps

### Critical (P1)

| Gap | Impact | Remediation |
|-----|--------|-------------|
| No README.md | Users can't discover entry point | Create README.md |
| Stale architecture.md | knowledge-base/ references mislead | Remove stale sections |
| Broken cross-references | 5 links point to missing files | Fix paths |

### High (P2)

| Gap | Impact | Remediation |
|-----|--------|-------------|
| No end-to-end walkthrough | Users unsure what happens after interview | Add to user-manual |
| No CONTRIBUTING.md | Developers have no onboarding | Create contributor guide |
| Prerequisites undocumented | Users may fail silently | Add to README |

### Medium (P3)

| Gap | Impact | Remediation |
|-----|--------|-------------|
| No FAQ | Users stuck on common issues | Add troubleshooting section |
| Master/Creator "Planned" status | Unclear what works | Update status markers |
| audit/ unprioritized | Tech debt accumulates | Create remediation tracking |

---

## Artifacts to Create

### README.md (Root)

**Content:**
- Title: VS Code Agentic Workflow Generator
- Tagline: Generate .github/ frameworks for VS Code Copilot customization
- Quick Start (5 steps)
- What You Get (artifact types)
- Prerequisites (summary)
- Documentation Links
- Current Status

**Length:** ~95 lines

### Prerequisites.md

**Content:**
- VS Code requirements
- Copilot requirements
- Tool availability
- Environment compatibility
- Troubleshooting

**Location:** generator/prerequisites.md or include in README

### CONTRIBUTING.md (Future)

**Content:**
- Development setup
- Code structure
- How to add artifact types
- Testing
- Pull request process

---

## Iterations Completed: 3/3-4
- [x] D8.1: User journey mapping
- [x] D8.2: Prerequisites definition
- [x] D8.3: Quick-start content draft
