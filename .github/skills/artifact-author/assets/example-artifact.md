<!-- This file demonstrates a correctly structured framework artifact. -->
<!-- Use it as a reference when authoring new .md files for the framework. -->

This file defines the error reporting contract for all agent-to-agent communication. The governing principle is: every failure must be actionable — status codes classify severity, messages explain cause, and recovery fields prescribe next steps.


<error_format>

<!-- Prose intro within section establishes purpose before listing rules. -->

All error reports use a three-field structure. Each field serves a distinct consumer: `status` drives automation, `message` informs humans, `recovery` enables retry logic.

- **status** — Classification of outcome: `success` | `partial` | `failed` | `blocked`
- **error_code** — Machine-readable identifier in kebab-case: `missing-config`, `path-violation`
- **message** — Human-readable explanation of what happened and why
- **recovery** — Prescribed next action to resolve the failure

Wrong: `{ "error": "something went wrong" }` — no classification, no recovery path
Correct: `{ "status": "failed", "error_code": "missing-config", "message": "Config file not found at .github/config.yml", "recovery": "Create config file using template at templates/config.yml" }`

</error_format>


<severity_tiers>

<!-- Arrow notation shows precedence: left tier takes priority over right. -->

Classify every error into exactly one tier. Tier determines handling priority: P1 → P2 → P3.

- **P1 (blocking)** — Prevents task completion; requires immediate resolution before any further work proceeds
- **P2 (degraded)** — Task completes but output quality is reduced; fix before final delivery
- **P3 (cosmetic)** — Does not affect correctness or quality; fix when time permits

<!-- Em-dash definitions keep term and meaning on one line for parseability. -->

Escalation rules:

- If a P2 error recurs 3 times in the same session, then escalate to P1
- If a P3 error affects ≥5 files, then escalate to P2
- Never downgrade severity — only the originating component may reclassify

</severity_tiers>


<retry_policy>

<!-- Separating retry rules from error format keeps each tag single-concern. -->

Failed operations follow exponential backoff before reporting `blocked`. The retry sequence applies to transient failures only — permanent failures (missing files, permission errors) skip retry and report immediately.

- Attempt 1 — Immediate retry
- Attempt 2 — Wait 2 seconds
- Attempt 3 — Wait 8 seconds
- After attempt 3 — Report `blocked` with cumulative error context

Wrong: Retrying a `path-violation` error (permanent) — wastes cycles on an unrecoverable condition
Correct: Retrying a `timeout` error (transient) — network conditions may resolve

</retry_policy>


<reporting_chain>

<!-- Hierarchy uses arrow notation to show delegation flow. -->

Error reports flow through a defined chain: origin → coordinator → user. Each level may enrich the report but never suppress it.

- **origin** — The component that detected the failure; sets `status`, `error_code`, `message`
- **coordinator** — Aggregates errors from multiple origins; adds `recovery` if origin omitted it
- **user** — Final consumer; receives filtered report with actionable recovery steps only

Suppression rules:

- No component may silently discard an error — every error either resolves or propagates
- Duplicate errors within the same operation collapse into a single report with occurrence count
- P1 errors always propagate regardless of aggregation settings

</reporting_chain>
