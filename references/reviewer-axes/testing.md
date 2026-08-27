# Testing
Gate: on when the diff changes test files, fixtures, mocks, or harness code, or when it changes runtime behavior (new branches, state mutation, error handling, control flow) without corresponding test changes. Adapted from Every's `ce-code-review`, testing reviewer.

Report: new behavior with no test, tests that assert implementation details instead of external behavior, tests that cannot fail (no assertion, mocked subject), tests that duplicate an existing one at a lower seam, and mocks that hide the integration the change actually risks. Name the highest existing seam that would prove each untested behavior.

Severity: P1 a changed behavior on a normal path has no test; P2 an edge case has no test or a test cannot fail; P3 a test is at the wrong seam.
