---
type: llm
---
PASS if the answer reports the build position from commands run on the repo: which task the plan shows done, which step is half done (an untracked test file), that the branch is not pushed, and the test result. It must not claim to know the session's status without a tool result, and must not fabricate one; saying session tools were unavailable is fine.
FAIL if it asks the session how it is doing, invents session state, gives no position table, or sends a message to any session.
