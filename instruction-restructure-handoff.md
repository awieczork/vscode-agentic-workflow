## Handoff: Instruction System Restructure

**Summary:** This exchange analyzed the relationship between the artifact-design-report and a unified-instructions-proposal, iterated on both, and converged on design decisions for restructuring the existing 4-file instruction system. The unified proposal is abandoned — the multi-file architecture is correct. The grouped format replaces the per-rule format. The report is reframed as design heuristics.

**Findings:** See below for agreed design decisions, what to keep, what to change, and what to discard.

**Confidence:** High — convergence reached across 9 iterations and adversarial review from both sides.

**Open questions:** Listed at end.

→ Ready for: @architect (planning) then @build (implementation)


### Agreed Design Decisions

**1. Keep the multi-file architecture. Do not consolidate.**

The existing 4 files (copilot-instructions.md, writing.instructions.md, structure.instructions.md, glossary.instructions.md) correctly implement one concern per file. The unified proposal violated this principle while stating it. Each file loads independently, keeping per-interaction context cost proportional to relevance.

**2. Apply the grouped format to each file individually.**

Replace the current per-rule format (`<rule id="X_NN">` with individual justification/benefit) with the grouped format:

```md
<group_name>

<rules>

- Rule 1
- Rule 2

</rules>

<justification>

Collective justification in prose (2-4 sentences). Only for rules that deviate from training defaults.

</justification>

<benefit>

Collective benefit in prose (1-2 sentences). Only for rules that deviate from training defaults.

</benefit>

</group_name>
```

**3. Drop rule IDs entirely.**

Cross-references use group names (`per <reference_notation>`) instead of rule IDs (`per W_60`). Only 6 cross-references existed across all files. All resolve naturally to group-level references.

**4. Strip justifications from training-aligned rules.**

Rules the agent would follow naturally (active voice, explicit conditionals, consistent notation) do not need justification blocks — the tokens compete for attention against rules that actually need reinforcement. Keep justifications only for rules that deviate from training defaults or where the Wrong/Correct pair alone is insufficient.

**5. Replace prose explanations with Wrong/Correct pairs where possible.**

One concrete example teaches more than a paragraph of justification. Add `<anti_patterns>` blocks with "Wrong: ... → Correct: ..." pairs to groups where the violation is non-obvious.

**6. Use comparative anchors instead of absolute thresholds.**

Instead of "50-120 lines" or "7-12 rules," use comparisons: "closer to a README than a specification," "fewer rules per file than you think you need." Magnitude without false precision.

**7. Scope agent_patterns to agent files only.**

Create a new `agent.instructions.md` with `applyTo: ".github/agents/**"` containing phase/step naming, iron law structure, error handling format, stopping rules, and error reporting format. Do not load this content globally.

**8. Keep vocabulary as a separate file.**

Vocabulary definitions are reference data, not behavioral calibration. Folding them into writing rules violates instruction/data separation. glossary.instructions.md stays independent.

**9. Update P_20 in copilot-instructions.md.**

The current meta-rule mandates `<rule id="X_NN">` tags. Update it to describe the new grouped format (rules/justification/benefit within named groups, IDs dropped).

**10. Rename the report.**

`artifact-design-report.md` currently presents itself as "research findings from 14 iterations." It is design heuristics derived from practitioner intuition and LLM-informed reasoning — valuable, but not research. Rename to "Design Heuristics for LLM Artifacts" and strip language that implies empirical methodology. The insights stand on their own as engineering guidance.

**11. Inline constraints at point of action.**

Do not collect constraints in separate `<constraints>` sections and actions in separate `<rules>` sections. Place each constraint adjacent to the action it constrains. "Name the skill (lowercase-with-hyphens)" is more effective than a naming rule in one section and a naming action in another.


### Epistemic Caveat

Both sides of this exchange acknowledged: claims about AI attention weight, positional deprioritization, and compliance degradation curves are plausible narratives constructed from architectural reasoning, not empirical observations. Neither the AI agent nor the human author can verify these claims from inside the system. The design heuristics derived from these narratives may be correct for reasons neither party can confirm.

Frame all heuristics as practitioner judgment informed by architectural reasoning — not as self-reported cognitive limitations or measured behavior. The architect should treat directional guidance (shorter is better, examples outperform prose) as actionable, but should NOT treat specific magnitudes as hard constraints during planning.


