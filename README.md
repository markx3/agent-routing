# mstack

markx3's agentic stack: a Claude Code plugin with the roles and the orchestration procedure I use for day-to-day agentic coding. One command takes an issue through planning, building, review, an open PR, and watching that PR until it merges, with every agent spawned fresh and briefed by the previous agent's handoff.

## Install

```
claude plugin marketplace add markx3/mstack
claude plugin install mstack@mstack
```

Restart Claude Code or run `/reload-plugins`, then run `/mstack:setup` once to write the per-machine settings. If you installed the earlier `agent-routing` plugin, uninstall it first; `setup` offers to remove its leftover agent copies.

Requires `gh` authenticated against the repos you work in, and `jq`.

## Roles

| Role | Model | Effort | Does |
| --- | --- | --- | --- |
| `feature-planner` | fable | xhigh | Classifies the work, then writes the plan: problem, solution, usage example, types and signatures, module map, test seams, ordered steps with proving tests, user decisions, out of scope |
| `debug-planner` | opus | high | Reproduces the bug, keeps a hypothesis ledger, names the root cause, the fix location, and the regression test target |
| `builder` | opus | xhigh | Implements from the plan and the previous handoff in the run's worktree, pushes, opens or updates the PR |
| `reviewer` | opus | high | Selects review axes from the diff, spawns sub-reviewers, reports findings grouped by axis with P0-P3 severities |
| `sub-reviewer` | opus | high | Reviews one axis from its reference file |
| `watcher` | haiku | default | Reports what changed on the PR: failing checks with a trimmed log, new comments. Never fixes or replies |
| `explorer` | sonnet | low | Read-only codebase search for planners |
| `mechanic` | haiku | default | Closes the issue, removes the worktree, runs `graphify update` |

Roles are addressed as `mstack:<role>`, unless a per-machine copy exists under the bare name (see the settings section). Planners and the reviewer are never a cheaper model than the builder whose work they shape or check.

## Skills

`/mstack:orchestrate <issue | spec path | request>` runs the whole pipeline and confirms with you at six gates: the model and effort before every spawn, the plan (published as an artifact), the diagnosis, the review breadth, the decision after each watcher report, and any reply a builder would post on the PR. Everything else proceeds without asking.

`/mstack:orchestrate-auto <same>` runs the same pipeline with no gates and stops on its own brakes: three build-review rounds, the same P0 finding twice, a planner decision only you can make, or one check failing three times. It reports which brake fired, and `/mstack:orchestrate` resumes from the saved state.

`/mstack:babysit <pr> [auto]` enters the watch phase for any open PR, yours or a teammate's.

`/mstack:setup` writes `~/.claude/mstack.md`.

## Review axes

The reviewer reads twelve axis files under `references/reviewer-axes/`, each with its own gate: spec and correctness always, then standards, testing, maintainability, security, performance, api-contract, reliability, data-migration, previous-comments, and agent-native when the diff triggers them. Findings are grouped by axis and never reranked across axes, so a change that follows every standard but implements the wrong thing is reported as exactly that. Review breadth (`single`, `core`, `gated`, `all`) sets how many sub-reviewers get spawned, and the reviewer prints which axes it spawned and which it walked itself.

The spec and standards axes adapt Matt Pocock's `code-review` skill, including its Fowler smell baseline. The other axes and the P0-P3 scale adapt Every's `ce-code-review` from the compound-engineering plugin. The planner adapts ideas from pstack's `architect` and `figure-it-out`, superpowers' `brainstorming`, and Matt Pocock's `to-spec`, `codebase-design`, and `handoff`.

## Handoffs

No agent is resumed. Before a role returns, it writes a handoff from `templates/handoff.md` into the run directory (`<scratchpad>/mstack/<issue>/`): what is done with evidence, what is not, open findings, decisions, what it was unsure of, gotchas, next step. The next spawn of any role starts from that file. A builder that starts at an empty context with a handoff does better and costs less than one resumed at half its window.

The orchestrator keeps its own `state.md` in the same directory and rewrites it at every phase change, so a compacted or resumed session continues from the right phase.

## Watching a PR

`scripts/pr-watch.sh` polls `gh pr view` and emits one line per change in checks, reviews, or comments, every 60 seconds while a check is pending and every 5 minutes otherwise, and exits when the PR merges or closes. The orchestrator runs it as a persistent monitor and spawns a `watcher` on each line. The watcher's report is routed: a failing check or a mechanical comment to a fresh builder, a comment that changes the design to a planner first, a decision only you can make to you. The orchestrator never merges and never posts; builders reply to comments with the commit SHA and never resolve threads.

## A run

`/mstack:orchestrate 42` on an issue that adds an export endpoint. The orchestrator reads the settings, creates `.worktrees/42`, and routes to `feature-planner` because the issue adds a module boundary. You confirm fable/xhigh at the gate. The plan comes back as an artifact classified `bounded`, with the endpoint's types, the serializer module that owns them, the existing integration test seam, and four steps; you approve. A fresh builder gets the plan, implements at that seam, and opens the PR. At the review gate you keep `gated`; the reviewer selects spec, correctness, testing, and api-contract, spawns four sub-reviewers, and returns one P1 (a missing test for the empty case). A fresh builder gets the review report and the first builder's handoff, adds the test, pushes. The reviewer approves. The monitor starts. Twenty minutes later a teammate comments asking for pagination; the watcher reports it, and at the gate you send it to the planner since it changes the contract. A fresh planner amends the plan, a fresh builder implements it and, after you approve the reply, posts the commit SHA in the thread. CI passes, the PR merges, the monitor exits, and the mechanic closes the issue and removes the worktree.

## Per-machine settings

`~/.claude/mstack.md` holds model per role, review breadth, parallel cap, base branch, watch intervals, and the auto-mode brakes, as `key: value` lines. `/mstack:setup` writes it; any missing key falls back to the default in `skills/orchestrate/SKILL.md`. Models are applied through the Agent tool's `model` parameter at spawn time.

Effort is not a spawn parameter. To change a role's effort on one machine, copy `agents/<role>.md` from the plugin into `~/.claude/agents/`, edit `effort:`, and leave `name:` alone. The copy registers under the bare name next to the plugin's `mstack:` one, and the orchestrator prefers the bare name. Pull it again after the plugin's version of that role changes.

## Update

```
claude plugin marketplace update mstack
claude plugin update mstack@mstack
```

Third-party marketplaces do not auto-update.
