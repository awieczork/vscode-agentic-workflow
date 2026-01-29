# Iteration State: Spec Format Routing Problem

> **Topic:** How to improve `project.spec.md` format to prevent workflow misrouting
> **Iterations:** 10 of 10 ✅
> **Created:** 2026-01-28
> **Status:** COMPLETE

---

## HANDOFF (FINAL)

**TL;DR:** Use content-based routing with Ask-When-Uncertain pattern. Add optional `spec_purpose:` field as explicit override. Keep separate spec schemas but share common base structure.

### Key Decisions (Post-Critique)

| ID | Decision | Final Confidence | Change from Initial |
|----|----------|------------------|---------------------|
| D1 | Keep separate spec schemas (agent-ecosystem vs build) | 85% ✅ | Maintained — critique raised good points but separate concerns still warrant separate schemas |
| D2 | Primary routing: **Content-based analysis** (not self-describing) | 85% ✅ | REVISED — demoted `spec_purpose:` from required to optional override |
| D3 | Filename is **human hint only**, not routing signal | 75% 🟡 | REVISED — from primary to secondary |
| D4 | Add **Ask-When-Uncertain** pattern when confidence < 80% | 90% ✅ | NEW — leverage agent capabilities |
| D5 | Add weighted field scoring for schema matching | 85% ✅ | NEW — concrete implementation |

### Recommendations for @architect

1. **Create `project.build.spec.md` schema** for application builds
   - Share base structure with agent-ecosystem spec (project block, _meta block)
   - Add build-specific sections: Functional Requirements, Data Architecture, Deployment

2. **Update `project-spec-schema.md`** (current agent-ecosystem spec)
   - Rename to clearly indicate purpose (`project-agent-ecosystem-schema.md`)
   - Enforce `type:` enum validation (fail on unknown values)
   - Make `components:` presence a validation warning

3. **Implement content-based routing** in receiving agents:
   - Score spec against both schemas using weighted field matching
   - Auto-route at ≥80% confidence
   - Ask user at 60-79% (with suggested answer)
   - Require explicit `_meta.spec_purpose:` in batch mode when <80%

4. **Add `_meta.spec_purpose:` as optional override**:
   ```yaml
   _meta:
     spec_purpose: agent-ecosystem | build  # Optional — overrides scoring
   ```

5. **Update @interviewer** to capture intent early:
   - Ask "Are you generating agents or building an application?" early in discovery
   - Produce the correct spec type based on answer

---

## Problem Statement

`master-generator` received a Shiny app spec and got confused because:
1. The spec format doesn't clearly signal **what kind of deliverable** is expected
2. There's no explicit **workflow routing** field
3. The current `project-spec-schema.md` is designed for **agent ecosystem generation**, not application code

### Root Cause (CONFIRMED)

The `project.type` field exists but:
- Values like `cli-tool`, `api-service`, `web-app` don't distinguish between:
  - **A)** Generate agent files to HELP build this project type ← Schema's intent
  - **B)** Actually BUILD this project type (code, not agents) ← Shiny spec's intent

The Shiny app spec uses `type: shiny-app` which isn't even in the enum.

---

## Iteration Log

### Iteration 1: Routing Patterns Research
**Findings:** Kubernetes `kind`, Terraform namespacing, OpenAPI discriminator, npm `type` field — all use explicit routing signals in the document body (not filename).

### Iteration 2: Failed Spec Analysis
**Findings:** Shiny spec has `type: shiny-app` (invalid enum), missing `components:` section (key signal), and has build-only sections (Functional Requirements, Data Architecture). Schema validation would have caught this if enforced.

### Iteration 3: Routing Responsibility
**Findings:** Self-describing spec (Envelope Wrapper pattern) is fail-fast and portable. But invoker decision is what failed here.
**Initial Decision:** Primary: self-describing. Backup: lightweight validation.

### Iteration 4: Unified vs Separate Formats
**Findings:** Only 3-12 fields overlap depending on measurement. Different consumers (generator vs architect). JSON Schema polymorphism is brittle.
**Initial Decision:** Separate formats.

### Iteration 5: CRITIQUE of D1 (Separate Formats)
**Challenge:** "Only 3 fields overlap" is misleading — actual structural overlap is 60-70%. Maintenance burden scales poorly with more spec types. Kubernetes uses unified format successfully.
**Response:** Valid points. However, the KEY sections are non-overlapping (`components:` vs `Functional Requirements`). Separate formats remain cleaner for distinct consumers.
**Verdict:** D1 MAINTAINED at 85% confidence (down from 90%)

