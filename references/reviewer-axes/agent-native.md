# Agent-native
Gate: on when the diff touches skills, agent definitions, prompts, tool definitions, MCP configuration, slash commands, or hooks.

Read the changed instruction files as the agent that will follow them. Report: a step with no completion criterion, two instructions that conflict, a trigger that overlaps another skill's trigger, an instruction that restates what the environment already tells the agent, a reference to a path or tool that does not exist, and a rule that a model would read differently from how the author meant it. Check every path and tool name the file mentions.

Severity: P1 an agent following the file would do the wrong thing; P2 an agent would stall or ask; P3 wording.