### Per-Rule Transformation Procedure

Apply this decision procedure to each rule during restructuring:

1. **Does this rule deviate from training defaults?**
   - **No** → Single imperative line, no justification. Optionally a Wrong/Correct pair if the deviation is subtle
   - **Yes** → Imperative line + justification. Mandatory Wrong/Correct pair

2. **Does this rule have a separate justification block in the current files?**
   - Check if the justification is needed (per step 1). If not, cut it
   - If needed, compress to a collective group-level justification, not a per-rule paragraph

3. **Is there a corresponding anti-pattern?**
   - Convert to Wrong/Correct pair format
   - Place inline with the rule group, not in a separate distant section

4. **Does this rule belong in the file it's currently in?**
   - Check the concern scope. If it's an agent-pattern rule in a global file, move it to agent.instructions.md
   - Check the `applyTo` pattern. If it loads for files where it adds zero value, narrow it


### File-by-File Plan

**copilot-instructions.md** — Group into: `<governing_principles>`, `<decision_making>`, `<collaboration>`, `<error_reporting>`. Drop `<rule_format>` section or rewrite to describe the new grouped format. Strip justification from training-aligned rules (P_130 parallel tool calls, P_110 scope discipline). Add Wrong/Correct pairs for P_50 confidence thresholds and P_60 resource resilience.

**writing.instructions.md** — Group into: `<voice_and_precision>`, `<prohibitions>`, `<reference_notation>`, `<formatting_conventions>`. Use the writing-instructions-proposal.md as the starting draft — it was validated in earlier iterations. Strip justification from training-aligned rules (active voice, explicit conditionals). Keep justification for reference notation (non-obvious type system). Add anti-patterns block to voice_and_precision.

**structure.instructions.md** — Group into: `<xml_system>`, `<document_anatomy>`, `<tag_design>`. Strip justification from training-aligned rules (snake_case, spacing). Keep justification for exclusivity (no markdown headings — this deviates from default behavior). Add Wrong/Correct pair for raw XML vs backtick references.

**glossary.instructions.md** — Group into: `<vocabulary_rules>` (3 usage rules), `<canonical_terms>` (17 term definitions), `<validation>` (grep pattern). Minimal changes — this file is already close to the right format. Strip individual justifications from the 3 vocabulary rules, replace with one collective block.

**NEW: agent.instructions.md** — Create with `applyTo: ".github/agents/**"`. Group into: `<artifact_structure>` (phase/step naming, examples, modular design), `<safety_patterns>` (iron laws, error handling format), `<stopping_rules>` (handoff vs escalation triggers, error reporting format). Source content from current structure.instructions.md `<agent_artifacts>` section.


### What to Discard

- **unified-instructions-proposal.md** — Superseded by this handoff. The grouped format is adopted; the consolidation architecture is rejected
- **writing-instructions-proposal.md** — Content absorbed into the writing.instructions.md plan above
- **Specific numerical thresholds from artifact-design-report.md** — "7-12 compliance cap," "~80%," "800-2,500 tokens" are not design constraints. Directional guidance only: shorter is better, fewer rules is better, examples outperform prose


### What to Preserve from artifact-design-report.md (as Design Heuristics)

- Four-artifact taxonomy (agent/skill/prompt/instruction as cognitive prosthetics) — use as design vocabulary
- FRAME → GUARD → CORE → VERIFY → ENDGAME body ordering — use as recommended sequence, not rigid constraint
- Fatal anti-patterns per artifact type — useful diagnostic checklist
- Determinism layers (HARD/STRUCTURED/FLEXIBLE) — useful for organizing rule rigidity
- Truncation survivability — front-load critical content
- Example superiority — Wrong/Correct pairs over prose justification
- Comparative anchors over absolute thresholds


### Open Questions

1. Should the 4 existing instruction files be restructured simultaneously or sequentially (to validate the format on one file before applying to others)?
2. The `<agent_artifacts>` section currently in structure.instructions.md — remove it after extracting to agent.instructions.md, or leave a cross-reference?
3. Should skills also get a scoped instruction file (`skill.instructions.md` with `applyTo: ".github/skills/**"`) or is that premature?
