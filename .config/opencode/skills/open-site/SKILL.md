---
name: open-site
description: Open a provided URL in a browser using the Playwright MCP.
compatibility: opencode
metadata:
  tool: playwright-mcp
  intent: browser-open
---
## What I do
- Use the Playwright MCP server to open the provided URL in a real browser.
- Rely on the MCP launcher script to resolve the browser executable.

## How I work
- Call the Playwright MCP to open the URL (for example: `/playwright open <url>`).
- If the URL is missing a scheme, assume `https://`.

## When to use me
Use this when you want to quickly open a site from the current project context.

## If something fails
- Report if the browser executable could not be found by the MCP script.
- Ask for an alternate browser path if needed.
