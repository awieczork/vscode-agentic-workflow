---
description: 'Run a comprehensive repository audit checking cross-file consistency, redundancy, and production readiness'
agent: 'brain'
workflow: 'audit'
---

Orchestrate a full read-only audit of this repository following the [audit workflow](../agent-workflows/audit.workflow.md). Spawn parallel researcher instances — one per audit dimension — then synthesize findings into a unified audit report. Do not apply fixes; report findings and recommendations only.
