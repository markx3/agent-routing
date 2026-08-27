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

# Issue 2: Rename to mstack and add orchestration skills, handoffs, a PR watcher, and broader planners and reviewers

## Goal
Turn `agent-routing` into `mstack` (markx3's agentic stack), a public Claude Code plugin whose orchestration is a skill rather than a hook, with a confirmed and an unattended mode, fresh agents fed by handoff documents, a PR watcher, and planner and reviewer roles with more breadth.

## Rename
- Plugin, marketplace, and agent prefix become `mstack`. Repo becomes `markx3/mstack`. `plugin.json` gets `version: 0.1.0`.
- `pstack-models.md` and `hooks/` are removed.
- README is for a public audience: install, roles table, the four skills and their gates, handoff, watcher, one worked example (one issue through plan, gate, build, review, watch), per-machine effort override. No private-repo auth section, no migration section beyond one line on uninstalling `agent-routing`.

## Skills
`skills/orchestrate/SKILL.md` holds the whole procedure:
1. Read `~/.claude/mstack.md`; keys absent there use the defaults stated in the skill.
2. Resolve the input: issue number via `gh issue view`, else a spec file path, else free text.
3. If `<scratchpad>/mstack/<issue>/state.md` exists, resume from the phase it records. Otherwise create it. Update it at every phase change with phase, worktree, PR, handoff paths, pending gate.
4. Create the worktree before the first builder.
5. Route: design surface to `feature-planner`, broken behavior to `debug-planner`, trivial straight to `builder`.
6. Build, review, fix loop. Every spawn is fresh and receives the latest handoff path. Never resume a live agent.
7. Open the PR (builder does it). Enter the watch phase: run `scripts/pr-watch.sh <pr>` through the Monitor tool; on change spawn `watcher`; act on its report: CI failure or mechanical comment to a fresh `builder` with handoff, a comment that changes the design to the planner first, merge or close ends the phase.
8. `mechanic` closes the issue and removes the worktree.

Non-auto gates, each an `AskUserQuestion` with the recommended answer first: model and effort before every spawn; plan approval, published as an artifact; diagnosis approval; review breadth at review entry; the decision after each watcher report; any reply the builder would post on the PR.

`skills/orchestrate-auto/SKILL.md`: follow `orchestrate` with the gates removed, plan written to scratchpad only, and stop with a report when the build-review loop passes 3 rounds, the reviewer returns the same P0 twice, a planner flags a decision only the user can make, or one check fails 3 times. All four thresholds read from `mstack.md`.

`skills/babysit/SKILL.md`: enter `orchestrate` at the watch phase for the given PR.

`skills/setup/SKILL.md`: detect available models, ask model per role (feature-planner, debug-planner, builder, reviewer, sub-reviewer, explorer, watcher, mechanic), review breadth, poll intervals, base branch, max parallel subagents, auto-mode thresholds, then write `~/.claude/mstack.md`. Re-running offers current values as defaults. Offers, never performs unasked, removal of stale `~/.claude/agents/` copies from the `agent-routing` layout.

## Settings
`~/.claude/mstack.md`, prose "key: value" lines. Model per role is applied through the Agent tool's `model` parameter. Effort is not a spawn parameter, so a per-machine effort change copies the agent file into `~/.claude/agents/` and edits `effort:`; the README documents that in one paragraph. Review breadth is one of `single` (reviewer walks the axes itself), `core` (spawns spec and correctness), `gated` (spawns the axes the diff triggers, capped by max parallel), `all`. Default `gated`.

## Agents
- `feature-planner`: plan sections are classification (spike, bounded, architectural, which decides how much of the rest is filled), problem and solution, usage example, types and signatures with file paths, module map with ownership, test seams (highest existing seam, fewest seams), ordered steps each with its proving test, decisions only the user can make, out of scope. Credits: pstack `architect`, superpowers `brainstorming`, Matt Pocock `to-spec`, `codebase-design`. Adapted, not copied.
- `debug-planner`: adds a hypothesis ledger, three lines per hypothesis (hypothesis, probe, VERIFIED or NOT VERIFIED), credit pstack `figure-it-out`.
- `reviewer`: coordinator. Selects axes from the diff, spawns `sub-reviewer` per axis up to max parallel, prints selected and dropped axes, reports grouped by axis with P0-P3 severities and no cross-axis reranking. Under `single` breadth it walks the axes itself.
- `sub-reviewer` (new, opus, read-only): reviews one axis from the reference file named in its prompt.
- `agents/reviewer-axes/*.md`: spec, standards (with the Fowler smell baseline), correctness, testing, maintainability, security, performance, api-contract, reliability, data-migration, previous-comments, agent-native. Each file opens with its gate condition and a credit line (Matt Pocock `code-review` for spec and standards, Every `ce-code-review` for the rest).
- `watcher` (new, haiku, read-only): given a PR and the previous state, returns CI status per check with the failing log excerpt trimmed, new review comments with author, file, line, body, and nothing else.
- Every role writes `<scratchpad>/mstack/<issue>/<role>-<n>.md` before returning, from `templates/handoff.md`: goal and issue, current state (branch, PR, last commit), done with verification evidence, not done, open findings by file:line, decisions and why, what I was unsure of, gotchas, suggested next step, role-specific free-form section. Reference commits, diffs, and plans by path or URL rather than restating them (Matt Pocock `handoff`).

## Scripts
`scripts/pr-watch.sh <pr> [interval]`: polls `gh pr view --json statusCheckRollup,reviews,comments,state,mergeable`, hashes the result, prints the JSON and exits on change or when the PR is merged or closed. 60 seconds while any check is pending, 300 seconds otherwise.

## PR conduct
Builder replies to a review comment with the commit SHA and never resolves threads. The orchestrator never posts on or merges the PR. Watching stops on merge, close, or user stop.

## Out of scope
- Any change to projects that use the agents.
- Token accounting or spend limits.
- Cross-model or stack-specific review personas.
