Shared validation rules for all artifact types produced by creator skills. The governing principle is: validation consistency across artifact types — every artifact passes the same structural and quality gates regardless of type, eliminating duplicated rules and ensuring uniform standards.


<p1_blocking>

Rules that block output delivery. Any violation requires immediate correction.

- All YAML string values wrapped in single quotes: `name: 'value'`, `description: 'value'`
- No hardcoded secrets or absolute paths
- No markdown headings — XML tags are exclusive structure
- No cross-artifact-type tags — verify against the relevant forbidden-tags section in [forbidden-tags.md](forbidden-tags.md) for your artifact type

</p1_blocking>


<p2_quality>

Rules that degrade output quality. Fix before finalizing.

- Cross-file XML tag references use linked-file form: `<tag>` in [file.md](path) — same-file references use backticks only
- Every `Load [file] for:` directive resolves to an existing file
- No orphaned resources — every file in subfolders referenced from the parent skill file

</p2_quality>


<p3_polish>

Rules that affect consistency and tone. Apply during final review.

- Active voice throughout, no hedging
- Every file in the skill folder opens with a prose intro containing governing principle

</p3_polish>
