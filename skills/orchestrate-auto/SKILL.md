---
name: orchestrate-auto
description: "Unattended run of mstack's orchestrate skill: no confirmation gates, plan kept in the scratchpad, stops on its own brakes. Invoke with /mstack:orchestrate-auto."
argument-hint: "<issue number | spec path | request>"
disable-model-invocation: true
---

Read `${CLAUDE_PLUGIN_ROOT}/skills/orchestrate/SKILL.md` and follow it with these differences:

- Skip gates G1 through G6. Models come from the settings, the plan and diagnosis are accepted as returned, breadth is the settings value, watcher routing follows the routes without asking, and the builder posts its PR replies directly.
- Do not publish the plan as an artifact; `$RUN/plan.md` is its only copy.
- Stop, write `state.md`, and report to the user when any of these holds, each read from the settings:
  - the build-review loop reaches `max build-review rounds`;
  - the reviewer reports the same P0 finding (same `file:line` and axis) `max repeated P0` times;
  - a planner returns a decision only the user can make;
  - one check fails `max check failures` times in the watch phase.

The report names the brake that fired, the PR, and the handoff paths, so `/mstack:orchestrate <same input>` can resume from `state.md` with the user present.
