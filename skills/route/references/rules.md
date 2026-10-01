# Routing rules

Every project on a machine routes by these rules, the owner's policy
(`~/.config/route/route-policy.md`) and the registry the policy names. The
rules belong to the `route` skill and are read here, in place; nothing copies
them into a project or a policy. The Contract's four lines are tested wording
(a bare session went from 0 of 3 to 3 of 3 on a blind hand-off and an honest
receipt, 2026-09-28); change them only with a run that shows the new words
work.

## Floors

- Walk a job's Do list in order; the first eligible rank wins. Name every rank you skip, and why. Eligible: in the registry, not marked `gone`, no call to it has failed this session, and every reviewer its job requires is eligible too.
- The reviewer works in a context other than the builder's and is never a lower tier, as the owner set the tiers.
- Money and security work: the reviewer is from another family than the builder, unless the owner waives that in writing.
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

- Coordinator: the session the owner talks to, on the model the owner picked. Routes by these rules and the policy, hands the work off, integrates the result.
- Builder: re-checks the spec against today's code first, changes only what the job names, runs the named checks, reports evidence and deviations.
- Reviewer: reads the work against the spec in its own context, a fresh one or the coordinator's where a Review list names `coordinator`, and works from the builder's test output. Changes nothing.
