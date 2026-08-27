# Reliability
Gate: on when the diff touches error handling, retries, timeouts, background jobs, queues, external service calls, or process lifecycle. Adapted from Every's `ce-code-review`, reliability reviewer.

Report: a call to an external service with no timeout, a retry with no bound or no backoff, an operation that is not idempotent but can be retried, a caught exception that is swallowed, a job that cannot resume after a crash mid-way, and a failure mode the caller cannot distinguish from success.

Severity: P0 silent data loss or an infinite retry; P1 an outage path a normal failure triggers; P2 a degraded path with no signal; P3 hygiene.
