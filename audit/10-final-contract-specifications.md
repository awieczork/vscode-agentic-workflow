# Final Contract Specifications

Formal YAML schemas and validation rules for the generation pipeline, incorporating adversary analysis feedback.

---

## Design Decisions

Adversary findings addressed:

1. **Replace Markdown tables with YAML blocks** — All structured data uses YAML
2. **Specify checkpoint persistence mechanism** — `.github/.generator-state.yaml`
3. **Define Master as final validation authority** — Explicit override rules
4. **Add tolerance for format variations** — Normalization rules documented
5. **Specify timeout and retry behavior** — Hard limits with grace periods

---

## 1. Interview → Master Contract

### Payload Schema

```yaml
# InterviewHandoff Schema
# Delivered in conversation context, not as file

interview_handoff:
  # REQUIRED: Execution manifest with artifact specifications
  manifest:
    artifacts:
      - name: string                    # kebab-case identifier
        type: enum                      # agent | skill | prompt | instruction
        path: string                    # relative to workspace root
        skill: enum                     # agent-creator | skill-creator | prompt-creator | instruction-creator
        tools: list[string]             # tool names for agents, empty for others
        constraints: list[string]       # constraint labels (C1, C2, etc.)
        complexity: enum                # L0 | L1 | L2
        mode: enum                      # new | extend | replace (default: new)

  # REQUIRED: Mapping of constraints to artifact names
  constraint_mapping:
    C1: [artifact-name-1, artifact-name-2]
    C2: [artifact-name-3]

  # REQUIRED: Full project brief as markdown string
  brief_markdown: string

  # REQUIRED: List of existing artifacts found (empty list if none)
  existing_artifacts: list[string]

  # OPTIONAL: Reference summaries from brain processing
  ref_summaries:
    - src: string                       # URL or file path
      tags: list[string]                # associated tags
      summary: string                   # condensed summary

  # OPTIONAL: Verbatim user notes with suggestions highlighted
  user_notes: string | null
```

### Required Fields

| Field | Required | Default if Omitted |
|-------|----------|--------------------|
| `manifest.artifacts` | Yes | — |
| `manifest.artifacts[].name` | Yes | — |
| `manifest.artifacts[].type` | Yes | — |
| `manifest.artifacts[].path` | Yes | — |
| `manifest.artifacts[].skill` | Yes | — |
| `manifest.artifacts[].tools` | Yes | `[]` |
| `manifest.artifacts[].constraints` | Yes | `[]` |
| `manifest.artifacts[].complexity` | Yes | — |
| `manifest.artifacts[].mode` | No | `new` |
| `constraint_mapping` | Yes | — |
| `brief_markdown` | Yes | — |
| `existing_artifacts` | Yes | `[]` |
| `ref_summaries` | No | `null` |
| `user_notes` | No | `null` |

### Validation Rules

```yaml
validation_rules:
  name:
    pattern: "^[a-z][a-z0-9-]*[a-z0-9]$"
    min_length: 2
    max_length: 64
    description: "kebab-case, starts with letter, ends with letter or digit"

  type:
    allowed: [agent, skill, prompt, instruction]
    extensible: true
    extension_rule: "Accept unknown type if skill exists at .github/skills/[type]-creator/"

  path:
    patterns:
      agent: ".github/agents/[name].agent.md"
      skill: ".github/skills/[name]/SKILL.md"
      prompt: ".github/prompts/[name].prompt.md"
      instruction: ".github/instructions/[name].instructions.md"

  skill:
    allowed: [agent-creator, skill-creator, prompt-creator, instruction-creator]
    extensible: true
    extension_rule: "Accept if .github/skills/[skill]/ exists"

  complexity:
    allowed: [L0, L1, L2]
    definitions:
      L0: "Single-file artifact, no references needed"
      L1: "May need 1-2 reference files for context"
      L2: "Full integration layer with references/ folder"

  constraints:
    pattern: "^C[0-9]+$"
    max_count: 10
    must_exist_in_mapping: true

  manifest:
    min_artifacts: 1
    max_artifacts: 50
    unique_paths: true
    unique_names: true
```

