---
description: 'Audit workflow — parallel dimension-scoped research with severity-graded findings synthesis'
triggers: ['audit']
phases: ['parse-sources', 'parallel-research', 'deduplicate', 'classify', 'synthesize']
---

<!-- ═══════════════════════════════════════════════════════════════════ -->
<!-- SOURCES OF TRUTH — authoritative references for audit baseline     -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<sources_of_truth>

Load these files as the authoritative references for repository structure, orchestration contracts, and generation workflow:

- [copilot-instructions.md](../copilot-instructions.md) — workspace map, project context, constraints, decision framework
- [orchestration.model.md](../models/orchestration.model.md) — hub-and-spoke agent contracts
- [generation-workflow.model.md](../models/generation-workflow.model.md) — generation pipeline stages

</sources_of_truth>


<!-- ═══════════════════════════════════════════════════════════════════ -->
<!-- AUDIT DIMENSIONS — one researcher instance per dimension           -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<audit_dimensions>

Assign each dimension to a separate researcher instance. Each instance scans every file in the repository relevant to its dimension.

- **D1 — Cross-file consistency** — Verify all file references, relative paths, and citations between artifacts resolve to existing files. Check that XML tag cross-references (e.g., "`<tag>` in [file.md](path)") point to real tags in real files. Confirm agent spawn templates reference correct agent files
- **D2 — Redundancy** — Identify duplicated content across files. Flag overlapping responsibilities between agents, skills, instructions, or prompts. Detect copy-pasted sections that should be single-sourced
- **D3 — Component compatibility** — Verify agents, skills, instructions, prompts, models, and templates form a coherent system. Check that spawn templates match agent input contracts. Confirm skill references in copilot-instructions.md match actual skill folders. Validate that prompt `agent` fields reference existing agents
- **D4 — Naming conventions** — Audit file naming patterns (kebab-case, extensions), XML tag naming (snake_case, no conflicts with reserved tags), YAML field naming (consistent casing and quoting). Flag deviations from established patterns
- **D5 — Stale content** — Find references to deleted or renamed files, outdated terminology, orphaned artifacts (files not referenced from anywhere), and TODO/FIXME markers. Check workspace map in copilot-instructions.md against actual directory contents
- **D6 — Completeness** — Identify missing fields in frontmatter, incomplete contracts (e.g., agent missing iron laws, skill missing validation), partial implementations, and gaps where documented structure promises content that does not exist
- **D7 — Production readiness** — Assess whether all components are functional and sufficient for end-to-end use. Flag placeholder content, empty directories listed as Active, missing error handling, and undocumented dependencies between components

</audit_dimensions>


<!-- ═══════════════════════════════════════════════════════════════════ -->
<!-- EXECUTION — step-by-step audit procedure                           -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<execution>

1. Parse the sources of truth to establish the expected repository structure and contracts
2. Spawn one researcher per dimension (D1–D7) — each researcher scans all relevant files and returns raw findings
3. Collect all researcher results
4. Deduplicate findings that appear across multiple dimensions
5. Classify each unique finding by severity:
   - P1 — Blocks correct operation or breaks a contract
   - P2 — Degrades quality or causes confusion
   - P3 — Cosmetic or optional improvement
6. Synthesize into the output format below

</execution>


<!-- ═══════════════════════════════════════════════════════════════════ -->
<!-- OUTPUT FORMAT — unified audit report structure                      -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<output_format>

Present the unified audit report in this structure:

- **Summary** — Total finding count by severity (P1/P2/P3), overall production-readiness assessment (Ready / Needs Work / Not Ready)

- **Findings** — One entry per finding, as a bullet list:
  - `[P{n}]` `[D{n}]` **{file path}** (line {number or range}, if applicable) — {finding description} — Fix: {recommended action}

  Sort findings: P1 first, then P2, then P3. Within each severity, group by dimension.

- **Recommendations** — Top 3-5 prioritized actions that would most improve production readiness, ordered by impact

</output_format>


<!-- ═══════════════════════════════════════════════════════════════════ -->
<!-- SCOPE BOUNDARY — read-only restriction                             -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<scope_boundary>

This audit is strictly read-only. Do not edit, create, move, or delete any files. Do not execute commands that modify repository state. Output findings and recommendations only.

</scope_boundary>
