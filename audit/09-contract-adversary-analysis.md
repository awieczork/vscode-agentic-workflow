# Contract Adversary Analysis

Critical evaluation of Interview → Master → Creator interface contracts.

---

## Risk Assessment Summary

**Overall Robustness Score: 6/10** — Contracts are well-designed for happy path but fragile under real-world conditions.

| Risk Category | Severity | Likelihood | Impact | Mitigation Status |
|---------------|----------|------------|--------|-------------------|
| Format brittleness | HIGH | HIGH | Cascading | Unmitigated |
| State management gaps | HIGH | MEDIUM | Session loss | Partial |
| Subagent reliability | MEDIUM | HIGH | Single artifact | Partial |
| Validation circular dependency | MEDIUM | MEDIUM | Ambiguous truth | Unmitigated |
| Skill evolution coupling | HIGH | HIGH | Breaking changes | Unmitigated |
| Error propagation | MEDIUM | MEDIUM | Cascade | Partial |

---

## 1. Format Brittleness

### Is This a Real Risk?

**YES — Critical risk.**

Contracts rely on:
- Markdown tables for Execution Manifest
- TypeScript-style interfaces as documentation (never actually parsed)
- Prose sections with expected headers
- Inline code blocks as "templates"

### Failure Modes

**Mode 1: Table Malformation**

Interview outputs Execution Manifest as Markdown table:
```
| Artifact | Type | Path | Skill | Tools | Constraints | Complexity |
|----------|------|------|-------|-------|-------------|------------|
| my-agent | agent | .github/agents/my-agent.agent.md | agent-creator | codebase, edit | C1, C2 | L1 |
```

What happens when:
- LLM adds extra column? → Parse fails
- LLM omits column? → Wrong field mapped
- LLM uses different column order? → Misinterpretation
- Table has alignment issues? → Rendering works, parsing ambiguous

**Mode 2: Prose Deviation**

Interview deviates from section order:
- Puts "Constraints" before "Key Workflows"
- Uses "## Tech Stack" instead of "## Technology Stack"
- Omits "## Approval" section entirely

Master cannot reliably find sections.

**Mode 3: Structured Data Rot**

TypeScript interfaces in contracts are **documentation only**:
```typescript
interface CreatorPayload {
  artifact: ArtifactSpec;
  context: CreatorContext;
  // ...
}
```

No actual serialization format defined. Is this YAML? JSON? Markdown prose?

When Master "sends payload" to Creator, the format is:
```markdown
Create artifact using skill.

**Artifact Specification:**
- Name: [name]
- Type: [type]
```

This is **prose with bullet points**, not a parseable structure.

### Mitigation Recommendations

1. **Define canonical serialization format** — Use YAML frontmatter blocks for structured data, not Markdown tables
2. **Add format examples with variations** — Show acceptable variations explicitly
3. **Implement graceful degradation** — If table parse fails, fall back to prose extraction
4. **Add format self-check** — Interview validates its own output format before handoff

**Proposed Amendment:**

```yaml
# Execution Manifest (YAML block, not table)
---
execution_manifest:
  - name: my-agent
    type: agent
    path: .github/agents/my-agent.agent.md
    skill: agent-creator
    tools: [codebase, edit]
    constraints: [C1, C2]
    complexity: L1
---
```

---

## 2. State Management Gaps

### Is This a Real Risk?

**YES — Session interruption is common.**

Contracts define `MasterState` with `Checkpoint`:
```typescript
interface Checkpoint {
  timestamp: Date;
  completedPaths: string[];
  pendingPaths: string[];
}
```

But state exists only conceptually. No actual persistence mechanism specified.

### Failure Modes

**Mode 1: Session Timeout**

User starts generation of 10 artifacts. At artifact 6:
- VS Code crashes
- LLM times out
- User closes window

Where is `MasterState`? **In-memory only.** 

Master contract claims "Resume capability" but doesn't specify:
- Where checkpoints are written
- Format of checkpoint files
- How Master detects prior state on restart

