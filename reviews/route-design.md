# route — the design, the plan, and what the reviews left unsettled

Written 2026-09-28, before any file of the skill exists. One consult, three pair
rounds on the design and one on the plan, all blind, all against a GPT partner
(rung 1). Findings that changed the design are folded into the sections below;
dissent that survived is kept in its own section, not averaged away.

## What `route` is

A checklist the **coordinator** runs before handing work to a subagent: read two
files the owner writes, walk a ranked list, print a decision line, dispatch,
print a receipt. No script, no hook. Setup is the skill's first step, not a
command.

The reusable part of a consuming project's 2,200-word routing document, which
mixed four kinds of content: generic mechanics, public CLI facts, the machine's
model inventory, and one project's preferences. It had routed three features
over two days (24 route lines, all eight job kinds) and logged five gaps; the
skill is designed against that record, not against theory.

## Rulings (owner, 2026-09-27 and 2026-09-28)

1. **Four homes.** Skill and `references/` ship here. A per-machine registry and a
   per-project policy are written by the owner and never live in this repo.
2. **Ranked at run time, no script.** The agent walks an ordered list; first fit
   wins; reviewer eligibility is checked before the build starts; every skipped
   higher rank is named. Replaces an earlier deterministic picker that lived in a
   framework now frozen. A same-input-same-output resolver is foreclosed here
   unless the checklist proves unreliable in the eval.
3. **No hook, yet.** None of the three candidate hooks (route line present in
   the dispatch; model known to the registry; policy well-formed) is earned by a
   logged incident. The one field failure that looked like a hook case was an
   edit-boundary problem, not a dispatch one. Revisit on the second missed
   route line.
4. **Formats.** Registry: flat `key=value` blocks, one block per **profile**
   (`profile= model= tier= family= role= card= call= effort= confirmed=`), split
   at the first `=`, blank line ends a block, unique profile names. Policy:
   strict markdown, one job per heading, one line per rank, review lists marked
   *alternatives* or *cumulative*, risk classes (ordinary; money and security),
   quota order, waiver authority. JSON for neither: no second reader exists and
   the conditions per rank are prose.
5. **Profiles, not models.** One model may carry several profiles (a read-only
   pair card and a build card are different call shapes). Pair calls point at
   the `pair` record; they are not copied into the registry.
6. **Coordinator.** The session the owner is talking to. Its model is the
   owner's pick, a routing *input* the decision line states, never an output.
   Host choice waives no floor: when the coordinator plays another role it is
   bound by that role's rules. The planner is folded into the coordinator; it
   dispatches a planner only for a large spec, and says so.
7. **Roles, one line each:** coordinator (talks to the owner; frames, routes,
   integrates, closes the gate); builder (revalidates the spec against today's
   code, changes only the named scope, runs the named checks, reports evidence
   and deviations, never commits); reviewer (reads the artifact against the
   spec, alone, reports supported findings, missing checks and a verdict,
   changes nothing, never the author's context); reader (gathers cited
   evidence, separates seen from inferred, decides nothing); partner (answers
   one blind question with evidence and assumptions, executes nothing, never
   stands in for review, and is reached by running `pair`, never by reusing its
   transport).
8. **Independence has three grades:** a different context, a different model, a
   different family. A same-model fresh review is allowed for ordinary work and
   is named as such in the receipt; it never satisfies a different-model or
   different-family requirement. Money and security need a different family.
   Field basis: one same-model fresh review found seven findings where the
   different-model coordinator review found none.
9. **Two lines per job.** A decision line before dispatch:
   `Route: job <id> · coordinator <model, user-chosen; also did: <roles|none>> · do <profile; model; effort|n/a> · rank <k — reason> · review <required|none — reason> · bypassed <higher candidates — reasons|none> · exceptions <requirement — disposition|none>`.
   A receipt after: observed model **per role** (or `unknown`, never the
   configured value relabelled), verdicts, dismissed findings with reasons,
   optional usage. A decision revised at dispatch time (a quota error learned by
   trying) is re-issued with an attempt number, not silently replaced.
10. **The reviewer is never weaker than the builder** survives the coordinator
    change; the registry's `tier=` key is what makes it checkable.
11. **The registry is a file named `route-registry`** in the directory that
    holds the `pair-transport.<host-family>` record (owner, 2026-09-28). The
    skill names the file and that relation, never a path. Setup looks there
    first; a missing file is the setup trigger, a `confirmed=` older than the
    installed tools is the staleness trigger.
12. **The Claude Code advisor tool is never the review** (2026-09-28, both
    readers). It reads the author's full conversation, so by ruling 8 it is at
    best a different model in the same context, and a review requires a
    different context. The decision line records it as configuration, not as
    evidence a consultation happened: `advisor: <model>|off|unknown`, with
    `unknown` never collapsed to `off`. Workers inherit it subject to their
    own pairing check, so the session field does not prove a worker's
    configuration. Ranking "profile + advisor" as a candidate of its own is
    deferred (backlog 6): it would add availability, compatibility and a
    consultation the model decides on into eligibility, and nothing yet
    records whether a consultation ran. The operational rule goes into
    `references/roles.md` and the notation into `references/lines.md` when
    the skill is written; this record holds the reason. For the build of this
    skill and its evals the advisor stays off, so attribution has one fewer
    moving part. The `pair` catalog carries the matching exclusion.

## The plan, as corrected by the plan review

