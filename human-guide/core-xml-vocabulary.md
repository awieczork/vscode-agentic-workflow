# Core XML Vocabulary

Universal, repo-agnostic XML tag standard for AI agent artifacts. Each artifact type owns a unique set of tags — no tag name appears in more than one type except where explicitly justified. Project-specific tags extend this core based on domain needs.

Derived through 9 iterations: purpose-driven design, naming clarity, overlap detection, gap analysis, consistency audit, initial synthesis, deep challenge, subsection analysis, and final stress test.

---

## Design Principles

1. **Unique per type** — Each tag name belongs to one artifact type, with two justified exceptions (`error_handling`, shared by Agent and Skill — disambiguated by file extension and internal structure)
2. **Noun-phrase form** — All tags are noun phrases or compound nouns
3. **No type prefixes** — The file type provides context; `defaults` not `skill_defaults`
4. **Freeform domain wrappers** — Section-grouping tags are project vocabulary, not standardized (per S_50)
5. **Earn existence** — A tag earns its place only by carrying structurally distinct content the agent must process differently from adjacent content

---

## Agent Tags (8)

Agents are autonomous executors. Tags answer: "Who am I? What must I never do? How do I behave? When do I stop?"

| Tag | Purpose | Required |
|-----|---------|----------|
| `safety` | Priority chain (Safety → Accuracy → Clarity → Style) plus NEVER/ALWAYS rules that apply before any action | Yes |
| `iron_laws` | Inviolable constraints with rationalization counters. Opens with halt-trigger scan index. Child: `iron_law`. Conditional: only for agents with high-consequence actions (destructive tools, citation authority, approval authority) | Conditional |
| `boundaries` | Three-tier behavioral envelope: Do / Ask First / Don't | Yes |
| `modes` | Named behavioral configurations the agent switches between. Child: `mode`. Conditional: only for multi-behavior agents | Conditional |
| `context_loading` | What to load, in what order, and fallback behavior when missing. Child: `on_missing`. Absorbs lifecycle/persistence triggers | Yes |
| `error_handling` | Condition-action pairs for runtime recovery. Child: `if`. Absorbs blocked protocol | Yes |
| `stopping_rules` | When to hand off to another agent, when to escalate to user. Absorbs completion criteria | Yes |
| `outputs` | Deliverable templates, confidence thresholds, handoff payload formats. Agent-wide (not per-mode) | Yes |

**Child tags:** `iron_law`, `mode`, `on_missing`, `if`

**What a minimal agent looks like (no iron_laws, no modes):** 6 tags — `safety`, `boundaries`, `context_loading`, `error_handling`, `stopping_rules`, `outputs`.

---

## Skill Tags (6)

Skills are reusable procedures. Tags answer: "What are the steps? What can go wrong? How do I validate?"

| Tag | Purpose | Required |
|-----|---------|----------|
| `workflow` | Container for the ordered step sequence. Child: `step_N_verb` | Yes |
| `defaults` | Fallback values when user specification omits details. Only when ≥3 defaults exist | Optional |
| `error_handling` | If-then recovery pairs for step-level errors. Absorbs escalation triggers (when to ask user) | Yes |
| `quality` | Observable signals distinguishing good from excellent output. Absorbs anti-patterns (common mistakes) | Yes |
| `loading_directives` | Which reference files to load at which step, using JIT syntax. Enables progressive disclosure | Optional |
| `related_artifacts` | Links to related skills, agents, or project files | Optional |

**Child tags:** `step_N_verb` (e.g., `step_1_classify`, `step_4_draft`, `step_5_validate`)

**Why `preconditions` was cut:** Zero occurrences in any skill file. Environment prerequisites belong in Step 1 or the skill description frontmatter.

**Why `acceptance_criteria` was cut:** Quality checks already live in `quality` and the final `step_N_validate`. Separate acceptance criteria creates ambiguity about which is authoritative.

---

## Prompt Tags (5)

