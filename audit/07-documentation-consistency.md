# D7: Documentation Consistency

## Terminology Inventory

### Canonical Terms

| Category | Canonical Term | Definition |
|----------|----------------|------------|
| **Artifact Types** | agent, skill, prompt, instruction | Lowercase, singular |
| **Pipeline Agents** | Interview, Master, Creator | Title case when naming agent |
| **Documents** | project brief, execution manifest | Two words, lowercase |
| **Status** | not-started, in-progress, completed, failed | Lowercase, hyphenated |
| **Complexity** | L0, L1, L2 | Uppercase L + digit |
| **Priority** | P1, P2, P3 | Uppercase P + digit |
| **Folders** | .github/, generator/ | With trailing slash |

### Inconsistencies Found (14)

| ID | Issue | Files Affected | Remediation |
|----|-------|----------------|-------------|
| T1 | Agent name casing (`Interview` vs `interview`) | Multiple | Use Title case for agent names |
| T2 | "project brief" vs "projectbrief" | generator.md, interview.agent.md | Standardize to "project brief" |
| T3 | "execution manifest" vs "artifact manifest" | generator.md | Standardize to "execution manifest" |
| T4 | Status casing (`Complete` vs `complete`) | Various | Use lowercase always |
| T5 | `in-progress` vs `in_progress` | interview.agent.md | Use hyphenated form |
| T6 | `complete` vs `completed` | Various | Use "completed" for past state |
| T7 | knowledge-base/ references | 4+ files | Remove (folder archived) |
| T12 | spawn/invoke/delegate unclear | Agent files | Define: spawn=subagent, handoff=transfer |

---

## Cross-Reference Audit

### Broken Links (5)

| Location | Target | Issue |
|----------|--------|-------|
| architecture.md | xml-tags.md | File does not exist |
| architecture.md | interview.agent.md | Wrong path (../../.github/) |
| generator.md | user-manual.md | Wrong path (../../generator/) |
| copilot-instructions.md | creator-skill-patterns.md | Folder does not exist |
| instruction-creator | knowledge-base/*.md | Folder does not exist |

### Orphan Files

- prompt-creator has no references/ folder (intentional — simpler artifact)
- audit/*.md files unreferenced (expected — working documents)

---

## Stale Content Inventory

### P1: Actively Misleading (7 items)

| File | Content | Action |
|------|---------|--------|
| architecture.md:9-10 | knowledge-base/ purpose statement | REMOVE |
| architecture.md:17-32 | Folder diagram with knowledge-base/ | UPDATE |
| architecture.md:49-59 | Knowledge-Base Organization section | DELETE |
| architecture.md:77-78 | Dead link to xml-tags.md | REMOVE |
| generator.md:5 | Status re: Master/Creator agents | UPDATE |
| generator.md:37-41 | Three-Agent table with "Planned" | CLARIFY |
| copilot-instructions.md:25 | Dead link to creator-skill-patterns.md | REMOVE |

### P2: Outdated (7 items)

| File | Content | Action |
|------|---------|--------|
| architecture.md:23-24 | memory-bank/ without context | CLARIFY |
| generator.md:57-66 | Master Agent planned section | UPDATE or ARCHIVE |
| generator.md:68-73 | Creator Agent planned section | UPDATE |
| generator.md:78-81 | Flow prompts as Planned | UPDATE |
| generator.md:80 | projectbrief.md path | CLARIFY |
| All agent files | memory-bank context_loading | ADD NOTE |

### P3: Cosmetic (5 items)

- Multiple markdown tables violate style rules
- Unusual relative paths in cross-references

---

## Summary Statistics

| Category | Count | Status |
|----------|-------|--------|
| Terminology inconsistencies | 14 | Needs standardization |
| Broken links | 5 | Needs removal |
| Orphan files | ~25 | Mostly expected |
| P1 stale content | 7 | Critical to fix |
| P2 stale content | 7 | Should fix soon |
| P3 stale content | 5 | Can defer |

---

## Remediation Priority

### Immediate (Before Master/Creator work)

1. Remove all knowledge-base/ references
2. Fix broken links in architecture.md, generator.md, copilot-instructions.md
3. Fix instruction-creator external references
4. Standardize terminology (in-progress, status values)

### Soon (During refactoring)

5. Clarify generator architecture (skills vs agents)
6. Add memory-bank context notes to agent files
7. Update Three-Agent table in generator.md

### Later (Cleanup)

8. Convert markdown tables to bullet lists
9. Fix unusual relative paths
10. Add audit/README.md

---

## Iterations Completed: 3/3-4
- [x] D7.1: Terminology inventory
- [x] D7.2: Cross-reference validation
- [x] D7.3: Stale content identification
