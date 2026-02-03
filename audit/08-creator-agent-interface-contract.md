# Creator Agent Interface Contract

Formal specification of Creator agent interfaces for artifact generation within the generation pipeline.

---

## Role Summary

Creator is the execution layer spawned by Master for each artifact:

```
Master → Creator (per artifact) → Master
```

**Responsibilities:**
- Receive artifact specification and context from Master
- Load skill for specified artifact type
- Execute skill workflow step-by-step
- Run skill's validation checklist
- Return artifact content and validation report to Master

**Does NOT:**
- Write files (Master handles persistence)
- Interact with user (Master handles prompts)
- Maintain state across invocations (stateless per artifact)
- Make decisions about which artifacts to create

---

## Input Contract (from Master)

### CreatorPayload Schema

```typescript
interface CreatorPayload {
  artifact: ArtifactSpec;
  context: CreatorContext;
  validation: ValidationRequirements;
}

interface ArtifactSpec {
  name: string;           // kebab-case identifier
  type: ArtifactType;     // "agent" | "skill" | "prompt" | "instruction"
  path: string;           // relative path, e.g., ".github/agents/reviewer.agent.md"
  skill: CreatorSkill;    // "agent-creator" | "skill-creator" | "prompt-creator" | "instruction-creator"
  tools: string[];        // Tool names for agents, empty for others
  constraints: string[];  // ["C1", "C2"] constraint labels
  complexity: Complexity; // "L0" | "L1" | "L2"
}

interface CreatorContext {
  projectBrief: string;           // Relevant excerpt from project brief
  constraintText: string[];       // Full text of applicable constraints
  relatedArtifacts: RelatedArtifact[];  // Already-created artifacts
  refSummaries: RefSummary[];     // Relevant reference summaries (from Interview)
}

interface RelatedArtifact {
  path: string;           // Path of created artifact
  type: ArtifactType;     // Type for context
  summary: string;        // 1-2 sentence description
}

interface RefSummary {
  src: string;            // URL or path
  tags: string[];         // Associated tags
  summary: string;        // Brain-generated summary
}

interface ValidationRequirements {
  targetComplexity: Complexity;   // Expected output complexity
  mustInclude: string[];          // Elements from constraints (Iron Laws, boundaries)
  skipChecks: string[];           // Validation checks to skip (default: [])
}

type ArtifactType = "agent" | "skill" | "prompt" | "instruction";
type CreatorSkill = "agent-creator" | "skill-creator" | "prompt-creator" | "instruction-creator";
type Complexity = "L0" | "L1" | "L2";
```

### Payload Delivery

Master spawns Creator as subagent with payload in conversation context:

```markdown
Create artifact using skill.

**Artifact Specification:**
- Name: [name]
- Type: [type]
- Path: [path]
- Skill: [skill]
- Complexity: [complexity]
- Tools: [tools list or "none"]
- Constraints: [C1, C2 or "none"]

**Constraint Details:**
- C1: [full constraint text]
- C2: [full constraint text]

**Project Context:**
[relevant excerpt from project brief]

**Related Artifacts:**
- [path]: [summary]
- [path]: [summary]
(or "None yet")

**Reference Summaries:**
[if applicable, summaries from Interview's @brain processing]

**Requirements:**
- Target complexity: [L0|L1|L2]
- Must include: [elements from constraints]
```

### Payload Guarantees

Creator can trust Master validated:

- Skill exists in `.github/skills/`
- Path does not overwrite existing file (or user approved)
- Constraints are valid labels from Interview
- Related artifacts exist and were successfully created

### Payload Does NOT Guarantee

Creator must handle:

- Context may be insufficient (skill may need clarification)
- Complexity may be under/over-estimated
- Constraints may conflict (skill resolves conflicts)

---

## Skill Loading

### Skill Discovery

Creator locates skill files at fixed paths:

```
.github/skills/[skill-name]/
├── SKILL.md              # Required: Main skill file
├── references/           # Optional: JIT-loaded context
│   ├── decision-rules.md
│   ├── structure-reference.md
│   └── validation-checklist.md
└── assets/               # Optional: Templates, examples
    ├── example-skeleton.md
    └── example-*.md
```

### Loading Sequence

```
1. Read SKILL.md from .github/skills/[skill]/SKILL.md
2. Parse frontmatter for name, description
3. Identify steps in ## Process section
4. Execute steps in order
5. Load references when skill directs: "Load [file] for:"
6. Use assets when skill directs: "Use template from [file]"
```

### Missing Skill Handling

| Scenario | Action |
|----------|--------|
| SKILL.md missing | Return failed status, error: "Skill not found: [skill]" |
| Reference file missing | Continue without, log warning |
| Asset file missing | Return failed status, error: "Required asset missing: [file]" |