**Mode 2: Context Window Overflow**

Large manifest (20+ artifacts). By artifact 15:
- Conversation context exceeds limit
- Older context dropped
- Master loses track of earlier artifacts

No mechanism for context compression or state externalization.

**Mode 3: Partial Writes**

Master writes artifact, then crashes before checkpoint. On resume:
- File exists (write succeeded)
- No checkpoint (crash before update)
- Master sees file, assumes complete
- But was it validated? Unknown.

### Mitigation Recommendations

1. **Explicit checkpoint file format**
```yaml
# .github/generator-state.yaml
session_id: "2026-02-02-15-30-00"
manifest_hash: "sha256:abc123..."
artifacts:
  - path: .github/agents/my-agent.agent.md
    status: complete
    validation_hash: "sha256:def456..."
    written_at: "2026-02-02T15:32:00Z"
  - path: .github/skills/my-skill/SKILL.md
    status: in-progress
    attempt: 1
```

2. **Write checkpoint before artifact write** — Checkpoint includes "pending write to X"
3. **Add checkpoint commands to Master** — `!checkpoint`, `!status`, `!resume`
4. **Context summarization** — Periodically compress completed artifacts to summaries

**Proposed Amendment:**

Add to Master contract:
```markdown
### Checkpoint Persistence

Master writes `.github/.generator-state.yaml` after each artifact.

**Checkpoint timing:**
- BEFORE starting artifact: status = "in-progress"
- AFTER successful write + validation: status = "complete"
- ON failure: status = "failed", error recorded

**Resume detection:**
- On Master invocation, check for `.generator-state.yaml`
- If exists and session < 24h old: prompt user "Resume or restart?"
- If > 24h: prompt "Stale session found. Resume, restart, or clean?"
```

---

## 3. Subagent Reliability

### Is This a Real Risk?

**YES — Subagent failures are expected.**

Master spawns Creator as subagent. Subagent is a separate LLM invocation with:
- Its own context window
- Its own timeout potential
- No guaranteed completion

### Failure Modes

**Mode 1: Subagent Timeout**

Creator starts working on L2 agent with complex iron laws. Takes long time:
- Subagent times out mid-generation
- No partial result returned
- Master sees... nothing?

Contract doesn't define timeout handling.

**Mode 2: Malformed Return**

Creator returns:
```markdown
## Creator Result

**Status:** sucess  <!-- typo -->

### Artifact
- Path: .github/agents/my-agent.agent.md
- Length: [X] characters, [Y] lines  <!-- placeholders not filled -->
```

How does Master parse this? Contract defines expected format but no validation.

**Mode 3: Hallucinated Completion**

Creator returns `status: success` but:
- Content is actually truncated
- Validation report claims 25/25 passed (but was invented)
- Artifact has `<!-- TODO -->` markers

Master trusts Creator's self-report. No independent verification.

**Mode 4: Wrong Skill Execution**

Creator receives `skill: agent-creator` but:
- Loads wrong skill file
- Executes different skill
- Returns mismatched artifact

### Mitigation Recommendations

1. **Timeout with grace**
```markdown
Subagent timeout policy:
- Soft timeout: 60s → Send "Please complete within 30s"
- Hard timeout: 90s → Terminate, mark failed
- Return partial if any content received
```

2. **Structural validation of return**
```markdown
Master validates CreatorResult structure:
- [ ] "## Creator Result" header present
- [ ] Status is one of: success, partial, failed
- [ ] Artifact content block present
- [ ] Content length > 100 characters
- [ ] Path echoed matches expected path
```

3. **Independent spot-check**
```markdown
Master runs 3 random P1 checks on returned artifact:
- If all pass: trust Creator validation
- If any fail: mark partial, log discrepancy
```

4. **Skill verification**
```markdown
Creator echoes skill loaded in result:
- skillLoaded: "agent-creator"
- skillPath: ".github/skills/agent-creator/SKILL.md"

Master validates match.
```

**Proposed Amendment:**

