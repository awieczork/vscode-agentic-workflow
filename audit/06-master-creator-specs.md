# D6: Master/Creator Agent Specifications

## Overview

This document defines interface contracts for the planned Master and Creator agents. Interview agent is implemented; Master and Creator are planned.

---

## Pipeline Flow

```
User → Interview → Master → Creator (loop) → Artifacts
         ↓           ↓           ↓
    Project Brief  Validate   Read Skill
    + Manifest     + Order    + Generate
                   + Spawn    + Validate
```

---

## Contract 1: Interview → Master

### Payload Schema (YAML)

```yaml
interview_handoff:
  version: "1.0"
  timestamp: ISO8601
  
  manifest:
    - name: string (kebab-case)
      type: agent | skill | prompt | instruction
      path: string (.github/ relative path)
      skill: string (creator skill name)
      tools: string[] (optional, agents only)
      constraints: string[] (C1, C2, etc.)
      complexity: L0 | L1 | L2
  
  constraint_map:
    C1: "constraint text"
    C2: "constraint text"
  
  brief:
    overview: string (2-3 sentences)
    tech_stack: string[]
    workflows: 
      - id: W1
        priority: P1 | P2 | P3
        goal: string
    existing_artifacts: string[]
  
  ref_summaries: # optional
    - url: string
      summary: string
      tags: string[]
```

### Validation Rules

- `name`: kebab-case, 3-50 chars
- `type`: enum validation
- `path`: must start with `.github/`
- `skill`: must match existing skill folder name
- `constraints`: must exist in constraint_map

---

## Contract 2: Master → Creator

### Payload Schema (YAML)

```yaml
creator_payload:
  artifact:
    name: string
    type: agent | skill | prompt | instruction
    path: string
    tools: string[]
    constraints: string[]
    complexity: L0 | L1 | L2
  
  context:
    brief_excerpt: string (overview + relevant workflows)
    constraint_text:
      C1: "full text"
    related_artifacts:
      - path: string
        type: string
        relationship: extends | uses | replaces
    ref_summaries: string[] (relevant only)
  
  validation:
    target_complexity: L0 | L1 | L2
    must_include: string[] (required elements)
    skip_checks: string[] (optional)
  
  session:
    manifest_id: string
    artifact_index: number
    timeout_seconds: 90
```

### Timeout Behavior

- 60s: Soft warning, request status update
- 90s: Hard limit, mark as timeout
- Retry: 1 automatic retry, then user prompt

---

## Contract 3: Creator → Master

### Result Schema (YAML)

```yaml
creator_result:
  status: success | partial | failed | timeout
  
  artifact:
    path: string
    content: string (full file content)
    line_count: number
    token_estimate: number
  
  validation:
    skill_used: string
    checks_run: number
    checks_passed: number
    checks_failed: number
    p1_failures: string[]
    p2_failures: string[]
    warnings: string[]
    inferences:
      - decision: string
        confidence: high | medium | low
        rationale: string
  
  metadata:
    complexity_achieved: L0 | L1 | L2
    references_loaded: string[]
    assets_used: string[]
    duration_seconds: number
```

### Status Criteria

| Status | P1 Failures | P2 Failures | Artifact |
|--------|-------------|-------------|----------|
| success | 0 | 0-2 | Complete |
| partial | 0 | 3+ | Usable with warnings |
| failed | 1+ | any | Not usable |
| timeout | n/a | n/a | None |

---

## Contract 4: State Checkpoint

### File Location

`.github/.generator-state.yaml`

### Schema

```yaml
generator_state:
  version: "1.0"
  session_id: string
  started_at: ISO8601
  last_updated: ISO8601
  
  manifest:
    total: number
    completed: number
    failed: number
    skipped: number
  
  artifacts:
    - name: string
      status: pending | in_progress | completed | failed | skipped
      path: string
      created_at: ISO8601 (optional)
      validation_passed: boolean
      failure_reason: string (optional)
  
  quality_score: number (0-100)
  checkpoint_reason: before_artifact | after_success | on_failure | user_pause
```

### Resume Semantics

- **Stale (>24h):** Prompt user: "Resume stale session or start fresh?"
- **Conflict:** If manifest changed, prompt user
- **Quality gate:** If score <50, pause for user review

---

## Dependency Ordering

Default creation order (Master determines):

1. **Instructions** — No dependencies (standalone rules)
2. **Skills** — May reference instructions
3. **Agents** — May use skills, apply instructions
4. **Prompts** — May delegate to agents

Within type: alphabetical unless explicit dependency declared.

---

## Error Handling Matrix

| Error Category | Action | Retry? |
|----------------|--------|--------|
| Manifest validation | Stop, report to user | No |
| Creator timeout | Retry once, then skip | Yes (1x) |
| P1 validation failure | Mark failed, continue | No |
| Dependency failure | Skip dependents | No |
| >50% failure rate | Stop, escalate | No |
| State file corrupt | Start fresh with user prompt | No |

---

## Validation Authority

| Check | Primary | Override |
|-------|---------|----------|
| Schema validation | Master | None |
| Skill compliance | Creator | Master spot-check |
| Content quality | Creator | Master final word |
| Consistency | Master | None |

**Master is final authority.** If Master and Creator disagree on validation, Master's assessment stands.

---

## Gaps Identified

| Gap | Severity | Status |
|-----|----------|--------|
| Brief not persisted by Interview | High | Master must write projectbrief.md |
| Manifest is Markdown in Interview | Medium | Master must parse and normalize |
| Skill format coupling | High | Contracts assume current skill structure |
| Semantic drift in constraints | Medium | Recommend constraint IDs with text lookup |

---

## Implementation Notes for @architect

### P1: Before Master Agent Build

1. Define `InterviewHandoff` extraction from Interview's chat output
2. Specify `projectbrief.md` write location and format
3. Create `.generator-state.yaml` schema validation

### P2: Master Agent Core

1. Manifest parsing with format tolerance
2. Dependency graph builder
3. Creator spawn/receive loop
4. Checkpoint persistence

### P3: Creator Agent Core

1. Skill loading pattern (SKILL.md + references + assets)
2. Step-by-step execution with JIT reference loading
3. Validation report generation
4. Inference documentation

### P4: Robustness

1. Timeout handling
2. Retry policies
3. Partial failure recovery
4. Quality gate enforcement

---

## Iterations Completed: 5/5-6
- [x] D6.1: Interview output contract
- [x] D6.2: Master input/output contracts
- [x] D6.3: Creator input/output contracts
- [x] D6.4: Adversary analysis
- [x] D6.5: Final specifications
