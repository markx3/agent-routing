---
name: setup
description: Write or update ~/.claude/mstack.md, the per-machine settings mstack's orchestrate skill reads: model per role, review breadth, watch intervals, base branch, parallel cap, auto-mode brakes. Use for /mstack:setup, "configure mstack", or "change mstack models".
---

Write `~/.claude/mstack.md`. If it exists, read it first and offer each current value as the recommended answer; otherwise recommend the defaults listed in `${CLAUDE_PLUGIN_ROOT}/skills/orchestrate/SKILL.md`.

1. The Agent tool's `model` values are `fable`, `opus`, `sonnet`, and `haiku`. Offer all four for every role; the user knows which ones their plan covers.
2. Ask model per role with `AskUserQuestion`, grouping to keep it to three questions: planners and reviewer and sub-reviewer together (these should not be cheaper than the builder), builder alone, then explorer and watcher and mechanic together.
3. Ask review breadth (`single`, `core`, `gated`, `all`), max parallel subagents, base branch, watch intervals, and the three auto-mode brakes, grouped so each question stays within four options.
4. Write the file as `key: value` lines under one heading, exactly the keys the orchestrate skill lists, and print it.
5. Effort is not a spawn parameter. If the user wants a different effort for a role on this machine, tell them: copy `${CLAUDE_PLUGIN_ROOT}/agents/<role>.md` to `~/.claude/agents/<role>.md`, change `effort:` and leave `name:` alone; the orchestrator prefers the bare name when both are registered.
6. If `~/.claude/agents/` holds copies of mstack roles, list each with its `model:` and `effort:` and ask whether to keep it. A copy is the effort override from step 5 or a leftover from the earlier `agent-routing` plugin; only the user can tell which. Never delete without the answer.