### Format Tolerance

Master accepts these variations without error:

```yaml
format_tolerance:
  # Field name variations (normalized to canonical)
  field_aliases:
    artifact_name: name
    artifactName: name
    artifact-name: name
    artifactType: type
    artifact_type: type
    file_path: path
    filePath: path

  # Enum case insensitivity
  enum_normalization:
    - "AGENT" → "agent"
    - "Agent" → "agent"
    - "SKILL-CREATOR" → "skill-creator"

  # Whitespace handling
  whitespace:
    trim_all_string_values: true
    collapse_internal_whitespace: false
    normalize_line_endings: true

  # Missing optional fields
  optional_defaults:
    mode: "new"
    tools: []
    constraints: []
    ref_summaries: null
    user_notes: null
```

### Interview Guarantees

What Master can trust without re-validation:

```yaml
interview_guarantees:
  - "Name matches kebab-case pattern"
  - "At least 2 workflows present in brief"
  - "Each artifact has valid type, path, skill, complexity"
  - "All constraint labels mapped to at least one artifact"
  - "User explicitly approved manifest before handoff"
  - "Artifact count between 1 and 50"
```

### Interview Does NOT Guarantee

Master must validate:

```yaml
master_must_validate:
  - "Paths do not already exist in filesystem"
  - "Skills exist in .github/skills/"
  - "Dependency order is optimal"
  - "Complexity assessment is accurate"
  - "Tools are valid for VS Code"
```

---

## 2. Master → Creator Contract

### Payload Schema

```yaml
# CreatorPayload Schema
# Delivered via subagent spawn message

creator_payload:
  # REQUIRED: Artifact specification
  artifact:
    name: string                        # kebab-case identifier
    type: enum                          # agent | skill | prompt | instruction
    path: string                        # relative path to write
    skill: string                       # skill to use for generation
    tools: list[string]                 # tools for agents
    constraints: list[string]           # constraint labels
    complexity: enum                    # L0 | L1 | L2

  # REQUIRED: Generation context
  context:
    project_brief: string               # relevant excerpt from brief
    constraint_text: list[string]       # full text of applicable constraints
    related_artifacts:                  # already-created artifacts
      - path: string
        type: enum
        summary: string                 # 1-2 sentence description
    ref_summaries:                      # reference summaries (may be empty)
      - src: string
        tags: list[string]
        summary: string

  # REQUIRED: Validation requirements
  validation:
    target_complexity: enum             # expected output complexity
    must_include: list[string]          # required elements from constraints
    skip_checks: list[string]           # checks to skip (default: [])

  # REQUIRED: Session metadata
  session:
    session_id: string                  # unique session identifier
    attempt: integer                    # attempt number (1, 2, etc.)
    timeout_seconds: integer            # hard timeout for this invocation
```

### Required Fields

| Field | Required | Default |
|-------|----------|---------|
| `artifact.*` | All required | — |
| `context.project_brief` | Yes | — |
| `context.constraint_text` | Yes | `[]` |
| `context.related_artifacts` | Yes | `[]` |
| `context.ref_summaries` | Yes | `[]` |
| `validation.target_complexity` | Yes | — |
| `validation.must_include` | Yes | `[]` |
| `validation.skip_checks` | No | `[]` |
| `session.session_id` | Yes | — |
| `session.attempt` | Yes | `1` |
| `session.timeout_seconds` | Yes | `90` |

### Timeout Behavior

```yaml
timeout_policy:
  soft_timeout_seconds: 60
  soft_timeout_action: "Send warning: 'Please complete within 30 seconds'"
  
  hard_timeout_seconds: 90
  hard_timeout_action: "Terminate, mark status as 'timeout'"
  
  partial_content_handling:
    if_content_received: "Accept partial, mark status 'partial'"
    if_no_content: "Mark status 'failed', error 'timeout_no_response'"

  retry_policy:
    max_attempts: 2
    retry_on: [timeout, failed]
    no_retry_on: [success, partial]
    backoff: none
```

### Payload Delivery Format

Master sends payload in conversation context:

