# agent-routing

A Claude Code plugin that carries the six subagent roles and the orchestration rules that route work between them. The repository is private, so installing it needs a GitHub login that can read it.

## Install

Authenticate `gh` and let git use its credentials:

```
gh auth login
gh auth setup-git
```

The `owner/repo` shorthand below clones over SSH, so load an SSH key first. If you would rather use HTTPS with the `gh` credentials, set:

```
export CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1
```

Then add the marketplace and install:

```
claude plugin marketplace add markx3/agent-routing
claude plugin install agent-routing@agent-routing
```

Restart Claude Code, or run `/reload-plugins` in an open session.

## What gets installed

Six subagents, addressed with the plugin prefix. Bare names do not resolve.

| Agent | Model | Effort |
| --- | --- | --- |
| `agent-routing:feature-planner` | fable | xhigh |
| `agent-routing:debug-planner` | opus | high |
| `agent-routing:builder` | opus | xhigh |
| `agent-routing:reviewer` | opus | high |
| `agent-routing:explorer` | sonnet | low |
| `agent-routing:mechanic` | haiku | default |

A `SessionStart` hook prints `hooks/orchestration.md` at startup, `/clear`, and compaction. Its output goes into the session context, which is how the routing rules reach the model without a CLAUDE.md. The rules say which role takes an issue first, that planners fan out their own explorers, that reviewer findings go back to the same builder, and that a planner or reviewer is never a cheaper model than the builder it shapes or checks.

## Per-machine model override

A plugin agent is shadowed by a file of the same name in `~/.claude/agents/`. That is the override: copy the role out of the repository, edit its `model:`, and the local copy wins.

```
gh api repos/markx3/agent-routing/contents/agents/builder.md -H "Accept: application/vnd.github.raw" > ~/.claude/agents/builder.md
```

Open `~/.claude/agents/builder.md` and set `model:` to the model this machine should pay for. The copy replaces the plugin's role in full, so a later change to the plugin will not reach it until you copy the file again.

To move every role down at once, without any local copies:

```
export CLAUDE_CODE_SUBAGENT_MODEL=sonnet
```

## Optional pstack sheet

`pstack-models.md` holds the per-role model choices for the pstack skills. It is useful only where pstack is installed, so the plugin ships it without wiring it up. To use it:

```
gh api repos/markx3/agent-routing/contents/pstack-models.md -H "Accept: application/vnd.github.raw" > ~/.claude/pstack-models.md
```

Then add this line to `~/.claude/CLAUDE.md`:

```
@~/.claude/pstack-models.md
```

## A machine that already has the originals

If this machine is where the setup came from, remove the originals so nothing is defined twice. Delete `feature-planner.md`, `debug-planner.md`, `builder.md`, `reviewer.md`, `explorer.md`, and `mechanic.md` from `~/.claude/agents/`, then delete the `# Orchestration` block from `~/.claude/CLAUDE.md`. Keep the `@~/.claude/pstack-models.md` import line if you use pstack.

Leaving a role file in `~/.claude/agents/` is not an error. It shadows the plugin's copy, which is what the override section above asks for.

## Update

```
claude plugin marketplace update agent-routing
claude plugin update agent-routing@agent-routing
```

Restart Claude Code afterwards. Third-party marketplaces do not auto-update, so this is a manual step.
