# Project Brief: patterns-shiny-app

> **Status:** v1 | **Updated:** 2026-01-28 | **Phase:** Setup

---

## 1. Vision

**Goal:** Interactive Shiny application for visualizing and exploring user session patterns through document relationship graphs.

**User:** Internal analysts exploring pattern data on corporate network.

**Principle:** Performance-first — handle large datasets (~800k sessions) without UI freezing.

---

## 2. How It Works

Users select a pattern from ~20k available, optionally filter by metadata (segment, industry, date), and view an interactive graph showing document co-occurrence relationships. A simulation feature lets users build a hypothetical session to find matching patterns.

### Key Components

| Component | Purpose | Status |
|-----------|---------|--------|
| Pattern Selection | Browse and search ~20k patterns | ⏳ |
| Session Filters | Filter by segment, industry, date range | ⏳ |
| Document Graph | visNetwork visualization of relationships | ⏳ |
| Session Simulation | Build session → find matching patterns | ⏳ |

---

## 3. Phases

### Phase 1: Core Infrastructure ⏳ CURRENT

| Step | Output | Status |
|------|--------|--------|
| 1.1 | Data layer (Arrow/Parquet loading) | ⏳ |
| 1.2 | Basic UI layout with bslib | ⏳ |
| 1.3 | Pattern list module | ⏳ |

### Phase 2: Visualization

| Step | Output | Status |
|------|--------|--------|
| 2.1 | Filter module | ⏳ |
| 2.2 | Graph visualization module | ⏳ |
| 2.3 | Performance optimization | ⏳ |

### Phase 3: Simulation & Polish

| Step | Output | Status |
|------|--------|--------|
| 3.1 | Session simulation module | ⏳ |
| 3.2 | Tooltips and UX polish | ⏳ |
| 3.3 | Docker deployment | ⏳ |

---

## 4. Deliverables

| # | Deliverable | Status | Location |
|---|-------------|--------|----------|
| 1 | Shiny application | ⏳ | `app/` |
| 2 | Docker configuration | ⏳ | `docker/` |
| 3 | Data schema documentation | ⏳ | `docs/` |

---

## 5. Agents

### Core Workflow Agents

| Agent | Purpose | When to Use |
|-------|---------|-------------|
| **@brain** | Strategic thought partner | Explore, synthesize, maintain coherence |
| **@architect** | Create actionable plans | Know what to do, need structured approach |
| **@build** | Execute plans | Have approved plan, ready to implement |
| **@inspect** | Verify builds | After build, before sign-off |
| **@research** | Quick lookup, fact-check | Need specific info fast |

### Domain Agents

| Agent | Purpose | When to Use |
|-------|---------|-------------|
| **@shiny-dev** | R/Shiny specialist | Modules, reactivity, bslib, visNetwork |
| **@docker-deploy** | Container deployment | Dockerfile, docker-compose, optimization |

**Workflow:** `brain → architect → (shiny-dev | docker-deploy) → inspect`

---

## 6. Directory Structure

```
{project}/
├── .github/
│   ├── agents/         # Agent definitions
│   ├── prompts/        # Workflow templates
│   ├── skills/         # Packaged capabilities
│   ├── instructions/   # Auto-apply rules
│   ├── memory-bank/    # Project state
│   └── copilot-instructions.md
├── src/                # Source code
└── ...
```

---

## 7. Notes

{Any additional context, decisions, or constraints}
