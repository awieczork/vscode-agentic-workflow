---
when:
  - classifying patterns by authority level
  - validating source attribution
  - auditing cookbook content provenance
  - syncing community vs official patterns
pairs-with:
  - constraint-hierarchy
  - constitutional-principles
  - hallucination-reduction
requires:
  - none
complexity: low
---

# Authority Index

> **Purpose:** Canonical source URLs for authority classification. Used by decision-mapper agent to classify patterns by authority level.

**Last Synced:** 2026-01-26
**Source:** [OFFICIAL-DOCS-VALIDATION-TRACKER.md](OFFICIAL-DOCS-VALIDATION-TRACKER.md)

---

## Authority Levels

| Level | Badge | Meaning |
|-------|-------|---------|
| A1 | 🟢 | **VS Code Native** — Official platform feature |
| A2 | 🔵 | **GitHub Native** — GitHub Copilot feature |
| A3 | 🟣 | **MCP Standard** — Model Context Protocol spec |
| A4 | 🟡 | **Community** — Attributed pattern with external source |
| A5 | ⚪ | **Cookbook-Defined** — Project-specific convention |

---

## Tier 1: VS Code Official (A1 🟢)

| ID | URL | Topics |
|----|-----|--------|
| D1 | https://code.visualstudio.com/docs/copilot/customization/custom-agents | Agent files, frontmatter, model, handoffs |
| D2 | https://code.visualstudio.com/docs/copilot/customization/prompt-files | Prompt files, variables |
| D3 | https://code.visualstudio.com/docs/copilot/customization/custom-instructions | Instruction files, scoping |
| D4 | https://code.visualstudio.com/docs/copilot/customization/mcp-servers | MCP configuration |
| D5 | https://code.visualstudio.com/docs/copilot/chat/chat-tools | Tools, tool sets |
| D6 | https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context | Context management |
| D7 | https://code.visualstudio.com/docs/copilot/chat/chat-sessions | Sessions, subagents |

---

## Tier 2: GitHub Official (A2 🔵)

| ID | URL | Topics |
|----|-----|--------|
| D8 | https://docs.github.com/en/copilot/customizing-copilot | GitHub customization, AGENTS.md |
| D8a | https://docs.github.com/en/copilot/reference/custom-agents-configuration | Agent YAML frontmatter reference |
| D8b | https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/ | AGENTS.md best practices |

---

## Tier 3: MCP Standard (A3 🟣)

| ID | URL | Topics |
|----|-----|--------|
| D9 | https://modelcontextprotocol.io/docs/learn/architecture | MCP architecture |
| D10 | https://modelcontextprotocol.io/docs/learn/server-concepts | MCP primitives, tools, resources |

---

## Tier 4: Community Sources (A4 🟡)

| ID | URL | Pattern | Attribution |
|----|-----|---------|-------------|
| C1 | https://github.com/cline/cline | Memory Bank | Cline project |
| C2 | https://github.com/humanlayer/12-factor-agents | Twelve-Factor Agents, ACE framework | HumanLayer |
| C3 | https://github.com/obra/superpowers | Iron Law, Red Flags, Rationalization Prevention | obra/superpowers |
| C4 | https://github.com/danielmiessler/telos | TELOS goals framework | danielmiessler |
| C5 | https://github.com/drumnation/cursor-riper-sigma | CursorRIPER, Protection Levels, RIPER modes | CursorRIPER.sigma |
| C6 | https://github.com/theowright/spec-kit | Spec-driven development, EARS notation | Spec-Kit |
| C7 | https://github.com/mem0ai/mem0 | Tiered memory, conflict resolution | mem0 |
| C8 | https://github.com/steveyegge/beads | Task dependencies, hash-based IDs | Beads (steveyegge) |

---

## Refresh Process

To re-sync this index from the validation tracker:

1. **Review** [OFFICIAL-DOCS-VALIDATION-TRACKER.md](OFFICIAL-DOCS-VALIDATION-TRACKER.md) "Tier 1 URLs" section
2. **Update** tables above with any new/changed URLs
3. **Update** "Last Synced" date at top of file
