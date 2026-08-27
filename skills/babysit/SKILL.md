---
name: babysit
description: Watch an open PR and route what happens to it through mstack's roles: CI failures and mechanical comments to a fresh builder, design comments to a planner, decisions to the user. Use for /mstack:babysit <pr>, "babysit this PR", or "keep an eye on the PR".
argument-hint: "<pr number or url> [auto]"
---

Read `${CLAUDE_PLUGIN_ROOT}/skills/orchestrate/SKILL.md` and enter it at step 8, the watch phase, for the given PR. Before that: read the settings, resolve the PR's issue from its body or branch name to pick the issue key, create `$RUN/state.md` with phase `watch` if none exists, and check out the PR branch into a worktree if the PR is not already in one.

With the `auto` argument, apply `orchestrate-auto`'s differences. The PR may belong to a teammate; the rules that the orchestrator never merges or posts hold, and G6 keeps every reply behind the user unless `auto` was given.
