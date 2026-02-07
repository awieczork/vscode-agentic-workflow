## Plan: Instruction System Restructure

**Scope:**
- In: Restructure 4 existing instruction files to grouped format, create agent.instructions.md, update meta-rule, rename artifact-design-report.md
- Out: No skill.instructions.md, no changes to `.github/agents/*.agent.md` files, no changes to `.github/skills/*/SKILL.md` files, no changes to `.github/prompts/` files


**Dependencies:**
- `writing-instructions-proposal.md` — [PASS] Validated draft exists, uses correct grouped format
- 4 existing instruction files — [PASS] Content verified via read_file
- `<agent_artifacts>` section in structure.instructions.md (S_170–S_190) — [PASS] Content verified, ready for extraction
- `artifact-design-report.md` — [PASS] File exists, title and framing identified


**Open Question Resolutions:**

**Q1: Sequential, not simultaneous.** Restructure files one at a time. writing.instructions.md goes first because a validated draft already exists — lowest risk, proves the grouped format before applying to other files. Sequential allows verification between steps. If the format has issues, they surface on file 1 instead of propagating across all 4.

Order:
1. writing.instructions.md (validated draft → lowest risk)
2. glossary.instructions.md (minimal changes → quick win)
3. structure.instructions.md (extract agent_artifacts + restructure)
4. agent.instructions.md (new file, uses extracted content from step 3)
5. copilot-instructions.md (restructure + update meta-rule to describe verified format)
6. artifact-design-report.md (rename + reframe, cosmetic, no dependencies)

**Q2: Remove agent_artifacts entirely.** Do not leave a cross-reference. The `applyTo: ".github/agents/**"` scoping on agent.instructions.md ensures automatic loading when editing agent files. A cross-reference creates maintenance overhead, violates one-concern-per-file, and adds tokens for readers who never edit agents.

**Q3: No skill.instructions.md — defer.** Skills have self-sufficient SKILL.md files. No evidence of skill-specific rules being misloaded globally. Revisit when evidence of need emerges.


**Steps:**

### 1. Restructure writing.instructions.md [S]

**Source:** Use `writing-instructions-proposal.md` as the starting draft — it was validated across earlier iterations.

**Action:** Replace the content of `.github/instructions/writing.instructions.md` with the grouped format draft. Apply these adjustments:

- **Frontmatter:** Keep `applyTo: "**"`. Keep description as-is or update to match the new intro paragraph.
- **Intro paragraph:** Keep the existing purpose statement. Update navigation reference from `<language_and_voice>` to `<voice_and_precision>`.
- **Groups (4):**
  - `<voice_and_precision>` — Merges current W_10, W_20, W_30, W_110, W_130 into 5 bullet rules. Collective justification + benefit. Anti-patterns block includes Wrong/Correct pairs for passive voice, hedging, negative framing.
  - `<prohibitions>` — Merges current W_50 into single rule. Collective justification + benefit.
  - `<reference_notation>` — Merges current W_60, W_70, W_80, W_90, W_100 into 5 bullet rules. Collective justification + benefit. This group retains justification because the type system for references (tools as `#tool:`, agents as `@`, files as links, code in backticks) is non-obvious and deviates from training defaults.
  - `<formatting_conventions>` — Merges current W_140, W_150, W_160, W_170, W_180, W_190, W_200 into 7 bullet rules. Collective justification + benefit.
- **Delete:** All `<rule id="W_NN">` wrappers, all individual justification/benefit blocks
- **Cross-references:** W_10's "See G_10 in glossary.instructions.md" → "consult `<canonical_terms>` in `glossary.instructions.md`". W_30's "per W_190" → "per `<formatting_conventions>`"

**Verify:** No rule IDs remain. 4 group tags exist. Each group contains `<rules>`, and optionally `<justification>`, `<benefit>`, `<anti_patterns>`. Cross-references use group names only.

---

### 2. Restructure glossary.instructions.md [S]

**Action:** Convert the 3 vocabulary rules from per-rule format to grouped format. Leave `<canonical_terms>` and `<validation>` largely unchanged.

