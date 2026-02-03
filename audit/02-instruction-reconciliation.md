# D2: Instruction Consolidation Reconciliation

Reconciles competing recommendations from D1 analysis to produce a final implementation decision.

---

## User's Stated Goals (Verbatim)

1. "consolidate all instructions into copilot-instructions.md"
2. "copilot-instructions.md should be project-wide general rules"
3. "we need to think about structure"

**Interpretation:** User wants reliability (rules load consistently) AND structure (logical organization). User did NOT say "minimize tokens" as a primary goal.

---

## Technical Reality Assessment

### Does applyTo: "**" Reliably Load?

**Evidence from VS Code documentation:**
- `applyTo` patterns match against the file being edited
- When editing a file, instruction files with matching patterns are injected
- `"**"` matches all files in the workspace

**Failure modes:**
- Chat without file context — no file to match, instructions may not load
- New file creation — file doesn't exist yet, pattern matching uncertain
- Cross-file operations — which file's context triggers the match?

**Verdict:** `applyTo: "**"` is reliable for file-editing tasks but unreliable for general chat, planning, and multi-file operations. This is the critical insight.

### Token Cost Comparison

| Approach | Base Cost | Notes |
|----------|-----------|-------|
| D1 (Model B) | ~2,000 tokens | All universal rules in copilot-instructions.md |
| D2 (Lean) | ~500-800 tokens | copilot-instructions.md only, plus conditional load |
| Current | ~2,200 tokens | copilot + prompting via applyTo |

**Verdict:** D1 saves ~200 tokens over current state. D2 saves ~1,400 tokens but risks rule non-loading.

---

## Maintenance Reality Assessment

### File Count Analysis

| Approach | Files | Maintenance Burden |
|----------|-------|-------------------|
| D1 | 2 files | Clear hierarchy, simple updates |
| D2 | 3+ files | Requires tracking which rules live where |
| Current | 3 files | Redundancy creates drift risk |

### Change Frequency Analysis

- **Project identity** (references, workflow protocol) — Changes rarely
- **Style rules** (formatting, language) — Changes rarely  
- **Behavioral steering** — Changes when agent behavior issues arise
- **Artifact requirements** — Changes when artifact types evolve

**Verdict:** All categories change infrequently. File count matters less than clear organization.

---

## The False Dichotomy

D1 and D2 are NOT opposite approaches. They optimize for different concerns:

- **D1 optimizes for:** Reliability (rules always load)
- **D2 optimizes for:** Token efficiency (rules load only when needed)

The user's goals suggest **reliability is primary**, but D2's concern about bloat is valid.

---

## Reconciled Recommendation: Hybrid Consolidation

**Core insight:** The tension resolves when we recognize two distinct rule categories:

1. **Always-needed rules** — Apply to every agent interaction
2. **Writing-specific rules** — Apply only when generating artifacts

### Final Structure

**copilot-instructions.md (~1,200 tokens)**
- Project identity and references (current content)
- Core formatting rules (tables forbidden, no emojis, imperative verbs)
- Core behavioral rules (positive framing, quantify guidance, one term per concept)
- Anti-patterns (overengineering, test-focused solutions)

**artifact-style.instructions.md (~650 tokens, unchanged)**
- Retains `applyTo: ".github/**/*.md"`
- Artifact-specific content requirements
- Template and checklist requirements

**prompting.instructions.md — REMOVE**
- XML usage → Move to copilot-instructions.md (always relevant for this project)
- VS Code references → Move to copilot-instructions.md (always relevant)
- Behavioral steering examples → Move to skill (on-demand reference)
- Research/subagent/thinking → Move to skill (advanced techniques)

### What Goes Where

**Into copilot-instructions.md:**
- `<xml_usage>` — Always relevant for prompt/instruction authoring
- `<vscode_references>` — Always relevant for VS Code artifacts
- `<formatting>` — Core rules only (forbidden formats)
- `<instruction_writing>` — Core principles only
- `<anti_patterns>` — All (prevent common mistakes)

**Into new skill (prompting-techniques):**
- `<behavioral_steering>` — Reference examples, not always needed
- `<research_tasks>` — Advanced technique
- `<subagent_orchestration>` — Advanced technique  
- `<thinking_guidance>` — Advanced technique

**Keep in artifact-style.instructions.md:**
- All current content (unchanged)
- Update cross-reference from prompting.instructions.md to copilot-instructions.md

---

## Rationale

1. **Addresses user's primary goal** — Universal rules consolidated into copilot-instructions.md
2. **Maintains reliability** — Critical rules load on every interaction
3. **Reduces bloat** — Advanced techniques move to on-demand skill (~400 token savings)
4. **Preserves targeting** — artifact-style keeps scoped loading
5. **Simplifies maintenance** — Clear hierarchy: copilot (universal) → artifact-style (scoped) → skills (on-demand)

---

## Implementation Steps

1. Create `prompting-techniques` skill with behavioral steering examples and advanced sections
2. Expand copilot-instructions.md with XML usage, VS Code references, core formatting, instruction writing principles, and anti-patterns
3. Update artifact-style.instructions.md cross-reference
4. Remove prompting.instructions.md
5. Validate: Run test chat sessions to confirm rules load correctly

---

## Token Budget Summary

| File | Current | After |
|------|---------|-------|
| copilot-instructions.md | ~400 | ~1,200 |
| prompting.instructions.md | ~1,800 | 0 (removed) |
| artifact-style.instructions.md | ~650 | ~650 |
| prompting-techniques skill | 0 | ~600 (on-demand) |
| **Base load** | **~2,200** | **~1,850** |

Net savings: ~350 tokens base load, plus advanced content moves to on-demand loading.

---

## Decision Gate

**Recommendation:** Proceed with Hybrid Consolidation

**Confidence:** High — reconciles both analyses, addresses user goals, improves both reliability AND efficiency.

**User approval required before implementation.**
