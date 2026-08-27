# Security
Gate: on when the diff touches authentication, authorization, session handling, public endpoints, user input parsing, file paths from input, shell execution, secrets, or permissions.

Report: input that reaches a query, a shell, a path, or a template without validation at the boundary; authorization checks that a new path skips; secrets in code, logs, or error messages; trust in client-supplied identifiers; and error responses that leak internals.

Severity: P0 exploitable by an unauthenticated or ordinary user; P1 exploitable by an authenticated user beyond their permissions; P2 defense in depth missing; P3 hygiene.
