# GENERATION-RULES Synthesis Reference

> **Date:** 2026-01-28 | **Status:** Active Reference  
> **Prompts:** `.github/prompts/*.prompt.md`  
> **State:** `workshop/synthesis-state/*.md`

---

## HARD RULES

> ⚠️ **Non-Negotiable** — These rules cannot be skipped or modified.

```
RULE_1: SUBAGENTS REQUIRED
  All analysis uses subagents. Brain orchestrates, subagents analyze.

RULE_2: ONE TASK PER SUBAGENT
  Each subagent gets exactly one source file or logical grouping.

RULE_3: CRITIQUE MANDATORY  
  Every synthesis includes a critique iteration that challenges decisions.

RULE_4: SAVE PROGRESS
  Update state file after every subagent returns. Never lose work.

RULE_5: NO HEDGING
  "You could" → "We do". Prescriptive, not exploratory.

RULE_6: PRIORITY STACK
  When conflicts: Safety > Clarity > Flexibility > Convenience
```

---

## Subagent Synthesis Workflow

**ALL synthesis tasks use subagents (self-loop).** Brain spawns brain subagents for fresh context. Orchestrator coordinates; subagents analyze; orchestrator synthesizes.

**Pattern:** `runSubagent(agentName: "brain", prompt: "...")`

### Workflow Phases

```
┌─────────────────────────────────────────────────────────────────┐
│ PHASE 1: PLANNING (Orchestrator)                                │
├─────────────────────────────────────────────────────────────────┤
│ 1. Read prompt file + synthesis-reference.md                    │
│ 2. Identify source files from prompt                            │
│ 3. Determine iteration count based on complexity                │
│ 4. Create state file with subagent task assignments             │
│ 5. Output: Iteration plan with subagent tasks                   │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ PHASE 2: ANALYSIS (Subagents — parallel when independent)       │
├─────────────────────────────────────────────────────────────────┤
│ Each subagent gets ONE source file or logical grouping:         │
│ • Read source file + its ## Related refs                        │
│ • Extract: purpose, capabilities, constraints, best practices   │
│ • Identify: conflicts, gaps, ambiguities                        │
│ • Output: Structured analysis (NOT prose)                       │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ PHASE 3: CRITIQUE (Subagent — fresh perspective)                │
├─────────────────────────────────────────────────────────────────┤
│ After analysis iterations, spawn critique subagent:             │
│ • Review accumulated decisions for contradictions               │
│ • Challenge assumptions — what might not be true?               │
│ • Identify gaps — what's missing?                               │
│ • Steel-man alternatives — strongest counter-argument?          │
│ • Output: Critique report with specific challenges              │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ PHASE 4: SYNTHESIS (Orchestrator)                               │
├─────────────────────────────────────────────────────────────────┤
│ Brain synthesizes all subagent outputs:                         │
│ • Resolve conflicts using priority hierarchy                    │
│ • Address critique findings                                     │
│ • Produce prescriptive output (no hedging)                      │
│ • Write final deliverable to output path                        │
│ • Update state file: Status: Complete                           │
└─────────────────────────────────────────────────────────────────┘
```

### Iteration Count by Complexity

| Complexity | Analysis Iterations | Critique Iterations | Total |
|------------|---------------------|---------------------|-------|
| **Low** | 2 (1-2 sources) | 0 | 2-3 |
| **Medium** | 3-4 (2-4 sources) | 1 | 4-5 |
| **High** | 4-6 (4+ sources) | 1-2 | 5-8 |

### Subagent Task Template

When spawning a subagent, use this structure:

```markdown
**Task:** Analyze {source-file.md} for {deliverable}

**Context:**
- Deliverable: {what we're building}
- Your focus: {specific aspect to analyze}

**Source Files:**
- Primary: {source-file.md}
- Follow: All ## Related refs in that file

**Extract:**
1. PURPOSE — Why does this component exist?
2. CAPABILITIES — What can it do?
3. CONSTRAINTS — Limits, size caps, required fields
4. BEST PRACTICES — Synthesized wisdom (with rationale)
5. ANTI-PATTERNS — What to avoid (with "why")
6. CONFLICTS — Anything contradicting other sources?
7. GAPS — Anything missing or ambiguous?

**Output Format:**
Return structured analysis (use headers above). NO prose summaries.
Be prescriptive: "This component MUST..." not "This component can..."
```

