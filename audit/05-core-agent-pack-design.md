# Core Agent Pack Design

Design specification for portable, project-independent agent distribution.

## Executive Summary

**Recommended approach:** Option A — Separate `core-agents/` folder in this repository with versioned releases.

**Rationale:**
- Single source of truth with development workflow
- Version control via git tags, not filename pollution
- Clear separation: `core-agents/` = stable distribution, `.github/agents/` = project-specific customizations
- No infrastructure overhead (separate repos, distribution channels)

---

## Design Decisions

### 1. Location: `core-agents/` Folder

```
vscode_agentic_workflow/
├── core-agents/                    # ← Portable distribution
│   ├── README.md                   # Installation guide
│   ├── CHANGELOG.md                # Version history
│   ├── agents/
│   │   ├── architect.agent.md
│   │   ├── brain.agent.md
│   │   ├── build.agent.md
│   │   └── inspect.agent.md
│   ├── docs/
│   │   ├── customization.md        # Extension patterns
│   │   └── agent-reference.md      # What each agent does
│   └── examples/
│       └── project-overlay.md      # Sample customization
├── .github/
│   └── agents/                     # ← Project-specific (interview stays here)
│       └── interview.agent.md
```

**Why not other options:**

- **Option B (tagged versions in .github/agents/):** Pollutes working directory; hard to separate "stable" from "dev"
- **Option C (separate repository):** Coordination overhead; version drift between repos
- **Option D (distribution channel):** Premature; no ecosystem demand yet

---

### 2. Copy-Paste Readiness Criteria

An agent is "copy-paste ready" when it meets ALL of these:

| Criterion | Test | Current Status |
|-----------|------|----------------|
| No absolute paths | Grep for `e:\`, `C:\`, `/home/` | ✓ Pass |
| No project-specific skills | No `#skill:` refs to local skills | ✓ Pass |
| Optional memory-bank refs | Memory-bank used conditionally ("if present") | ✓ Pass |
| Self-documenting identity | First paragraph explains role | ✓ Pass |
| Standard tool references | Uses canonical tool names only | ✓ Pass |
| No project-specific handoffs | Handoffs reference core agents only | ✓ Pass |

**Modifications needed for distribution:**

Remove from core agents:
- References to `.github/copilot-instructions.md` (project-specific) — make conditional
- References to `interview` agent in any handoffs (project-specific)

Add to core agents:
- Version header comment at top of file
- "Part of VS Code Core Agent Pack" identifier

---

### 3. Customization Pattern: Instruction Overlays

**Recommended approach:** Project-specific instructions that extend core agents.

**Mechanism:** VS Code's `applyTo` directive in `.github/instructions/` files.

**Pattern:**

```yaml
# .github/instructions/architect.project.instructions.md
---
applyTo: "**/architect.agent.md"
description: "Project-specific extensions for architect agent"
---

<project_context>

This project uses:
- TypeScript with strict mode
- pnpm for package management
- Vitest for testing

When planning, always include:
- Type definition updates
- Test file creation steps
- pnpm lock file considerations

</project_context>

<additional_constraints>

- Plans must include accessibility checks for UI components
- Database migrations require rollback scripts

</additional_constraints>
```

**Why not other patterns:**

- **Agent extension (inheritance):** VS Code doesn't support agent inheritance; would require preprocessing
- **Skill additions:** Skills are procedure-level; don't modify agent behavior at identity level
- **Fork and modify:** Loses upstream updates; maintenance burden

---

### 4. Documentation Inventory

**Required documents:**

| Document | Purpose | Location |
|----------|---------|----------|
| README.md | Installation guide | `core-agents/README.md` |
| CHANGELOG.md | Version history | `core-agents/CHANGELOG.md` |
| agent-reference.md | What each agent does, when to use | `core-agents/docs/` |
| customization.md | Extension patterns, examples | `core-agents/docs/` |

**README.md structure:**

