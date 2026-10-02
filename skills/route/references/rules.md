# Routing rules

How a session decides who builds and who reviews. Read these rules here, in
the `route` skill; they use two files the owner keeps on this machine:

- `~/.config/route/jobs.md` — each job's builders and reviewers, ranked, with the owner's notes. The ranks decide.
- `~/.config/route/dictionary.md` — every model this machine can hand work to: how to call it, its family and tier, what it is good for. The context for choosing within the ranks; it never reorders them.

## Routing

- Match the task to a job in `jobs.md`. A project's own routing lines, under the pointer in its briefing, add to the jobs; where they differ, the project's lines win in that project.
- Walk the job's builders in order; the first eligible one wins. Then its reviewers the same way, as the row says: alternatives (the first that fits) or cumulative (every one). Name every rank you skip, and why. Eligible: in the dictionary, not marked `gone`, no call to it has failed this session; a builder only when the reviewers its job needs are eligible too.
- Call a model exactly as its dictionary entry says: the build call for a builder, the read-only call for a reviewer.

## Floors

- A reviewer works in a context other than the builder's and is never a lower tier, as the owner set the tiers.
- Money and security work: at least one reviewer is from another family than the builder, unless the owner waives that in writing.
- A `<owner to choose …>` cell blocks the jobs that need it until the owner answers. A `(proposed)` cell may be followed, and a model whose `confirmed` says `no` may be used: the decision line says which.
- The builder never commits. A builder in another tool gets the Builder role's lines in its prompt; when it returns, check it left no commit, branch, worktree or stash.
- No jobs or dictionary file, or a model the jobs name is missing from the dictionary: stop, and ask the owner to run `/route`. Never guess a model.

## Contract

- Before the first dispatch of a job, print one decision line: the job, your own model (the user's pick), the builder and why, the reviewer and why, and every higher-ranked model you are not using, with the reason.
- The reviewer's prompt carries the spec, the code or its diff, and the test output. It never carries the builder's verdict or your own judgement of the work.
- After the review, print a receipt: the model each role actually reported, or `unknown` when nothing it returned names one. Never write the dictionary's value as observed.
- List every review finding you do not act on, with the reason.

## Roles

- Coordinator: the session the owner talks to, on the model the owner picked. Picks the job, routes it by these rules, hands the work off, integrates the result.
- Builder: re-checks the spec against today's code first, changes only what the job names, runs the named checks, reports evidence and deviations.
- Reviewer: reads the work against the spec in its own context, a fresh one or the coordinator's where the row ranks `main session`, and works from the builder's test output. Changes nothing. A reviewer of another family looks for what a same-family review may share a blind spot on.
- Reader: gathers facts from outside the repository, keeps what it saw apart from what it infers, decides nothing.
