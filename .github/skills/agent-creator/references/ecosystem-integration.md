This reference explains how agents connect to the broader ecosystem: memory-bank files, handoff chains, auto-loading instructions, and skill invocation. The governing principle is minimal coupling — agents reference ecosystem components by path rather than embedding content, enabling independent evolution. Use this during `<step_6_integrate>` to wire the agent into project infrastructure.


<memory_bank_structure>

```
.github/memory-bank/
├── sessions/
│   ├── _active.md              # Current session state
│   └── archive/
│       └── {date}-{topic}.md   # Completed sessions
└── global/
    ├── projectbrief.md         # Project context
    └── decisions.md            # ADR log (append-only)
```

<tier_definitions>

**HOT tier:**
- Load when: Every session
- Files: `_active.md`, `projectbrief.md`
- Token budget: Always include

**WARM tier:**
- Load when: On-demand
- Files: `decisions.md`, archived sessions
- Token budget: Below 60% utilization only

**FROZEN tier:**
- Load when: Excerpts only
- Files: Large specs, reference docs
- Token budget: Rarely, load sections not full files

</tier_definitions>

<context_thresholds>

- **Below 60%** — Load HOT + essential WARM
- **Above 60%** — Load HOT only, signal to user
- **Above 80%** — Compact HOT, preserve critical only

</context_thresholds>

<update_events>

**session_start:**
- Action: Read, update focus
- Target: `_active.md`

**session_end:**
- Action: Write handoff summary
- Target: `_active.md`

**decision_made:**
- Action: Append ADR entry
- Target: `decisions.md`

**blocker_found:**
- Action: Document blocker
- Target: `_active.md`

</update_events>

</memory_bank_structure>


<handoff_mechanics>

<frontmatter_syntax>

```yaml
handoffs:
  - label: 'Start Building'      # Button text shown to user
    agent: 'build'               # Target agent (without .agent.md)
    prompt: |                    # Context passed to target
      Summary: [Completed work description]
      Key Findings:
      - [Finding 1]
      - [Finding 2]
      Files Relevant:
      - `path/to/file` — [description]
      Next Steps: [What target should do]
      Constraints: [Inherited limits]
    send: false                  # false = user reviews, true = auto-send
    model: 'model-name'         # Optional model override
```

</frontmatter_syntax>

<send_behavior>

**`send: false` (default):**
- Behavior: Pre-fills prompt, waits for user review
- Use when: Target has edit/execute tools

**`send: true`:**
- Behavior: Auto-submits immediately
- Use when: Target is read-only, well-tested

Default to `send: false`. Use `send: true` only for read-only targets after extensive testing.

</send_behavior>

<common_handoff_chains>

**Standard flow:** brain (explore) → architect (plan) → build (execute) → inspect (verify)

**Handoff triggers:**
- brain → architect: Options identified, needs planning
- architect → build: Plan complete, needs implementation
- build → inspect: Implementation complete, needs verification
- inspect → architect: Issues found, needs plan adjustment

</common_handoff_chains>

</handoff_mechanics>


<instruction_loading>

Instructions auto-apply based on `applyTo` patterns.

```yaml
# In .github/instructions/typescript.instructions.md
---
applyTo: "**/*.ts"
---
```

**How it works:**
1. Agent opens or edits a file matching pattern
2. Matching instructions automatically load into context
3. Agent follows instruction rules for that file type

**Agent implication:** Do not duplicate file-specific rules in agent definition. Let instructions handle file-pattern rules.

</instruction_loading>


<skill_invocation>

Agents can invoke skills for complex procedures.

**Invocation methods:**
1. **Automatic** — Skill loads when task matches description triggers
2. **Explicit** — User or agent references skill by name

**Skill structure:**
```
.github/skills/[skill-name]/
├── SKILL.md           # Main instructions
├── references/        # Detailed docs (JIT loaded)
└── assets/            # Templates, examples
```

**Agent implication:** For complex procedures, create a skill rather than embedding in agent definition. Keep agents focused on identity and coordination.

</skill_invocation>


<mcp_server_integration>

External tools via Model Context Protocol.

**Syntax:**
```yaml
tools:
  - 'github/*'              # All tools from github server
  - 'context7/resolve'      # Specific tool from context7
  - 'playwright/navigate'   # Specific tool from playwright
```

**Error handling:**
When MCP tool fails:
1. Wait 1 second, retry once
2. If still failing, try alternative tool
3. If no alternative, report partial results

**Rate limits:** Add awareness for external tools:
```markdown
<constraints>
GitHub API: Max 30 requests per minute
External search: Max 10 queries per session
</constraints>
```

</mcp_server_integration>


<hub_and_spoke_architecture>

Single orchestrator coordinates specialists. No peer-to-peer.

**Structure:**
- Hub (orchestrator): `brain`
- Spokes (specialists): `architect`, `build`, `inspect`
- Communication: Hub → Spoke only, no Spoke → Spoke

**Rules:**
- Subagent spawning subagents = prohibited (uncontrolled depth)
- Maximum subagent depth = 1
- Chain depth ≤4 agents total
- Errors amplify through chains

</hub_and_spoke_architecture>


<cross_references_in_agents>

Link to ecosystem files using relative paths:

```markdown
See [decision-rules.md](references/decision-rules.md) for tool selection.
```

Do NOT embed large content. Reference by path, load JIT.

</cross_references_in_agents>


<cross_references>

- [SKILL.md](../SKILL.md) — Parent skill entry point

</cross_references>
