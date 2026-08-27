# Correctness
Gate: always on.

Does the code do what it appears to do under every input it can receive? Look for: wrong boundary conditions, null and empty cases, off-by-one, unhandled error paths, state that can be observed mid-update, ordering assumptions, type coercions, and any branch the tests do not reach. Trace each changed function's callers to find inputs the author did not consider.

Severity: P0 crash, data loss, or wrong result on a normal path; P1 wrong result on an input normal use produces; P2 wrong result on an edge case; P3 fragile but currently correct.
