# Interview Agent Interface Contract

Formal specification of Interview agent outputs for downstream agent consumption.

---

## Output Artifacts

Interview produces **one conversational output** (not written to disk):

| Artifact | Format | Written | Purpose |
|----------|--------|---------|---------|
| Project Brief + Execution Manifest | Markdown (inline in chat) | No | Consumed by downstream agents via handoff payload |

**Key characteristic:** Interview does NOT write files. The brief exists in conversation context until approved, then is passed as handoff payload to @architect or @build.

---

## Project Brief Structure

### Format

Plain Markdown with these sections in order:

```
## Sources Consulted
## Existing Artifacts
# Project Brief: [Name]
## Overview
## Tech Stack
## Key Workflows (prioritized)
## Constraints
## Execution Manifest
## Constraint Propagation
## Approval
```

### Section Details

<sections>

#### Sources Consulted (Optional)

**Format:** Collapsible `<details>` with Markdown table

**Fields:**
- `Source` — URL or path from `<refs>`
- `Tags` — Space-separated tags from user or inferred
- `Summary` — Brain-generated summary (≤3 bullets condensed)

**Present if:** User provided `<refs>` in questionnaire

---

#### Existing Artifacts (Required)

**Format:** Bullet list or prose

**Content:** Artifacts found in `.github/agents/`, `.github/prompts/`, `.github/skills/`, `.github/instructions/`

**Default if none:** "None found - starting fresh"

---

#### Project Brief Header (Required)

**Format:** H1 with project name

**Value:** `# Project Brief: [Name]` where Name comes from `<name>` field

---

#### Overview (Required)

**Format:** 2-3 sentences prose

**Source:** `<description>` field, expanded with context from clarification

---

#### Tech Stack (Required)

**Format:** Bullet list

**Source:** `<tech>` field items

**Default if empty:** Inferred from workspace (package.json, pyproject.toml)

---

#### Key Workflows (Required)

**Format:** Numbered list with priority and goal

**Structure per item:**
```
N. [Workflow name] (priority) — [Goal: why this matters]
```

**Requirements:**
- Minimum 2 workflows
- Each has associated goal (extracted during clarification)
- Priority indicated (high/medium/low or "priority" marker)

---

#### Constraints (Required)

**Format:** Labeled bullet list

**Structure:**
```
- **C1:** [Constraint verbatim from user]
- **C2:** [Constraint verbatim from user]
```

**Rules:**
- Use sequential labels (C1, C2, C3...)
- Preserve user's exact wording
- Max 10 constraints

---

#### Execution Manifest (Required)

**Format:** Markdown table

**Columns:**
| Column | Type | Description |
|--------|------|-------------|
| Artifact | string | kebab-case artifact name |
| Type | enum | `agent`, `skill`, `prompt`, `instruction` |
| Path | string | Target file location (e.g., `.github/agents/[name].agent.md`) |
| Skill | string | Creator skill to invoke (`agent-creator`, `skill-creator`, `prompt-creator`, `instruction-creator`) |
| Tools | string | Comma-separated tool list (agents only), `—` for others |
| Constraints | string | Applicable constraint labels (e.g., `C1, C2`), `—` if none |
| Complexity | enum | `L0`, `L1`, `L2` |

**Path patterns:**
- Agent: `.github/agents/[name].agent.md`
- Instruction: `.github/instructions/[name].instructions.md`
- Skill: `.github/skills/[name]/SKILL.md`
- Prompt: `.github/prompts/[name].prompt.md`

**Complexity levels:**
- `L0` — Single-file artifact, no references needed
- `L1` — May need 1-2 reference files for context
- `L2` — Full integration layer with references/ folder, multiple dependencies

---

#### Constraint Propagation (Required)

**Format:** Bullet list mapping constraints to artifacts

**Structure:**
```
- **C1:** [Constraint text] → Applies to: [artifact1], [artifact2]
```

**Purpose:** Tells build agent which Iron Laws or boundary rules to embed in which artifacts

---

#### Approval (Required)

**Format:** Prose with instructions

**Content:** Approval prompt + partial approval syntax

**Fixed text:**
```
Ready to proceed? Reply "approved" or request changes.

To modify specific items: "Approve 1-4, change 5 to instruction instead of agent"
```

</sections>

---

## Execution Manifest Schema

Formal schema for the manifest table (for parsing by downstream agents):

```typescript
interface ExecutionManifest {
  artifacts: ArtifactSpec[];
}

interface ArtifactSpec {
  name: string;           // kebab-case identifier
  type: ArtifactType;     // enum
  path: string;           // relative to workspace root
  skill: CreatorSkill;    // which skill generates this
  tools: string[];        // empty array for non-agents
  constraints: string[];  // ["C1", "C2"] or empty
  complexity: Complexity; // enum
}

type ArtifactType = "agent" | "skill" | "prompt" | "instruction";

type CreatorSkill = 
  | "agent-creator" 
  | "skill-creator" 
  | "prompt-creator" 
  | "instruction-creator";

type Complexity = "L0" | "L1" | "L2";
```

---

## Handoff Payload

### Defined Handoffs

Interview declares two handoffs in frontmatter:

| Label | Target | Trigger | Auto-send |
|-------|--------|---------|-----------|
| Create Plan | @architect | User wants planning before build | No |
| Start Generation | @build | User wants direct generation | No |