### Critique Subagent Template

```markdown
**Task:** Critique synthesis decisions for {deliverable}

**Context:**
Decisions so far:
{paste D1, D2, D3... from state file}

**Challenge:**
1. CONTRADICTIONS — Do any decisions conflict?
2. ASSUMPTIONS — What are we assuming that might not be true?
3. GAPS — What haven't we considered?
4. STEEL-MAN — Strongest argument AGAINST our approach?
5. PRE-MORTEM — "6 months later this failed. Why?"

**Output Format:**
| # | Challenge | Severity | Recommendation |
|---|-----------|----------|----------------|
| C1 | ... | 🔴 High / 🟡 Medium / 🟢 Low | ... |

Return table + brief rationale per item. Orchestrator decides resolution.
```

### State File Updates

Update state file after EVERY subagent returns:

```markdown
## Iteration Log

### Iteration 1: Agent Analysis
**Subagent:** @brain (self-loop)
**Task:** Analyze agent-file-format.md
**Output:** [summary of key findings]
**Decisions:** D1, D2

### Iteration 2: Skill Analysis
**Subagent:** @brain (self-loop)
**Task:** Analyze skills-format.md
**Output:** [summary of key findings]
**Decisions:** D3, D4

### Iteration 3: Critique
**Subagent:** @brain (critique mode)
**Challenges:** C1 (🟡), C2 (🟢)
**Resolution:** C1 addressed in D5
```

---

## Hard Rules

### Process Rules
1. **NAVIGATE** via `cookbook/INDEX.yaml`, `cookbook/README.md`, and `## Related` sections
2. **FOLLOW EVERY LINK** — missing a file = missing critical context
3. **ONE DELIVERABLE = ONE SESSION** — user invokes each synthesis separately
4. **SET ITERATION COUNT FIRST** — determine iterations based on complexity before starting
5. **SAVE PROGRESS** — update state file every 2-3 iterations; context loss is unacceptable
6. **NO SELF-LIMITING** — if it matters, do it; depth over speed

### Quality Rules
7. **STOP ON MISSING** — if a linked file cannot be found, STOP and report. Do not assume content.
8. **WHY > WHAT** — every decision MUST include rationale. A decision without "why" is incomplete.
9. **CHAIN DECISIONS** — reference prior decisions by ID (e.g., "Per D3 in agent-patterns..."). State files form a decision graph.
10. **DONE = CHECKLIST PASSES** — a deliverable is complete when ALL quality criteria are verifiable ✅

### Synthesis Rules  
11. **SYNTHESIZE CRITICALLY** — cookbook files are inputs, not gospel. Challenge, identify contradictions, resolve.
12. **RESOLVE CONFLICTS BY PRIORITY** — when sources contradict: **Safety > Clarity > Flexibility > Convenience**. Document rejected approach.
13. **TRACE TO SOURCE** — every MUST/MUST NOT must trace to cookbook source, framework priority, or documented decision. No orphan rules.
14. **NO HEDGING** — every "you could" → "we do". Every "consider" → "always" or "never". Framework is prescriptive.
15. **SELF-LOOP SUBAGENTS** — ALL synthesis uses brain→brain subagents. Fresh context window, same capabilities. `runSubagent(agentName: "brain", ...)`
16. **ONE TASK PER SUBAGENT** — each subagent gets exactly ONE source file or logical grouping. Never mix contexts.
17. **CRITIQUE MANDATORY** — High/Medium complexity requires at least 1 critique iteration. Spawn fresh brain subagent to challenge decisions.

---

## Error Handling

| Error | Action |
|-------|--------|
| Source file missing | **STOP.** Report to user. Do not proceed with incomplete sources. |
| Related link broken | Note in state file. Continue if non-critical. **STOP** if critical source. |
| State file corrupted | Create fresh state file. Note: "Restarting due to corruption." |
| Conflict unresolvable | Escalate to user with both options + tradeoffs. |

