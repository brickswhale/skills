---
name: supervise-build
description: Read another session's build position from disk (git, tests, plan ticks, line cap, deadline), compare it with its plan, and send that session one correction. Use for "/supervise-build <session title>", "check the build session", "how is the build going", "did it drift".
---

# supervise-build

Never ask the session how it is doing. Read disk. Needs the desktop app's session tools: `get_session`, `send_message`.

1. **Session.** `get_session` by title. Note running or idle, minutes since last activity, model.
2. **Repo.** Its cwd. `git status -sb`, `git log --oneline main..HEAD`, is the branch on origin, minutes since last commit. Untracked files mean a half-done step.
3. **Tests.** The test command from the repo's `AGENTS.md`. Count and result.
4. **Position.** Ticked vs unticked boxes in `plan.md`. Which task the last commit belongs to. Which step the untracked files belong to.
5. **Caps.** Lines in the code folder vs the cap in `README.md`. README words vs its cap. `test "$(date +%s)" -lt "$(cat .v0-deadline)"` if the file exists.
6. **Compare.** Is the next unticked step the one the disk implies? Anything off plan, over cap, or unpushed after a finished task?
7. **Report** a six-row table: session, last task done, current step, tests, caps, push. Then one line: on plan, or drifted and why.
8. **Correct** only if drifted, idle mid-step, or unpushed after a task: `send_message` with the exact disk position and the one next action. No plan, no praise.
9. **Rulings** from the owner are relayed verbatim, marked "owner's word." Never invented. `main` pushes and merges always wait for the owner.

Report only what a command showed.