```markdown
# VS Code Core Agent Pack

Four portable agents for AI-assisted development workflows.

## Quick Start

1. Copy `agents/` folder to your project's `.github/agents/`
2. Done — agents are ready to use

## What's Included

- **architect** — Plans and verifies plan compliance
- **brain** — Explores options, researches, synthesizes
- **build** — Executes plans, creates files
- **inspect** — Quality gate, final verification

## Customization

See [docs/customization.md] for project-specific extensions.

## Version

Current: 1.0.0
See CHANGELOG.md for history.
```

---

### 5. Naming Convention

**Recommendation:** Keep current names without namespace or version suffix.

| Approach | Example | Verdict |
|----------|---------|---------|
| Current names | `architect.agent.md` | ✓ Recommended |
| Namespaced | `core-architect.agent.md` | ✗ Verbose, no benefit |
| Versioned filename | `architect-1.0.agent.md` | ✗ Breaks handoff references |

**Rationale:**
- Simple, memorable names
- Version tracked via git tags and CHANGELOG.md
- Handoffs reference agent by `name` field, not filename
- Namespacing adds cognitive overhead with no practical benefit

---

## Distribution Workflow

### Initial Release (v1.0.0)

1. Create `core-agents/` structure
2. Copy and clean agents (remove project-specific references)
3. Add version comment to each agent
4. Write documentation
5. Tag release: `git tag core-agents-v1.0.0`

### Future Updates

1. Modify agents in `.github/agents/` (development)
2. Test changes in context
3. When stable, sync to `core-agents/`
4. Update CHANGELOG.md
5. Tag new release

### User Installation

```bash
# From release
curl -L https://github.com/.../archive/core-agents-v1.0.0.tar.gz | tar xz
cp -r vscode_agentic_workflow-*/core-agents/agents/ .github/agents/

# Or manual
# Download core-agents/agents/ folder
# Copy contents to .github/agents/
```

---

## Agent Modifications for Distribution

### Version Header (add to all)

```markdown
<!-- VS Code Core Agent Pack v1.0.0 -->
<!-- https://github.com/.../core-agents -->
```

### Context Loading (modify all)

Change from:

```markdown
**HOT (always load):**
1. `.github/copilot-instructions.md` — Project context and constraints (if present)
```

To:

```markdown
**HOT (always load):**
1. `.github/copilot-instructions.md` — Project context and constraints (load if exists, continue without if missing)
```

### Handoffs (verify all)

Ensure no handoffs reference `interview` agent (it's project-specific).

Current handoff graph (all valid for core pack):
- architect → build, brain, inspect ✓
- brain → architect, build ✓
- build → inspect, architect, brain ✓
- inspect → build, architect, brain ✓

---

## Implementation Checklist

### Phase 1: Structure

- [ ] Create `core-agents/` directory
- [ ] Create `core-agents/agents/` directory
- [ ] Create `core-agents/docs/` directory
- [ ] Create `core-agents/examples/` directory

### Phase 2: Agent Preparation

- [ ] Copy architect.agent.md, add version header
- [ ] Copy brain.agent.md, add version header
- [ ] Copy build.agent.md, add version header
- [ ] Copy inspect.agent.md, add version header
- [ ] Verify no project-specific references remain

### Phase 3: Documentation

- [ ] Write README.md
- [ ] Write CHANGELOG.md
- [ ] Write docs/agent-reference.md
- [ ] Write docs/customization.md
- [ ] Write examples/project-overlay.md

### Phase 4: Release

- [ ] Final review
- [ ] Tag v1.0.0

---

## Open Questions

1. **Memory-bank bootstrapping:** Should core-agents include a minimal memory-bank template? (Recommendation: No — keep agents stateless-capable, document memory-bank as optional enhancement)

2. **Skill bundling:** Should core agents ship with any skills? (Recommendation: No — skills are domain-specific by nature)

3. **Update mechanism:** How do users pull updates? (Recommendation: Manual for v1.0; consider automated sync script for v2.0)

---

## Approval Gate

**Status:** Design complete. Awaiting approval to proceed with implementation.

**Next action:** If approved, execute Phase 1-4 checklist to create the core-agents distribution folder.