---

## Core Intent

**We are DESIGNING A FRAMEWORK, not documenting options.**

```
Cookbook = 52 files of patterns/options (descriptive)
GENERATION-RULES = THE way our framework works (prescriptive)
```

Every "you can do A or B" becomes "our framework does X" — synthesized from best elements.

---

## Source of Truth

**Cookbook files ONLY.** Current agents are NOT authoritative — they will be rewritten.

Navigate via: `cookbook/INDEX.yaml` → `cookbook/README.md` → `## Related` sections

---

## Output Structure

```
GENERATION-RULES/                    # Root level
├── README.md
├── COMPONENT-MATRIX.md
├── RULES.md
├── NAMING.md
├── SETTINGS.md
├── WORKFLOW-GUIDE.md
├── PATTERNS/                        # 9 pattern files
├── TEMPLATES/                       # 6 skeleton files
└── CHECKLISTS/                      # 8 checklist files
```

---

## Pattern File Format

**ALL deliverables in GENERATION-RULES/ MUST follow this agent-optimized format.**

### Required YAML Frontmatter

```yaml
---
type: decision-matrix | patterns | rules | checklist | template
version: 1.0.0
purpose: One-line description of what this file decides/defines
applies-to: [generator, build, inspect, architect]  # Which agents use this
last-updated: YYYY-MM-DD
---
```

### Required Sections (in order)

```markdown
# {Title}

> **{One-line summary}**

---

## HOW TO USE THIS FILE

**For Generator Agents:**
{How generator agents should parse/use this file}

**For Build Agents:**
{How build agents should reference this file}

**For Inspect Agents:**
{What inspect agents should validate against this file}

---

## PURPOSE
{Why this file exists. What decisions it makes.}

---

## DECISION RULES (Machine-Parseable)

### Primary Selection Logic
{IF-THEN-ELSE rules in pseudocode — NOT prose}

```
IF condition_a OR condition_b
  THEN → CHOICE_1
ELSE IF condition_c
  THEN → CHOICE_2
ELSE
  THEN → DEFAULT
```

### Criteria Definitions
{Table mapping criterion names to "True When" definitions}

| Criterion | True When |
|-----------|----------|
| `criterion_name` | Specific condition description |

---

## VALIDATION RULES
{REQUIRE/REJECT rules for each choice — machine parseable}

```
VALID_{CHOICE}_SELECTION:
  REQUIRE at_least_one_of:
    - criterion_a
    - criterion_b
  REJECT_IF:
    - anti_pattern_condition → use ALTERNATIVE instead
```

---

## {Domain-Specific Sections}
{Capability matrices, constraint tables, use-case mappings, etc.}
{Use TABLES not prose. Use STRUCTURED formats not paragraphs.}

---

## ANTI-PATTERNS

| ❌ Don't | ✅ Instead | Why |
|----------|-----------|-----|
| {bad practice} | {correct approach} | {consequence of bad practice} |

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| `path/to/file.md` | How this file relates |

---

## SOURCES

- [source-file.md](path) — What was extracted from it
```

### Format Principles

| Principle | Rationale |
|-----------|-----------|
| **YAML frontmatter** | Agents can quickly identify file purpose without parsing body |
| **HOW TO USE section** | Different agents have different needs — make explicit |
| **IF-THEN pseudocode** | Machine-parseable; no ambiguity in decision logic |
| **Tables over prose** | Structured data is easier to extract than paragraphs |
| **VALIDATION rules** | Enable inspect agents to verify correct usage |
| **CROSS-REFERENCES** | Enable navigation without hardcoded paths |

### What NOT To Do

| ❌ Avoid | ✅ Use Instead |
|---------|---------------|
| ASCII art flowcharts only | Pseudocode rules + optional visual |
| Bullet lists for decisions | IF-THEN logic + tables |
| Prose paragraphs | Structured tables and code blocks |
| Implicit assumptions | Explicit CRITERIA DEFINITIONS |
| "Consider..." / "You could..." | "IF X THEN Y" / "REQUIRE" |