Prompts are parameterized templates invoked once. Tags answer: "What do I produce? From what? In what shape?"

| Tag | Purpose | Required |
|-----|---------|----------|
| `task` | The imperative instruction — what the agent must do | Yes |
| `context` | Input anchoring — files, selections, background information with variable substitution | Conditional |
| `format` | Output structure, shape, and length — only when format is complex enough to need its own section | Optional |
| `constraints` | Hard limits on generation — what not to do, boundaries, project conventions to follow | Optional |
| `examples` | Concrete demonstrations calibrating quality. Uses "Wrong:/Correct:" labeling per W_140 | Optional |

**No child tags** — prompts are flat templates.

**What a minimal prompt looks like:** 1 tag — `task`. Simple prompts ("Summarize this file") need nothing else.

**Why `input_variables` was cut:** Variables are declared in frontmatter and used inline. A body section listing variables is redundant.

**Why `negative_examples` was cut:** Negative examples are demonstrations with "Wrong:" labels — structurally identical to positive examples (W_140).

**Why `evaluation_rubric` was cut:** A well-specified task + format IS the rubric. Separate rubrics restate criteria in evaluation language.

---

## Instruction Tags (3)

Instructions are collections of enforceable rules. Tags answer: "What rules apply? How are terms defined?"

| Tag | Purpose | Required |
|-----|---------|----------|
| `rule` | Single enforceable instruction with statement, justification, benefit. Uses `id` attribute (e.g., `id="W_10"`). May contain `example` sub-elements | Yes |
| `term` | Canonical vocabulary entry with definition, aliases, and inline conflict notes. Uses `id` attribute. Domain-specific: only glossary-type instruction files need this | Domain-specific |
| Section wrappers | Freeform descriptive tags grouping related rules by domain concern (e.g., `<xml_conventions>`, `<formatting_conventions>`, `<prohibitions>`). Names are project vocabulary per S_50 — not standardized | Varies |

**Recommended section patterns:**

- A section containing positive domain rules (named to match the domain)
- A section containing prohibitions/anti-patterns (when common mistakes exist)

**Why `scope_pattern` was cut:** Frontmatter `applyTo` already handles file-matching. Body-level scoping duplicates metadata.

**Why `prohibited_patterns` was cut:** Prohibitions are negatively-framed rules. W_190 ("Start prohibitions with No/Never") handles this as a writing convention within `rule`, not a separate structure.

**Why `enforcement_checks` was cut:** Regex/grep patterns are tooling concerns for CI or linters, not instruction content the agent reads at runtime.

**Why `conflict_entries` was cut:** Conflicts are inline within `term` definitions — co-locating conflict data with the term it qualifies is better than separating them.

---

## Disambiguation: Same Concept, Different Tags

| Concept | Agent | Skill | Prompt | Instruction |
|---------|-------|-------|--------|-------------|
| What not to do | `iron_laws` | (in `quality` as anti-patterns) | `constraints` | (in `rule` with Never framing) |
| Error handling | `error_handling` | `error_handling` | — | — |
| Quality check | (in `stopping_rules`) | `quality` | — | — |
| Output format | `outputs` | — | `format` | — |
| Scope / limits | `boundaries` | `defaults` | `constraints` | (frontmatter `applyTo`) |
| Load resources | `context_loading` | `loading_directives` | `context` | — |
| Show examples | — | — | `examples` | (sub-element of `rule`) |
| Behavioral structure | `modes` | `workflow` | `task` | `rule` groups |

---

## Tag Count

| Type | Required | Conditional/Optional | Total |
|------|:--------:|:--------------------:|:-----:|
| Agent | 6 | 2 | 8 |
| Skill | 3 | 3 | 6 |
| Prompt | 1 | 4 | 5 |
| Instruction | 1 | 2 | 3 |
| **All** | **11** | **11** | **22** |

22 tags total — down from 41 (iteration 1) and 143 (raw inventory).
