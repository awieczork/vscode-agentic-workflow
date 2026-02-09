---
description: 'Orchestration model — two-phase convergence-to-execution pattern with checkpoint styles'
---

This artifact captures the orchestration model for multi-agent orchestration. The governing principle is two-phase execution — @brain drives convergence through exploration and decision modes, then orchestrates execution by routing work through specialized agents per an @architect plan.


<two_phase_model>

**Phase 1: Convergence** — User + @brain collaborate using explore/decide/research/perspective modes. Multiple iterations until shared understanding emerges. Output: converged idea with clear direction.

**Phase 2: Execution** — User triggers mode switch ("let's proceed", "make it happen"). @brain hands off to @architect for planning, then orchestrates execution by spawning agents per the plan.

@brain MUST hand off to @architect for planning — it never plans or decomposes tasks itself.

</two_phase_model>


<execution_styles>

Two styles, user chooses at trigger:

- **Checkpoint** (default, safer) — @brain presents each agent's result to user, waits for approval before routing to the next agent. Checkpoints occur at every handoff boundary
- **Autonomous** — @brain evaluates results internally, routes to next agent immediately. Reports final result to user
- **Hybrid** — "autonomous but pause before destructive actions" — checkpoints only at operator/build boundaries

Natural checkpoint moments (at every handoff boundary):

1. After @architect — "Here's the plan. Proceed?" (most critical)
2. After each domain agent — "Audit complete. Proceed to implementation?"
3. After @build — "Code written. Verify quality?"
4. After @inspect — "Issues found. Investigate or accept?"

Default: checkpoint. Explicit trigger needed for autonomous ("do it all", "fully autonomous", "don't stop").

</execution_styles>


<brain_orchestrate_mode>

`<mode name="orchestrate">` in @brain's behaviors:

**Trigger:** User signals shift from convergence to execution — "let's do it", "proceed", "make it happen"

**Steps:**

1. Summarize converged understanding
2. Hand off to @architect for plan decomposition
3. Receive plan (sequence of tasks with agent assignments)
4. For each task in plan: spawn assigned agent → evaluate result → route next (or checkpoint)
5. Report final result to user

**Exit:** All tasks complete → final report | Blocked → escalate to user

@brain's role in orchestrate mode: **evaluate and route** — it doesn't implement, plan, or verify. It reads results and decides what's next.

</brain_orchestrate_mode>
