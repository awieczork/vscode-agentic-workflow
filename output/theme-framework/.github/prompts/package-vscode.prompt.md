---
description: 'Package a VS Code color theme as a distributable .vsix extension'
agent: 'build'
tools: ['edit', 'execute']
---

Package the color theme **${input:themeName}** as a VS Code extension for publisher **${input:publisherName}**. Produce a complete extension directory ready for `vsce package`.

Reference the [theme-conventions](../instructions/theme-conventions.instructions.md) instruction file for VS Code color theme JSON format details.


<extension_scaffold>

Create the following directory structure, using a kebab-case version of **${input:themeName}** as the root folder name:

```
<theme-name>/
├── package.json
├── README.md
├── CHANGELOG.md
├── LICENSE
├── icon.png  (placeholder reference)
└── themes/
    └── <theme-name>-color-theme.json
```

- Derive `<theme-name>` by lowercasing **${input:themeName}** and replacing spaces with hyphens
- Copy the generated theme JSON into `themes/<theme-name>-color-theme.json`

</extension_scaffold>


<package_json>

Generate `package.json` with these fields:

```json
{
  "name": "<theme-name>",
  "displayName": "${input:themeName}",
  "description": "A dark color theme derived from algorithmic color math",
  "version": "0.1.0",
  "publisher": "${input:publisherName}",
  "engines": {
    "vscode": "^1.80.0"
  },
  "categories": ["Themes"],
  "contributes": {
    "themes": [
      {
        "label": "${input:themeName}",
        "uiTheme": "vs-dark",
        "path": "./themes/<theme-name>-color-theme.json"
      }
    ]
  },
  "icon": "icon.png",
  "repository": {
    "type": "git",
    "url": "https://github.com/<owner>/<theme-name>"
  },
  "keywords": ["theme", "dark", "color-theme", "editor-theme"]
}
```

- Replace `<theme-name>` with the derived kebab-case identifier
- Replace `<owner>` with the publisher name or a placeholder

</package_json>


<vsce_commands>

Install and run the packaging tool:

1. Install vsce globally — `npm install -g @vscode/vsce`
2. Change into the extension directory — `cd <theme-name>`
3. Package the extension — `vsce package`
4. Output file — `<theme-name>-0.1.0.vsix`
5. Install locally for testing — `code --install-extension <theme-name>-0.1.0.vsix`

</vsce_commands>


<marketplace_checklist>

Verify marketplace readiness before publishing:

- **README.md** — includes theme description, screenshots showing the theme in action, and installation instructions
- **CHANGELOG.md** — contains an initial `0.1.0` entry with release date and summary
- **icon.png** — 128x128 or 256x256 PNG, displayed on the marketplace listing
- **LICENSE** — valid open-source license file (MIT, Apache-2.0, or similar)
- **Publisher account** — registered at marketplace.visualstudio.com with a Personal Access Token configured for `vsce`

</marketplace_checklist>
