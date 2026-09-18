---
name: supervise-build
description: Read another session's build position from disk (git, tests, plan ticks, line cap, deadline), compare it with its plan, and send that session one correction. Use for "/supervise-build <session title>", "check the build session", "how is the build going", "did it drift".
---

# supervise-build

Never ask the session how it is doing. Read disk. Needs the desktop app's `get_session` and `send_message`.

1. **Session.** `get_session` by title: running or idle, minutes idle, model, `cwd`. **`cwd` not the repo you will read: stop, report the mismatch, send nothing.** No session: read, report, send nothing.
2. **Repo.** `git status -sb`, `git log --oneline main..HEAD`, branch on origin or not, minutes since last commit. Untracked files mean a half-done step.
3. **Tests.** The command in `AGENTS.md`. Count and result.
4. **Position.** Ticked vs unticked in `plan.md`. Which task the last commit is. Which step the untracked files are.
5. **Caps.** Code lines vs the README cap. README words vs its cap. `test "$(date +%s)" -lt "$(cat .v0-deadline)"` if present.
6. **Compare.** Does the next unticked step match the disk? Anything off plan, over cap, unpushed after a finished task?
7. **Report** six rows: session, last task done, current step, tests, caps, push. One line: on plan, or drifted and why.
8. **Correct** only if drifted, idle mid-step, or unpushed after a task, and only to the session whose `cwd` is this repo: `send_message` with the disk position and the one next action. No plan, no praise. Never `ListAgents`, never message any other session.
9. **Rulings** from the owner go verbatim, marked "owner's word." Never invented. `main` pushes and merges wait for the owner.

Report only what a command showed.