```markdown
Create artifact using skill.

---
creator_payload:
  artifact:
    name: "[name]"
    type: "[type]"
    path: "[path]"
    skill: "[skill]"
    tools: [tool1, tool2]
    constraints: [C1, C2]
    complexity: "[complexity]"
  context:
    project_brief: |
      [relevant excerpt]
    constraint_text:
      - "C1: [full constraint text]"
      - "C2: [full constraint text]"
    related_artifacts:
      - path: "[path]"
        type: "[type]"
        summary: "[summary]"
    ref_summaries: []
  validation:
    target_complexity: "[complexity]"
    must_include:
      - "[required element 1]"
      - "[required element 2]"
    skip_checks: []
  session:
    session_id: "[session-id]"
    attempt: 1
    timeout_seconds: 90
---

Execute skill workflow. Return CreatorResult when complete.
```

### Master Guarantees to Creator

```yaml
master_guarantees:
  - "Skill exists at .github/skills/[skill]/SKILL.md"
  - "Path does not overwrite existing file (or user approved overwrite)"
  - "Constraints are valid labels from manifest"
  - "Related artifacts exist and were successfully created"
  - "attempt is accurate (1 for first try, 2 for retry)"
```

---

## 3. Creator → Master Contract

### Result Schema

```yaml
# CreatorResult Schema
# Returned via subagent response

creator_result:
  # REQUIRED: Completion status
  status: enum                          # success | partial | failed | timeout

  # REQUIRED: Generated artifact
  artifact:
    path: string                        # echoed from input (must match)
    content: string                     # full artifact content as markdown
    content_length: integer             # character count
    line_count: integer                 # line count

  # REQUIRED: Validation report
  validation:
    skill_used: string                  # skill name for traceability
    skill_version: string               # skill interface version (default: "1.0")
    checks_run: integer                 # total checks executed
    checks_passed: integer              # checks that passed
    checks_failed: integer              # checks that failed
    failures:
      - check: string                   # check name
        severity: enum                  # P1 | P2 | P3
        message: string                 # failure explanation
        auto_fix_attempted: boolean
        auto_fix_succeeded: boolean
    warnings:
      - category: string                # warning category
        message: string                 # warning details
    inferences:
      - decision: string                # what was decided
        reason: string                  # why this inference was made
        confidence: enum                # high | medium | low

  # REQUIRED: Execution metadata
  metadata:
    complexity_achieved: enum           # L0 | L1 | L2
    steps_executed: integer             # workflow steps completed
    references_loaded: list[string]     # reference files loaded
    assets_used: list[string]           # asset files used
    duration_ms: integer                # execution time in milliseconds
```

### Status Definitions

```yaml
status_definitions:
  success:
    criteria:
      - "Artifact fully generated"
      - "All P1 checks pass"
      - "P2 failures ≤ 2"
      - "Content is non-empty"
      - "Content is valid markdown"
    master_action: "Write file, update checkpoint, continue"

  partial:
    criteria:
      - "Artifact generated but incomplete"
      - "All P1 checks pass"
      - "P2 failures ≥ 3 OR"
      - "Low-confidence inferences made"
    master_action: "Write file with warning, mark degraded, continue"

  failed:
    criteria:
      - "Any P1 check failed OR"
      - "Skill not found OR"
      - "Critical ambiguity unresolvable OR"
      - "Content empty or invalid"
    master_action: "Retry once, then skip and mark failed"

  timeout:
    criteria:
      - "Hard timeout exceeded"
      - "No complete response received"
    master_action: "Retry once, then mark failed"
```

### Pass/Fail Thresholds

```yaml
validation_thresholds:
  # Normalized across all skills
  p1_threshold: 0                       # any P1 failure → failed
  p2_threshold: 3                       # P2 failures ≥ 3 → partial
  p3_threshold: null                    # P3 never affects status

  status_determination:
    - condition: "p1_failures > 0"
      result: failed
    - condition: "p2_failures >= 3"
      result: partial
    - condition: "otherwise"
      result: success
```

### Result Message Format

Creator returns in this format:

```markdown
## Creator Result

---
creator_result:
  status: "[status]"
  artifact:
    path: "[path]"
    content_length: [N]
    line_count: [N]
  validation:
    skill_used: "[skill]"
    skill_version: "1.0"
    checks_run: [N]
    checks_passed: [N]
    checks_failed: [N]
    failures: []
    warnings: []
    inferences: []
  metadata:
    complexity_achieved: "[complexity]"
    steps_executed: [N]
    references_loaded: []
    assets_used: []
    duration_ms: [N]
---

### Artifact Content

```markdown
[full artifact content here]
```
```

### Master Validation of Creator Result

```yaml
master_result_validation:
  # Structural checks (always performed)
  structural_checks:
    - "Response contains '## Creator Result' header"
    - "YAML block present and parseable"
    - "status is valid enum value"
    - "artifact.path matches expected path"
    - "artifact.content_length > 0"
    - "Artifact Content section present"

  # Spot-check validation (for status: success)
  spot_check:
    enabled: true
    sample_size: 2                      # random P1 checks
    action_on_failure: "Downgrade to partial, log discrepancy"

  # Path echo validation
  path_validation:
    rule: "artifact.path must exactly match creator_payload.artifact.path"
    action_on_mismatch: "Error, do not write file"
```

### Validation Authority Hierarchy

```yaml
validation_authority:
  hierarchy:
    1: "Skill checklist — defines what to check"
    2: "Creator — executes checks, reports results"
    3: "Master — FINAL AUTHORITY, may override"

  override_rules:
    - "Master spot-check failure overrides Creator 'success' → 'partial'"
    - "Master cannot upgrade 'failed' to 'success'"
    - "Master cannot upgrade 'partial' to 'success'"
    - "All overrides logged with reason"

  logging:
    format: "OVERRIDE: [original_status] → [new_status]: [reason]"
```

---

## 4. State Checkpoint Contract

### File Location

```yaml
checkpoint_location:
  path: ".github/.generator-state.yaml"
  alternative_if_no_github: ".generator-state.yaml"
  gitignore: true                       # add to .gitignore
```

### Checkpoint Schema

```yaml
# Generator State Checkpoint Schema
# Written to .github/.generator-state.yaml

generator_state:
  # Session identification
  session_id: string                    # format: "YYYY-MM-DD-HH-MM-SS"
  started_at: string                    # ISO 8601 timestamp
  updated_at: string                    # ISO 8601 timestamp
  
  # Manifest tracking
  manifest_hash: string                 # SHA256 of original manifest YAML
  total_artifacts: integer              # total artifacts in manifest
  
  # Brief persistence
  brief_written: boolean                # whether projectbrief.md was written
  brief_path: string                    # path to written brief
  
  # Progress tracking
  artifacts:
    - path: string                      # artifact path
      name: string                      # artifact name
      status: enum                      # pending | in-progress | complete | failed | skipped | blocked
      attempt: integer                  # current attempt number
      written_at: string | null         # ISO 8601 timestamp when written
      validation_status: enum | null    # success | partial | failed
      validation_hash: string | null    # SHA256 of content when validated
      error: string | null              # error message if failed
      blocked_by: string | null         # path of blocking artifact if blocked

  # Quality tracking
  quality:
    score: integer                      # 0-100, starts at 100
    partials: integer                   # count of partial completions
    failures: integer                   # count of failures
    warnings: integer                   # count of warnings

  # Completion state
  completion:
    status: enum                        # in-progress | completed | paused | aborted
    completed_count: integer
    failed_count: integer
    skipped_count: integer
    blocked_count: integer
```

### Checkpoint Timing

```yaml
checkpoint_timing:
  # Write BEFORE starting artifact
  before_artifact:
    action: "Set status = 'in-progress', attempt = N"
    purpose: "Mark intent before work begins"

  # Write AFTER successful completion
  after_success:
    action: "Set status = 'complete', written_at = now, validation_hash = SHA256(content)"
    purpose: "Record successful write with verification hash"

  # Write ON failure
  on_failure:
    action: "Set status = 'failed', error = message, attempt = N"
    purpose: "Record failure for retry decision"

  # Write ON skip
  on_skip:
    action: "Set status = 'skipped' or 'blocked', blocked_by = path"
    purpose: "Record why artifact was not created"
```