### Payload Contents

Handoff includes (per `<outputs>` section):

1. **Full execution manifest table** — Complete artifact specs
2. **Constraint propagation mapping** — C1→artifacts, C2→artifacts
3. **Ref summaries** — Brain-generated summaries (if refs provided)
4. **Existing artifact context** — Whether extending, replacing, or fresh
5. **User notes** — Verbatim, with extracted suggestions highlighted

### Handoff Prompt Templates

**To @architect:**
```
Project interview complete. Requirements in projectbrief.md. 
Create implementation plan for generating the recommended artifacts.
```

**To @build:**
```
Project brief approved. Generate artifacts per the manifest in projectbrief.md. 
Validate each against its checklist.
```

**Note:** Prompt mentions "projectbrief.md" but Interview does NOT write this file. The brief exists in conversation context only.

---

## Validation State

### Pre-Handoff Validation

Interview performs these validations before presenting brief:

| Check | Validated | Enforcement |
|-------|-----------|-------------|
| Required fields present | Yes | Blocks synthesis |
| Name is kebab-case | Yes | Error surfaced |
| Description ≥10 chars | Yes | Error surfaced |
| ≥2 workflows with goals | Yes | Clarify mode until satisfied |
| Constraints ≤10 | Yes | Asks to prioritize |
| Refs ≤9 | Yes | Asks to prioritize |
| Artifact-workflow mapping | Yes | Every artifact tied to user workflow |
| Constraint propagation | Yes | Every constraint mapped to artifacts |

### What Downstream Agents Can Trust

**Trustable:**
- Name is valid kebab-case
- Description exists and is meaningful
- At least 2 workflows present
- Each artifact has valid type, path, skill, complexity
- Constraints are mapped to artifacts

**NOT Validated:**
- Paths do not already exist (build must check)
- Skills exist (assumed to be available)
- Tools are valid for artifact type (no schema validation)
- Complexity assessment is accurate (Interview's judgment)

### Approval Gate

Interview implements a **HARD gate** before handoff:
- User MUST say "approved" or equivalent
- User CAN request partial approval: "Approve 1-4, change 5 to instruction"
- Interview NEVER auto-hands-off

---

## Gaps and Ambiguities

### Identified Issues

<gap id="1" severity="high">

**Brief not persisted**

Interview's handoff prompt says "Requirements in projectbrief.md" but Interview does not write files. Either:
- Master agent must write the brief before calling @build
- Handoff payload must be sufficient for @build to operate without file

**Recommendation:** Master writes `projectbrief.md` from handoff payload before invoking build.

</gap>

<gap id="2" severity="medium">

**Manifest format is Markdown table**

Downstream agents must parse Markdown table to extract artifact specs. No structured data format (JSON/YAML).

**Recommendation:** Define canonical parsing rules or add structured frontmatter to brief.

</gap>

<gap id="3" severity="medium">

**Handoff payload not formally structured**

The five payload items are described in prose, not schema. No guarantee of field presence.

**Recommendation:** Define explicit handoff schema:
```typescript
interface InterviewHandoff {
  manifest: ExecutionManifest;
  constraintMapping: Record<string, string[]>;
  refSummaries: RefSummary[] | null;
  existingArtifacts: string[];
  userNotes: string | null;
}
```

</gap>

<gap id="4" severity="low">

**Partial approval handling unclear**

User can say "Approve 1-4, change 5 to instruction" but:
- What happens to unapproved items?
- Does Interview re-present or iterate?
- Is there a loop limit?

**Recommendation:** Define partial approval flow explicitly.

</gap>

<gap id="5" severity="low">

**Existing artifacts: extend vs replace**

Interview asks "Extend these, replace them, or start fresh?" but:
- How is this decision encoded in the manifest?
- Does build agent know which artifacts to extend vs create?

**Recommendation:** Add `mode: "extend" | "replace" | "new"` to ArtifactSpec.

</gap>

---

## Interface Contract Summary

```
┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│  Interview  │────────▶│   Master    │────────▶│   Build     │
└─────────────┘         └─────────────┘         └─────────────┘
       │                       │                       │
       │  Handoff Payload      │  projectbrief.md      │
       │  (conversation)       │  (persisted file)     │
       │                       │                       │
       ▼                       ▼                       ▼
  - Manifest table        - Writes brief          - Reads brief
  - Constraint map        - Routes to build       - Iterates manifest
  - Ref summaries         - Or routes to          - Invokes creator
  - Existing artifacts      architect               skills per row
  - User notes            - Tracks progress       - Validates output
```

**Contract guarantees:**
1. Interview outputs are validated for completeness
2. Every artifact in manifest has required fields
3. Every constraint is mapped to ≥1 artifact
4. User explicitly approved before handoff
5. Handoff payload contains all info needed to write brief

**Contract does NOT guarantee:**
1. Paths are unique (downstream must check)
2. Skills will succeed (downstream must handle failures)
3. Complexity is accurate (estimate only)
4. Brief is persisted (Master's responsibility)

---

## Cross-References

- [interview.agent.md](../.github/agents/interview.agent.md) — Source agent definition
- [05-core-agent-pack-design.md](05-core-agent-pack-design.md) — Core agent architecture context
