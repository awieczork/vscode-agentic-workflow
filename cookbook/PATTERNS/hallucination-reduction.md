---
when:
  - improving agent factual accuracy
  - requiring citations for claims
  - preventing fabricated information
  - building verification into prompts
pairs-with:
  - verification-gates
  - iron-law-discipline
  - critique-template
  - prompt-engineering
requires:
  - none
complexity: low
---

# Hallucination Reduction

> Never claim without evidence. When uncertain, say so.

<!-- PLATFORM NOTE: The patterns in this file are community best practices and prompting techniques
implementable via VS Code custom instructions. Official VS Code/Copilot docs acknowledge hallucination
risks but place validation burden on users ("Users of Copilot Chat are responsible for reviewing and
validating responses" — GitHub Responsible Use docs). These patterns help reduce that burden. -->

## The Problem

LLMs confidently state false information. Official documentation explicitly warns:

> "One of the limitations of Copilot Chat is that it may generate code that appears to be valid but may not actually be semantically or syntactically correct"
> — [GitHub Responsible Use of Copilot Chat](https://docs.github.com/en/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot-chat-in-your-ide)

> "There is a risk of 'hallucination,' where Copilot generates statements that are inaccurate"
> — [GitHub Responsible Use docs](https://docs.github.com/en/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot-chat-in-github)

Without explicit guardrails, agents:
- Describe code they haven't read
- Claim test results without running tests
- Fill knowledge gaps with plausible-sounding fabrications
- Rationalize incorrect answers when challenged

## Core Techniques

### 1. Allow "I Don't Know"

Explicitly permit uncertainty. Without permission, models fabricate to appear helpful.

<!-- PARTIAL SUPPORT: Microsoft's "Creating a dynamic UX" guidance confirms this pattern:
"Withhold outputs when necessary... In some cases, it's better for a copilot to give no answer
instead of outputting something potentially inappropriate." -->

```xml
<uncertainty_handling>
When you don't have enough information to answer confidently:
- Say "I don't know" or "I'm not certain"
- Explain what information would help
- Never fabricate plausible-sounding answers

This applies even when the user expects an answer.
</uncertainty_handling>
```

**Why it works:** Removes the implicit pressure to always provide an answer. Microsoft UX guidance explicitly recommends ["withholding outputs when necessary"](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/ux-guidance#6-withhold-outputs-when-necessary).

### 2. Direct Quote Grounding

For long documents (>20K tokens), extract verbatim quotes before answering.

<!-- CONFIRMED: Microsoft UX guidance states: "By integrating direct quotes from the source and
directing the user to the specific location of that information, your copilot can support
more thorough fact-checking." -->

```xml
<grounding_protocol>
When answering questions about provided documents:
1. First, extract exact quotes that support your answer
2. Include file paths and line numbers with each quote
3. Only then formulate your response based on quoted evidence
4. If no supporting quotes exist, say so explicitly
</grounding_protocol>
```

**Template:**
```markdown
Based on the codebase:

**Evidence:**
> "UserService.authenticate() returns null on invalid credentials"
> — [src/services/user.ts](src/services/user.ts#L45)

**Answer:** The authentication returns null rather than throwing...
```

**Official guidance:** Microsoft recommends [citations and direct quotes](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/ux-guidance#4-encourage-fact-checking-using-citations-and-direct-quotes) to "remind users to take accountability for the content they use."

### 3. Verify with Citations

Make claims → cite evidence → retract unsupported claims.

<!-- NOT IN OFFICIAL DOCS: This specific pattern of self-retraction is not documented
in VS Code/Copilot official docs. However, user review of AI outputs is emphasized. -->

```xml
<citation_verification>
After generating any factual claim:
1. Find a supporting quote from provided context
2. If found, include the citation
3. If not found, retract the claim with: "I stated X, but I cannot find supporting evidence for this"

Never leave unverified claims in final output.
</citation_verification>
```

**API-Level Implementation:** For applications using the Claude API, the [Citations API](https://www.anthropic.com/news/introducing-citations-api) (June 2025) provides built-in source citation. Anthropic reports this "reduced source hallucinations and formatting issues from 10% to 0%" in production (Endex case study). *Note: This API is Anthropic-specific and not integrated into VS Code Copilot.*

### 4. Best-of-N Verification

Self-verify by regenerating from a different angle.

<!-- NOT IN OFFICIAL DOCS: This technique is from prompt engineering research,
not documented in VS Code/Copilot official docs. -->

```xml
<self_verification>
For critical decisions, verify your own reasoning:
1. Generate initial answer
2. Ask yourself: "What evidence contradicts this?"
3. Re-examine from skeptical perspective
4. Only proceed if answer survives scrutiny
</self_verification>
```

**Use for:** Architecture decisions, security assessments, breaking changes.

### 5. Investigate-First Rule

Never speculate about code you haven't read.

<!-- PARTIAL SUPPORT: VS Code docs emphasize context provision and the Plan agent's
"research-first" approach. Security docs state: "Review all proposed changes, especially
modifications to important files such as .env or package.json before accepting." -->

```xml
<investigate_before_answering>
BEFORE answering any question about the codebase:
- If user mentions a file → READ that file first
- If describing behavior → FIND the implementation
- If claiming something exists → SHOW the code

Never speculate about code structure, file contents, or behavior without reading the actual files.
</investigate_before_answering>
```

**Forbidden Actions:**
- Claiming code exists without showing it
- Describing behavior without reading implementation
- Stating test results without running tests
- Explaining patterns based on "typical" implementations

**VS Code Support:** The `#codebase` tool and `#file` references provide mechanisms to gather code context before answering. Use these rather than relying on general knowledge.

### 6. External Knowledge Restriction

Explicitly constrain the model to provided documents only.

<!-- PARTIAL SUPPORT: Custom instructions can implement this. MS Transparency Note states
"An important mitigation in Microsoft 365 Copilot is to ground AI-generated content in
relevant business data." -->

```xml
<knowledge_restriction>
Only use information from the provided documents and codebase.
Do NOT use your general knowledge or training data to answer questions.
If the answer is not in the provided context, say so explicitly.
</knowledge_restriction>
```

**Why it works:** Prevents the model from filling gaps with plausible-sounding information from training data. Microsoft emphasizes ["grounding in business data"](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-transparency-note) as a key mitigation for ungrounded content.

### 7. Chain-of-Verification (CoVe)

For complex claims, generate verification questions and re-check.

<!-- NOT IN OFFICIAL DOCS: CoVe is from academic research (Meta/ACL 2023), not documented
in VS Code/Copilot official docs. Related: VS Code 1.99+ added "thinking tool" inspired
by Anthropic research for improved reasoning between tool calls. -->

```xml
<chain_of_verification>
After generating a response with factual claims:
1. Generate 3-5 verification questions about your claims
2. Answer each question independently
3. Compare answers to original claims
4. Revise any claims where verification found inconsistencies
</chain_of_verification>
```

**Example:**
```markdown
**Initial claim:** "The UserService handles authentication via OAuth2."

**Verification questions:**
1. Where is OAuth2 configured in UserService?
2. What OAuth2 library is imported?
3. What OAuth2 endpoints are defined?

**Verification answers:**
1. No OAuth2 config found in UserService
2. No OAuth2 imports found
3. No OAuth2 endpoints defined

**Revised claim:** "The UserService does not handle OAuth2. Authentication appears to use session tokens instead."
```

**Research:** Chain-of-Verification reduces factual hallucinations by 50–70% on QA benchmarks (Meta/ACL 2023).

## Confidence Thresholds

When claims require confidence assessment:

<!-- PARTIAL SUPPORT: Microsoft Copilot Studio documents similar thresholds:
"High (80-100)... Medium (50-79)... Low (0-49)" for prompt confidence scoring.
These exact thresholds are not in VS Code Copilot docs specifically. -->

| Confidence | Action | Phrasing |
|------------|--------|----------|
| High (≥80%) | Proceed with claim | "X does Y" |
| Medium (50-80%) | Add caveat | "Based on the code I've seen, X likely does Y" |
| Low (<50%) | Request clarification | "I'd need to read [file] to answer this accurately" |

*Note: These thresholds align with [Microsoft Copilot Studio guidance](https://learn.microsoft.com/en-us/microsoft-copilot-studio/guidance/kit-prompt-advisor#understand-the-confidence-score) but are practical guidelines for custom instructions, not native VS Code Copilot features. Adjust based on task criticality.*

See [conditional-routing.md](../WORKFLOWS/conditional-routing.md) for confidence-based routing patterns.

## Evidence-First Gate

Apply before any claim. From [verification-gates.md](verification-gates.md):

```markdown
## GATE: Evidence Required

Before claiming:
1. Find the evidence first
2. Quote directly (include file paths and line numbers)
3. Only then make claim
4. If no evidence found, say "I don't know"

❌ "The auth module validates tokens"
✅ "Looking at [auth.ts#L23], the `validateToken()` function checks..."
```

## Anti-Sycophancy Checks

Sycophancy (agreeing with user to please them) is a hallucination vector. Research shows more capable models may sycophant more convincingly.

<!-- NOT IN OFFICIAL DOCS: "Sycophancy" as a term and anti-sycophancy checks are not
documented in VS Code/Copilot official docs. Microsoft UX guidance emphasizes keeping
"Human in control" and avoiding anthropomorphizing AI, which are related principles. -->

**Warning Signs:**
- You're about to agree with user's assertion without checking
- User's framing conflicts with what you observed
- You're softening a finding to avoid disappointing the user
- User expresses strong preference and you're inclined to agree

**Counter-pattern:**
```xml
<sycophancy_prevention>
If user states something as fact:
1. Verify against actual code/docs before agreeing
2. If evidence contradicts user, state the contradiction clearly
3. Your job is accuracy, not agreement
</sycophancy_prevention>
```

**Sycophancy Detection Checklist:**
- [ ] Would this decision change if the user expressed opposite preferences?
- [ ] Has the agent disagreed with the user at least once in this session?
- [ ] Am I citing principles BEFORE decisions, not AFTER as justification?
- [ ] Am I considering ALL relevant guidelines, not just supporting ones?
- [ ] If a different user made this request, would the output be identical?

See [iron-law-discipline.md](iron-law-discipline.md) for rationalization prevention and [four-modes.md](../RED-TEAM/four-modes.md) for red-team verification.

## Integration with Workflows

### Research Phase
Ground findings in sources before proceeding:
```markdown
## Research Complete

Findings with evidence:
- [Finding 1] — Source: [URL]
- [Finding 2] — Source: [file.md#L10]

Unresolved (need more research):
- [Question without clear answer]
```

### Handoffs
Pass evidence, not conclusions:
```markdown
## Handoff

Evidence gathered:
- [Quote 1 with source]
- [Quote 2 with source]

Interpretation (verify independently):
- Based on above, X appears to do Y
```

## Checklist for High-Stakes Claims

Before making architecture recommendations, security assessments, or breaking changes:

- [ ] Have I read the relevant code/docs? (Not assumed from context)
- [ ] Can I quote evidence for each claim?
- [ ] Have I considered contradicting evidence?
- [ ] Am I agreeing because it's true, or because user expects it?
- [ ] Would I make this claim if asked to justify it to a senior engineer?

## VS Code Native Mitigation Features

VS Code Copilot provides several native features that help mitigate hallucination impact:

### Human Review Loop

> "Always review tool parameters carefully before approving, especially for tools that modify files, run commands, or access external services."
> — [VS Code Chat Tools docs](https://code.visualstudio.com/docs/copilot/chat/chat-tools)

- **Review Code Edits:** Keep/Undo controls for all AI-generated changes
- **Tool Approval:** Manual approval before tool execution (`chat.tools.autoApprove` controls)
- **URL Approval:** Two-step verification—approve request, then approve fetched content

### Checkpoints

Revert workspace to previous states when AI makes incorrect changes:
- Automatic checkpoints before edits
- Manual restore to any previous checkpoint
- See [chat-checkpoints docs](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints)

### Context Isolation

Subagents run with isolated context windows, preventing context pollution:
- Each subagent starts fresh
- Results summarized back to parent
- Prevents accumulated hallucinations from spreading

### Appropriate Friction

Microsoft UX guidance recommends ["adding appropriate friction"](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/ux-guidance#3-add-appropriate-friction-its-a-good-thing)—intentionally slowing users at save/share moments to encourage review.

### Context Engineering Anti-Patterns

From [VS Code Context Engineering Guide](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide):
- **Context dumping:** Avoid excessive unfocused information
- **Neglecting validation:** Don't assume AI correctly understands context
- **Session mixing:** Keep different work types in separate sessions

## Related

- [verification-gates.md](verification-gates.md) — Full gate patterns including Anti-Hallucination Gates
- [iron-law-discipline.md](iron-law-discipline.md) — Rationalization prevention and violation detection
- [context-quality.md](../CONTEXT-ENGINEERING/context-quality.md) — Correctness > Completeness > Size priority
- [context-quality.md](../CONTEXT-ENGINEERING/context-quality.md) — Grounding requires accurate context
- [just-in-time-retrieval.md](../CONTEXT-ENGINEERING/just-in-time-retrieval.md) — Investigate-first as JIT pattern
- [conditional-routing.md](../WORKFLOWS/conditional-routing.md) — Confidence-based escalation

## Sources

### Official Documentation
- [Responsible Use of Copilot Chat (IDE) — GitHub](https://docs.github.com/en/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot-chat-in-your-ide) — Official hallucination warnings
- [Responsible Use of Copilot Chat (GitHub) — GitHub](https://docs.github.com/en/copilot/responsible-use-of-github-copilot-features/responsible-use-of-github-copilot-chat-in-github) — Hallucination risk acknowledgment
- [Review Code Edits — VS Code Docs](https://code.visualstudio.com/docs/copilot/chat/review-code-edits) — Human review loop
- [Chat Tools — VS Code Docs](https://code.visualstudio.com/docs/copilot/chat/chat-tools) — Tool approval mechanisms
- [Chat Checkpoints — VS Code Docs](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) — Revert capabilities
- [Context Engineering Guide — VS Code Docs](https://code.visualstudio.com/docs/copilot/guides/context-engineering-guide) — Anti-patterns to avoid
- [Creating a Dynamic UX — Microsoft](https://learn.microsoft.com/en-us/microsoft-cloud/dev/copilot/isv/ux-guidance) — UX guidance for AI (withhold outputs, citations, friction)
- [Transparency Note for Microsoft 365 Copilot — Microsoft](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-transparency-note) — Grounding in business data

### Research & Best Practices
- [Reduce Hallucinations — Anthropic Guardrails](https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/reduce-hallucinations)
- [Claude 4 Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices)
- [Effective Context Engineering for AI Agents — Anthropic](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Citations API — Anthropic](https://www.anthropic.com/news/introducing-citations-api) — Reduces hallucinations to 0% in case studies
- [Why Language Models Hallucinate — OpenAI](https://openai.com/index/why-language-models-hallucinate/)
- [Chain-of-Verification Reduces Hallucination — Meta/ACL](https://arxiv.org/abs/2309.11495)
- [Best Practices for Mitigating Hallucinations — Microsoft](https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/best-practices-for-mitigating-hallucinations-in-large-language-models-llms/4403129)

---

*Last validated against official docs: 2026-01-25*
