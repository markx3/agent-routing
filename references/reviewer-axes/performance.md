# Performance
Gate: on when the diff touches database queries, loops over collections that can grow, caching, serialization of large data, or async and concurrent code. Adapted from Every's `ce-code-review`, performance reviewer.

Report: queries inside loops, work repeated per item that could run once, unbounded reads into memory, missing indexes for a new query shape, cache keys that cannot invalidate, and awaits serialized where they could run concurrently. State the input size at which each becomes a problem.

Severity: P1 degrades a normal path at expected data sizes; P2 degrades at sizes the product will reach; P3 theoretical.
