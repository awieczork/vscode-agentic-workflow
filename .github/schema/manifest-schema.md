This file defines the manifest schema — the index file produced by @interviewer and consumed by @master. The manifest lists all artifacts to create, their specs, and the orchestration model for domain agent workflows.


<design_decisions>

- Manifest = single YAML file listing all artifacts with paths to individual spec files
- Orchestration section defines HOW domain agents work together and WHERE core agents plug in
- Two orchestration layers: FIXED core agents (brain, architect, build, inspect) + PROJECT-SPECIFIC domain agents
- Workflow style: per-workflow default (checkpoint/autonomous) with per-edge overrides
- @creator receives manifest path alongside spec path — reads manifest for relationship context

</design_decisions>


<field_definitions>

<manifest_meta>

- `manifest_version` — `integer`, currently `1` — Schema version
- `project_name` — `string` — From questionnaire `project.name`
- `project_domain` — `string` — From questionnaire `project.domain`
- `created_by` — `"interviewer"` — Always set by @interviewer

</manifest_meta>

<artifacts>

Flat list of all artifacts to create. One entry per spec file.

- `artifacts[]` — Array of artifact entries:
  - `name` — `string` — Artifact name (matches spec `name`)
  - `artifact_type` — `"agent"` | `"prompt"` | `"instruction"` | `"skill"` — Artifact type
  - `spec_path` — `string` — Relative path to the spec YAML file
  - `priority` — `P1` | `P2` | `P3` — Creation priority for @master sequencing
  - `description` — `string` — One-line justification for why this artifact exists

</artifacts>

<orchestration>

Domain agent workflow design. Defines how the created agents connect to each other and to core agents.

- `core_integration` — Fixed mapping of core agent roles:
  - `entry` — `brain` — @brain routes user requests to entry points
  - `planning` — `architect` — @architect plans multi-agent sequences
  - `implementation` — `build` — @build handles code changes domain agents identify
  - `verification` — `inspect` — @inspect verifies domain agent outputs

- `entry_points[]` — Agents users invoke directly:
  - `agent` — `string` — Agent name from artifacts list
  - `trigger` — `string` — What user intent routes here

- `workflows[]` — Named sequences of agents:
  - `name` — `string` — Workflow identifier
  - `sequence` — `string[]` — Ordered list of agent names (may include core agents)
  - `style` — `checkpoint` | `autonomous` — Default execution style for all edges
  - `core_touchpoints[]` — Optional. Where core agents integrate:
    - `after` — `string` — Domain agent name
    - `to` — `string` — Core agent name
    - `reason` — `string` — Why this handoff exists

- `handoffs[]` — Explicit edges between agents:
  - `from` — `string` — Source agent name
  - `to` — `string` — Target agent name
  - `when` — `string` — Condition that triggers the handoff
  - `send` — `boolean`, optional — Override workflow `style` for this edge

- `instruction_bindings[]` — Maps instructions to agents and file patterns:
  - `instruction` — `string` — Instruction artifact name from artifacts list
  - `agents` — `string[]` — Agent names this instruction applies to
  - `file_patterns` — `string[]` — File glob patterns for `applyTo` frontmatter (e.g., `["**/*.R", "**/*.Rmd"]`)

</orchestration>

</field_definitions>


<example_manifest>

```yaml
manifest_version: 1
project_name: acme-api
project_domain: fintech
created_by: interviewer

artifacts:
  - name: deployer
    artifact_type: agent
    spec_path: .github/specs/deployer.spec.yaml
    priority: P1
    description: "Executes deployment pipelines — user described manual deploy process with frequent rollbacks"

  - name: reviewer
    artifact_type: agent
    spec_path: .github/specs/reviewer.spec.yaml
    priority: P1
    description: "Reviews PRs against project conventions — user wants automated code review"

  - name: verifier
    artifact_type: agent
    spec_path: .github/specs/verifier.spec.yaml
    priority: P2
    description: "Post-deployment health checks — validates system state after deployer finishes"

  - name: typescript-standards
    artifact_type: instruction
    spec_path: .github/specs/typescript-standards.spec.yaml
    priority: P2
    description: "TypeScript conventions — user listed specific style preferences in constraints"

  - name: deploy-runbook
    artifact_type: prompt
    spec_path: .github/specs/deploy-runbook.spec.yaml
    priority: P3
    description: "Quick deployment checklist prompt — supplements deployer agent for manual runs"

orchestration:
  core_integration:
    entry: brain
    planning: architect
    implementation: build
    verification: inspect

  entry_points:
    - agent: reviewer
      trigger: "PR needs review"
    - agent: deployer
      trigger: "Deployment requested"

  workflows:
    - name: deploy-pipeline
      sequence: [reviewer, deployer, verifier]
      style: checkpoint
      core_touchpoints:
        - after: verifier
          to: inspect
          reason: "Final quality gate on deployment artifacts"

    - name: hotfix
      sequence: [reviewer, deployer, verifier]
      style: autonomous
      core_touchpoints:
        - after: reviewer
          to: build
          reason: "Apply hotfix code changes"

  handoffs:
    - from: reviewer
      to: deployer
      when: "Review approved, ready to deploy"
    - from: deployer
      to: verifier
      when: "Deployment complete, needs health check"
    - from: verifier
      to: inspect
      when: "Health check complete, needs final verification"

  instruction_bindings:
    - instruction: typescript-standards
      agents: [reviewer]
      file_patterns: ["**/*.ts", "**/*.tsx"]
```

</example_manifest>