---

## Decision Matrix File Format

For files like COMPONENT-MATRIX.md that choose between options:

```markdown
---
type: decision-matrix
version: X.X.X
purpose: {What decision this matrix makes}
applies-to: [generator, build, inspect]
last-updated: YYYY-MM-DD
---

# {Title}

## HOW TO USE THIS FILE
{Agent-specific usage instructions}

## DECISION RULES (Machine-Parseable)
{IF-THEN selection logic}

## VALIDATION RULES
{REQUIRE/REJECT for each option}

## CAPABILITY MATRIX
{What each option can/cannot do — TABLE format}

## CONSTRAINT MATRIX
{Limits for each option — TABLE format}

## USE-CASE MAPPING
{Scenario → Option mapping — TABLE format}

## ANTI-PATTERNS
{Don't/Instead/Why — TABLE format}

## CROSS-REFERENCES
{Related files}

## SOURCES
{Where rules came from}
```

---

## Pattern File Format (Non-Matrix)

For files like agent-patterns.md that define HOW to create something:

```markdown
---
type: patterns
version: X.X.X
purpose: {What this pattern file teaches}
applies-to: [generator, build, inspect]
last-updated: YYYY-MM-DD
---

# {Component} Patterns

## HOW TO USE THIS FILE
{Agent-specific usage instructions}

## PURPOSE
{Why this component exists. When to create it.}

## THE FRAMEWORK APPROACH
{THE single approach — not options}

## STRUCTURE

### Required Sections
| Section | Purpose | Required |
|---------|---------|----------|
| {section} | {why needed} | ✅ / ⚠️ |

### Section Order
```
1. {first section}
2. {second section}
...
```

## AUTHORING RULES

```
RULE_001: {rule name}
  REQUIRE: {what must be present}
  REJECT_IF: {what invalidates}
  EXAMPLE_VALID: {good example}
  EXAMPLE_INVALID: {bad example}
```

## VALIDATION CHECKLIST

```
VALIDATE_{component}:
  □ Has required frontmatter fields
  □ Has required sections in order
  □ Follows RULE_001
  □ Follows RULE_002
  ...
```

## ANTI-PATTERNS
| ❌ Don't | ✅ Instead | Why |

## EXAMPLES

### Minimal Valid Example
{Smallest complete example}

### Full Example
{Comprehensive example}

## CROSS-REFERENCES
| Related File | Relationship |

## SOURCES
{Where patterns came from}
```

---

## State File Format

```markdown
# Synthesis State: {deliverable}

**Status:** Planning | Analyzing | Critiquing | Synthesizing | Complete
**Progress:** ████████░░ 80%
**Iteration:** 5 of 7
**Next Decision #:** D12

## Iteration Plan

| # | Phase | Task | Subagent | Status |
|---|-------|------|----------|--------|
| 1 | Analysis | Analyze {source1.md} | @brain | ✅ Done |
| 2 | Analysis | Analyze {source2.md} | @brain | ✅ Done |
| 3 | Analysis | Analyze {source3.md} | @brain | 🔄 In Progress |
| 4 | Analysis | Analyze {source4.md} | @brain | ⏳ Pending |
| 5 | Critique | Challenge decisions D1-D8 | @brain | ⏳ Pending |
| 6 | Synthesis | Final synthesis | @brain | ⏳ Pending |

## Source Files
- [x] file1.md — analyzed (Iteration 1)
- [x] file2.md — analyzed (Iteration 2)
- [ ] file3.md — pending

## Iteration Log

### Iteration 1: {Source} Analysis
**Subagent:** @brain
**Task:** Analyze {source-file.md}
**Key Findings:**
- Finding 1
- Finding 2
**Decisions:** D1, D2

### Iteration 2: {Source} Analysis
...

### Iteration N: Critique
**Subagent:** @brain (critique mode)
**Challenges Found:**
| # | Challenge | Severity | Resolution |
|---|-----------|----------|------------|
| C1 | ... | 🟡 | Addressed in D9 |

## Decisions Made
- **D1:** {decision} — {rationale} — [Source: {file}]
- **D2:** {decision} — {rationale} — [Source: {file}]

## Conflicts Identified
- {file1} says X, {file2} says Y → Resolved: {approach} (Priority: {which})

## Current Draft
{Latest synthesis output}
```

