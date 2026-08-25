# Orchestration

Subagents come from the `agent-routing` plugin and are addressed as `agent-routing:<name>` (`feature-planner`, `debug-planner`, `builder`, `reviewer`, `explorer`, `mechanic`). Before spawning one, check the agent list for the bare `<name>`: when it is registered too, it is the per-machine override of that role, and you must spawn the bare `<name>` and never the `agent-routing:` one. Subagents can spawn subagents up to three layers deep (`CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH`); planners use that for explorers, builders and reviewers do not delegate.

- An issue with design surface gets a `feature-planner` first; a bug report gets a `debug-planner`. Trivial issues go straight to the `builder`.
- Planners fan out `explorer` agents themselves when an issue spans more than one subsystem; the orchestrator does not pre-explore for them.
- Planner output is the builder's spec. Reviewer findings go back to the same builder, which fixes and pushes. The reviewer never edits, so it is also safe on a teammate's PR.
- A planner or reviewer is never a cheaper model than the builder whose work it shapes or checks.
- `mechanic` does the judgment-free tail: closing issues, removing worktrees, `graphify update`.
