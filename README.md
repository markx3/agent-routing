# agent-routing

A Claude Code plugin that carries the six subagent roles and the orchestration rules that route work between them. The repository is private, so installing it needs a GitHub login that can read it.

## Install

Authenticate `gh` and let git use its credentials:

```
gh auth login
gh auth setup-git
```

Claude Code clones the `owner/repo` shorthand over SSH by default. A fresh machine with only `gh` and `claude` on it has no SSH key, and marketplace refreshes clone in the background where nothing can prompt you, so set this in your shell profile rather than in one session:

```
export CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1
```

The clone then goes over HTTPS with the credentials `gh auth setup-git` installed. If this machine already has an SSH key GitHub accepts, you can leave the variable unset and let the SSH path work.

Then add the marketplace and install:

```
claude plugin marketplace add markx3/agent-routing
claude plugin install agent-routing@agent-routing
```

Restart Claude Code, or run `/reload-plugins` in an open session.

## What gets installed

Six subagents, registered under the plugin prefix. The Agent tool and `@` mentions need the full `agent-routing:` name.

| Agent | Model | Effort |
| --- | --- | --- |
| `agent-routing:feature-planner` | fable | xhigh |
| `agent-routing:debug-planner` | opus | high |
| `agent-routing:builder` | opus | xhigh |
| `agent-routing:reviewer` | opus | high |
| `agent-routing:explorer` | sonnet | low |
| `agent-routing:mechanic` | haiku | inherits |

A `SessionStart` hook prints `hooks/orchestration.md` into the session context, on startup, resume, `/clear`, compaction, and fork. That is how the routing rules reach the model without a CLAUDE.md. The rules say which role takes an issue first, that planners fan out their own explorers, that reviewer findings go back to the same builder, that a planner or reviewer is never a cheaper model than the builder it shapes or checks, and which name to use when a role exists twice.

The plugin ships no `version` field, so the commit SHA is the version. `claude plugin validate` reports that as a warning and passes, and `claude plugin validate --strict` fails on it. That is expected.

## Per-machine model override

Put a copy of the role in `~/.claude/agents/` and change its `model:`. The copy registers as a second agent under the bare name, next to the plugin's `agent-routing:` one, and the injected orchestration rules tell the model to prefer the bare name when both exist.

```
mkdir -p ~/.claude/agents
gh api repos/markx3/agent-routing/contents/agents/builder.md -H "Accept: application/vnd.github.raw" > ~/.claude/agents/builder.md
```

Open `~/.claude/agents/builder.md` and set `model:` to the model this machine should pay for. Leave the `name:` field alone, since the bare name is what the rules look for. The copy does not follow the plugin, so pull it again after the plugin's version of that role changes.

To move every role down at once, with no local copies:

```
export CLAUDE_CODE_SUBAGENT_MODEL=sonnet
```

## Optional pstack sheet

`pstack-models.md` holds the per-role model choices for the pstack skills. It is useful only where pstack is installed, so the plugin ships it without wiring it up. To use it:

```
mkdir -p ~/.claude
gh api repos/markx3/agent-routing/contents/pstack-models.md -H "Accept: application/vnd.github.raw" > ~/.claude/pstack-models.md
```

Then add this line to `~/.claude/CLAUDE.md`:

```
@~/.claude/pstack-models.md
```

## A machine that already has the originals

Delete the `# Orchestration` block from `~/.claude/CLAUDE.md`. The hook injects those rules now, and leaving the block in place puts them in the context twice. Keep the `@~/.claude/pstack-models.md` import line if you use pstack.

The six role files in `~/.claude/agents/` can stay. They are per-machine overrides, and the rules point at them ahead of the plugin's copies. Delete them if you want this machine to run the models the plugin ships.

## Update

```
claude plugin marketplace update agent-routing
claude plugin update agent-routing@agent-routing
```

Restart Claude Code afterwards. Third-party marketplaces do not auto-update, so this is a manual step.