Add to Master contract:
```markdown
### Creator Result Validation

Master does NOT blindly trust CreatorResult.

**Structural checks (always):**
1. Result message contains required sections
2. Status is valid enum value
3. Path matches expected path
4. Content is non-empty

**Spot-check validation (for status: success):**
1. Select 2 random P1 checks from skill's checklist
2. Execute independently on returned content
3. If any fail: downgrade to partial, add warning

**Timeout handling:**
- No response in 90s: mark failed, retry once
- Partial response: accept content, mark partial
```

---

## 4. Validation Circular Dependency

### Is This a Real Risk?

**YES — Source of truth is ambiguous.**

Validation hierarchy:
```
Skill checklist → Creator validates artifact
Creator report → Master validates Creator
Master decision → Final truth?
```

### Failure Modes

**Mode 1: Disagreement**

Creator validates using skill checklist: "23/25 passed, status: success"
Master spot-checks: 2 P1 failures found

Who is right?
- Creator had full context during generation
- Master is doing post-hoc check with less context
- Skill checklist was written for human usage, may be ambiguous

**Mode 2: Skill Checklist Inconsistency**

Different skills have different validation stringency:
- `agent-creator` has 25+ checks
- `prompt-creator` has 8 checks

An agent with 3 P2 failures = partial
A prompt with 3 P2 failures = ... the whole checklist?

Severity thresholds not normalized across skills.

**Mode 3: Checklist Version Drift**

Skill is updated, checklist gets new P1 check.
Existing artifacts in session were validated against old checklist.
New artifacts validated against new checklist.

Session has inconsistent validation baseline.

### Mitigation Recommendations

1. **Single source of truth: Master**
```markdown
Master is final arbiter.

- Creator validation: advisory
- Master spot-check: authoritative
- On disagreement: Master wins, log for review
```

2. **Normalized severity thresholds**
```markdown
All skills use same pass/fail threshold:
- P1 failures > 0: failed
- P2 failures > 3: partial
- P3: advisory only

Skill complexity doesn't change threshold.
```

3. **Checklist versioning**
```markdown
Each validation checklist has version:
---
version: 1.2.0
last_updated: 2026-02-01
---

Creator reports checklist version in result.
Master logs version for audit.
```

**Proposed Amendment:**

Add to contracts:
```markdown
### Validation Authority

**Hierarchy:**
1. Skill checklist — defines what to check
2. Creator — executes checks, reports results
3. Master — FINAL AUTHORITY, may override

**Override rules:**
- Master spot-check failure overrides Creator success
- Master cannot override "failed" to "success"
- All overrides logged with reason
```

---

## 5. Skill Evolution Coupling

### Is This a Real Risk?

**YES — Highest likelihood risk.**

Contracts assume current skill structure:
- 6-step process
- Specific reference files
- Specific validation checklist format

### Failure Modes

**Mode 1: Step Count Change**

Skill evolves from 6 steps to 8 steps:
- Creator contract expects 6
- Skill has 8
- `stepsExecuted: 6` is now wrong metric

**Mode 2: Reference Reorganization**

Skill moves from:
```
references/
├── decision-rules.md
├── structure-reference.md
└── validation-checklist.md
```

To:
```
references/
├── rules/
│   ├── tool-mapping.md
│   └── safety-requirements.md
├── structure.md
└── validation.md
```

Creator loading logic breaks.

**Mode 3: Checklist Format Change**

Checklist changes from:
```markdown
- [ ] `name` field present
```

To:
```markdown
| Check | Priority | Pass Criteria |
|-------|----------|---------------|
| name field | P1 | Field present, matches filename |
```

Creator parsing breaks.

**Mode 4: New Skill Type**

New artifact type: "workflow"
- Needs `workflow-creator` skill
- Contracts only list 4 types
- Master rejects "workflow" as invalid type

### Mitigation Recommendations

