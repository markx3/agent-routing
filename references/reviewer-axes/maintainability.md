# Maintainability
Gate: on when the diff is structural: a new abstraction, a file move, a coupling or type-boundary change, or 200 or more executable changed lines.

Count the layers a reader crosses between a question and its answer, and the state they must hold in their head. Report: wrappers with one caller, mutable scope wider than needed, abstractions with one implementation, module interfaces wider than their use, and names that a newcomer would have to open the file to understand.

Severity: P2 a change that makes the next change in this area harder; P3 a local readability cost.