### Resume Semantics

```yaml
resume_behavior:
  # Detection
  detection:
    trigger: "Master invocation when .generator-state.yaml exists"
    age_threshold_hours: 24

  # User prompts
  prompts:
    fresh_session: "Starting new generation session."
    recent_session: "Found session from [time]. Resume ([N] remaining) or restart?"
    stale_session: "Found stale session from [date]. Resume, restart, or clean?"

  # Resume logic
  resume_logic:
    for_each_artifact:
      - condition: "status == 'complete' AND file exists AND hash matches"
        action: "Skip, already done"
      - condition: "status == 'complete' AND file exists AND hash differs"
        action: "Prompt: file modified since generation. Overwrite/skip?"
      - condition: "status == 'complete' AND file missing"
        action: "Re-create (file was deleted)"
      - condition: "status == 'in-progress'"
        action: "Restart artifact (was interrupted)"
      - condition: "status == 'failed' AND attempt < max_attempts"
        action: "Retry"
      - condition: "status == 'failed' AND attempt >= max_attempts"
        action: "Prompt: retry again or skip?"
      - condition: "status == 'pending'"
        action: "Create"
      - condition: "status == 'blocked'"
        action: "Re-evaluate blocking dependency"

  # Clean action
  clean:
    action: "Delete .generator-state.yaml, do not delete any artifacts"
    confirmation: "This will discard progress tracking. Created files remain. Continue?"
```

### Quality Gate

```yaml
quality_gate:
  enabled: true
  threshold: 50                         # pause when score drops below

  scoring:
    initial: 100
    partial_penalty: -10
    failed_penalty: -15
    warning_penalty: -2

  trigger_action:
    prompt: |
      Quality threshold reached (score: [score]).
      - Partials: [N]
      - Failures: [N]
      - Warnings: [N]
      
      Review partials before continuing?
    options: [continue, review, abort]
```

---

## 5. Error Handling Specifications

### Error Categories

```yaml
error_categories:
  manifest_error:
    examples:
      - "Circular dependency detected"
      - "Duplicate paths in manifest"
      - "Invalid artifact type"
    response: "Stop immediately, report to user"
    retry: false

  skill_missing:
    examples:
      - "Skill folder not found"
      - "SKILL.md missing"
    response: "Stop for affected artifact, report to user"
    retry: false

  creator_failure:
    examples:
      - "P1 validation failed"
      - "Content generation error"
    response: "Retry once, then skip"
    retry: true
    max_retries: 1

  timeout:
    examples:
      - "No response in 90 seconds"
      - "Partial response only"
    response: "Retry once, then mark failed"
    retry: true
    max_retries: 1

  write_failure:
    examples:
      - "Permission denied"
      - "Disk full"
    response: "Stop immediately, report completed artifacts"
    retry: false

  validation_warning:
    examples:
      - "P2 check failed"
      - "P3 check failed"
    response: "Log, continue"
    retry: false
```

### Dependency-Aware Failure Handling

```yaml
dependency_failure_handling:
  on_failed:
    action: "Mark all dependents as 'blocked'"
    dependent_status: blocked
    continue_non_dependents: true
    report: "List blocked artifacts with reason"

  on_partial:
    action: "Mark all dependents as 'degraded'"
    continue_dependents: true
    warning_in_dependents: |
      <!-- WARNING: Built on partial artifact [path] -->
    report: "Note degraded chain in summary"

  on_skipped:
    action: "Propagate skip to dependents"
    dependent_status: blocked
    blocked_by: "[skipped artifact path]"
```

### Retry Policy

