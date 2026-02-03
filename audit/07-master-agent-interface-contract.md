# Master Agent Interface Contract

Formal specification of Master agent interfaces for generation pipeline orchestration.

---

## Role Summary

Master sits between Interview and Creator agents in the generation pipeline:

```
Interview → Master → Creator (per artifact) → Master → Files
```

**Responsibilities:**
- Receive validated brief from Interview
- Validate artifact decisions in fresh context
- Determine creation order from dependencies
- Spawn Creator for each artifact with payload
- Receive and validate Creator output
- Write validated artifacts to filesystem
- Track progress and handle failures

---

## Input Contract (from Interview)

### Handoff Payload Structure

Master receives the Interview handoff payload in conversation context:

```typescript
interface InterviewHandoff {
  manifest: ExecutionManifest;
  constraintMapping: Record<string, string[]>;
  refSummaries: RefSummary[] | null;
  existingArtifacts: string[];
  userNotes: string | null;
  briefMarkdown: string;  // Full project brief as markdown
}

interface ExecutionManifest {
  artifacts: ArtifactSpec[];
}

interface ArtifactSpec {
  name: string;           // kebab-case identifier
  type: ArtifactType;     // "agent" | "skill" | "prompt" | "instruction"
  path: string;           // relative to workspace root
  skill: CreatorSkill;    // which skill generates this
  tools: string[];        // empty array for non-agents
  constraints: string[];  // ["C1", "C2"] or empty
  complexity: Complexity; // "L0" | "L1" | "L2"
}

interface RefSummary {
  src: string;
  tags: string[];
  summary: string;
}
```

### Interview Guarantees

Master can trust these validations from Interview:

- Name is valid kebab-case
- At least 2 workflows present
- Each artifact has valid type, path, skill, complexity
- Constraints are mapped to artifacts
- User explicitly approved before handoff

### Interview Does NOT Guarantee

Master must validate:

- Paths do not already exist (check filesystem)
- Skills exist (verify skill folder present)
- Dependency order is optimal (Interview doesn't order)
- Complexity assessment is accurate (Interview estimates)

---

## Validation Responsibilities

### Phase 1: Manifest Validation

Performed immediately on receiving handoff:

| Check | Action on Failure | Can Override |
|-------|-------------------|--------------|
| All paths are unique | Error to user | No |
| No path overwrites existing file | Prompt user: overwrite/rename/skip | Yes |
| All skills exist in `.github/skills/` | Error: missing skill | No |
| Artifact types match paths | Auto-fix path if simple | Yes |
| Constraints mapped to artifacts | Warning only | Yes |

### Phase 2: Dependency Validation

Before determining creation order:

| Check | Action on Failure |
|-------|-------------------|
| No circular dependencies | Error to user |
| Referenced artifacts in manifest | Error: missing dependency |
| Skill dependencies available | Error: missing skill |

### Override Authority

**Master CAN override:**
- Path patterns (e.g., fix `.github/agent/` → `.github/agents/`)
- Complexity assessment (upgrade L0 to L1 if tools require iron law)
- Creation order (reorder based on dependencies)

**Master CANNOT override:**
- Artifact type decisions (requires re-prompting user)
- Artifact inclusion/exclusion (requires user approval)
- Constraint mappings (user's domain knowledge)

### Re-Prompting Triggers

Master surfaces these issues to user:

- Existing file would be overwritten
- Interview missed obvious dependencies
- Manifest has internal contradictions
- Critical skill missing from workspace

---

## Dependency Ordering

### Artifact Type Dependencies

Dependencies flow in this order (earlier types must exist before later):

```
instructions → skills → agents → prompts
     ↓           ↓         ↓
  (none)     (none)   (skills, agents)
```

**Dependency rules:**

| Type | May Depend On | Reason |
|------|---------------|--------|
| Instruction | None | Self-contained rules |
| Skill | None | Standalone procedures |
| Agent | Skills, other Agents | `#skill:` refs, handoff targets |
| Prompt | Skills, Agents | May reference agents or embed skill procedures |

### Intra-Type Dependencies

Within artifact types:

- **Agents:** Check `handoffs` field for @agent references
- **Skills:** Check for `#skill:` references (rare, typically none)
- **Prompts:** Check for @agent mentions in template

### Ordering Algorithm

```
1. Parse manifest into dependency graph
2. For each agent: extract handoff targets, add edges
3. For each artifact: extract skill references, add edges
4. Topological sort
5. If cycle detected: error to user
6. Return ordered list
```

### Parallel Creation

Artifacts with no dependencies on each other can be created in parallel:

```
instructions ──┬── skill-a ──┬── agent-main
               │             │
               └── skill-b ──┘
```

In this example: instructions, skill-a, skill-b can be parallel. agent-main must wait.

**Implementation:** Master tracks `pending`, `in-progress`, `complete` states. Spawns next batch when dependencies satisfied.

---

## Creator Invocation Contract

### Invocation Method

**Mechanism:** Subagent spawn (not handoff)

**Rationale:**
- Master maintains control and receives results
- Handoff transfers control permanently
- Master needs to loop through multiple artifacts

### Creator Payload

Master sends this payload when spawning Creator:

```typescript
interface CreatorPayload {
  artifact: ArtifactSpec;
  context: CreatorContext;
  validation: ValidationRequirements;
}

interface CreatorContext {
  projectBrief: string;           // Relevant excerpt from brief
  constraintText: string[];       // Full text of applicable constraints
  relatedArtifacts: string[];     // Paths of already-created artifacts
  refSummaries: RefSummary[];     // Relevant reference summaries
}

interface ValidationRequirements {
  requiredChecks: string[];       // From skill's validation checklist
  complexity: Complexity;         // Target complexity level
  mustInclude: string[];          // Elements from constraints
}
```

### Spawn Message Template

```
Create artifact using skill #skill:[skill-name].

**Artifact Specification:**
- Name: [name]
- Type: [type]
- Path: [path]
- Complexity: [complexity]

**Applicable Constraints:**
[constraint text, one per line]

**Project Context:**
[relevant excerpt from project brief]

**Related Artifacts Already Created:**
[list of paths or "None yet"]

**Validation Requirements:**
Run skill's validation checklist. Ensure [complexity] requirements met.
```

### Creator Return Contract

Creator returns to Master:

```typescript
interface CreatorResult {
  status: "success" | "partial" | "failed";
  artifactPath: string;
  artifactContent: string;        // Full markdown content
  validationReport: ValidationReport;
  warnings: string[];
}

interface ValidationReport {
  checksRun: number;
  checksPassed: number;
  failures: ValidationFailure[];
}

interface ValidationFailure {
  check: string;
  severity: "blocker" | "warning";
  message: string;
}
```

---

## Output Contract (Artifacts)

### File Writing Responsibility

**Master writes all files.** Creator returns content; Master handles persistence.

**Rationale:**
- Single point of control for filesystem
- Master can validate before writing
- Master tracks what was written for rollback
- Avoids partial state from Creator failures

### Pre-Write Validation

Master validates Creator output before writing:

| Check | Action on Failure |
|-------|-------------------|
| Content is non-empty | Retry Creator once |
| Path matches expected path | Error (Creator bug) |
| No blocker validations failed | Retry or skip (see error handling) |
| Content parses as valid markdown | Retry Creator once |

### Write Sequence

For each artifact:

1. Receive CreatorResult
2. Validate result
3. Create parent directories if needed
4. Write file atomically
5. Update progress state
6. Log to session memory (if available)

### Post-Write Validation

After all artifacts written:

- Verify all manifest paths exist
- Run `get_errors` on created files (if applicable)
- Report summary to user

---

## State Management

### Progress Tracking

Master maintains this state during execution:

```typescript
interface MasterState {
  manifest: ExecutionManifest;
  orderedArtifacts: ArtifactSpec[];  // After dependency sort
  status: Record<string, ArtifactStatus>;
  createdPaths: string[];
  failedArtifacts: FailedArtifact[];
  startTime: Date;
  checkpoints: Checkpoint[];
}

type ArtifactStatus = 
  | "pending"
  | "in-progress" 
  | "validating"
  | "complete"
  | "failed"
  | "skipped";

interface FailedArtifact {
  artifact: ArtifactSpec;
  attempt: number;
  error: string;
  creatorResult?: CreatorResult;
}

interface Checkpoint {
  timestamp: Date;
  completedPaths: string[];
  pendingPaths: string[];
}
```

### Checkpoint/Resume

**Checkpoint creation:**
- After each successful artifact write
- Contains: completed paths, pending paths, timestamp

**Resume capability:**
- If Master fails mid-execution, user can re-invoke
- Master checks existing files against manifest
- Skips already-created artifacts
- Resumes from first incomplete

**Resume detection:**
```
On startup:
  For each artifact in manifest:
    If path exists AND content matches expected:
      Mark "complete"
    Else if path exists AND content differs:
      Prompt user: overwrite/skip/abort
    Else:
      Mark "pending"
```

---

## Error Handling

### Error Categories

| Category | Example | Response |
|----------|---------|----------|
| Manifest error | Circular dependency | Stop, report to user |
| Skill missing | `skill-creator` not found | Stop, report to user |
| Creator failure | Skill produced invalid output | Retry once, then skip |
| Write failure | Permission denied | Stop, report to user |
| Validation warning | Optional check failed | Log, continue |

### Retry Policy

```
On Creator failure:
  If attempt < 2:
    Retry with same payload
  Else:
    Mark artifact "failed"
    Prompt user: retry/skip/abort
    
On write failure:
  Stop immediately (filesystem issue)
  Report completed artifacts
  Provide resume instructions
```

### Failure Modes

**Single artifact fails:**
- Mark failed, continue with non-dependents
- At end: report failures, ask user

**Dependency fails:**
- Skip all artifacts that depend on failed artifact
- Mark as "skipped" with reason
- Report dependency chain to user

**Multiple failures:**
- If >50% fail: stop and report
- User decides: abort or continue remaining

### Rollback

**No automatic rollback.** Created files remain.

**Rationale:**
- Partial progress is better than nothing
- User can review what was created
- Resume is more useful than rollback
- Rollback risks data loss

**Manual cleanup option:**
- Master reports all created paths
- User can manually delete if needed

---

## Memory Integration

### Session Memory (if available)

Master logs to `.github/memory-bank/sessions/` if present:

```markdown
## Generation Session [timestamp]

**Manifest:**
[artifact count] artifacts planned

**Progress:**
- [timestamp] Started
- [timestamp] Created [path]
- [timestamp] Failed [path]: [reason]
- [timestamp] Completed

**Summary:**
- Created: [count]
- Failed: [count]
- Skipped: [count]
```

### Project Brief Persistence

**Master writes projectbrief.md** before starting generation:

```
Location: .github/memory-bank/global/projectbrief.md
Content: briefMarkdown from InterviewHandoff
```

**Rationale:**
- Interview doesn't write files
- Brief becomes persistent reference
- Future agents can read context

---

## Complete Flow

```
1. Receive InterviewHandoff
2. Validate manifest (Phase 1)
   - Check paths unique
   - Check no overwrites (or prompt)
   - Check skills exist
3. Write projectbrief.md
4. Build dependency graph
5. Topological sort → orderedArtifacts
6. For each artifact in order:
   a. Build CreatorPayload
   b. Spawn Creator with payload
   c. Receive CreatorResult
   d. Validate result
   e. If valid: write file, checkpoint
   f. If invalid: retry or handle failure
7. Post-write validation
8. Report summary to user
```

---

## Interface Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                           Master Agent                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────────────┐ │
│  │   Receive    │────▶│   Validate   │────▶│  Order Dependencies  │ │
│  │   Handoff    │     │   Manifest   │     │                      │ │
│  └──────────────┘     └──────────────┘     └──────────────────────┘ │
│         │                    │                        │              │
│         ▼                    ▼                        ▼              │
│  InterviewHandoff     Validation errors        Ordered list          │
│                       → User prompt            of ArtifactSpec       │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │                    Creation Loop                              │   │
│  │  ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐   │   │
│  │  │  Build  │───▶│  Spawn  │───▶│ Receive │───▶│  Write  │   │   │
│  │  │ Payload │    │ Creator │    │ Result  │    │  File   │   │   │
│  │  └─────────┘    └─────────┘    └─────────┘    └─────────┘   │   │
│  │       │              │              │              │         │   │
│  │       ▼              ▼              ▼              ▼         │   │
│  │  CreatorPayload  Subagent     CreatorResult   Checkpoint    │   │
│  │                  spawn                                       │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌──────────────┐     ┌──────────────┐                              │
│  │   Validate   │────▶│   Report     │                              │
│  │   All Files  │     │   Summary    │                              │
│  └──────────────┘     └──────────────┘                              │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘

External Interfaces:
───────────────────
← InterviewHandoff (conversation context)
→ CreatorPayload (subagent spawn)
← CreatorResult (subagent return)
→ Files (filesystem write)
→ Summary (user report)
```

---

## Cross-References

- Interview contract: [06-interview-interface-contract.md](06-interview-interface-contract.md)
- Generator architecture: [../generator/generator.md](../generator/generator.md)
- Core agent design: [05-core-agent-pack-design.md](05-core-agent-pack-design.md)
- Creator skills:
  - [../.github/skills/agent-creator/SKILL.md](../.github/skills/agent-creator/SKILL.md)
  - [../.github/skills/skill-creator/SKILL.md](../.github/skills/skill-creator/SKILL.md)
  - [../.github/skills/prompt-creator/SKILL.md](../.github/skills/prompt-creator/SKILL.md)
  - [../.github/skills/instruction-creator/SKILL.md](../.github/skills/instruction-creator/SKILL.md)