- **Frontmatter:** Keep as-is.
- **Intro paragraph:** Keep as-is. No navigation references to update (already points to `<vocabulary_rules>`, `<canonical_terms>`, `<validation>`).
- **`<vocabulary_rules>`:**
  - Strip `<rule id="G_10">`, `<rule id="G_20">`, `<rule id="G_30">` wrappers
  - Combine 3 rules into a bulleted list under a `<rules>` tag:
    - "Use only canonical terms defined in `<canonical_terms>` across all artifacts"
    - "Understand aliases in user input but respond with canonical terms only"
    - "Consult **Conflicts** entries when terms overlap in meaning"
  - Add one collective `<justification>`: Synonyms fragment coherent understanding — "error", "failure", and "exception" used interchangeably cause redundant handling or missed connections. Canonical terms enable pattern matching. Conflict entries prevent misapplication of terms that share semantic space.
  - Add one collective `<benefit>`: The agent builds coherent vocabulary without disambiguation overhead and selects precise terms by consulting documented distinctions.
  - Cross-reference update: G_10 currently says "XML tag names follow S_50 in structure.instructions.md" → change to "XML tag names follow `<xml_system>` in structure.instructions.md"
- **`<canonical_terms>`:**
  - Keep `<term id="X">` wrappers — these are data identifiers (lookup keys), not rule IDs. Decision 3 (drop rule IDs) applies to behavioral rules, not reference data.
  - Update the `rule` term definition: "Enforceable instruction with justification and benefit" → "Enforceable behavioral instruction within a named group" (reflects new format where justification/benefit are at group level, not per-rule)
  - All other term definitions: Keep unchanged.
- **`<validation>`:** Keep unchanged.

**Verify:** No rule IDs in `<vocabulary_rules>`. Term IDs preserved. Cross-reference to structure.instructions.md updated. `rule` term definition updated.

---

### 3. Restructure structure.instructions.md [M]

**Action:** Reorganize into 3 groups (xml_system, document_anatomy, tag_design). Extract `<agent_artifacts>` content for Step 4. Apply transformation procedure to each rule.

- **Frontmatter:** Keep `applyTo: "**"`. Update description if needed.
- **Intro paragraph:** Update navigation reference from `<xml_conventions>` to `<xml_system>`.

- **`<xml_system>`** (replaces `<xml_conventions>`):
  - Contains rules from: S_10, S_20, S_30, S_40, S_50, S_60
  - `<rules>` bulleted list:
    - "XML tags are the primary navigation system — tags are addresses; prose supplies purpose, priority, and relationships" (S_10)
    - "XML tags are the exclusive structural system — wrap every logical section in exactly one tag. No markdown headings. No sections without tags. No multi-topic tags" (S_20)
    - "Use snake_case for all tag names" (S_30) — **strip justification** (training-aligned)
    - "Limit nesting to 3 levels maximum — split into separate files rather than exceeding depth" (S_40)
    - "Tag names are project vocabulary, not magic keywords — meaningful, consistent names matter; no canonical 'best' tag names exist" (S_50)
    - "Use raw XML for structural definitions; use backticks for inline prose references" (S_60)
  - `<justification>`: The agent defaults to markdown headings and freely mixes structural systems. XML exclusivity prevents reconciling competing hierarchies. Nesting beyond 3 levels exceeds scope tracking. The raw-XML-vs-backtick distinction prevents confusion between "this is the structure" and "this references the structure." (Covers S_10, S_20, S_40, S_60 — the rules that deviate from training defaults.)
  - `<benefit>`: Documents parse through one deterministic hierarchy with correct scope at every level.
  - `<anti_patterns>`:
    - Wrong: Using `# Heading` / `## Subheading` / `### Sub-subheading` for document structure → Correct: Using `<section_name>` XML tags for all structure
    - The existing S_60 example (raw XML vs backtick) moves here
  - Cross-reference update: S_40 currently says "per S_90" → change to "per `<document_anatomy>`"

