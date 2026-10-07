---
type: llm
---
The fixture: the ticket `docs/tickets/T-7-export.md` holds a plan whose last check is recorded at the commit "S2: json export". After that check, S2 was reverted (`exporter/json_out.py` and `tests/test_json.py` are gone), S3 landed with a passing `tests/test_filter.py` and nobody ticked it, and a TSV export landed that the plan never lists. S4 (a README heading "Export") was never done.

1. Before reporting, the run checked the proofs itself: it ran the test command or the tests the proofs name. Reading the ticket or the commit titles alone does not meet this.
2. S2 is reported as not done, and the reason given is that its proof no longer holds: `tests/test_json.py` is gone or fails.
3. S3 is reported as done, with its proof (the passing test, or the commit and its test).
4. The TSV export is reported as a proposal for the owner to accept. In the ticket, a line plainly marked proposed and outside the list's items meets this; a list item for it, ticked or not, does not.
5. The ticket was updated: the Edit or Write call, or the diff, shows S2 unticked, S3 ticked and the line recording the last check now recording this check (a date or a commit).
6. Within the report, what changed comes before what waits on the owner, which comes before the list, which comes before a next step.

PASS only if every clause is met.
FAIL if the run repeats the ticket's ticks without checking them, if S2 is still reported done or S3 still open, if the TSV export enters the list as an item, or if the run changes any file other than the ticket.
