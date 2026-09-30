# Routing policy template

`/route` copies the block below into the project, fills every `<…>`, and
deletes the lines that do not apply. The project decides where the file
lives; its agent briefing carries one line pointing at it. A session deciding
who builds and who reviews reads this file and the registry it names, nothing
else.

**Floors**, **Contract** and **Roles** are the template's: on an update
`/route` offers their current text. Every other section is the owner's and is
kept as written. The Contract's four lines are tested wording (a bare session
went from 0 of 3 to 3 of 3 on a blind hand-off and an honest receipt,
2026-09-28); change them only with a run that shows the new words work.

The shape, so any agent reads it the same way:

- One `## Job:` heading per job; under it, one line per rank.
- A rank names a registry `profile`, `coordinator` (the session does it
  itself) or `owner` (a person does it).
- Every review list says **cumulative** (every line runs) or
  **alternatives** (the first that fits runs).
- A rank's condition is prose after the dash, judged from the job in hand.
- An obligation that no longer holds is retired with a dated line under
  **Retired**, never deleted.

```markdown
# Routing policy — <project>

Owner: <who rules on this file> · Revised: <date> · Registry: `<path of this machine's route-registry, with ~ for the home directory>`

## Floors

- Walk a job's Do list in order; the first eligible rank wins. Name every rank you skip, and why. Eligible: in the registry, not marked `gone`, no call to it has failed this session, and every reviewer its job requires is eligible too.
- The reviewer works in a context other than the builder's and is never a lower tier, as the owner set the tiers.
- Money and security work: the reviewer is from another family than the builder, unless the owner waives that in writing.
- A `<owner to choose …>` line blocks the jobs that need it until the owner answers. A `(proposed)` line may be followed, and a profile whose `confirmed` says `no` may be used: the decision line says which.
- The builder never commits. A builder in another tool gets the Builder role's lines in its prompt; when it returns, check it left no commit, branch, worktree or stash.
- No registry at the path above, or a profile this file names is missing from it: stop, and ask the owner to run `/route`. Never guess a model.

## Contract

- Before the first dispatch of a job, print one decision line: the job, your own model (the user's pick), the builder profile and why, the reviewer and why, and every higher-ranked profile you are not using, with the reason.
- The reviewer's prompt carries the spec, the code or its diff, and the test output. It never carries the builder's verdict or your own judgement of the work.
- After the review, print a receipt: the model each role actually reported, or `unknown` when nothing it returned names one. Never write the registry's value as observed.
- List every review finding you do not act on, with the reason.

## Roles

- Coordinator: the session the owner talks to, on the model the owner picked. Routes by this file, hands the work off, integrates the result.
- Builder: re-checks the spec against today's code first, changes only what the job names, runs the named checks, reports evidence and deviations.
- Reviewer: reads the work against the spec in its own context, a fresh one or the coordinator's where a Review list names `coordinator`, and works from the builder's test output. Changes nothing.

## Risk classes

- money-security: <paths or kinds: payments, auth, secrets, access rules, …>
- ordinary: everything else.

## Quota

- <family>: spend on <…>; never on <…>.

## Job: <id> — <what this job is, one line>

Do (ranked):
1. <profile | coordinator> — <when this rank fits>

Review (<cumulative | alternatives>):
1. <profile | coordinator | owner> — <when>

## Other obligations

- <each rule this project holds that the lines above do not express>

## Retired

- <date> — <obligation> — <why it no longer holds, and who ruled>
```
