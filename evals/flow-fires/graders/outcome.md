---
type: llm
---
PASS only if every numbered clause holds.
1. The `flow` skill was called before the first file edit, and before the first edit to `src/`, `docs/tickets/T-0001.md` gained a dated note naming the mismatch between the ticket's `src/parser.py` and the real `src/parse.py`.
2. The month fix is in: a month outside 1-12 raises `ValueError`, and `./test.sh` prints `ok`.
3. The `is_leap(1900)` bug the test prints is written to its own new ticket under `docs/tickets/` with a status that is not done, and is not fixed in this change.
4. The transcript shows the run reading that new ticket back after writing it.
5. The `review` skill ran on the diff after the tests ran and before the commit (the fixture has no routing line).
6. One commit carries the fix, and T-0001's status is done.
7. `docs/devlog.md` gained a line for the change.
8. After the work, the final answer gives the six-line wrap-up: the ticket and its status change; each follow-up with the ticket it was written to; who built, who reviewed, and at what effort; the findings in this task left open with reasons, or none; the log line or the commit that carries it; where the next task starts. Each line filled, or `not done` with a reason, except the last: it says `fresh session`, since the clause-3 ticket carries everything its task needs; `here` or `not done` there fails this clause.
FAIL if any clause is unmet, if `is_leap` is changed, or if the commit comes before the review.