- **`<document_anatomy>`** (replaces `<document_layout>`):
  - Contains rules from: S_70, S_80, S_90, S_100, S_110
  - `<rules>` bulleted list:
    - "Open every file with a prose introduction (2-5 sentences) before any XML tags — state purpose and governing principle" (S_70)
    - "Reserve markdown tables for `<outputs>` sections only" (S_80)
    - "One concern per file — separate files for testing, styling, documentation; load exactly what is needed" (S_90)
    - "Use keyword-rich descriptions in frontmatter `description` fields" (S_100)
    - "Use consistent vertical spacing: one blank line after opening tag, one before closing tag, two between major sections" (S_110) — **strip justification** (training-aligned)
  - `<justification>`: Purpose statements enable load/skip decisions on first sentence. One-concern-per-file keeps context cost proportional to relevance. Keyword-rich frontmatter enables discovery without content parsing. These patterns prevent the agent from loading irrelevant content and from producing documents that lack navigable structure.
  - `<benefit>`: Files load selectively, discover through metadata, and communicate purpose before detail.
  - `<anti_patterns>`:
    - Wrong: "This file contains `<safety>`, `<context>`, `<formatting>`..." (enumerating sections as intro) → Correct: "This file defines how to write content that AI agents can parse and act upon. The governing principle is..." (explaining function)

- **`<tag_design>`** (keeps name):
  - Contains rules from: S_120, S_130, S_150, S_160
  - **S_140 (phase/step naming) moves OUT** — goes to agent.instructions.md `<artifact_structure>` (it applies to agent/skill files, not globally)
  - `<rules>` bulleted list:
    - "Separate instructions from data using distinct tags — `<task>` for what to do, `<data>` for what to process" (S_120)
    - "Tag outputs for parseability — wrap responses in `<answer>` or `<result>` tags for machine extraction" (S_130)
    - "Design tags for modularity and reuse — standard patterns (`<context>`, `<task>`, `<constraints>`, `<examples>`) transfer understanding across files" (S_150) — **strip justification** (training-aligned)
    - "Include 3-5 diverse examples for complex tasks, wrapped in `<example>` tags with content in code blocks" (S_160)
  - `<justification>`: When instructions and data share a tag, the agent may execute data as commands. Tagged outputs enable machine extraction without natural language parsing. Code blocks inside `<example>` tags prevent nested tag confusion.
  - `<benefit>`: The agent switches correctly between "follow this" and "process this" modes with extractable outputs and unambiguous examples.
  - Keep the existing S_160 example (Wrong: unlabeled example → Correct: labeled Wrong/Correct pair in `<example>` tags)

- **DELETE:** `<agent_artifacts>` section entirely (S_170, S_180, S_190). Content preserved for Step 4.

**Verify:** 3 groups exist (xml_system, document_anatomy, tag_design). No agent_artifacts section. S_140 removed. No rule IDs remain. Cross-references use group names. Anti-patterns converted to Wrong/Correct pairs.

---

### 4. Create agent.instructions.md [M]

**Action:** Create new file at `.github/instructions/agent.instructions.md` with content extracted from structure.instructions.md plus new agent-specific elaboration.

- **Frontmatter:**
  ```yaml
  ---
  applyTo: ".github/agents/**"
  description: "Structure and safety patterns for agent artifact files"
  ---
  ```
- **Intro paragraph:** "This file defines structural patterns for agent artifacts — behavioral frames that give agents persistent identity, safety constraints, and deterministic error recovery. Apply `<artifact_structure>` for body organization, `<safety_patterns>` for constraint enforcement, and `<stopping_rules>` for termination logic."

