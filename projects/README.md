# Projects Folder

> **Your workspace for project configurations before generation.**

---

## Purpose

This folder holds your **input** for the generation pipeline:
- `project-context.md` — Your project description (you fill this)
- `project.spec.md` — Complete specification (@interviewer creates this)

**Not for generated output** — that goes to `generated/{project-name}/`

---

## Quick Start

1. **Copy the template folder:**
   ```
   projects/_template/  →  projects/{your-project-name}/
   ```

2. **Fill out your context:**
   - Open `project-context.md` in your new folder
   - Fill in the REQUIRED fields (marked with ⚠️)
   - Check the self-validation at the bottom

3. **Run the interviewer:**
   ```
   @interviewer projects/{your-project-name}/project-context.md
   ```

4. **Review the spec:**
   Check `project.spec.md` created by interviewer

5. **Generate:**
   ```
   @master-generator projects/{your-project-name}/project.spec.md
   ```

6. **Deploy:**
   Copy `generated/{your-project-name}/.github/` to your target project

---

## Example: Filled project-context.md

```markdown
## Project Name ⚠️

file-organizer

## What Are You Building? ⚠️

A CLI tool that organizes files by moving them into subfolders based on 
their extension. For example, .jpg → images/, .txt → documents/.

## What Does "Done" Look Like? ⚠️

I can run `organize ~/Downloads` and all files get sorted into folders 
by type. Includes a --dry-run flag to preview changes.

## Primary Language ⚠️

Python

## Starting From

[x] Starting fresh — no existing code

## Project Type

[x] CLI tool — command-line application

## Constraints

**What MUST be true?**
- Must work on Windows and Linux
- Python 3.10+

**What MUST NOT happen?**
- No external dependencies (stdlib only)
```

---

## Folder Structure

```
projects/
├── README.md              # This file
├── _template/             # Starter template (copy, don't edit)
│   └── project-context.md
├── my-api-project/        # Example project
│   ├── project-context.md
│   └── project.spec.md
└── another-project/       # Another example
    ├── project-context.md
    └── project.spec.md
```

---

## What Goes Here vs Generated

| This Folder (`projects/`) | Generated Folder (`generated/`) |
|---------------------------|--------------------------------|
| Your project description | Agents, prompts, skills |
| Interview spec | Instructions, memory-bank |
| Additional context files | manifest.json |
| **INPUT** (before generation) | **OUTPUT** (after generation) |

---

## See Also

- [WORKFLOW-GUIDE.md](../GENERATION-RULES/WORKFLOW-GUIDE.md) — Full 6-step workflow
- [COMPONENT-MATRIX.md](../GENERATION-RULES/COMPONENT-MATRIX.md) — Choose component types