1. **Skill interface contract**
```markdown
All skills must implement:

Required files:
- SKILL.md (main file)
- references/validation-checklist.md

Required sections in SKILL.md:
- ## Process (may have N steps)
- ## Validation (summary)

Required checklist format:
- Sections: P1, P2, P3 (in order)
- Item format: `- [ ] [check description]`
```

2. **Version compatibility**
```markdown
Skill declares compatibility:
---
interface_version: 1.0
---

Creator refuses skill if interface_version > supported.
```

3. **Extensible type enum**
```markdown
ArtifactType is open enum:
- Known: agent, skill, prompt, instruction
- Unknown: valid if skill exists

Master accepts unknown type if `.github/skills/[type]-creator/` exists.
```

**Proposed Amendment:**

Add new section to contracts:
```markdown
### Skill Interface Requirements

For Creator compatibility, skills must:

**File structure:**
- `SKILL.md` at root
- `references/validation-checklist.md` (exact path)

**SKILL.md requirements:**
- Frontmatter with `name`, `description`
- `## Process` section (steps numbered, any count)
- Step format: `### Step N: [Name]`

**Validation checklist requirements:**
- Markdown format with `- [ ]` items
- Sections headed `## P1`, `## P2`, `## P3`
- Items are self-contained (no external dependencies)

**Compatibility declaration:**
Skills may declare interface version in frontmatter.
Absence means version 1.0.
```

---

## 6. Error Propagation

### Is This a Real Risk?

**YES — Errors compound across layers.**

Three-layer pipeline: Interview → Master → Creator
Each layer can fail independently or dependently.

### Failure Modes

**Mode 1: Silent Corruption**

Interview extracts constraints incorrectly:
- User said "never delete production data"
- Interview records: "handle production data carefully"

Constraint loses force. Propagates to:
- Master (doesn't know original intent)
- Creator (embeds weak constraint)
- Final artifact (insufficient safety)

No validation catches semantic loss.

**Mode 2: Cascading Dependencies**

Manifest:
```
1. base-skill (L0)
2. helper-skill (L0, depends on base-skill patterns)
3. main-agent (L1, uses both skills)
```

base-skill fails. Helper-skill creates anyway with:
- Missing context from base-skill
- Guessed patterns

main-agent creates with:
- Broken helper-skill reference
- Missing base-skill reference

Result: 3 artifacts, all subtly wrong.

**Mode 3: Partial Failure Accumulation**

5 artifacts planned:
1. success
2. partial (2 P2 failures)
3. partial (3 P2 failures)
4. success (but depends on #2, #3)
5. partial (1 P2 failure)

Total: 0 failures, but quality is low.
- 3/5 partial
- #4 built on partial foundations
- Accumulated warnings: 6

Is this success? The contracts say yes.

### Mitigation Recommendations

1. **Semantic validation gates**
```markdown
Interview → Master handoff:

Master echoes understanding:
"I will create 5 artifacts. Constraint C1 means [interpretation]. Confirm?"

User confirms semantic understanding, not just format.
```

2. **Dependency-aware failure handling**
```markdown
On artifact failure:
- Mark all dependents as "blocked"
- Do not attempt blocked artifacts
- Report dependency chain to user

On artifact partial:
- Warn for dependents
- Continue, but mark dependents as "degraded"
- Include warning in dependent artifacts
```

3. **Quality accumulation tracking**
```markdown
Session quality score:
- Start at 100
- Each partial: -10
- Each failed (retried to partial): -15
- Each warning: -2

If score < 50: pause, prompt user
"Quality threshold reached. Review partials before continuing?"
```

4. **Constraint traceability**
```markdown
Each artifact records constraint lineage:
<!-- Constraint trace:
C1 original: "never delete production data"
C1 as received: "never delete production data"
C1 as embedded: "<iron_law>NEVER delete production data</iron_law>"
-->

Enables audit of semantic drift.
```

**Proposed Amendment:**

Add to Master contract:
```markdown
### Error Propagation Control

**Dependency blocking:**
- Failed artifact blocks all dependents
- Partial artifact degrades all dependents
- Blocked artifacts not attempted
- Degraded artifacts marked with warning

