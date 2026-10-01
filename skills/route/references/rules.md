# Routing rules

Every project on a machine routes by these rules, the owner's policy
(`~/.config/route/route-policy.md`) and the registry the policy names. The
rules belong to the `route` skill and are read here, in place; nothing copies
them into a project or a policy. The Contract's four lines are tested wording
(a bare session went from 0 of 3 to 3 of 3 on a blind hand-off and an honest
receipt, 2026-09-28); change them only with a run that shows the new words
work.

## Jobs

A task is one of these jobs. Each names the roles it needs; the policy lists, for each role, the profiles that can play it, ranked.

- **Small fix** — the cause is known, no design choice, a few files. The coordinator does it, reads its own diff, and shows the failing check now passing. No other role.
- **Build** — a feature or change from a clear spec: a builder and a reviewer.
- **Money-security build** — work in the policy's money-security class: a money builder, a reviewer and an auditor.
- **Research** — facts from outside the repository: the coordinator's own tools first, a reader for what they cannot settle, and the coordinator checks every cited fact before anything rests on it.

## Floors

- For each role a job needs, walk the policy's ranked list for that role; the first eligible profile wins. Name every rank you skip, and why. Eligible: in the registry, not marked `gone`, no call to it has failed this session; a builder only when the reviewers its job needs are eligible too.
- A reviewer works in a context other than the builder's and is never a lower tier, as the owner set the tiers.
- Money and security work: at least one reviewer or auditor is from another family than the builder, unless the owner waives that in writing.
- A `<owner to choose …>` line blocks the jobs that need it until the owner answers. A `(proposed)` line may be followed, and a profile whose `confirmed` says `no` may be used: the decision line says which.
- The builder never commits. A builder in another tool gets the Builder role's lines in its prompt; when it returns, check it left no commit, branch, worktree or stash.
- A project's own routing lines, under the pointer in its briefing, add to the policy; where they differ, the project's lines win in that project.
- No policy or registry where the pointer says, or a profile the policy names is missing from the registry: stop, and ask the owner to run `/route`. Never guess a model.

## Contract

- Before the first dispatch of a job, print one decision line: the job, your own model (the user's pick), the builder profile and why, the reviewer and why, and every higher-ranked profile you are not using, with the reason.
- The reviewer's prompt carries the spec, the code or its diff, and the test output. It never carries the builder's verdict or your own judgement of the work.
- After the review, print a receipt: the model each role actually reported, or `unknown` when nothing it returned names one. Never write the registry's value as observed.
- List every review finding you do not act on, with the reason.

## Roles

- Coordinator: the session the owner talks to, on the model the owner picked. Picks the job, routes it by these rules and the policy, hands the work off, integrates the result.
- Builder: re-checks the spec against today's code first, changes only what the job names, runs the named checks, reports evidence and deviations.
- Reviewer and auditor: read the work against the spec in their own context, a fresh one or the coordinator's where the policy ranks `coordinator`, and work from the builder's test output. Change nothing. An auditor looks for what a same-family review may share a blind spot on.
- Reader: gathers facts from outside the repository, keeps what it saw apart from what it infers, decides nothing.