### Iteration 6: CRITIQUE of D2/D3 (Self-Describing + Filename)
**Challenge:** Adding `spec_purpose:` shifts cognitive burden to users. Users can get it wrong just like `type:`. Validation chicken-egg problem. LLM agents should ASK when uncertain.
**Response:** Strong critique. The "Ask When Uncertain" pattern is underutilized.
**Verdict:** D2 REVISED — demote to optional override. D3 REVISED — filename is hint only.

### Iteration 7: Ask-When-Uncertain Pattern
**Findings:** Weighted field scoring can distinguish schemas. 80% threshold for auto-routing. Below threshold: ask with A/B/C choice. Batch mode: fail-fast with explicit override.
**New Decision (D4/D5):** Implement content-based routing with Ask-When-Uncertain.

### Iteration 8-10: Synthesis and Final Review
- Consolidated all findings
- Resolved conflicting recommendations
- Produced actionable handoff for @architect

---

## Blocking Questions (RESOLVED)

| Q# | Question | Resolution |
|----|----------|------------|
| BQ1 | One format or separate? | Separate — but share common base structure |
| BQ2 | Who owns routing? | Content-based analysis by receiving agent, user asked when uncertain |
| BQ3 | Minimal change? | Enforce existing validation + add Ask-When-Uncertain |

---

## Scoring Criteria for Routing

| Field | Agent-Ecosystem Weight | Build-Spec Weight |
|-------|----------------------|-------------------|
| `components:` section | **30** | 0 |
| `components.agents` list | **15** | 0 |
| `Functional Requirements` section | 0 | **25** |
| `Data Architecture` section | 0 | **20** |
| `Technical Stack` section | 0 | **15** |
| `project.type` in known enum | **10** | 5 |
| `_meta.generated_by: interviewer` | **10** | 0 |
| `workflow:` section | **10** | 0 |
| `Deployment` section | 0 | **10** |

**Routing Logic:**
```
score_agent = sum(weights for matching agent-ecosystem fields)
score_build = sum(weights for matching build-spec fields)
confidence = max(score_agent, score_build) / total_possible

IF confidence >= 80%: auto-route to winner
ELIF confidence >= 60%: ask with suggested answer
ELSE: ask required (no default)

IF _meta.spec_purpose present: override scoring, use declared purpose
```

---

## Clarification Question Template

```markdown
⚠️ **Spec type unclear** — Which workflow did you intend?

Your spec `{filename}` could match either:

**A) Generate agent ecosystem** ← Create Copilot agents, skills, instructions
   - Score: {agent_score}% | {missing_fields}
   
**B) Build application** ← Architect and implement the app
   - Score: {build_score}% | {present_fields}
   
**C) Something else** — I'll ask follow-up questions

Enter A, B, or C: _
```

---

## Sources

- [Enterprise Integration Patterns — Envelope Wrapper](https://www.enterpriseintegrationpatterns.com/patterns/messaging/EnvelopeWrapper.html)
- [JSON Schema Blog — Modelling Inheritance](https://json-schema.org/blog/posts/modelling-inheritance) — Anti-patterns for polymorphic schemas
- [Kubernetes API Structure](https://iximiuz.com/en/posts/kubernetes-api-structure-and-terminology/) — `kind` discriminator pattern
- [Learning to Ask: When LLM Agents Meet Unclear Instruction](https://arxiv.org/html/2409.00557v3) — Ask-When-Needed pattern
- [Google ML Thresholding](https://developers.google.com/machine-learning/crash-course/classification/thresholding) — Confidence threshold guidance

---

## Decisions Triage (FINAL)

| ID | Decision | Status | Confidence |
|----|----------|--------|------------|
| D1 | Separate spec schemas | ✅ | 85% |
| D2 | Content-based routing (primary) | ✅ | 85% |
| D3 | Filename as human hint only | 🟡 | 75% |
| D4 | Ask-When-Uncertain pattern | ✅ | 90% |
| D5 | Weighted field scoring | ✅ | 85% |
| D6 | Optional `_meta.spec_purpose:` override | ✅ | 80% |

---

## Next Steps

1. **@architect** — Design spec routing implementation (content-based scoring + Ask-When-Uncertain)
2. **@architect** — Create `project.build.spec.md` schema template
3. **@build** — Update `project-spec-schema.md` with validation enforcement
4. **@build** — Update @interviewer to capture workflow intent early
