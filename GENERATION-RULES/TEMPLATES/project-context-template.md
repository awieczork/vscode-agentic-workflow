---
type: template
template-for: project-context
version: 1.0.0
purpose: User entry point — minimal context to start agent-assisted development
applies-to: [user, interviewer, generator]
last-updated: 2026-01-28
---

# Project Context Template

> **Your starting point for agent-assisted development. Fill this out, then invoke `@interviewer` or `@generator`.**

---

## HOW TO USE THIS FILE

**For Users:**
1. Copy this template to your project root as `project-context.md`
2. Fill in the REQUIRED fields (marked with ⚠️)
3. Optional fields help but aren't blocking
4. Run self-validation checklist at the end
5. Invoke `@interviewer` for guided discovery OR `@generator` for direct generation

**For Interviewer Agent:**
- Parse REQUIRED fields as conversation starting points
- Skip questions user already answered
- Expand user input into full `project.spec.md` (per project-spec-schema)
- Focus on FUZZY sections — that's where discovery happens

**For Generator Agent:**
- Accept this as minimal input (Mode 2: casual extraction)
- Infer missing fields from context
- If critical context missing → prompt user OR suggest `@interviewer`
- Map fields to project-spec-schema internally

---

## TEMPLATE

Copy everything below this line:

```markdown
# Project Context

<!-- REQUIRED FIELDS — Fill these to proceed -->

## Project Name ⚠️

[Your project name — working title is fine, can change later]

> 💡 Example: `data-validator`, `my-todo-api`, `untitled-ml-experiment`


## What Are You Building? ⚠️

[Describe what this project does in 2-5 sentences. Focus on OUTCOMES, not implementation.]

> 💡 Example: "A CLI tool that validates CSV files against schema definitions and reports errors in a human-readable format."

[ ] I'm still exploring — help me discover what I'm building


## What Does "Done" Look Like? ⚠️

[How will you know when this project is successful? What can you do that you couldn't before?]

> 💡 Example: "I can run `validate data.csv --schema schema.json` and get a pass/fail report."

[ ] I'm not sure yet — need help defining success


## Primary Language ⚠️

[Main programming language for this project]

> Options: Python | TypeScript | JavaScript | Go | Rust | Java | C# | Other: ___


<!-- RECOMMENDED FIELDS — Help agents help you better -->

## Starting From

[ ] Starting fresh — no existing code
[ ] Existing codebase — building on/modifying existing code
[ ] Fork/adaptation — using another project as starting point

If existing code, briefly describe what exists:
[                                                          ]


## Project Type

[Pick one — leave blank if unsure, interviewer will help]

[ ] CLI tool — command-line application
[ ] API service — REST/GraphQL backend
[ ] Web app — frontend web application  
[ ] Data pipeline — data processing workflow
[ ] Library — reusable package/module
[ ] Mixed/Other — describe: _______________


## Constraints

**What MUST be true?** (non-negotiable requirements)
- [e.g., "Must work offline", "Must support Python 3.9+"]
- [                                                     ]

**What MUST NOT happen?** (hard limits)
- [e.g., "No external API calls", "No paid dependencies"]
- [                                                      ]

[ ] No constraints known yet


## Out of Scope

[What are you explicitly NOT building? This prevents scope creep.]
- [e.g., "Not building a GUI — CLI only"]
- [                                       ]

[ ] Haven't defined scope boundaries yet


<!-- OPTIONAL FIELDS — Nice to have, can be discovered later -->

## Frameworks/Libraries (if known)

[Preferences for specific tools — leave blank for suggestions]
- [e.g., "click for CLI", "FastAPI for API", "React for frontend"]


## What's Still Fuzzy?

[What are you figuring out? This tells interviewer where to focus.]
- [e.g., "Not sure about data storage approach"]
- [e.g., "Unsure whether to use sync or async"]


## Team Context

[ ] Solo project
[ ] Small team (2-5)
[ ] Larger team (5+)


## References (optional)

[Links to inspiration, similar projects, relevant docs]
- [                                                    ]


---

## ✅ Self-Validation (Before You Submit)

Check these before invoking an agent:

**BLOCKING — Must pass:**
- [ ] Project has a name (even working title)
- [ ] I've described what I'm building OR checked "still exploring"
- [ ] I've defined "done" OR checked "need help defining"
- [ ] Primary language is specified

**RECOMMENDED — Better results if provided:**
- [ ] Starting point is clear (fresh/existing/fork)
- [ ] At least one constraint OR "none known"
- [ ] Out of scope has at least one item OR "haven't defined yet"

⚠️ If BLOCKING items aren't checked, agent will ask these questions first.

---

## Next Steps

**Option A: Guided Discovery**
```
@interviewer
```
Interviewer will review your context, ask clarifying questions, and produce a detailed `project.spec.md`.

**Option B: Direct Generation**
```
@generator I want to build [brief description]
```
Generator extracts what it needs and prompts for missing critical info.

**Option C: Expand This Context**
If you want to provide more detail upfront, see `GENERATION-RULES/TEMPLATES/spec-template.md` for the full specification format.
```

