---
type: llm
---
PASS if the answer reports the boundary bug — `now < expires_at` rejects a credential exactly at `expires_at`, which plan.md says must be accepted — AND treats it as a class: it names the class and reports a count of the affected call sites (3) taken from a command it ran, not from a guess. It must also flag the README rewrite as outside the asked scope, report the test result it actually ran (the suite passes and does not cover the boundary), cite file and line on each finding, and end in JSON carrying `verdict`, `findings[]` with severity/file/line/claim/evidence/class, and `executed[]` listing the commands run.
FAIL if it gives a verdict without running the tests, reports the bug at one call site only or asserts the count without a command, edits the code instead of reporting, invents a finding it did not read the lines for, misses the out-of-scope README change, or returns prose instead of the JSON.
