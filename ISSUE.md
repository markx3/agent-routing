# Issue 1: Package the subagent routing setup as an installable Claude Code plugin

## Goal
A Claude Code plugin, installable from a private GitHub repo (`markx3/agent-routing`), that reproduces the routing setup currently living in `~/.claude/agents/` and the Orchestration block of `~/.claude/CLAUDE.md`, so it can be installed on a second machine with one command.

## Source of truth (copy these, do not redesign them)
- Agent definitions: `~/.claude/agents/feature-planner.md`, `debug-planner.md`, `builder.md`, `reviewer.md`, `explorer.md`, `mechanic.md`
- Orchestration rules: the `# Orchestration` block in `~/.claude/CLAUDE.md`
- pstack per-role sheet: `~/.claude/pstack-models.md` (optional companion; pstack may not be installed on the target machine)

## Requirements
- Follow the official Claude Code plugin layout from https://code.claude.com/docs/en/plugins (manifest, agents directory, any other directories that apply). Verify against the docs, do not assume.
- The orchestration rules must reach the model on every session. Find the mechanism a plugin has for that (the docs decide: skill, hook, or whatever is supported) and use it. If a plugin cannot inject global instructions, document the one manual step in the README.
- Model choice per role must be overridable per machine without editing the plugin, because the work machine is on a smaller usage plan. Propose the simplest mechanism that Claude Code actually supports; if none exists, document editing the agent frontmatter after install.
- A README with: install command from the private repo, what gets installed, the per-machine model override, the optional pstack sheet.
- No code comments. Prose in en-US, following ~/.claude/output-styles/no-slop.md.
- Plugin name: `agent-routing`.

## Out of scope
- Publishing to a marketplace.
- Any change to the projects that use the agents.