**Quality gate:**
Master tracks session quality:
- Partials and warnings reduce score
- At threshold (configurable, default 50): pause session
- User decides: continue, review, abort

**Constraint echo:**
Before starting generation, Master echoes constraint interpretations.
User confirms semantic accuracy before proceeding.
```

---

## Contract Amendments Summary

### Interview Contract Amendments

1. **Change Execution Manifest from Markdown table to YAML block**
2. **Add format self-validation before handoff**
3. **Define acceptable format variations explicitly**

### Master Contract Amendments

1. **Add checkpoint persistence specification**
   - File: `.github/.generator-state.yaml`
   - Write timing: before/after each artifact
   - Resume detection logic

2. **Add Creator result validation**
   - Structural checks (always)
   - Spot-check validation (for success)
   - Timeout handling (90s hard limit)

3. **Define validation authority**
   - Master as final arbiter
   - Override rules and logging

4. **Add dependency-aware failure handling**
   - Blocked vs degraded states
   - Quality gate threshold

5. **Add constraint echo confirmation**

### Creator Contract Amendments

1. **Add skill interface requirements**
   - Required file structure
   - Required section format
   - Compatibility declaration

2. **Add result structure requirements**
   - Required fields in return
   - Path echo validation
   - Checklist version reporting

3. **Define timeout behavior**
   - Grace period messaging
   - Partial return on timeout

### New Shared Contract

Create `00-shared-contract-definitions.md`:

1. **Serialization format** — YAML for structured data, Markdown for prose
2. **Validation severity normalization** — Same thresholds across all skills
3. **Checklist versioning** — Format and compatibility rules
4. **Error state definitions** — failed, partial, blocked, degraded
5. **Quality scoring** — Calculation and thresholds

---

## Robustness Scoring

### Current State: 6/10

| Component | Score | Notes |
|-----------|-------|-------|
| Happy path | 9/10 | Well-designed flow |
| Format resilience | 4/10 | Markdown tables are fragile |
| State recovery | 3/10 | No actual persistence |
| Subagent handling | 5/10 | Retry exists, validation weak |
| Validation clarity | 5/10 | Circular authority |
| Evolution resilience | 4/10 | Tightly coupled to skill format |
| Error handling | 6/10 | Basic handling, cascade risk |

### With Amendments: 8/10

| Component | Score | Improvement |
|-----------|-------|-------------|
| Happy path | 9/10 | (unchanged) |
| Format resilience | 7/10 | YAML + variations |
| State recovery | 7/10 | Explicit checkpoints |
| Subagent handling | 7/10 | Spot-check + timeout |
| Validation clarity | 7/10 | Clear authority |
| Evolution resilience | 6/10 | Interface contract |
| Error handling | 8/10 | Quality gates + blocking |

### Remaining Gaps (require implementation, not just specification)

- Actual YAML parser in agents
- Filesystem operations for checkpoints
- Timer mechanisms for timeouts
- Context window management
- Semantic validation (human judgment)

---

## Recommendations

### Immediate (before implementation)

1. Convert Execution Manifest to YAML — Prevents table parse failures
2. Define checkpoint file format — Enables recovery
3. Add Master spot-check — Reduces trust in self-report

### Short-term (during implementation)

4. Create skill interface contract — Documents expectations
5. Add quality gate — Prevents cascade degradation
6. Implement constraint echo — Catches semantic drift

### Long-term (post-MVP)

7. Add checklist versioning — Supports evolution
8. Implement context compression — Handles large manifests
9. Add validation audit log — Enables debugging

---

## Cross-References

- Interview contract: [06-interview-interface-contract.md](06-interview-interface-contract.md)
- Master contract: [07-master-agent-interface-contract.md](07-master-agent-interface-contract.md)
- Creator contract: [08-creator-agent-interface-contract.md](08-creator-agent-interface-contract.md)
- Skill structure: [../.github/skills/agent-creator/SKILL.md](../.github/skills/agent-creator/SKILL.md)
