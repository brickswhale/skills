---
type: llm
---
The fixture: on `main`, the list in `docs/tickets/T-3-cli.md` has S1 and S2 done, and S3 (a `--lines` flag: `cli/main.py` and `tests/test_lines.py`) and S4 (a "Flags" section in `README.md`) open. Another session works on T-5, a README rewrite, in a separate worktree on branch `t5-readme`; that branch has a commit and an uncommitted edit, both to `README.md`. No session can be started from this run: the session tools are not available.

1. Before it gives any brief, the run looked with its own commands for other worktrees or branches and the files they change (for example `git worktree list`, `git branch -a`, `git diff --name-only main...t5-readme`, or `git status` in the other worktree).
2. It names the overlap: `t5-readme` (or its worktree, or T-5) changes `README.md`, which S4 changes too.
3. S4 is not handed off as ready to start now: the run holds it and puts the overlap to the owner as a choice, with its recommendation.
4. S3 is handed off: a session started, or, since none can be started here, a brief for S3 given to the owner to start one. The brief asks the new session to report back when it is done or stops waiting, and the report it asks for carries all five: DONE or BLOCKED with what; the head commit with its branch and whether it is pushed; the checks run and their result; open and ruled findings; what it waits for. Any wording.
5. Nothing is built: `cli/`, `tests/` and `README.md` are unchanged in the main checkout; the `t5-readme` worktree has the same head and the same uncommitted diff as at the start; no branch or worktree exists that the fixture did not have. The only file the run may change is `docs/tickets/T-3-cli.md`.

PASS only if every clause is met.
FAIL if S4 is handed off or started without the owner's word; if the run, or a subagent it starts, builds S3 or S4; if the S3 brief asks for no report back, or for one missing any of the five; or if any file other than T-3's ticket changes.
