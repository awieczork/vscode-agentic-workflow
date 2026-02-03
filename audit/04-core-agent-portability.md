# D4: Core Agent Portability

## Agent Categorization

| Agent | Category | Portability | Notes |
|-------|----------|-------------|-------|
| architect | Core | 57% | Portable with fixes |
| brain | Core | 57% | Portable with fixes |
| build | Core | 57% | Portable with fixes |
| inspect | Core | 57% | Portable with fixes |
| interview | Project-Specific | 20% | Tied to artifact generation pipeline |

---

## What Makes Agents "Core"

**Confirmed portable characteristics:**
- No project-specific paths (all use optional memory-bank patterns)
- No dependencies on project-specific skills
- Self-documenting identity and boundaries
- Technology-agnostic implementation

**interview is NOT portable because:**
- References specific artifact types (agents, skills, prompts, instructions)
- Hardcoded paths for artifact generation
- Domain-specific questionnaire schema
- Tied to creator skills

---

## Portability Issues Discovered

### P1: Critical Issues (Must Fix)

| Issue | Likelihood | Impact | Mitigation |
|-------|------------|--------|------------|
| Handoff targets assumed | H | M | Add "if missing" fallback behavior |
| Tool availability (execute) | H | H | Add command-reporting fallback |
| copilot-instructions coupling | H | M | Add explicit fallback behavior |

### P2: Important Issues (Should Fix)

| Issue | Likelihood | Impact | Mitigation |
|-------|------------|--------|------------|
| Model-specific prompting (XML) | M | M | Document Claude 4.x optimization |
| Full ecosystem assumed | H | M | Document minimum viable agent set |
| Archive paths hardcoded | M | L | Check directory exists before write |

### P3: Minor Issues (Nice to Have)

| Issue | Likelihood | Impact | Mitigation |
|-------|------------|--------|------------|
| No standalone mode | M | L | Create instruction overlay |
| No portability self-test | L | L | Add checklist |

---

## Required Changes for True Portability

### 1. Add Tool Availability Fallbacks

```markdown
**On missing tools:** 
- If `execute` unavailable: Report commands to run instead of executing
- If `web` unavailable: Ask user to provide research manually
- If `agent` unavailable: Provide handoff context inline
```

### 2. Make Handoffs Conditional

```markdown
**On handoff target missing:** 
If referenced agent doesn't exist, provide handoff context inline 
and instruct user to manually invoke or continue.
```

### 3. Add copilot-instructions Fallback

```markdown
**On missing/incompatible copilot-instructions.md:** 
Operate without project context. Ask user for project-specific 
constraints if needed for current task.
```

---

## Portable Agent Pack Structure

```
core-agents/
├── README.md              # Installation guide
├── CHANGELOG.md           # Version history  
├── agents/
│   ├── architect.agent.md
│   ├── brain.agent.md
│   ├── build.agent.md
│   └── inspect.agent.md
├── docs/
│   ├── agent-reference.md     # What each does
│   └── customization.md       # Extension patterns
└── examples/
    └── project-overlay.md     # Sample customization
```

---

## Customization Patterns

### Recommended Approach: Instruction Overlays

| Scenario | Solution | File to Create |
|----------|----------|----------------|
| Add quality checks to @inspect | Instruction overlay | `instructions/inspect.project.instructions.md` |
| Add domain knowledge to @brain | copilot-instructions.md | Global rules section |
| Add build scripts to @build | Instruction overlay | `instructions/build.project.instructions.md` |
| Add planning constraints to @architect | Instruction overlay | `instructions/architect.project.instructions.md` |

### Overlay File Template

```markdown
---
applyTo: "**"
---

# Project Customization for @[agent]

<project_context>
[Domain-specific rules this agent should follow]
</project_context>
```

### Anti-Patterns to Avoid

- **Forking agents** — Loses upstream updates
- **Overloading copilot-instructions.md** — Causes bloat on every chat
- **Duplicating rules** — Put shared rules in one place
- **Creating agents for minor tweaks** — Use overlays instead

---

## Portability Score Breakdown

| Category | Weight | Score | Notes |
|----------|--------|-------|-------|
| No absolute paths | 10% | 100% | ✓ Clean |
| Tool availability handled | 20% | 40% | Needs fallbacks |
| Handoff dependencies | 20% | 20% | Needs conditionals |
| Memory-bank fallback | 15% | 90% | ✓ Well-designed |
| copilot-instructions flexibility | 15% | 50% | Needs explicit handling |
| Model agnosticism | 10% | 60% | Claude 4.x optimized |
| File structure tolerance | 10% | 80% | ✓ Graceful |
| **TOTAL** | | **57%** | |

**Original claim: 95% → Revised: 57%**

---

## Open Questions

1. Should core-agents/ live in this repo or separate repo?
2. Is 57% portability acceptable, or must we reach higher before release?
3. How to handle interview agent? Keep project-specific or abstract?
4. Should we create model-agnostic variants?

---

## Iterations Completed: 4/4-5
- [x] D4.1: Core vs project-specific categorization
- [x] D4.2: Portable agent pack structure
- [x] D4.3: Adversary analysis on portability claims
- [x] D4.4: Customization patterns
