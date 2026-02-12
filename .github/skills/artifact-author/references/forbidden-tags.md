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
