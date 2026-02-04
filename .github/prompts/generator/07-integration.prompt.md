---
name: 'generator-phase-07'
agent: build
description: "Validate end-to-end pipeline and update documentation to reflect implemented state"
---

# Phase 7: Integration & Polish

<context>

## Context

End-to-end pipeline validation and documentation. This phase tests the complete Interview → Master → Creator flow, fixes integration issues, updates documentation to reflect implemented state, and closes audit risks.

</context>

<prerequisites>

## Prerequisites

Phase 6 (Creator Agent) must be complete:
- [ ] creator.agent.md exists with skill loading and validation
- [ ] master.agent.md exists with spawn loop
- [ ] All creator skills exist (agent, instruction, prompt, skill)

</prerequisites>

<orchestration_rules>

## Orchestration Rules

- Spawn @build subagent per task group
- Report brief bullets after each group completes
- SOFT gate between groups (testing may require iteration)
- On failure: pause, report which task failed, wait for user decision (retry/skip/rollback)

</orchestration_rules>

<task_groups>

## Task Groups

### Group 1: End-to-End Testing

**Tasks:**

**P7.1: End-to-end test**

**Test scenario:** Generate a minimal framework for a test project

1. **Setup**
   - Create test project context (simple TypeScript project)
   - Prepare sample questionnaire responses

2. **Run Interview**
   - Execute `/interview` or invoke @interview
   - Provide test responses:
     - Project: "test-project"
     - Type: TypeScript library
     - Request: 1 instruction (typescript-standards), 1 agent (code-review)
   - Capture InterviewHandoff output

3. **Run Master**
   - Invoke @master with Interview output
   - Verify: Manifest parsed correctly
   - Verify: Artifacts ordered (instruction before agent)
   - Verify: Checkpoint file created

4. **Observe Creator spawns**
   - Master spawns @creator for typescript-standards instruction
   - Verify: Creator loads instruction-creator skill
   - Verify: Creator returns CreatorResult
   - Master writes artifact

5. **Observe second artifact**
   - Master spawns @creator for code-review agent
   - Verify: Creator loads agent-creator skill
   - Verify: Creator returns CreatorResult
   - Master writes artifact

6. **Verify outputs**
   - [ ] `./generator/outputs/test-project/.github/instructions/typescript-standards.instructions.md` exists
   - [ ] `./generator/outputs/test-project/.github/agents/code-review.agent.md` exists
   - [ ] `./generator/outputs/test-project/.generator-state.yaml` shows completed status
   - [ ] Both artifacts have valid structure

**P7.2: Fix integration issues**

**Common issues to watch for:**

- **Payload format mismatch:** Master sends format Creator doesn't expect
  - Fix: Align YAML schemas between agents
  
- **Skill loading failure:** Creator can't find or parse skill
  - Fix: Verify skill paths, add error messages
  
- **Timeout:** Creator takes too long on complex artifacts
  - Fix: Add timeout handling in Master
  
- **Checkpoint not updating:** State file stale after operations
  - Fix: Ensure write triggers fire correctly
  
- **Error propagation:** Creator failure not properly reported to Master
  - Fix: Ensure CreatorResult.status flows back

**After each fix:** Re-run relevant portion of end-to-end test

**Files affected:**
- [.github/agents/master.agent.md](../../agents/master.agent.md) — Potential fixes
- [.github/agents/creator.agent.md](../../agents/creator.agent.md) — Potential fixes
- Test output files in `./generator/outputs/test-project/`

---

### Group 2: Documentation Updates

**Tasks:**

**P7.3: Update generator.md**

File: [generator/generator.md](../../../generator/generator.md)

Updates:
- [ ] Change Master status: "Planned" → "Implemented"
- [ ] Change Creator status: "Planned" → "Implemented"
- [ ] Add links to agent files:
  - `[Master Agent](../.github/agents/master.agent.md)`
  - `[Creator Agent](../.github/agents/creator.agent.md)`
- [ ] Update Resources table with new files
- [ ] Remove any "TODO" or "Planned" markers for implemented features

**P7.4: Create CONTRIBUTING.md**

Location: [CONTRIBUTING.md](../../../CONTRIBUTING.md) (workspace root)

Content:
```markdown
# Contributing to VS Code Agentic Workflow

## Development Setup

1. Clone the repository
2. Open in VS Code with GitHub Copilot extensions
3. Review `.github/copilot-instructions.md` for project context

## Code Structure

```
.github/
├── agents/           # Agent definitions
├── skills/           # Reusable procedures
├── prompts/          # Task templates
├── instructions/     # File-pattern rules
└── copilot-instructions.md  # Global context