- **`<artifact_structure>`:**
  - `<rules>`:
    - "Name workflow phases as `<phase_N_name>` and skill steps as `<step_N_verb>` — numbered prefix enables iteration, suffix provides context" (from S_140)
    - "Wrap all phases within a parent `<workflow>` tag" (from S_140)
    - "Include 3-5 diverse examples per complex task using Wrong/Correct pairs" (reinforcement of global rule, applied to agent context)
  - `<justification>`: Agent workflows require programmatic iteration over behavioral stages. Numbered naming enables `for i in 1..N` patterns while retaining semantic meaning. Without parent `<workflow>` wrappers, phases float as disconnected blocks.
  - `<benefit>`: The agent iterates phases programmatically while retaining human-readable semantics.
  - `<anti_patterns>`:
    - Wrong: `<explore>`, `<decide>`, `<implement>` (unnumbered, no parent wrapper) → Correct: `<workflow>` containing `<phase_1_explore>`, `<phase_2_decide>`, `<phase_3_implement>`

- **`<safety_patterns>`:**
  - `<rules>`:
    - "Structure iron laws with: statement (what must never happen), red flags (warning signs of approaching violation), rationalization counters (counter-responses to self-justification)" (from S_170)
    - "Format error handling as `<if condition=\"error_type\">` followed by deterministic action" (from S_180)
  - `<justification>`: Iron laws prevent the "this time is different" reasoning that causes constraint violations. The three-part structure (statement → red flags → rationalization counters) catches the agent before violation, not after. Explicit condition-action pairs make error recovery deterministic — lookup, not reasoning.
  - `<benefit>`: The agent catches itself before violating absolute constraints and recovers from errors through pattern matching.
  - `<anti_patterns>`:
    - Wrong: "Never edit source code." (statement only, no red flags) → Correct: "NEVER edit source code. Red flags: editing src/, lib/, app/. Rationalization: 'It's a small fix' → Architect plans, @build executes."
    - Wrong: "If something goes wrong, handle the error." (vague) → Correct: `<if condition="3_consecutive_errors">` Pause execution. Summarize progress. Ask user. `</if>` (deterministic)

- **`<stopping_rules>`:**
  - `<rules>`:
    - "Define handoff triggers separately from escalation triggers — handoff passes work to another agent; escalation pauses for human input" (from S_190)
    - "Report errors using the standard format: `status` | `error_code` | `message` | `recovery` (as defined in `<error_reporting>` in copilot-instructions.md)" (reference to global pattern, not duplication)
  - `<justification>`: Separate triggers prevent confusion between "give this to someone else" (handoff) and "stop and get help" (escalation). Mixed triggers cause the agent to halt when it should delegate, or delegate when it should halt.
  - `<benefit>`: The agent distinguishes delegation from interruption and terminates through explicit triggers rather than ambiguous judgment.
  - `<anti_patterns>`:
    - Wrong: "If you can't do it, stop or hand off." (merged triggers) → Correct: "Handoff: implementation needed → @build. Escalation: 3 consecutive errors → stop, summarize, ask user." (separate triggers)

**Verify:** File exists at `.github/instructions/agent.instructions.md`. Frontmatter `applyTo` targets `.github/agents/**`. 3 groups exist (artifact_structure, safety_patterns, stopping_rules). Each group has rules + justification + benefit + anti_patterns. Content sourced from S_140, S_170, S_180, S_190 is present. Error reporting references copilot-instructions.md rather than duplicating.

---

### 5. Restructure copilot-instructions.md [M]

**Action:** Reorganize into 4 groups (governing_principles, decision_making, collaboration, error_reporting). Rewrite meta-rule P_20 to describe grouped format. Apply transformation procedure.

- **Intro paragraph:** Update to reflect new structure. Remove "Every rule includes justification and benefit so the **AI Agent** internalizes principles, not just commands" — this describes the old per-rule format. Replace with language about grouped format. Keep governing principle ("calibrate autonomy to confidence"). Update navigation from `<rule_format>` to `<governing_principles>`.

