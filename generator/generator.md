# Generation Pipeline

Automated creation of `.github/` frameworks for new projects.

**Status:** Interview agent implemented. Master and Creator agents planned.

---

## Overview

The `generator/` folder provides automated `.github/` framework creation through user interviews that transform requirements into validated artifacts.

---

## Questionnaire Format

Users fill the XML questionnaire in `/interview` prompt:

```xml
<questionnaire version="1.0">
  <name required="true">kebab-case identifier</name>
  <description required="true">What it does, 2-3 sentences</description>
  <tech>Languages, frameworks, tools — one per line</tech>
  <workflows>Tasks you repeat — one per line</workflows>
  <constraints>Rules to enforce — one per line</constraints>
  <refs>
    <ref src="url-or-path" tags="word word" />
  </refs>
</questionnaire>
```

**Required fields:** `<name>`, `<description>`

**Optional fields:** `<tech>`, `<workflows>`, `<constraints>`, `<refs>`

See [user-manual.md](../../generator/user-manual.md) for examples.

---

## Reference Processing

The `<refs>` element links external documentation:

```xml
<refs>
<ref src="https://example.com/docs" tags="framework routing" />
<ref src="./docs/style-guide.md" tags="style internal" />
</refs>
```

- `src` (required) — URL or relative file path
- `tags` (optional) — Space-separated keywords, user's choice

Interview agent batches refs (max 3 per batch) and spawns @brain to summarize each batch. Summaries inform artifact recommendations.

---

## Three-Agent Architecture

| Agent | Role | Input | Output | Status |
|-------|------|-------|--------|--------|
| **Interview** (`@interview`) | Clarifies questionnaire, synthesizes requirements | Questionnaire + conversation | Project brief + artifact manifest | Implemented |
| **Master** (planned) | Validates decisions, determines order, spawns Creator | Project brief + manifest | Validated artifacts | Planned |
| **Creator** (planned) | Reads skills, produces artifacts | Type + spec + skill path | Artifact + validation report | Planned |

---

## Generation Flow

1. **User Input** — Run `/interview` prompt, fill XML questionnaire
2. **Validation** — Interview checks required fields, identifies gaps
3. **Reference Summary** — Interview spawns @brain to summarize linked sources
4. **Clarification** — Interview asks 2-3 questions if ambiguities exist
5. **Synthesis** — Interview generates project brief + artifact manifest
6. **User Approval** — Review recommendations before proceeding
7. **Handoff** — To @architect for planning or @build for generation

---

## Agent Responsibilities

### Interview Agent (Implemented)

- Parse and validate XML questionnaire
- Spawn @brain to summarize `<refs>` in batches (max 3 per batch)
- Clarify ambiguities through follow-up questions (2-3 per turn, 5-7 max total)
- Synthesize requirements into project brief
- Recommend artifacts with rationale tied to user workflows
- Wait for explicit user approval before handoff
- Output: project brief + artifact manifest

### Master Agent (Planned)

- Validate Interview's artifact decisions in fresh context
- Determine creation order based on dependencies
- Spawn Creator for each artifact: type, spec, skill path
- Loop: spawn → receive → validate → next

### Creator Agent (Planned)

- Read skill for specified artifact type
- Follow skill workflow (skill is self-sufficient)
- Produce validated artifact + validation report
- Return artifact to Master

---

## Resources

| Resource | Path | Status |
|----------|------|--------|
| Interview agent | `.github/agents/interview.agent.md` | Implemented |
| Interview prompt | `.github/prompts/interview.prompt.md` | Implemented |
| User manual | `generator/user-manual.md` | Implemented |
| Flow prompts | `.github/prompts/_flow/` | Planned |
| Project Brief | `.github/memory-bank/global/projectbrief.md` | Runtime |

---

## Cross-References

- Architecture overview: [architecture.md](architecture.md)
- Interview agent: [interview.agent.md](../../.github/agents/interview.agent.md)
