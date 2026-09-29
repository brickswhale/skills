# Routing policy template

`/route` writes the block below into the project, fills every `<…>` from the
owner's answers, and deletes the lines that do not apply. The project decides
where it lives; its agent briefing carries one line pointing at it. The file
is self-contained: a session deciding who builds and who reviews reads this
file and the machine's `route-registry`, and nothing else. The **Contract**
and **Roles** sections are copied as written. The Contract's four lines are
the exact words an eval showed a bare session following (2026-09-28): they
turned a blind reviewer hand-off and an honest receipt from 0 of 3 into 3 of
3. Change their wording only with a run that shows the new words work.

Rules for the shape, so any agent reads it the same way:

- One `## Job:` heading per job. Under it, one line per rank.
- A rank names a registry `profile`, or `coordinator` (the session does it
  itself), or `owner` (a person does it). Nothing else.
- Every review list says whether it is **cumulative** (every line runs) or
  **alternatives** (first fit runs). First fit never drops a cumulative line.
- A rank's condition is prose after the dash. If a condition cannot be judged
  from the job in hand, the rank is badly written; fix the line, not the run.
- Nothing is removed from here to make a run pass. An obligation that no
  longer holds is retired with a dated line under **Retired**.

```markdown
# Routing policy — <project>

Owner: <who rules on this file> · Revised: <date>

## Defaults

- Reviewer: never the author's context; never a lower tier than the builder.
- Same-model fresh review: <allowed for ordinary work | not allowed>.
- Money and security: the reviewer is from a different family than the builder.
- Waivers: only <the owner>, in writing, naming the requirement waived.
- Coordinator does the work itself: <when handing it off costs more than it saves | never for jobs marked below>.
- No `route-registry` on this machine, or a profile this file names is missing from it: stop, and ask the owner to run `/route`. Do not guess a model.
- A profile whose `confirmed` says `no` may be used: the decision line calls it unconfirmed, and its first failed call closes it for the session.

## Routing

- The machine's models are in `route-registry`, in the directory that holds the `pair` skill's record.
- Walk a job's Do list in order; the first rank that fits wins. A builder fits only when every reviewer its job requires exists and is eligible for it: check that before the build starts.
- A choice this file leaves to the owner (a line marked `<owner to choose …>` or `(proposed)`) blocks every job that needs it until the owner answers or accepts it. Stop and ask; no stand-in default.
- Not eligible, so skip it and name it among the ranks not used: a profile the registry marks `gone`; one whose call names a path that no longer exists; one whose call has no model selector while the tool's configured default is no longer its `model`; one whose tier is `unknown`, for any rank that compares tiers. Skipping to the next rank already written is routing, not rerouting.
- A profile confirmed on a tool version or path no longer installed counts as unconfirmed.
- A decision revised after a failed call is printed again as `Route (attempt 2): …`, the failure named among the ranks not used.

## Contract

- Before the first dispatch of a job, print one decision line: the job, your own model (the user's pick), the builder profile and why, the reviewer and why, and every higher-ranked profile you are not using, with the reason.
- The reviewer's prompt carries the spec, the code or its diff, and the test output. It never carries the builder's verdict or your own judgement of the work.
- After the review, print a receipt: the model each role actually reported, or `unknown` when nothing it returned names one. Never write the registry's value as observed.
- List every review finding you do not act on, with the reason.

## Roles

- Coordinator: the session the owner talks to, on the model the owner picked. Frames the job, routes it by this file, integrates the result, and plans; bound by a role's rules whenever it plays that role.
- Builder: re-checks the spec against today's code first, changes only what the job names, runs the named checks, reports evidence and deviations. Never commits.
- Reviewer: reads the artifact against the spec in a fresh context, never the builder's. Reports supported findings, missing checks and a verdict. Changes nothing and runs no tests: it reads the test output the builder produced, and may inspect the work read-only. An advisor consult is never the review.
- Reader: gathers cited evidence, keeps what it saw apart from what it infers, decides nothing.
- Partner: answers one blind question through the `pair` skill. Executes nothing and never stands in for a review.

## Risk classes

- money-security: <paths or kinds: payments, auth, secrets, access rules, …>
- ordinary: everything else.

## Quota

- <family>: spend on <1st>, then <2nd>; never on <…>. On the first quota error, that family is off for the session.

## Job: <id> — <what this job is, one line>

Do (ranked):
1. <profile | coordinator> — <when this rank fits>
2. <profile> — <when>

Review (<cumulative | alternatives>):
1. <profile | coordinator | owner> — <when>
2. <profile> — <when>

## Other obligations

- <each rule this project already holds that the lines above cannot express:
  effort floors, pre-checks before a large dispatch, audit order, what a
  failed reviewer means, what a manual lane may never receive>

## Retired

- <date> — <obligation> — <why it no longer holds, and who ruled>
```
