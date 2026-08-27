# Data migration
Gate: on when the diff adds or changes migration files, schema definitions, schema dumps, or backfill scripts. Adapted from Every's `ce-code-review`, data-migration reviewer.

Report: a migration that locks a large table, a column dropped or renamed before every reader was updated, a backfill with no batching, a migration that is not reversible with no stated reason, a default that differs between the schema and the model, and a deploy order in which old code meets the new schema.

Severity: P0 data loss or an outage on deploy; P1 a deploy that fails or blocks; P2 a reversibility or ordering gap; P3 naming.