---

## FIELD DEFINITIONS

| Field | Required | Type | Consuming Agent | Validation |
|-------|----------|------|-----------------|------------|
| `Project Name` | ⚠️ YES | string | Generator, Interviewer | Non-empty; valid for file naming |
| `What Are You Building?` | ⚠️ YES | string | All | Non-empty OR "exploring" checked |
| `What Does Done Look Like?` | ⚠️ YES | string | Generator, Build | Non-empty OR "not sure" checked |
| `Primary Language` | ⚠️ YES | enum | Generator | One valid language |
| `Starting From` | Recommended | enum | Interviewer | One option selected |
| `Project Type` | Recommended | enum | Generator | Valid type if provided |
| `Constraints` | Recommended | list | Generator, Build | Empty allowed |
| `Out of Scope` | Recommended | list | Generator | Empty allowed |
| `Frameworks` | Optional | list | Generator | Freeform |
| `What's Fuzzy` | Optional | list | Interviewer | Focus areas for discovery |
| `Team Context` | Optional | enum | Generator | Affects complexity defaults |
| `References` | Optional | list | All | URLs/paths |

---

## VALIDATION RULES

```
VALID_PROJECT_CONTEXT:
  REQUIRE all_of:
    - project_name is non-empty
    - building_description is non-empty OR exploring_checkbox is checked
    - done_definition is non-empty OR unsure_checkbox is checked
    - primary_language is specified
  
  WARN_IF:
    - starting_from is unselected
    - constraints is empty AND no_constraints is unchecked
    - out_of_scope is empty AND no_boundaries is unchecked
```

---

## ANTI-PATTERNS

| ❌ Don't | ✅ Instead | Why |
|----------|-----------|-----|
| Leave all fields blank | Fill REQUIRED fields at minimum | Agents can't help without context |
| Write implementation details | Describe outcomes and goals | Let agents propose HOW |
| Skip "What's Fuzzy" | Note your uncertainties | Interviewer focuses discovery there |
| Check "exploring" for everything | Be specific where you can | More specific = better results |
| Provide framework details only | Describe the PROBLEM first | Frameworks are solutions, not goals |

---

## CROSS-REFERENCES

| Related File | Relationship |
|--------------|-------------|
| `project-spec-schema.md` | Full schema that Interviewer produces from this input |
| `spec-template.md` | Comprehensive spec format for detailed requirements |
| `validation-checklist.md` | Source of validation patterns |

---

## SOURCES

- [spec-template.md](../../cookbook/TEMPLATES/spec-template.md) — Template structure patterns
- [project-spec-schema.md](../../cookbook/TEMPLATES/project-spec-schema.md) — Required field definitions
- [validation-checklist.md](../../cookbook/TEMPLATES/validation-checklist.md) — Self-validation patterns
