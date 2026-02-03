# D1: Instruction Consolidation Analysis

## Current State

**Files:**
- `copilot-instructions.md` — ~400 tokens, project context and references
- `prompting.instructions.md` — ~1,800 tokens, universal writing rules (applyTo: **)
- `artifact-style.instructions.md` — ~650 tokens, .github/ specific rules (applyTo: .github/**/*.md)

**Token cost per chat:** ~2,200 base (copilot + prompting via applyTo)

---

## Rule Inventory Summary

| Category | Universal Rules | Artifact-Specific Rules |
|----------|-----------------|------------------------|
| Language Rules | 3 | 5 |
| Formatting Rules | 7 | 12 |
| XML/Tag Rules | 11 | 0 |
| VS Code References | 10 | 0 |
| Behavioral Steering | 10 | 0 |
| Anti-Patterns | 9 | 0 |
| Content Requirements | 0 | 13 |
| **Total** | **~50** | **~30** |

---

## Critical Rules to Preserve

### Formatting (must survive consolidation)
- Markdown tables forbidden — convert to bullet lists
- No emojis — unprofessional and reduce clarity
- Starting with delimiters forbidden — first char must be letter
- No system parsing markers (---START/---END)

### Language Style (must survive consolidation)
- Use imperative verbs — "Include X" not "X should be included"
- Quantify guidance — "2-3 paragraphs" not "brief"
- One term per concept — no synonyms
- Positive framing — tell what TO do, not what NOT to do

### Anti-Patterns (must survive consolidation)
- Avoid overengineering — only make changes directly requested
- Implement general solutions, not test-passing code
- Clean up temporary files when done

---

## Redundancy Found

1. **Markdown tables** — duplicated in both files
2. **Passive voice / Imperative verbs** — conceptual overlap
3. **Vague quantifiers / Quantify guidance** — conceptual overlap
4. **File references** — guidance split across files

---

## Risk Analysis

| Risk | Likelihood | Impact | Priority |
|------|------------|--------|----------|
| Scope Loss (artifact rules apply universally) | H | H | **P1** |
| Layering Loss (inheritance semantics break) | H | H | **P1** |
| Token Bloat (80 rules load always) | H | M | **P2** |
| Conflicting Rules (domain mismatch) | M | M | **P2** |
| Update Fragility (single file changes risk) | M | L | **P3** |

---

## Models Evaluated

### Model A: Lean Bootstrap
- copilot-instructions.md: 5-10 critical rules only
- Keep instruction files for detail
- **Token cost:** 600 base
- **Risk:** Rule duplication, judgment calls on "critical"

### Model B: Tiered Consolidation (RECOMMENDED)
- copilot-instructions.md: Universal rules from prompting.instructions.md
- artifact-style stays separate (preserves applyTo targeting)
- Remove prompting.instructions.md
- **Token cost:** 2,000 base
- **Risk:** Larger base file

### Model C: Reference-Based
- copilot-instructions.md: Just #file: references
- **Token cost:** Variable (unreliable)
- **Risk:** References may not resolve

### Model D: Skill Migration
- Move ALL rules to a skill
- **Token cost:** 300 base + on-demand
- **Risk:** Rules not loaded for writing tasks

---

## Recommendation

**Model B: Tiered Consolidation**

**Rationale:**
1. Reliability over optimization — guarantees universal rules load
2. Preserves applyTo targeting — artifact-style keeps .github/ scope
3. Simplest maintenance — one fewer file, clear hierarchy
4. Matches user goals — critical rules in copilot-instructions.md

**Implementation steps:**
1. Move `<xml_usage>`, `<formatting>`, `<instruction_writing>`, `<behavioral_steering>`, `<anti_patterns>` sections from prompting.instructions.md into copilot-instructions.md
2. Remove prompting.instructions.md
3. Update cross-references in artifact-style.instructions.md

---

## Open Questions

1. Should `<research_tasks>`, `<subagent_orchestration>`, `<thinking_guidance>` sections move to copilot-instructions.md or become a skill?
2. How to handle artifact-style's reference to "see prompting.instructions.md" after removal?
3. Is 2,000 token base cost acceptable for this project?

---

## Iterations Completed: 3/4-5
- [x] D1.1: Rule extraction and inventory
- [x] D1.2: Pre-mortem risk analysis
- [x] D1.3: Alternative model exploration
- [ ] D1.4: Final structure proposal
