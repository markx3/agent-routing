# API contract
Gate: on when the diff changes routes, request or response shapes, serializers, exported type signatures, public function signatures, or versioned interfaces. Adapted from Every's `ce-code-review`, api-contract reviewer.

Report: a change that breaks an existing caller or client, a field removed or renamed without a migration path, a response shape that differs between branches of the same endpoint, an error format that differs from the rest of the API, and a public signature whose types allow an illegal state.

Severity: P0 breaks a deployed client; P1 breaks an in-repo caller not updated in the diff; P2 inconsistent shape; P3 naming.
