# Routing rules

How a session decides who builds and who reviews. Read these rules here, in
the `route` skill; they use two files the owner keeps on this machine:

- `~/.config/route/jobs.md` — each job's models, ranked to do the work and to review it, with the owner's notes. The ranks decide.
- `~/.config/route/dictionary.md` — every model this machine can hand work to: how to call it, its family and tier, what it is good for. The context for choosing within the ranks; it never reorders them.

## Routing

- Match the task to a job in `jobs.md`; a task that fits two jobs takes the one with the stricter review, and the decision line names the job passed over. A project's own routing lines, under the pointer in its briefing, add to the jobs; where they differ, the project's lines win in that project.
- Walk the job's Do ranks in order; the first eligible one wins. Then its Review ranks the same way, as the row says: alternatives (the first that fits) or cumulative (every one). Name every rank you skip, and why. Eligible: in the dictionary, not marked `gone`, with the call its role needs (write to build, read-only to review) on the host you run on — the agent app, not the tools this session has switched on — and no call to it has failed this session; a builder only when the reviewers its job needs are eligible too. When no rank in a cell is eligible on your host, that role waits for the owner: name the rank and the host it needs.
- Call a model exactly as its dictionary entry says: its write call for work that changes files, its read-only call for a review or a read.

## Floors

- A reviewer works in a context other than the builder's and is never a lower tier, as the owner set the tiers.
- Money and security work: at least one reviewer is from another family than the builder, unless the owner waives that in writing.
- A `<owner to choose …>` cell blocks the jobs that need it until the owner answers. A `(proposed)` cell may be followed, and a model whose `confirmed` says `no` may be used: the decision line says which.
- Every builder prompt carries the Builder role's lines, whatever tool runs it; when the builder returns, check it left no commit, staged change, push, branch, worktree, stash or pull request.
- No jobs or dictionary file, or a model the jobs name is missing from the dictionary: stop, and ask the owner to run `/route`. Never guess a model. Only `/route` writes those two files: a session that finds one wrong reports it to the owner and never edits it by hand.

## Contract

- Before the first dispatch of a job, print one decision line: the job, your own model (the user's pick), the builder with its effort and why, the reviewer with its effort and why, and every higher-ranked model you are not using, with the reason. A rank taken later, because an earlier one failed, is named when it is taken.
- The reviewer's prompt carries the spec, the code or its diff, and the test output. It never carries the builder's verdict or your own judgement of the work.
- After the review, print a receipt: the model and effort each role actually reported, or `unknown` when nothing it returned names one. Never write the dictionary's value as observed.
- List every review finding you do not act on, with the reason.

## Roles

- Coordinator: the session the owner talks to, on the model the owner picked. Picks the job, routes it by these rules, hands the work off, integrates the result.
- Builder: never commits, stages or pushes, and creates no branch, worktree, stash or pull request. Re-checks the spec against today's code first; a spec that is stale, wrong, already done or superseded stops the work, reported as found, never rewritten to fit. Changes only what the job names; a scope or design choice the spec leaves open is reported, not taken. Runs the named checks, reports evidence and deviations.
- Reviewer: reads the work against the spec in its own context, a fresh one or the coordinator's where the row ranks `main session`, and works from the builder's test output. Changes nothing. A reviewer of another family looks for what a same-family review may share a blind spot on.
- Reader: gathers facts from outside the repository, keeps what it saw apart from what it infers, decides nothing.
