# Design Heuristics for LLM Artifacts

A language model is a powerful but stateless reasoner. Every artifact injects state the model cannot maintain — identity, procedural memory, resolved intent, or behavioral calibration. This document captures design heuristics derived from practitioner judgment and architectural reasoning for the cognitive foundations, body structure, and design principles of the four artifact types.


<cognitive_model>

Each artifact type compensates for a specific cognitive limitation of language models.

| Limitation | Artifact | Cognitive Function | Persistence |
|-----------|----------|-------------------|-------------|
| No persistent self-model | Agent | Behavioral frame — working-memory prosthetic for identity | Session-long, across turns |
| No reliable procedural memory | Skill | Externalized procedure — validated steps replacing re-derivation | Permanent, invoked on demand |
| Interpretation space explosion | Prompt | Attention funnel — collapses input ambiguity to specific output | Single-shot, stateless |
| No local calibration | Instruction | Ambient constraint — shifts output from training-average toward project-correct | Pattern-activated, invisible |

The unifying principle: artifacts don't provide knowledge the model lacks — they provide **selection pressure** to apply the right knowledge at the right time.

</cognitive_model>


<universal_findings>

These findings apply across all four artifact types, regardless of platform or framework.

**Token economics.** Every token in context competes for finite attention weight. Dense, imperative language outperforms verbose explanation. A low-value token dilutes the weight available for high-value tokens. If a sentence can be cut without losing behavioral impact, cut it.

**Compliance capacity.** Compliance tracks linearly up to ~12 salient directives, then degrades logarithmically. An artifact with 25 rules reliably follows ~10 and partially follows ~5. Cap at 7-12 high-priority elements per artifact.

**Proximity principle.** Constraints separated from the action they constrain lose attention weight at the moment of compliance. Inline constraints at point of action outperform separate constraint sections. "Name the skill (lowercase-with-hyphens, 1-64 chars)" is more effective than stating the naming rule in one section and the naming action in another.

**Example superiority.** A concrete correct/incorrect pair teaches format, tone, and scope more efficiently than descriptive rules. The model pattern-matches against examples more reliably than it follows abstract instructions. One clear example does ~80% of the work of five rules.

**Negative space handling.** "Don't do X" activates the representation of X. "NEVER X — because Y" activates X, suppresses it with the absolute quantifier, and provides the causal model for generalization. State positive space first; use explicit NEVER/ALWAYS for hard constraints.

**Three determinism layers.** HARD (`NEVER`/`ALWAYS` — binary, no exceptions) → STRUCTURED (`If X, then Y` + escalation — conditional determinism) → FLEXIBLE (intent verbs like "prefer," "consider" — guided discretion). Every directive belongs to exactly one layer. Mixing layers causes hard constraints to be treated as suggestions.

**Justification economics.** Rules that align with training data work without justification. Rules that deviate from training defaults need justification because the model must override its default pattern. Justification transforms a flat rule into a principle the model applies to novel situations — it enables edge-case generalization, not compliance with stated cases.

**Processing model.** The model processes the ENTIRE context window before generating any token. Ordering matters not because the model reads top-to-bottom sequentially, but because earlier content frames interpretation of later content, earlier content has higher retention priority during compaction, and contradictions resolve in favor of earlier content.

</universal_findings>


<agent_heuristics>

**The problem.** Language models have no persistent identity. Without a behavioral frame, the model is a generic chameleon that mirrors whatever context it receives, attempts everything, refuses nothing, and maintains no consistency across turns. RLHF training actively causes scope creep — models learned that more comprehensive answers score higher, so scope expansion is the literal objective the model was optimized for.

**The mechanism.** An agent constructs a synthetic self-model by front-loading a behavioral frame into context. This frame acts as a decision-making lens: all subsequent inputs are filtered through it.

**Body elements in cognitive dependency order:**

1. **Identity paragraph** — 3-5 dense sentences encoding role, capabilities, stance, anti-identity with handoff targets, and 1-2 critical behavioral rules. The single most important element — if everything else is compacted away, this paragraph alone produces ~80% correct behavior. Anti-identity ("Not a planner → @architect") is higher value than positive identity because it creates specific delegation targets that prevent scope creep

2. **Safety rules** — 5-8 NEVER/ALWAYS lines, no justification needed. Iron laws with one rationalization counter each, only for agents with destructive tools. More than one counter per iron law is dead weight — the model only needs one "this time is different" rebuttal to resist override pressure