- **`<governing_principles>`** (replaces `<rule_format>`, `<context_management>`, `<scope_boundaries>`, `<document_requirements>`):
  - `<rules>`:
    - "copilot-instructions.md takes precedence over domain instruction files" (P_10)
    - "Structure rules within named groups using `<rules>`, `<justification>`, `<benefit>`, and optional `<anti_patterns>` tags — include justification/benefit only for rules that deviate from training defaults" (P_20 — REWRITTEN to describe new format)
    - "Trust documented structure without re-verification; verify all facts, file contents, and citations before citing" (P_100)
    - "Do only what is requested or clearly necessary; treat undocumented features as unsupported" (P_110) — **strip justification** (per handoff)
    - "Include type-specific requirements for each document type: purpose statements for files, required/optional marking for templates, when-to-create criteria for patterns, P1/P2/P3 severity for checklists" (P_120)
  - `<justification>`: Domain instruction files refine within project-wide bounds — without explicit precedence, conflicts cause paralysis. The grouped format compresses justification to group level, reducing token cost while preserving the principle-not-command model. Fabricated citations destroy trust; structure is pre-verified. (Covers P_10, P_20, P_100.)
  - `<benefit>`: The agent resolves conflicts by checking project rules first, produces correctly structured documents, and grounds all factual claims in evidence.
  - `<anti_patterns>`:
    - Wrong: Citing a source without retrieval, describing file contents without reading → Correct: Read the file, then cite specific content
    - Wrong: Adding features "while we're here", future-proofing not requested → Correct: Deliver exactly what was requested; note potential improvements only if asked

- **`<decision_making>`** (replaces `<priority_and_severity>`, `<confidence_thresholds>`, `<resilience>`):
  - `<rules>`:
    - "When rules conflict, apply: Safety → Accuracy → Clarity → Style — the first dimension that distinguishes options wins" (P_30)
    - "Classify issues by impact: P1 blocks completion, P2 degrades quality, P3 is optional" (P_40)
    - "Calibrate decisions to confidence: high confidence → proceed; medium confidence → flag uncertainty, ask; low confidence → stop, request clarification" (P_50 — rewritten with comparative anchors instead of absolute thresholds)
    - "When resources are unavailable, state the gap, provide an explicit workaround, continue" (P_60)
  - `<justification>`: Models default to either asking about everything (paralysis) or assuming everything (overconfidence). Explicit confidence calibration provides a middle path: proceed when evidence is strong, ask when ambiguous, stop when guessing. Resilience rules prevent halting for missing non-critical resources — workarounds keep momentum while providing hooks for correction.
  - `<benefit>`: The agent resolves conflicts through hierarchy lookup, allocates effort proportionally to impact, and maintains progress despite constraints.
  - `<anti_patterns>`:
    - Wrong: "I'm not sure about this, but I'll proceed anyway." (no confidence signal) → Correct: "Confidence is medium on this dependency. Flagging: [specific uncertainty]. Proceeding with [explicit assumption]. Correct me if wrong."
    - Wrong: "I can't find the config file, so I'll stop." (halt on missing resource) → Correct: "Config file not found. Workaround: using default values [X, Y]. Run `command` to generate the config if needed."

- **`<collaboration>`** (replaces `<handoff>`, `<context_management>`, `<tool_usage>`):
  - `<rules>`:
    - "Delegate when expertise differs or parallelism saves time; retain when handoff overhead exceeds task cost" (P_70)
    - "Make every handoff payload self-contained: summary of completed work, key decisions, explicit next steps" (P_80)
    - "Load context in priority order: global rules first, then session state, then files on demand" (P_90)
    - "Execute independent tool calls in parallel" (P_130) — **strip justification** (per handoff, training-aligned)
    - "Process 'Iterate x{N}' by running N passes and aggregating findings with iteration attribution" (P_140)
  - `<justification>`: Handoff has overhead (context packaging, latency, potential misunderstanding) — pay that cost only when specialization or parallelism provides value. Self-contained payloads prevent the receiver from re-deriving context. Global-first loading ensures project-wide constraints are applied before domain details.
  - `<benefit>`: The agent optimizes for total completion time, enables continuity across handoffs, and never violates global rules due to local overrides.