---

## Quality Criteria

### Per Deliverable
- [ ] Iteration plan created before analysis starts
- [ ] All source files analyzed via subagents (not direct reads)
- [ ] All ## Related refs followed
- [ ] Critique iteration completed (Medium/High complexity)
- [ ] All critique challenges addressed or explicitly deferred
- [ ] Conflicts identified and resolved (with rationale + priority)
- [ ] Output matches Pattern File Format
- [ ] Every rule traces to source
- [ ] Anti-patterns include "why"
- [ ] State file: Status: Complete
- [ ] Iteration log documents all subagent outputs

### Cross-Deliverable
- [ ] No contradictions between pattern files
- [ ] Cross-references resolve correctly
- [ ] Templates match patterns
- [ ] Checklists verify patterns

---

## Deliverable Index

| # | Deliverable | Prompt File | Complexity |
|---|-------------|-------------|------------|
| 1 | COMPONENT-MATRIX.md | `.github/prompts/01-component-matrix.prompt.md` | High |
| 2 | agent-patterns.md | `.github/prompts/02-agent-patterns.prompt.md` | High |
| 3 | skill-patterns.md | `.github/prompts/03-skill-patterns.prompt.md` | Medium |
| 4 | instruction-patterns.md | `.github/prompts/04-instruction-patterns.prompt.md` | Medium |
| 5 | prompt-patterns.md | `.github/prompts/05-prompt-patterns.prompt.md` | Medium |
| 6 | memory-patterns.md | `.github/prompts/06-memory-patterns.prompt.md` | High |
| 7 | mcp-patterns.md | `.github/prompts/07-mcp-patterns.prompt.md` | Medium |
| 8 | orchestration-patterns.md | `.github/prompts/08-orchestration-patterns.prompt.md` | High |
| 9 | quality-patterns.md | `.github/prompts/09-quality-patterns.prompt.md` | High |
| 10 | checkpoint-patterns.md | `.github/prompts/10-checkpoint-patterns.prompt.md` | Medium |
| 11 | RULES.md | `.github/prompts/11-rules.prompt.md` | Medium |
| 12 | NAMING.md | `.github/prompts/12-naming.prompt.md` | Low |
| 13 | SETTINGS.md | `.github/prompts/13-settings.prompt.md` | Low |
| 14 | TEMPLATES/ | `.github/prompts/14-templates.prompt.md` | Medium |
| 15 | project-context-template.md | `.github/prompts/15-project-context.prompt.md` | Medium |
| 16 | CHECKLISTS/ | `.github/prompts/16-checklists.prompt.md` | Medium |
| 17 | README + WORKFLOW-GUIDE | `.github/prompts/17-readme-workflow.prompt.md` | High |

---

## Checkpoints

| After | Action |
|-------|--------|
| #5 | Phase 1 coherence review — run `.github/prompts/checkpoint-phase1.prompt.md` |
| #10 | All patterns review — run `.github/prompts/checkpoint-phase3.prompt.md` |
| #16 | Artifacts integration — run `.github/prompts/checkpoint-phase5.prompt.md` |
| #17 | **FINAL** — run `.github/prompts/checkpoint-final.prompt.md` |

---

## Enhancement Capture

Log discoveries during synthesis:
- 🔧 Agent improvements → update agent files directly or note for later
- ✨ New agent ideas → add to projectbrief challenges
- 📝 Pattern refinements → note in state file
- ⚠️ Inconsistencies found → resolve or escalate

---

## Remember

> **We are framework architects, not documentarians.**
> 
> Every "choice point" becomes a decision.
> Every "option" becomes THE approach.
> The generator executes our vision — it doesn't choose.
