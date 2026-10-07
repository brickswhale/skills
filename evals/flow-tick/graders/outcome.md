---
type: llm
---
The fixture: the ticket `docs/tickets/T-0002.md` holds a plan list. S1 (a month outside 1-12 raises `ValueError`) is ticked; S2 (a day past the month's last day raises `ValueError`, proof: `./test.sh` fails if "2026-04-31" is accepted) and S3 (a year before 1900 raises `ValueError`) are open; below the list, a `Checked:` line records the list's last check, at the S1 commit. The owner asked for the next slice, committed. This case grades the tick; `flow-fires` grades the rest of the skill.

1. S2 is done and S3 is not: after the run, `src/parse.py` rejects "2026-04-31" with `ValueError` and still accepts "1899-12-31", and `./test.sh` prints `ok` with a check that fails if "2026-04-31" is accepted.
2. S2's change is committed, in one commit or more.
3. After the run, S2's line in the ticket is ticked and ends with `done: <hash>`, where the hash, short or full, is in the final history and names the commit that carries S2's change: the one that makes its proof hold.
4. The tick follows the proof: before the edit that ticks S2, the transcript shows `./test.sh` run with the S2 check in place and printing `ok`.
5. The tick is in a commit of its own: a commit after the one named on S2's line changes S2's line to ticked and changes no file outside `docs/tickets/`, and the ticket in the last commit shows S2 ticked.
6. S3's line is unchanged and not ticked, S1 stays ticked, and the `Checked:` line is unchanged, unless the run called the `progress` skill, which owns that line.

PASS only if every clause is met.
FAIL if S3's code is changed or S3 is ticked, if S2 is ticked with no commit hash or with one that is not in the final history, or if any file changes other than files under `docs/tickets/`, `src/parse.py` and `test.sh`.
