---
when:
  - debugging UI issues from screenshots
  - converting designs to code
  - analyzing error messages visually
  - discussing architecture diagrams
pairs-with:
  - prompt-engineering
requires:
  - none
complexity: low
---

# Vision Capabilities

Use image input in Copilot Chat for UI debugging, error analysis, design-to-code workflows, and architecture interpretation.

**Status:** Preview feature
**Requirement:** Vision-capable model

> **Platform Note:** Vision capabilities are documented for VS Code. Some specific limits (3 images per message, GIF single-frame) are explicitly documented for Visual Studio 2022 but silent in VS Code docs — they likely share backend constraints.
>
> Source: [VS Code Chat Context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context#_vision-preview), [GitHub Using Images](https://docs.github.com/en/copilot/using-github-copilot/copilot-chat/asking-github-copilot-questions-in-your-ide#using-images-in-copilot-chat)

## How to Attach Images

| Method | Action |
|--------|--------|
| **Drag & Drop** | Drag from Explorer, OS file manager, or web browser into Chat |
| **Paste** | Copy image → `Ctrl+V` in Chat |
| **Screenshot** | Click Attach (📎) → Screenshot Window |
| **Context Menu** | Right-click image in Explorer → Copilot → Add File to Chat |
| **Add Context** | Click "Add Context" button in Chat view |

<!-- NOT IN OFFICIAL DOCS (VS Code): 3 images per message limit - documented for VS 2022 only - flagged 2026-01-26 -->
**Limit:** 3 images per message (documented for Visual Studio 2022)

## Supported Formats

| Format | Support |
|--------|---------|
| PNG | ✅ Full |
| JPEG/JPG | ✅ Full |
| GIF | ✅ Supported <!-- NOT IN OFFICIAL DOCS (VS Code): "single frame only" is documented for VS 2022 only - flagged 2026-01-26 --> |
| WEBP | ✅ Full |

> **Note:** Visual Studio 2022 docs specify "GIF (single-frame only)" — VS Code docs list GIF as supported but don't mention frame limitations.

## Vision-Capable Models

| Model | Best For |
|-------|----------|
| **GPT-5 mini** | Fast multimodal tasks, screenshot analysis |
| **GPT-5.2** | Advanced visual reasoning |
| **GPT-4o** | General visual tasks, reliable baseline |
| **Claude Sonnet 4** | Visual debugging, UI analysis |
| **Claude Opus 4.5** | Enhanced vision: zoom inspection, multi-image, video frame analysis |
| **Gemini 3 Pro** | Deep visual reasoning |
| **Gemini 3 Flash** | Fast visual processing |
| **Gemini 2.5 Pro** | Complex visual analysis |

> **Tip**: For visual tasks like interpreting screenshots or UI diagrams, GitHub recommends **GPT-5 mini**, **Claude Sonnet 4**, or **Gemini 3 Pro**.

> **Note**: Gemini 2.0 Flash was retired in October 2025.

## Practical Patterns

### Pattern 1: Visual Debugging

Screenshot broken UI and ask for fixes.

```
[Attach screenshot of broken layout]

What CSS issue is causing this layout problem?
The sidebar should be fixed, but it's scrolling with content.
```

### Pattern 2: Error Analysis

Capture error dialogs, stack traces, or console output.

```
[Attach screenshot of error message]

Explain this error and suggest how to fix it.
This happens when I click the submit button.
```

### Pattern 3: Design-to-Code

Turn mockups into working components.

```
[Attach Figma/sketch mockup]

Create a React component matching this design.
Use Tailwind CSS for styling.
Include hover states as shown.
```

### Pattern 4: Architecture Discussion

Analyze system diagrams and create implementation plans.

```
[Attach architecture diagram]

Based on this architecture:
1. What services need to be created?
2. What are the data flows?
3. Create an implementation plan starting with the core API.
```

### Pattern 5: Accessibility Audit

Get accessibility recommendations from UI screenshots.

```
[Attach screenshot of form UI]

Review this form for accessibility issues.
Check: color contrast, label associations, keyboard navigation, screen reader support.
```

### Pattern 6: Code Explanation

When you have code as an image (documentation, slides, screenshots).

```
[Attach screenshot of code]

Explain what this code does.
Are there any bugs or improvements you'd suggest?
```

## Model Selection Guide

| Task | Recommended Model |
|------|-------------------|
| Fast UI feedback | Gemini 3 Flash, GPT-5 mini |
| Complex visual debugging | Claude Sonnet 4, Claude Opus 4.5 |
| General visual tasks | GPT-4o, GPT-5.2 |
| Deep visual analysis | Gemini 3 Pro, Gemini 2.5 Pro |
| Multi-image analysis | Claude Opus 4.5 |
| UI element inspection | Claude Opus 4.5 (zoom action) |

## Limitations

<!-- NOT IN OFFICIAL DOCS: "Chat view only" is implied (vision documented under Chat View section) but not explicitly stated - flagged 2026-01-26 -->
- **Chat view only** — Not available for inline completions (implied from documentation structure)
- **No video/audio** — Static images only
- **GIF limitation** — Only first frame processed (Visual Studio 2022 docs; VS Code silent)
- **Model required** — Must select vision-capable model
- **3 image limit** — Maximum per message (Visual Studio 2022 docs; VS Code silent)
- **Enterprise policy** — Admin must enable "Editor preview features" for Copilot Business/Enterprise
- **Preview feature** — Vision is marked as "Preview" in official docs

## VS Code Extension API

Extension developers can check for vision capability:

```typescript
// Check if model supports image input
interface LanguageModelChatCapabilities {
  readonly imageInput?: boolean;  // True if vision supported
  readonly toolCalling?: boolean | number;
}

// Select a vision-capable model using @capability:vision filter
const [model] = await vscode.lm.selectChatModels({ 
  vendor: 'copilot', 
  family: 'gpt-4o'  // Vision-capable
});

// Create image data for chat
const imagePart = vscode.lm.LanguageModelDataPart.image(
  imageData,  // Uint8Array
  'image/png' // MIME type
);
```

> **Tip:** Use `@capability:vision` in the model picker to filter for vision-capable models.

Source: [VS Code API Reference](https://code.visualstudio.com/api/references/vscode-api#LanguageModelChatCapabilities)

## Testing Visual Features

**SWE-bench Multimodal** — Benchmark for visual software domains (UI testing, screenshot analysis). Useful for evaluating agent performance on visual tasks.

- [SWE-bench](https://www.swebench.com/) — Industry standard benchmark including multimodal variants

## Related

- [keyboard-shortcuts](keyboard-shortcuts.md) — Image input keyboard methods
- [context-variables](../CONTEXT-ENGINEERING/context-variables.md) — Other context input types
- [settings-reference](../CONFIGURATION/settings-reference.md) — Model selection settings
- [mcp-server-stacks](mcp-server-stacks.md) — Testing stacks for visual workflows

## Sources

**Official Documentation**
- [GitHub Docs: Using Images in Copilot Chat](https://docs.github.com/en/copilot/using-github-copilot/copilot-chat/asking-github-copilot-questions-in-your-ide#using-images-in-copilot-chat)
- [GitHub Docs: AI Model Comparison](https://docs.github.com/en/copilot/reference/ai-models/model-comparison) — Task-based model recommendations
- [GitHub Docs: Supported AI Models](https://docs.github.com/en/copilot/reference/ai-models/supported-models) — Model availability and retirement history
- [VS Code Docs: Manage Context for AI](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) — Vision capabilities with preview note
- [VS Code API Reference](https://code.visualstudio.com/api/references/vscode-api#LanguageModelChatCapabilities) — Extension API for vision capabilities
- [Visual Studio 2022 Copilot Chat](https://learn.microsoft.com/visualstudio/ide/visual-studio-github-copilot-chat#attach-images-to-chat-prompts) — Explicit limits (3 images, GIF single-frame)

**VS Code Release Notes**
- [VS Code 1.97 Release](https://code.visualstudio.com/updates/v1_97#_copilot-vision-in-vs-code-insiders-preview) — Screenshot Window feature
- [VS Code 1.98 Release](https://code.visualstudio.com/updates/v1_98#_copilot-vision-preview) — Vision preview with attachment methods

**Announcements**
- [GitHub Changelog: Vision Input Public Preview](https://github.blog/changelog/2025-03-05-copilot-chat-users-can-now-use-the-vision-input-in-vs-code-and-visual-studio-public-preview/)
- [GitHub Changelog: Vision with Claude and Gemini](https://github.blog/changelog/2025-04-16-using-vision-input-in-copilot-chat-with-claude-and-gemini-is-now-in-public-preview/)

**Claude Opus 4.5 Vision**
- [Anthropic: Claude Opus 4.5 Announcement](https://www.anthropic.com/news/claude-opus-4-5) — Enhanced vision capabilities

*Validated: 2026-01-26 (Official Docs)*
