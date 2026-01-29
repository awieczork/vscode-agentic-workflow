# Project Brief: VS Code Agentic Workflow Framework

> **Status:** v15 | **Updated:** 2026-01-28 | **Phase:** Phase 6: Clarification

---

## 1. Vision

**Goal:** Meta-agentic framework where user provide high-level project context and agents 
generate a complete, customized workflow of agents, skills, prompts, instructions, 
and memory-bank files — all tailored to the user's specific project needs.

**User:** Data Scientist, who builds this framework for own use to streamline 
future AI-assisted projects.

**Principle:** Generator **synthesizes** (not selects) patterns from enriched cookbook 
— combining elements intelligently based on project context.

**CRITICAL REQUIREMENT** VS Code + GitHub Copilot Chat only

---

## 2. How It Works
> During meta-phase user created a cookbook covering configs, requierements, patterns,
> and templates for agentic workflows. Cookbook covers VS Code + GitHub Copilot Chat
> platform constraints, inspiration from other well-established agent frameworks, 
> community patterns and approaches. For many problems multiple patterns exist,
> each with pros/cons. 

> Based on cookbook, user with help of Copilot Chat agents created a GENERATION-RULES
> set of synthesis instructions, patterns, and checklists that can guide the agent to 
> produce the desired output files.


## 3. Constraints

### Platform (fixed)

- 100% VS Code with GitHub Copilot Chat as primary interface
- In-file config only (`.md`, `.json` etc.)
- Agent files: YAML frontmatter + markdown body
