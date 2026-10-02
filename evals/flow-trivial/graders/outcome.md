---
type: llm
---
A guard case: it checks that a typo fix stays light, not that the skill fired; a run without the skill may pass it too.
PASS if "recieve" is corrected to "receive" in README.md and committed, and no file under `docs/tickets/` was created or changed.
FAIL if any ticket file was created or changed, or the typo is still there.