---

## Artifact Generation

### Skill Workflow Execution

Creator executes skill steps sequentially as an interpretation loop:

```
For each step in SKILL.md:
  1. Read step instructions
  2. If step contains "Load [file]": read referenced file
  3. Apply step logic to build artifact
  4. If decision gate requires user input: make best inference, log warning
  5. Track decisions made for validation report
```

### Step Types

**Classification steps:**
- Confirm artifact type matches skill
- If mismatch: Return failed status with reason

**Extraction steps:**
- Pull elements from payload context
- Apply defaults from skill when context missing

**Decision steps:**
- Load decision-rules.md from skill references
- Map payload elements to skill-defined rules
- Select options based on constraints

**Drafting steps:**
- Build artifact structure layer by layer
- Apply complexity requirements (L0/L1/L2)
- Use assets as templates when specified

**Validation steps:**
- Load validation-checklist.md from skill references
- Execute each check
- Record pass/fail with severity

### Decision Gate Handling

Skills may include decision gates that normally require user input:

```markdown
If unclear, ask user: "What is the primary responsibility?"
```

**Creator behavior:**

| Scenario | Action |
|----------|--------|
| Context provides answer | Use context, proceed |
| Default available | Use default, log warning: "Inferred [X] from [reason]" |
| No default, critical | Return partial status, list ambiguities |
| No default, non-critical | Make reasonable inference, log warning |

**Inference rules:**
- Prefer explicit constraints over inference
- Prefer related artifact patterns over generic defaults
- Document all inferences in validation report

---

## Validation

### Validation Execution

Creator runs skill's validation checklist after drafting:

```
1. Load references/validation-checklist.md
2. Execute Quick Check (P1 blockers)
3. If any P1 fails: attempt auto-fix, re-check
4. Execute P2 checks (required quality)
5. Optionally execute P3 checks (enhancements)
6. Build ValidationReport
```

### ValidationReport Schema

```typescript
interface ValidationReport {
  skillUsed: string;              // Skill name for traceability
  checksRun: number;              // Total checks executed
  checksPassed: number;           // Checks that passed
  checksFailed: number;           // Checks that failed
  failures: ValidationFailure[];  // Failed check details
  warnings: ValidationWarning[];  // Non-blocking issues
  inferences: Inference[];        // Decisions made without explicit input
}

interface ValidationFailure {
  check: string;                  // Check name/description
  severity: "P1" | "P2" | "P3";   // Priority level
  message: string;                // Failure explanation
  autoFixAttempted: boolean;      // Whether auto-fix was tried
  autoFixSucceeded: boolean;      // Whether auto-fix worked
}

interface ValidationWarning {
  category: string;               // Warning category
  message: string;                // Warning details
}

interface Inference {
  decision: string;               // What was decided
  reason: string;                 // Why this inference was made
  confidence: "high" | "medium" | "low";  // Confidence level
}
```

### Pass/Fail Threshold

| P1 Failures | P2 Failures | Status |
|-------------|-------------|--------|
| 0 | 0-2 | success |
| 0 | 3+ | partial |
| 1+ | any | failed |

**Rationale:**
- P1 are blockers — any failure invalidates artifact
- P2 are quality — few failures acceptable with warnings
- P3 are enhancements — not counted toward threshold

---

## Output Contract (to Master)

### CreatorResult Schema

```typescript
interface CreatorResult {
  status: CreatorStatus;
  artifact: ArtifactOutput;
  validation: ValidationReport;
  metadata: CreatorMetadata;
}

type CreatorStatus = "success" | "partial" | "failed";

interface ArtifactOutput {
  path: string;                   // Expected path (echoed from input)
  content: string;                // Full artifact content as markdown string
  contentLength: number;          // Character count
  lineCount: number;              // Line count
}

interface CreatorMetadata {
  skillUsed: string;              // Skill that generated artifact
  complexityAchieved: Complexity; // Actual complexity of output
  stepsExecuted: number;          // Steps completed
  referencesLoaded: string[];     // Reference files loaded
  assetsUsed: string[];           // Asset files used
  durationEstimate: string;       // Rough execution time
}
```

### Status Definitions

**success:**
- Artifact fully generated
- All P1 checks pass
- ≤2 P2 checks failed
- Content is non-empty and valid markdown

**partial:**
- Artifact generated but incomplete
- All P1 checks pass
- 3+ P2 checks failed OR
- Decision gates required inference with low confidence
- Content may need manual review

**failed:**
- Artifact could not be generated
- P1 check failed OR
- Skill not found OR
- Critical ambiguity unresolvable
- Content may be empty or invalid

### Result Message Template

Creator returns result in structured format:

```markdown
## Creator Result

**Status:** [success|partial|failed]

### Artifact
- Path: [path]
- Length: [X] characters, [Y] lines
- Complexity achieved: [L0|L1|L2]

### Validation Summary
- Checks run: [N]
- Passed: [N]
- Failed: [N]

#### Failures (if any)
- [P1|P2|P3] [check]: [message]

#### Warnings (if any)
- [category]: [message]

#### Inferences Made (if any)
- [decision] — [reason] (confidence: [high|medium|low])

### Artifact Content

```markdown
[full artifact content]
```
```

---

## Error Handling

### Error Categories

| Category | Cause | Response |
|----------|-------|----------|
| Skill not found | `.github/skills/[skill]/SKILL.md` missing | Return failed, error message |
| Asset missing | Required template file missing | Return failed, specify missing file |
| Classification mismatch | Spec type doesn't match skill type | Return failed, suggest correct skill |
| Critical ambiguity | Cannot infer required element | Return partial, list ambiguities |
| Validation blocker | P1 check failed after auto-fix attempt | Return failed, detail failure |
| Content generation error | Skill step produced invalid output | Return failed, specify step |

### User Input Scenarios

Skills may prompt for user input. Creator handles without user access:

| Skill Prompt | Creator Behavior |
|--------------|------------------|
| "What is the primary responsibility?" | Infer from projectBrief, log inference |
| "Confirm agent?" (classification) | Check ArtifactSpec.type matches, proceed if yes |
| "Which domain: [A] or [B]?" | Select based on constraints/context, log choice |
| "Will this modify files?" | Check if tools include edit/delete, infer |

### Partial Results

When returning `partial` status:

- Include all generated content
- Mark incomplete sections with `<!-- TODO: [what's missing] -->`
- List specific items needing resolution in warnings
- Provide confidence assessment for inferences

### Error Escalation

Creator does NOT:
- Retry on failure (Master handles retry)
- Prompt user (Master handles user interaction)
- Make destructive assumptions (prefer partial over bad guess)

---

## Skill Interaction Patterns

### Standard Skill Structure

All creator skills follow 6-step pattern:

```
Step 1: Classify — Confirm artifact type
Step 2: Extract/Name — Pull elements from context
Step 3: Decide/Assess — Apply decision rules
Step 4: Draft — Build artifact content
Step 5: Validate — Run checklist
Step 6: Integrate — Add ecosystem connections
```

### Reference Loading Pattern

Skills use explicit loading directives:

```markdown
Load [file] for:
- [bullet 1]
- [bullet 2]
```

Creator loads file content when encountering directive.

### Asset Usage Pattern

Skills reference templates:

```markdown
Use template from [file]
Use `assets/example-skeleton.md` as base
```

Creator reads asset and uses as foundation.

### Cross-Reference Pattern

Skills link to references without auto-loading:

```markdown
See [validation-checklist.md](references/validation-checklist.md)
```

Creator follows link only when validation step executes.

---

## Interface Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                          Creator Agent                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────────────┐ │
│  │   Receive    │────▶│    Load      │────▶│  Execute Workflow    │ │
│  │   Payload    │     │    Skill     │     │  Step by Step        │ │
│  └──────────────┘     └──────────────┘     └──────────────────────┘ │
│         │                    │                        │              │
│         ▼                    ▼                        ▼              │
│  CreatorPayload       SKILL.md +            Draft artifact          │
│  from Master          references            layer by layer          │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │                    Generation Loop                            │   │
│  │  ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐   │   │
│  │  │ Classify│───▶│ Extract │───▶│ Decide  │───▶│  Draft  │   │   │
│  │  │  (S1)   │    │  (S2)   │    │  (S3)   │    │  (S4)   │   │   │
│  │  └─────────┘    └─────────┘    └─────────┘    └─────────┘   │   │
│  │       │              │              │              │         │   │
│  │       ▼              ▼              ▼              ▼         │   │
│  │    Type OK?      Elements       Decisions       Content      │   │
│  │    If no: fail   + defaults     + rules         layers      │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────────────┐ │
│  │   Validate   │────▶│   Build      │────▶│   Return Result      │ │
│  │   (S5)       │     │   Result     │     │   to Master          │ │
│  └──────────────┘     └──────────────┘     └──────────────────────┘ │
│         │                    │                        │              │
│         ▼                    ▼                        ▼              │
│  Run P1/P2/P3         CreatorResult            Subagent return      │
│  checklist            assembly                                       │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘

External Interfaces:
───────────────────
← CreatorPayload (subagent spawn from Master)
← Skill files (filesystem read)
→ CreatorResult (subagent return to Master)
```

---

## Invocation Examples

### Example 1: Agent Creation (Success)

**Input payload:**
```typescript
{
  artifact: {
    name: "code-reviewer",
    type: "agent",
    path: ".github/agents/code-reviewer.agent.md",
    skill: "agent-creator",
    tools: ["codebase", "problems", "usages"],
    constraints: ["C1", "C3"],
    complexity: "L1"
  },
  context: {
    projectBrief: "TypeScript web app. Needs code quality enforcement...",
    constraintText: [
      "C1: All reviews must check for security issues",
      "C3: Never auto-approve PRs"
    ],
    relatedArtifacts: [],
    refSummaries: []
  },
  validation: {
    targetComplexity: "L1",
    mustInclude: ["security check in boundaries", "no-auto-approve in iron_law"],
    skipChecks: []
  }
}
```

**Expected result:**
```typescript
{
  status: "success",
  artifact: {
    path: ".github/agents/code-reviewer.agent.md",
    content: "---\nname: code-reviewer\n...",
    contentLength: 4500,
    lineCount: 180
  },
  validation: {
    skillUsed: "agent-creator",
    checksRun: 25,
    checksPassed: 25,
    checksFailed: 0,
    failures: [],
    warnings: [],
    inferences: []
  },
  metadata: {
    skillUsed: "agent-creator",
    complexityAchieved: "L1",
    stepsExecuted: 6,
    referencesLoaded: ["decision-rules.md", "structure-reference.md", "validation-checklist.md"],
    assetsUsed: ["example-skeleton.md"],
    durationEstimate: "~30s"
  }
}
```

### Example 2: Skill Creation (Partial)

**Scenario:** Ambiguous capability description

**Input payload:**
```typescript
{
  artifact: {
    name: "data-processor",
    type: "skill",
    path: ".github/skills/data-processor/SKILL.md",
    skill: "skill-creator",
    tools: [],
    constraints: [],
    complexity: "L0"
  },
  context: {
    projectBrief: "Data pipeline project. Process various data formats.",
    constraintText: [],
    relatedArtifacts: [],
    refSummaries: []
  },
  validation: {
    targetComplexity: "L0",
    mustInclude: [],
    skipChecks: []
  }
}
```

**Expected result:**
```typescript
{
  status: "partial",
  artifact: {
    path: ".github/skills/data-processor/SKILL.md",
    content: "---\nname: data-processor\n...\n<!-- TODO: Clarify data formats supported -->",
    contentLength: 1200,
    lineCount: 60
  },
  validation: {
    skillUsed: "skill-creator",
    checksRun: 12,
    checksPassed: 9,
    checksFailed: 3,
    failures: [
      { check: "Description has specific trigger phrases", severity: "P2", message: "Trigger too generic", autoFixAttempted: true, autoFixSucceeded: false }
    ],
    warnings: [
      { category: "ambiguity", message: "Data formats not specified in context" }
    ],
    inferences: [
      { decision: "Support JSON and CSV", reason: "Common formats for data pipelines", confidence: "medium" }
    ]
  },
  metadata: {
    skillUsed: "skill-creator",
    complexityAchieved: "L0",
    stepsExecuted: 6,
    referencesLoaded: ["structure-reference.md", "validation-checklist.md"],
    assetsUsed: ["example-skeleton.md"],
    durationEstimate: "~20s"
  }
}
```

### Example 3: Missing Skill (Failed)

**Scenario:** Skill folder doesn't exist

**Expected result:**
```typescript
{
  status: "failed",
  artifact: {
    path: ".github/prompts/unknown.prompt.md",
    content: "",
    contentLength: 0,
    lineCount: 0
  },
  validation: {
    skillUsed: "unknown-creator",
    checksRun: 0,
    checksPassed: 0,
    checksFailed: 0,
    failures: [],
    warnings: [],
    inferences: []
  },
  metadata: {
    skillUsed: "unknown-creator",
    complexityAchieved: "L0",
    stepsExecuted: 0,
    referencesLoaded: [],
    assetsUsed: [],
    durationEstimate: "~1s"
  }
}
// Error: "Skill not found: .github/skills/unknown-creator/SKILL.md"
```

---

## Cross-References

- Master contract: [07-master-agent-interface-contract.md](07-master-agent-interface-contract.md)
- Interview contract: [06-interview-interface-contract.md](06-interview-interface-contract.md)
- Generator architecture: [../generator/generator.md](../generator/generator.md)
- Creator skills:
  - [agent-creator](../.github/skills/agent-creator/SKILL.md)
  - [skill-creator](../.github/skills/skill-creator/SKILL.md)
  - [prompt-creator](../.github/skills/prompt-creator/SKILL.md)
  - [instruction-creator](../.github/skills/instruction-creator/SKILL.md)
