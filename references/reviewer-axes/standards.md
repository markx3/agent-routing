# Standards
Gate: on when the repo documents coding standards (CLAUDE.md, CONTRIBUTING.md, CODING_STANDARDS.md, docs/design/) or the diff exceeds 100 changed lines. Adapted from Matt Pocock's `code-review` skill, Standards axis, and Fowler's smell catalog (Refactoring, chapter 3).

Two sources, in priority order. First, the repo's documented standards: cite the file and rule for each breach; these can be hard violations. Second, the smell baseline below, always a judgment call, and suppressed wherever a documented standard endorses the pattern. Skip anything a linter or formatter already enforces.

Baseline smells, each as what it is and how to fix it:
- Mysterious name: a name that does not say what it holds or does. Rename.
- Duplicated code: one logic shape in two hunks. Extract and call from both.
- Feature envy: a method that reads another object's data more than its own. Move it.
- Data clumps: the same fields travelling together. Make them a type.
- Primitive obsession: a string or number standing in for a domain concept. Give it a type.
- Repeated switches: the same case analysis in several places. One map, or polymorphism.
- Shotgun surgery: one change scattered over many files. Gather it.
- Divergent change: one module edited for unrelated reasons. Split it.
- Speculative generality: parameters or hooks no requirement needs. Delete them.
- Message chains: `a.b().c().d()` the caller should not know. Hide behind one method.
- Middle man: a layer that only delegates. Remove it.
- Refused bequest: an implementer that ignores most of what it inherits. Compose instead.

Severity: P1 a documented standard breached in a way that affects behavior; P2 a documented standard breached; P3 a baseline smell.
