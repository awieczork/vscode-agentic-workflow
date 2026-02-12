Canonical single-source for forbidden tag validation across artifact types. Each artifact type has a closed tag vocabulary — tags from other artifact types must not appear in its output. Skills that validate output artifacts reference this file instead of maintaining inline tag lists.


<agents_forbidden_tags>

Tags that MUST NOT appear in `.agent.md` output — these belong to skills:

- `<workflow>`
- `<step_N_verb>` (any `<step_` prefixed tag)
- `<use_cases>`
- `<resources>`
- `<error_handling>`
- `<validation>`

</agents_forbidden_tags>


<skills_forbidden_tags>

Tags that MUST NOT appear in `SKILL.md` output — these belong to agents:

- `<constraints>`
- `<behaviors>`
- `<outputs>`
- `<termination>`
- `<iron_law>`
- `<mode>`
- `<context_loading>`
- `<on_missing>`
- `<when_blocked>`
- `<if>`

</skills_forbidden_tags>


<prompts_forbidden_tags>

Tags that MUST NOT appear in `.prompt.md` output — these belong to agents and skills:

Agent tags:

- `<constraints>`
- `<behaviors>`
- `<outputs>`
- `<termination>`
- `<iron_law>`
- `<mode>`
- `<context_loading>`
- `<on_missing>`
- `<when_blocked>`
- `<if>`

Skill tags:

- `<workflow>`
- `<step_N_verb>` (any `<step_` prefixed tag)
- `<use_cases>`
- `<resources>`
- `<error_handling>`
- `<validation>`

</prompts_forbidden_tags>


<instructions_forbidden_tags>

Tags that MUST NOT appear in `.instructions.md` output — these belong to agents and skills:

Agent tags:

- `<constraints>`
- `<behaviors>`
- `<outputs>`
- `<termination>`
- `<iron_law>`
- `<mode>`
- `<context_loading>`
- `<on_missing>`
- `<when_blocked>`
- `<if>`

Skill tags:

- `<workflow>`
- `<step_N_verb>` (any `<step_` prefixed tag)
- `<use_cases>`
- `<resources>`
- `<error_handling>`
- `<validation>`

</instructions_forbidden_tags>


<platform_reserved>

VS Code injects these tags into agent system prompts. Using them in authored artifacts causes unpredictable collision. Treat as globally reserved.

- `<instructions>` — Wraps agent mode instructions
- `<skills>` — Platform-injected skill listing
- `<modeInstructions>` — Agent mode-specific instructions
- `<toolUseInstructions>` — Tool usage guidelines
- `<communicationStyle>` — Communication formatting
- `<outputFormatting>` — Output format rules
- `<repoMemory>` — Memory system instructions
- `<reminderInstructions>` — Reminder system
- `<workflowGuidance>` — Workflow tracking guidance
- `<agents>` — Agent listing injected by platform. **Exception:** `<agents>` is used deliberately in `copilot-instructions.md` as a framework convention to list available spoke agents. This collision is mitigated because VS Code injects `copilot-instructions.md` content within `<attachment>` wrappers, so the framework's `<agents>` tag operates in attachment scope rather than at the system-prompt top level where the platform reserves it.

</platform_reserved>