3. **Boundaries** — Three flat lists (Do / Ask First / Don't), ~5 items each. Tool restrictions are structural boundaries enforced by the platform; prose boundaries are aspirational and depend on compliance

4. **Modes** — Trigger + Steps only. Output format and exit conditions within modes are dead weight — the model does not reference them during generation. 30% constraints / 70% capabilities ratio — constraint density above ~40% causes excessive caution

5. **Stopping rules** — Flat list of handoff triggers + escalation triggers. These influence generation through background attention weight — the model does not proactively check them, but their presence shapes termination decisions. Must include self-contained handoff payload templates

6. **Error handling** — 3-5 if/then pairs. Consulted only when errors occur. End-position benefits from recency-effect attention bias

**Size:** 300-500 lines (800-2,500 tokens). Diminishing returns at ~2,000 tokens. Hard ceiling at ~4,000.

**Quality test:** "If the identity paragraph were removed, would this artifact still behave consistently across 20 turns with tool access?" If yes, it is not an agent — it is an instruction wearing an agent's clothes.

**Fatal anti-pattern:** Vague identity ("You are a helpful assistant") — changes nothing because the model defaults to this behavior anyway. The entire cognitive function of an agent is to produce DIFFERENT behavior than the base model would.

</agent_heuristics>


<skill_heuristics>

**The problem.** Language models possess vast declarative knowledge but no reliable procedural memory. They know ABOUT how things work but cannot consistently execute multi-step procedures with the same precision across invocations. Each encounter forces re-derivation from first principles — producing variable step ordering, skipped validations, and an inability to learn from past executions. The model's procedural output is a sample from a distribution of possible procedures, not a specific validated procedure.

**The mechanism.** A skill externalizes a validated procedure into a retrievable, executable format. It converts "figure it out each time" into "follow these verified steps." Critically, a skill captures not just steps but decision points that only emerge from repeated execution with feedback — expert knowledge the model cannot derive because it doesn't persist across sessions.

**Body elements in cognitive dependency order:**

1. **Opening paragraph** — 2-3 sentences: what this skill produces, when to use it, one-line classification escape ("If the spec describes an agent, stop — use agent-creator instead"). This replaces the 15-25% token budget currently spent on step-1 classification gates that never fire because the skill was already selected

2. **Defaults** — Flat list of fallback values when ≥3 exist. Before the steps because defaults are referenced during step execution

3. **Numbered steps with inline everything** — Imperative verb-led steps, max 7. Constraints inline at point of action. Validation inline at the step producing the validatable thing. Error handling inline when step-specific. Loading directives inline ("Load `reference.md` for:"). A concrete example of the expected output at each step, not just at the end — this is the single most effective mechanism for procedural compliance

4. **Error handling** — 3-5 if/then pairs for cross-step errors only. Step-specific errors belong inline. This section covers "the whole procedure is going wrong" situations

**Size:** 150-300 lines (500-2,000 tokens body). Reference files extend capacity without context cost via progressive loading. Discovery phase must work in ~100 tokens (name + description).

**Quality test:** "Could a different agent follow these steps and produce the same output?" If no, the skill has leaked identity — it is contaminated with agent concerns.

**Fatal anti-pattern:** Agent contamination — persona, stance, or safety rules inside a skill. Creates a shadow agent that conflicts with the invoking agent's identity. A skill is a what-to-do artifact, never a who-to-be artifact.

</skill_heuristics>


<prompt_heuristics>

**The problem.** Language models are highly sensitive to input framing. Every natural language request has multiple plausible interpretations, and the model defaults to the most common one from training data, which may not match the user's actual intent. Ambiguity forces the model to allocate attention across many possible interpretations simultaneously, degrading quality on all of them.

**The mechanism.** A prompt collapses the interpretation space from "all plausible tasks" to "this specific task with this specific output shape." By separating concerns into distinct sections, each receives focused attention rather than competing for it.

**Body elements in cognitive dependency order:**

1. **Example** — The single highest-impact element in any prompt. One concrete output sample calibrates the model's sense of target before processing anything else. The model pattern-matches against examples more reliably than it follows abstract rules. For generative prompts, invest 50% of the token budget here

2. **Task declaration** — 1-3 imperative sentences, verb-first, single goal. With the example already loaded, the task narrows the scope. Multi-task prompts split attention proportionally — each task gets fractional quality

3. **Constraints** — 3-5 bullet NEVER/ALWAYS rules, only when needed. For simple prompts, inline constraints work better than separate sections ("Write a function, max 20 lines, no external dependencies")

4. **Context** — Files, variables, background information. Supporting material after the directive — by this point the model already knows the target (example), the goal (task), and the limits (constraints). Context is raw material, not framing

5. **Format** — Output structure specification, only when non-obvious from the example. The lowest-stakes element — if omitted, the model defaults to something reasonable based on the example

**Exception:** For analytical prompts (not generative), context before task — analysis depends on understanding the material before the task makes sense.

**Structure threshold:** XML tags help when the body exceeds ~150 tokens. Below that, plain prose — wrapping two sentences in tags adds overhead without benefit.

**Size:** Under 300 tokens body. Prompts share the context window with task input, file contents, and auto-loaded instructions. Diminishing returns at ~400 tokens.

**Quality test:** "Does every variable narrow the output space, and does the template produce a useful result with zero turns of follow-up?" If no, it needs refinement or should be an agent.

**Fatal anti-pattern:** Multi-task scope ("create and test and deploy") — a stateless artifact with multiple goals splits attention across competing objectives. One prompt, one task.

</prompt_heuristics>


<instruction_heuristics>

**The problem.** Language models have no persistent preferences, standards, or calibration. They produce outputs calibrated to the statistical center of training data — generically correct but contextually wrong for specific projects, teams, or domains. Rules stated in conversation exist only in the current context window — the model has no mechanism to carry them forward.

**The mechanism.** An instruction injects calibration rules that modify the model's default behavior passively, without the model needing to actively consult them. They function like environmental parameters: shaping every token prediction, activated by pattern matching against the current working context. They shift the model's output distribution from "generically correct" toward "locally appropriate."

**Body elements in cognitive dependency order:**

1. **Opening line** — 1 sentence stating what this instruction covers. Keywords for semantic matching. Load/skip decision

2. **Safety rules** — 2-5 NEVER/ALWAYS lines, only when this domain has safety concerns. Binary, no justification needed. Survive context compaction

3. **Behavioral rules** — 7-10 imperative sentences, cap at 12 rules. Single-line for training-aligned rules ("use TypeScript strict mode"). Justified with em-dash for training-deviant rules ("use type aliases, not interfaces — project convention"). Beyond 12, split by concern into separate files

4. **Example pairs** — Wrong/Correct pairs for the 3-5 most surprising rules. Mandatory for training-deviant rules — without them, the model reverts to training patterns

**Rule stickiness ranking (strongest to weakest):** NEVER/ALWAYS imperative → Correct/Incorrect pair → Imperative with em-dash justification → If/then conditional → Bare imperative

**Stacking cost.** Instructions load silently and stack. 3 instructions at 800 tokens each = 2,400 tokens of invisible context cost. The total ambient context (all auto-loaded instructions + agent) should stay under ~4,000 tokens to preserve ≥75% of the context window for task work.

**Size:** 50-120 lines (200-800 tokens). Hard ceiling at ~1,200 tokens. Size discipline is critical because cost multiplies by stacking.

**Quality test:** "If this loaded silently alongside 5 other instructions, would it improve generation without contradicting any of them?" If no, it has stacking conflicts or is too broad.

**Fatal anti-pattern:** Broad scope with narrow content (e.g., applying to all files but containing TypeScript-only rules) — loads for every interaction, consuming context window tokens for files where it adds zero value.

</instruction_heuristics>


<body_ordering>

All four types follow the same meta-sequence, justified by cognitive dependency:

| Phase | Purpose | Agent | Skill | Prompt | Instruction |
|-------|---------|-------|-------|--------|-------------|
| FRAME | Establish interpretive lens | Identity paragraph | Opening paragraph | Example output | Opening line |
| GUARD | Hard constraints before action | Safety rules | (inline in opening) | (inline in task) | Safety rules |
| CORE | Primary operational content | Modes + Boundaries | Numbered steps | Task + Constraints | Behavioral rules |
| VERIFY | Quality assurance | Stopping rules + Outputs | (inline in steps) | Context + Format | Example pairs |
| ENDGAME | Recovery and references | Error handling | Error handling | — | — |

**Truncation survivability:** If context cuts from the bottom, every type preserves its most critical elements — identity + safety for agents, opening + steps for skills, example + task for prompts, opening + safety rules for instructions.

</body_ordering>


<summary_matrix>

| Dimension | Agent | Skill | Prompt | Instruction |
|-----------|-------|-------|--------|-------------|
| Fills gap | No persistent self-model | No procedural memory | Interpretation explosion | No local calibration |
| Prosthetic type | Behavioral frame | Validated procedure | Attention funnel | Ambient constraint |
| Core element | Identity paragraph | Numbered steps | Example output | Behavioral rules |
| Sweet spot | 800-2,500 tokens | 500-2,000 tokens | 150-500 tokens | 200-800 tokens |
| Fatal error | Vague identity | Agent contamination | Multi-task scope | Broad scope + narrow content |
| Highest-impact change | Dense self-sufficient identity paragraph | Inline constraints at point of action | Example before task | Cap at 12 rules, split beyond |

</summary_matrix>