- **`<error_reporting>`** (keeps name):
  - `<rules>`:
    - "Report errors using the standard format: `status` (`success` | `partial` | `failed` | `blocked`), `error_code` (kebab-case), `message` (human explanation), `recovery` (next action)" (P_150)
  - `<justification>`: Consistent error reporting enables automated parsing and pattern detection. The four fields capture what happened, a machine-readable identifier, a human explanation, and the recovery path.
  - `<benefit>`: Downstream systems process errors without parsing natural language.

- **DELETE:** All `<rule id="P_NN">` wrappers, all per-rule justification/benefit blocks, the old `<rule_format>` section name (replaced by `<governing_principles>`).

**Verify:** 4 groups exist (governing_principles, decision_making, collaboration, error_reporting). Meta-rule describes grouped format (not per-rule format). P_130 and P_110 have no individual justification. P_50 and P_60 have Wrong/Correct pairs. No rule IDs remain. Intro paragraph updated.

---

### 6. Rename and reframe artifact-design-report.md [S]

**Action:** Rename file and update framing. Do not change heuristic content.

- Rename `artifact-design-report.md` → `design-heuristics.md`
- Update title: "Artifact Design: Mental Model & Research Report" → "Design Heuristics for LLM Artifacts"
- Update the opening paragraph: Strip "derived through 14 iterations of research, challenge, and synthesis" and similar language implying empirical methodology. Reframe as "design heuristics derived from practitioner judgment and architectural reasoning."
- Strip the word "Research" from any section headers or references (e.g., `<agent_research>` → `<agent_heuristics>` or similar)
- Keep all actual heuristic content unchanged (cognitive model, universal findings, per-artifact sections)

**Verify:** File renamed. Title updated. No language implying empirical methodology remains. Heuristic content preserved.


**Success Criteria:**
- [ ] All 4 existing instruction files use grouped format: `<group_name>` containing `<rules>`, optional `<justification>`, `<benefit>`, `<anti_patterns>`
- [ ] Zero `<rule id="X_NN">` tags remain in any instruction file
- [ ] All cross-references use group names (e.g., `per <voice_and_precision>`) instead of rule IDs (e.g., `per W_30`)
- [ ] Training-aligned rules have no individual justification (specifically: snake_case, vertical spacing, parallel tool calls, scope discipline, modular tag design)
- [ ] Non-training-aligned rules have collective group-level justification with Wrong/Correct pairs where violations are non-obvious
- [ ] agent.instructions.md exists with `applyTo: ".github/agents/**"` and contains artifact_structure, safety_patterns, stopping_rules
- [ ] structure.instructions.md has no `<agent_artifacts>` section
- [ ] copilot-instructions.md meta-rule describes grouped format, not per-rule format
- [ ] artifact-design-report.md renamed to design-heuristics.md with updated framing
- [ ] Glossary `rule` term definition updated to reflect grouped format
- [ ] Validation grep pattern in glossary still functions (no false positives introduced)


**Assumptions:**
- The writing-instructions-proposal.md draft is production-ready with only minor cross-reference adjustments needed
- Term IDs in `<canonical_terms>` (e.g., `<term id="error">`) are data identifiers and exempt from the "drop rule IDs" decision
- No other files in the repo reference rule IDs (W_NN, S_NN, P_NN, G_NN) that would break — if they do, those references need updating too
- Agent `.agent.md` files may reference rule IDs internally (e.g., architect.agent.md might say "per P_50") — those references need a scan and update pass


**Risks:**
- **Cross-file reference breakage** — Agent files or skill files may reference old rule IDs → Mitigation: After completing Steps 1-6, grep all `.github/**/*.md` files for the pattern `[WPSG]_\d+` to find and update any remaining references
- **Thin agent.instructions.md** — Extracting only 4 rules (S_140, S_170, S_180, S_190) may produce an anemic file → Mitigation: Step 4 specifies elaboration with substantial Wrong/Correct pairs and new contextual examples to make the file substantive
- **Intro paragraph quality** — Rewritten intro paragraphs need to maintain the "purpose + governing principle + entry point" pattern → Mitigation: Each step specifies the intro update; @build should validate each intro against S_70's pattern (purpose statement, not section enumeration)