| # | Step | Proof |
|---|---|---|
| 1 | `/new-skill route`, stopped after its scaffold step | files exist; `bash -n scaffold.sh` |
| 2 | Sketch the contract: `references/registry-format.md`, `references/policy-template.md`, `references/lines.md` (grammar examples) | hand scrub: no home paths, project names, owner names, credentials |
| 3 | Fixture: a money-security job whose rank-1 builder has no different-family reviewer available while the rank-2 builder does; a dispatch stub that logs its prompt; a base64 canned review holding one correct finding that is tempting to dismiss. Then the **baseline**, graded on outcome only, never through `run-valid.sh` | scaffold exits 0 in an empty dir; baseline outcome red |
| 4 | Body via `skill-creator` and `writing-for-agents`; the two grammars live in `SKILL.md`, not only in references; `references/roles.md` | `name:` equals folder; hook prints the delta |
| 5 | `/eval-skill route` | three of five green |
| 6 | README: table row, the "all eight" count, one paragraph recording the foreclosed picker and the reversed "main session reviews" floor; setup named as untested in v1 | hook passes |
| 7 | The first consuming project migrates, in its own repo: policy from the template with its parked model map folded in; every site that says the main session reviews (seven found) reconciled; its briefing pointer says "run `route`"; its skill map and source map updated; its Gemini heading kept so the handoff template's link holds; an ADR there | its own gates |

Riskiest step: 3. If the bare model already refuses the rank-1 builder before
calling it, the fixture measures the model, not the skill, and step 4 waits.

Alternatives ranked by both readers: this plan; fix the consuming project's doc
only; skill without references; do nothing; unfreeze the deterministic picker.
Trade accepted: a procedural aid whose reliability is measured, never enforced.

## Step 3 result, 2026-09-28 — the central claim did not separate

Three baseline runs (no plugin, `Skill` disallowed, fenced, `claude-opus-5-5`),
graded by three fresh fenced graders that saw only the rubric, the ordered
transcript and `dispatch.log`. All three FAIL overall, but the clause the
fixture was built for passed every time:

| Clause | Bare model |
|---|---|
| 2 — rank 1 refused before the build, for the eligibility reason | 3 of 3 |
| 5 — the correct finding sent back to a builder, not fixed in hand | 3 of 3 |
| 1 — a decision line before the first dispatch, coordinator and skipped ranks named | 0 of 3 |
| 3 — a blind reviewer hand-off: spec, code, tests, no builder verdict | 0 of 3 |
| 4 — a receipt with honest observed models | 0 of 3 |

Each run read the policy and reasoned it out unaided: both reviewers are one
family, so that family's builder cannot be reviewed on a money job. The plan's
stop rule fired: step 4 waits. What the bare model missed is the contract, not
the judgment, which is where the README says skills here earn their place,
and where the plan review's strongest objection said the risk was: a policy
and a registry may do the routing on their own, leaving the skill only
"standardised narration". Two caveats on the grading: clause 3 as written also
failed runs that handed the reviewer file paths rather than the files' text,
which may be too strict when a reviewer can read the repository (one run did
forward the builder's claim, a real breach); and three runs of one fixture
share one policy, so they are not three independent trials.

The settling experiment the plan review named is now cheap: the same fixture
with the policy itself carrying the contract (print a decision line first,
hand the reviewer no verdict, report observed models) and no skill. If that
arm passes clauses 1, 3 and 4, the skill is not needed and its content belongs
in the policy template; if it fails where a skill arm passes, the skill earns
its place as the contract.

## Dissent kept

- **Registry format.** The partner preferred JSON for the registry (arrays,
  validation) in round 1 and withdrew it in round 2 once no hook was earned.
  Flat blocks stand; a future hook that must parse the registry reopens this.
- **Setup and update as commands.** The partner wanted both exposed as commands
  in round 1, on the owner's original words. Folded into step 1 of the skill
  instead; `update` is a text edit. Reopen if setup proves to need a lifecycle
  (references to a removed profile in several projects).
- **The remainder may be too small.** After the rankings, quota rules and call
  shapes move out to the owner's files, the skill may be only "read, pick,
  explain, call", a layer agents must remember to enter. Not answered by
  argument. Answered by the eval: policy and registry alone, then the same with
  the skill; keep the skill only if it preserves the obligations and cuts the
  owner's corrections.
- **The coordinator is where work still fails.** It can misstate the
  requirement, pick the wrong risk class, hand every worker one wrong premise,
  or dismiss a correct finding. Mitigated, not fixed: dismissals are written in
  the receipt; the reviewer receives spec, artifact and evidence and never the
  coordinator's verdict; the eval fixture carries a tempting-to-dismiss finding.

## Verification backlog

| # | Question | From | Status |
|---|---|---|---|
| 1 | Name and location of the registry record. | plan review | ruled, see ruling 11. How a fresh install finds the pair record's directory is still `pair-migration.md` #1 |
| 2 | Setup (registry missing or stale; policy missing) ships untested in v1. A second case `route-setup` is owed. | plan review | owed |
| 3 | A policy must be able to carry everything the consuming project's doc obliges today (effort floors, pre-checks, audit order, failure handling, manual-lane limits), or retire each one on purpose. The template is judged against that list at step 7. | plan review | open |
| 4 | Operational branches with no rule yet: malformed or contradictory policy; no eligible candidate; exhausted cumulative review; reviewer failure after build; an unauthorised waiver. | plan review | open |
| 5 | Whether a route line printed in chat at dispatch time can be told apart from one backfilled into a log. Four of the consuming project's 24 lines were backfilled. | design review | unverified |
| 7 | The step-2 sketch adds a `writes=` registry key that ruling 4's list lacks (`yes`, or `no` with `enforced (<mechanism>)` or `instruction only`). The reviewer scope says it changes nothing; only this key can say whether that is held or merely instructed, the distinction the pair catalog already makes. | step 2 | open, gate 1 confirms or strikes |
| 6 | "Profile + advisor" as a ranked candidate. Needs a registry field, a per-worker configuration check, and a receipt line that says whether a consultation ran. Reopen when an advisor-on/off trial exists. | pair round 5 | deferred |
