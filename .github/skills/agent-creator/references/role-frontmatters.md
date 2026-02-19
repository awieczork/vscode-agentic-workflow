Baseline frontmatters for the five core roles. Domain agents inherit and extend these templates — they may add tools to match domain needs but should not remove core tools. Use the appropriate role template as the starting point, then customize `name`, `description`, and `tools` for the target domain.


<developer>

```yaml
---
name: '{domain}-developer'
description: '{domain-specific description}'
tools: ['search', 'read', 'edit', 'execute', 'context7', 'web']
user-invokable: false
disable-model-invocation: false
agents: []
---
```

</developer>


<researcher>

```yaml
---
name: '{domain}-researcher'
description: '{domain-specific description}'
tools: ['search', 'read', 'web', 'context7']
user-invokable: false
disable-model-invocation: false
agents: []
---
```

</researcher>


<planner>

```yaml
---
name: '{domain}-planner'
description: '{domain-specific description}'
tools: ['search', 'read']
user-invokable: false
disable-model-invocation: false
agents: []
---
```

</planner>


<inspector>

```yaml
---
name: '{domain}-inspector'
description: '{domain-specific description}'
tools: ['search', 'read', 'context7', 'runTests', 'testFailure']
user-invokable: false
disable-model-invocation: false
agents: []
---
```

</inspector>


<curator>

```yaml
---
name: '{domain}-curator'
description: '{domain-specific description}'
tools: ['search', 'read', 'edit', 'execute']
user-invokable: false
disable-model-invocation: false
agents: []
---
```

</curator>


<customization_rules>

- Domain agents may add tools to the base set but should not remove core tools — the base set defines minimum capability for the role
- `user-invokable` is always `false` — domain agents are subagents, never user-facing
- `agents` is always an empty array — domain agents do not invoke other agents
- `description` should be keyword-rich and domain-specific — it drives agent discovery and selection by the orchestrator
- `name` follows the `{domain}-{core-role}` pattern — the domain prefix describes the specialization, the suffix maps to the core role

</customization_rules>