```yaml
retry_policy:
  creator_invocation:
    max_attempts: 2
    retry_conditions:
      - "status == 'failed'"
      - "status == 'timeout'"
    no_retry_conditions:
      - "status == 'success'"
      - "status == 'partial'"
      - "error contains 'skill_not_found'"

  payload_modification_on_retry:
    attempt: "increment by 1"
    other_fields: "unchanged"

  user_prompt_after_max_retries:
    prompt: "Artifact [name] failed after [N] attempts: [error]. Retry again, skip, or abort?"
    options: [retry, skip, abort]
```

---

## 6. Implementation Notes for @architect

### Priority Order

```yaml
implementation_priority:
  p1_immediate:
    - "YAML serialization for manifest (replace Markdown tables)"
    - "Checkpoint file write/read operations"
    - "Status enum handling in Master"

  p2_short_term:
    - "Timeout mechanism for Creator spawn"
    - "Spot-check validation in Master"
    - "Quality gate tracking"

  p3_long_term:
    - "Skill version compatibility checking"
    - "Context compression for large manifests"
    - "Validation audit logging"
```

### Agent Implementation Requirements

```yaml
interview_agent:
  changes:
    - "Output manifest as YAML block instead of Markdown table"
    - "Add self-validation of output format before handoff"
    - "Include session_id in handoff payload"

master_agent:
  changes:
    - "Parse YAML manifest from Interview"
    - "Write checkpoint before/after each artifact"
    - "Implement resume detection on startup"
    - "Add spot-check validation of Creator results"
    - "Track quality score, trigger gate at threshold"
    - "Handle dependency blocking/degradation"

creator_agent:
  changes:
    - "Return YAML-formatted CreatorResult"
    - "Include skill_version in validation report"
    - "Echo path in result for verification"
    - "Handle timeout gracefully (return partial if possible)"
```

### Skill Interface Requirements

```yaml
skill_interface:
  required_structure:
    files:
      - "SKILL.md"                      # required, main skill file
      - "references/validation-checklist.md"  # required, validation checks

    skill_md_sections:
      - "## Process"                    # required, workflow steps
      - "### Step N: [Name]"            # format for steps

    validation_checklist_format:
      sections: ["## P1", "## P2", "## P3"]
      item_format: "- [ ] [check description]"

  compatibility:
    version_field: "interface_version"  # in SKILL.md frontmatter
    default_version: "1.0"
    version_check: "Creator refuses if skill version > supported"
```

### File Operations

```yaml
file_operations:
  checkpoint_write:
    method: "atomic write (write to temp, rename)"
    encoding: "UTF-8"
    permissions: "inherit from parent directory"

  artifact_write:
    method: "atomic write"
    create_parents: true
    encoding: "UTF-8"

  brief_write:
    path: ".github/memory-bank/global/projectbrief.md"
    fallback_path: ".github/projectbrief.md"
    timing: "before first artifact creation"
```

### Robustness Checklist

```yaml
robustness_checklist:
  format_handling:
    - "[ ] YAML parser handles missing optional fields"
    - "[ ] Enum values normalized to lowercase"
    - "[ ] Field aliases mapped to canonical names"
    - "[ ] Whitespace trimmed from string values"

  state_management:
    - "[ ] Checkpoint written atomically"
    - "[ ] Resume detects stale sessions"
    - "[ ] Hash verification for complete artifacts"
    - "[ ] Quality score calculated correctly"

  error_handling:
    - "[ ] Timeout terminates gracefully"
    - "[ ] Failed artifacts don't block unrelated artifacts"
    - "[ ] User prompted for retry decisions"
    - "[ ] All errors logged with context"

  validation:
    - "[ ] Master spot-checks Creator results"
    - "[ ] Path echo verified before write"
    - "[ ] Status downgrade on spot-check failure"
    - "[ ] Override decisions logged"
```

---

## Cross-References

- Adversary analysis: [09-contract-adversary-analysis.md](09-contract-adversary-analysis.md)
- Interview contract (original): [06-interview-interface-contract.md](06-interview-interface-contract.md)
- Master contract (original): [07-master-agent-interface-contract.md](07-master-agent-interface-contract.md)
- Creator contract (original): [08-creator-agent-interface-contract.md](08-creator-agent-interface-contract.md)
- Generator architecture: [../generator/architecture.md](../generator/architecture.md)
