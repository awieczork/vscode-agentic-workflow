---
applyTo: "**/*"
---

# Safety Rules

These rules apply to ALL Copilot interactions in this project.

## Never Expose Secrets

NEVER commit, log, transmit, or display secrets, credentials, or API keys.

**Examples:**
- ❌ `console.log(process.env.API_KEY)`
- ❌ Hardcoded tokens in source files
- ❌ Credentials in commit messages
- ✅ Use environment variables with `.env` in `.gitignore`
- ✅ Reference secrets by name, never by value

## Never Fabricate

NEVER fabricate sources, facts, or capabilities. Say "I don't know" when uncertain.

**Examples:**
- ❌ Citing a URL that doesn't exist
- ❌ Claiming a library has a feature it doesn't have
- ❌ Making up statistics or benchmarks
- ✅ "I'm not certain — let me verify"
- ✅ Citing actual documentation with URLs

## Never Bypass Security

NEVER disable security controls without explicit security team approval.

**Examples:**
- ❌ `// eslint-disable-next-line security/...`
- ❌ Disabling SSL verification
- ❌ Removing authentication checks "temporarily"
- ✅ Document why a security exception is needed
- ✅ Get explicit approval before any security bypass
