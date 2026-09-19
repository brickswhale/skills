---
name: supervise-build
description: Read another session's build position from disk, compare with its plan. Use for "/supervise-build <session title>", "check the build session", "did it drift", "what is it asking me".
---

# supervise-build

Read disk, not the session.

1. **Session.** `get_session` by title: running or idle, `cwd`. Wrong `cwd`: stop, report, nothing sent. No session: same.
2. **Repo.** `git status -sb`, `git log --oneline main..HEAD`, origin, last commit. Untracked means a half-done step; clean isn't proof.
3. **Tests.** `AGENTS.md`'s command, in a temp copy, never the worker's tree.
4. **Position.** Ticked, unticked in `plan.md`: last task, untracked step.
5. **Caps.** Code lines, README words vs limits. `test "$(date +%s)" -lt "$(cat .v0-deadline)"` if present.
6. **Compare.** Step match disk? Off plan, over cap, unpushed?
7. **Report** six rows: session, last task, current step, tests, caps, push. One line: on plan, or drifted, why.
8. **Correct** only if drifted, idle mid-step, or unpushed, and only to the session whose `cwd` matches: `send_message` position and next action, no plan, no praise. **Callback,** any hand-off, send instead: "when this is done, or when you stop with 'waiting for: X', send_message to session <supervisor's session id> with five lines: DONE or BLOCKED: <what> / head: <sha> on <branch>, pushed yes/no / lines, tests, verify / findings: open, ruled / waiting for: <X or none>. Send once per stop, before your final line, then keep going if you can." Reply triggers the next pass; disk decides.
9. **Decisions.** Never answer for the owner: question, disk evidence, two options, your pick and why. Owner answers; relay verbatim as "owner's word."

**Never:** edit, run, or finish anything in the worker's repo; start a step; declare work lost, the session checks its subagents first; message any other session; `ListAgents`; assess from memory; invent a ruling.
