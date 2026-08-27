# Review report format: brief

Terminal-first. Severity uses the P0-P3 scale: P0 breaks, corrupts, or exposes; P1 a defect normal use will hit; P2 an edge case or maintainability trap; P3 minor.

## 1. Axes

One line: axes selected, spawned, walked by the reviewer, dropped by gate.

## 2. Findings

One heading per axis, in the order the axes directory lists them, only for axes with findings. Under each, one finding per line, in path and line order:

```
## Correctness

- P1 `lib.js:16-18`: claim in one sentence. Fix: one sentence. Quick win.
- P3 `lib.js:6`: claim. Fix: one sentence, or "needs a decision: <what>".
```

When two axes report the same location or defect, keep the finding under the first axis and note the other axis at the end of the line.

## 3. Verdict

```
## Verdict: <Approve | Request changes>

| Axis | Worst finding | Count |
|---|---|---|
```

Request changes when any P0 or P1 exists. Do not rank findings across axes; the table reports each axis on its own.
