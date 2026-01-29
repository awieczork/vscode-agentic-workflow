# Memory Tags

Tag vocabulary for memory-bank schema — persistent project state.

---

## Required

```yaml
tiers: Memory hierarchy (HOT/WARM/COLD/FROZEN with TTL)
update_triggers: When to update files (event → file mappings)
```

## Recommended ⭐

Make memory predictable and maintainable.

```yaml
loading_order: Priority-ordered read sequence
schema: Field definitions (types, constraints, validation)
conflict_resolution: How to handle merge conflicts
```

## Optional

For complex memory systems.

```yaml
retention: Archival rules (when to archive or delete)
compaction: How to summarize old entries
backup: Snapshot/restore strategy
```

---

## Examples

**tiers** — nest each tier:
```markdown
<tiers>

<tier name="HOT" ttl="session">
activeContext.md, currentTask.md
</tier>

<tier name="WARM" ttl="1_week">
decisions.md, progress.md
</tier>

<tier name="COLD" ttl="persistent">
projectbrief.md
</tier>

<tier name="FROZEN" ttl="immutable">
techContext.md
</tier>

</tiers>
```

**update_triggers** — event → file:
```markdown
<update_triggers>

<trigger event="session_end">activeContext.md</trigger>
<trigger event="decision_made">decisions.md (append)</trigger>
<trigger event="phase_complete">projectbrief.md</trigger>

</update_triggers>
```

**loading_order** — priority sequence:
```markdown
<loading_order>
1. projectbrief.md (always)
2. activeContext.md (always)
3. decisions.md (on-demand)
</loading_order>
```

<!-- Reference Links -->
[tag-index]: TAG-INDEX.md
