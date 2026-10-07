---
type: llm
---
The fixture: the ticket `docs/tickets/T-9-tags.md` holds a list whose items name no proof, and no line records a past check. "Store tags on a note" is ticked and `tests/test_tags.py` passes. "Filter notes by tag" is unticked, but a later commit added `notes/filter.py` with a passing `tests/test_filter.py`. "Tag chips on the note page" has no code.

1. Before reporting, the run ran the tests itself.
2. "Filter notes by tag" is reported as done on the evidence of its passing test (or the commit and its test); storing tags is reported as done; the tag chips are reported as not done.
3. Each item that was open before the check ends with a proof named. "Filter notes by tag": the evidence that showed it done is written onto its line as its proof, or proposed for the owner to accept. "Tag chips on the note page": a proof (what would show it done) is proposed for the owner to accept, in the report or on a line marked proposed, and is not written onto its line as if agreed.
4. The ticket was updated: the Edit or Write call, or the diff, shows "Filter notes by tag" ticked and a new line recording this check (a date or a commit).
5. Within the report, what changed comes before what waits on the owner, which comes before the list, which comes before a next step.

PASS only if every clause is met.
FAIL if the run reports the ticket's ticks without checking them, if it writes a proof onto an open item as if agreed, or if it changes any file other than the ticket.
