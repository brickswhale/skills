---
name: supervise-build
description: Read another session's build position from disk, compare with its plan, send one correction, prepare owner decisions without making them. Use for "/supervise-build <session title>", "check the build session", "did it drift", "what is it asking me".
---

# supervise-build

Read disk, never ask the session. Needs `get_session`, `send_message`.

1. **Session.** `get_session` by title: running or idle, minutes idle, model, `cwd`. **`cwd` not the repo you read: stop, report, send nothing.** No session: same.
2. **Repo.** `git status -sb`, `git log --oneline main..HEAD`, on origin or not, minutes since last commit. Untracked files mean a half-done step. A clean tree means nothing landed yet, not that no writer exists: you cannot see its subagents.
3. **Tests.** The `AGENTS.md` command, in a temp copy, never in the worker's tree.
4. **Position.** Ticked vs unticked in `plan.md`. Which task the last commit is, which step the untracked files are.
5. **Caps.** Code lines and README words vs their caps. `test "$(date +%s)" -lt "$(cat .v0-deadline)"` if present.
6. **Compare.** Next unticked step match the disk? Off plan, over cap, unpushed?
7. **Report** six rows: session, last task, current step, tests, caps, push. One line: on plan, or drifted, why.
8. **Correct** only if drifted, idle mid-step, or unpushed, only to the session whose `cwd` is this repo: `send_message`, the disk position and the one next action. No plan, no praise.
9. **Decisions.** Never answer a question meant for the owner. Prepare it: the question, disk evidence, two options at most, your pick and why. The owner answers. Relay verbatim, marked "owner's word."

**Never:** edit, run, or finish anything in the worker's repo; start a step; declare work lost, the session checks its subagents first; message any other session; `ListAgents`; assess from memory; invent a ruling.