generator/
├── generator.md      # Pipeline overview
├── user-manual.md    # End-user guide
└── outputs/          # Generated frameworks
```

## How to Add Artifact Types

1. Create creator skill in `.github/skills/{type}-creator/`
2. Follow existing skill structure (SKILL.md, references/, assets/)
3. Update Creator agent skill loading to recognize new type
4. Add validation checklist for new type
5. Test with end-to-end flow

## Testing Approach

- **Unit testing:** Verify individual skills load and parse correctly
- **Integration testing:** Run `/interview` → Master → Creator flow
- **Output validation:** Check generated artifacts against validation checklists

## Pull Request Process

1. Create feature branch from `main`
2. Make changes following existing patterns
3. Test with end-to-end flow if modifying pipeline
4. Update documentation if adding features
5. Submit PR with clear description

## Code Style

- Follow patterns in existing agent/skill files
- Use XML tags for structured sections in agents
- Keep artifacts self-contained where possible
- Document all inferences and decisions
```

**P7.5: Final documentation review**

**Check all documentation for accuracy:**

- [ ] [README.md](../../../README.md) quick-start steps work
- [ ] All cross-references in `generator/` are valid links
- [ ] No "Planned" status for implemented features
- [ ] Terminology consistent throughout (in-progress, lowercase status)
- [ ] [copilot-instructions.md](../../copilot-instructions.md) reflects current structure
- [ ] Creator skills reference correct paths

**Fix any issues found during review.**

**Files affected:**
- [generator/generator.md](../../../generator/generator.md) — Update status and links
- [CONTRIBUTING.md](../../../CONTRIBUTING.md) — Create new file
- Any files with documentation issues found in review

---

### Group 3: Risk Closure

**Tasks:**

**P7.6: Close audit risks**

Review [audit/09-risk-registry.md](../../../audit/09-risk-registry.md) and verify P1 risks resolved:

**R004: Stale architecture documentation**
- [ ] Verify: `architecture.md` deleted (Phase 3)
- [ ] Verify: `generator.md` is current
- [ ] Status: Close if verified

**R008: Skill format coupling**
- [ ] Verify: Skill format documented in creator.agent.md
- [ ] Verify: Known limitation noted in core-agents/README.md
- [ ] Status: Close as "documented limitation"

**R009: No README.md**
- [ ] Verify: `README.md` exists at workspace root (Phase 1)
- [ ] Verify: Contains quick-start and overview
- [ ] Status: Close if verified

**R018: Format brittleness (markdown tables)**
- [ ] Verify: YAML used for structured data exchange
- [ ] Verify: InterviewHandoff, CreatorPayload, CreatorResult all YAML
- [ ] Status: Close if verified

**R019: State management gap**
- [ ] Verify: `.generator-state.yaml` checkpoint implemented (Phase 5)
- [ ] Verify: Resume logic documented in master.agent.md
- [ ] Status: Close if verified

**Update risk registry:** Mark closed risks with resolution date and verification notes.

**Files affected:**
- [audit/09-risk-registry.md](../../../audit/09-risk-registry.md) — Update risk statuses

</task_groups>

<success_criteria>

## Success Criteria

- [ ] End-to-end test passes (Interview → Master → Creator → artifacts)
- [ ] All integration issues from P7.1 resolved
- [ ] `generator.md` shows Master and Creator as "Implemented"
- [ ] `CONTRIBUTING.md` exists with development guide
- [ ] All documentation accurate (no stale references, correct status)
- [ ] P1 risks (R004, R008, R009, R018, R019) closed in registry

</success_criteria>

<rollback_notes>

## Rollback Notes

**Group 1:** Delete test output files in `./generator/outputs/test-project/`
**Group 2:** Revert documentation changes via git
**Group 3:** Revert risk registry updates via git

Test artifacts can be deleted without impact. Documentation changes are additive and revertible.

</rollback_notes>

<completion_checklist>

## Completion Checklist

When Phase 7 completes, the framework is ready for use:

- [ ] `/interview` → full artifact generation works
- [ ] Core agents portable (with documented limitations)
- [ ] Generator pipeline documented accurately
- [ ] New contributors can follow CONTRIBUTING.md
- [ ] No open P1 risks

**Handoff:** Framework complete. Return to user for acceptance testing.

</completion_checklist>
