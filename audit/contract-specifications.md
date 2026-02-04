# Contract Specifications

YAML schemas for the generation pipeline contracts.

<metadata>

**Last Updated:** 2026-02-04
**Schemas:** 5
**Status:** Specification complete, implementation pending

</metadata>

<overview>

## Pipeline Flow

```
Interview Agent
      │
      ▼ InterviewHandoff
Master Agent
      │
      ▼ CreatorPayload (per artifact)
Creator Agent
      │
      ▼ CreatorResult
Master Agent (receives, validates, writes)
```

</overview>

<interview_handoff>

## InterviewHandoff Schema

Payload from Interview to Master containing manifest and context.

```yaml
interview_handoff:
  manifest:
    artifacts:
      - name: string              # kebab-case, 2-64 chars
        type: enum                # agent | skill | prompt | instruction
        path: string              # relative to workspace root
        skill: string             # creator skill name
        tools: list[string]       # for agents only
        constraints: list[string] # C1, C2, etc.
        complexity: enum          # L0 | L1 | L2
        mode: enum                # new | extend | replace (default: new)

  constraint_mapping:
    C1: [artifact-name-1, artifact-name-2]
    C2: [artifact-name-3]

  brief_markdown: string          # full project brief

  existing_artifacts: list[string] # found artifacts (may be empty)

  ref_summaries:                  # optional
    - src: string
      tags: list[string]
      summary: string

  user_notes: string | null       # optional verbatim notes
```

### Validation Rules

- `name`: Pattern `^[a-z][a-z0-9-]*[a-z0-9]$`, 2-64 chars
- `type`: Enum, extensible if skill exists
- `path`: Must match type pattern (.github/agents/[name].agent.md, etc.)
- `constraints`: Pattern `^C[0-9]+$`, max 10 per artifact
- `manifest`: 1-50 artifacts, unique paths, unique names

</interview_handoff>

<creator_payload>

## CreatorPayload Schema

Data sent from Master to Creator for artifact generation.

```yaml
creator_payload:
  artifact:
    name: string
    type: enum
    path: string
    skill: string
    tools: list[string]
    constraints: list[string]
    complexity: enum

  context:
    project_brief: string         # relevant excerpt
    constraint_text: list[string] # full text of constraints
    related_artifacts:
      - path: string
        type: enum
        summary: string           # 1-2 sentences
    ref_summaries: list           # may be empty

  validation:
    target_complexity: enum
    must_include: list[string]    # required elements
    skip_checks: list[string]     # default: []

  session:
    session_id: string
    attempt: integer              # 1 or 2
    timeout_seconds: integer      # default: 90
```

### Timeout Policy

- **Soft timeout:** 60 seconds → warning
- **Hard timeout:** 90 seconds → terminate
- **Retry policy:** max 2 attempts for failed/timeout

</creator_payload>

<creator_result>

## CreatorResult Schema

Response from Creator to Master with artifact and validation.

```yaml
creator_result:
  status: enum                    # success | partial | failed | timeout

  artifact:
    path: string                  # must echo input path
    content: string               # full markdown content
    content_length: integer
    line_count: integer

  validation:
    skill_used: string
    skill_version: string         # default: "1.0"
    checks_run: integer
    checks_passed: integer
    checks_failed: integer
    failures:
      - check: string
        severity: enum            # P1 | P2 | P3
        message: string
        auto_fix_attempted: boolean
        auto_fix_succeeded: boolean
    warnings:
      - category: string
        message: string
    inferences:
      - decision: string
        reason: string
        confidence: enum          # high | medium | low

  metadata:
    complexity_achieved: enum
    steps_executed: integer
    references_loaded: list[string]
    assets_used: list[string]
    duration_ms: integer
```

### Status Determination

- **success:** P1 failures = 0, P2 failures < 3
- **partial:** P1 failures = 0, P2 failures >= 3
- **failed:** P1 failures > 0 OR content empty
- **timeout:** Hard timeout exceeded

</creator_result>

<generator_state>

## GeneratorState Schema

Checkpoint file for session recovery.

**Location:** `.github/.generator-state.yaml`

```yaml
generator_state:
  session_id: string              # YYYY-MM-DD-HH-MM-SS
  started_at: string              # ISO 8601
  updated_at: string              # ISO 8601

  manifest_hash: string           # SHA256 for change detection
  total_artifacts: integer

  brief_written: boolean
  brief_path: string

  artifacts:
    - path: string
      name: string
      status: enum                # pending | in-progress | complete | failed | skipped | blocked
      attempt: integer
      written_at: string | null
      validation_status: enum | null
      validation_hash: string | null
      error: string | null
      blocked_by: string | null

  quality:
    score: integer                # 0-100, starts at 100
    partials: integer
    failures: integer
    warnings: integer

  completion:
    status: enum                  # in-progress | completed | paused | aborted
    completed_count: integer
    failed_count: integer
    skipped_count: integer
    blocked_count: integer
```

### Resume Semantics

- **complete + file exists + hash matches:** Skip
- **complete + hash differs:** Prompt overwrite/skip
- **in-progress:** Restart artifact
- **failed + attempt < 2:** Retry
- **blocked:** Re-evaluate after dependency

### Quality Gate

- Initial score: 100
- Partial penalty: -10
- Failed penalty: -15
- Warning penalty: -2
- **Pause threshold:** 50

</generator_state>

<artifact_spec>

## ArtifactSpec Schema

Single artifact definition within manifest.

```yaml
artifact_spec:
  name: string                    # kebab-case identifier
  type: enum                      # agent | skill | prompt | instruction
  path: string                    # relative path to write
  skill: string                   # creator skill to use
  tools: list[string]             # for agents, empty for others
  constraints: list[string]       # applicable constraint labels
  complexity: enum                # L0 | L1 | L2
  mode: enum                      # new | extend | replace
```

### Path Patterns by Type

- **agent:** `.github/agents/[name].agent.md`
- **skill:** `.github/skills/[name]/SKILL.md`
- **prompt:** `.github/prompts/[name].prompt.md`
- **instruction:** `.github/instructions/[name].instructions.md`

### Complexity Levels

- **L0:** Single-file artifact, no references needed
- **L1:** May need 1-2 reference files for context
- **L2:** Full integration layer with references/ folder

</artifact_spec>

<cross_references>

## Cross-References

- [implementation-status.md](implementation-status.md) — Phase status
- [risk-registry.md](risk-registry.md) — Format brittleness risks
- Original: audit-legacy/10-final-contract-specifications.md (to be deleted)

</cross_references>
