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

13. **The pivot: `route` is an owner-started setup-and-update command, not a
    dispatch-time checklist** (owner, 2026-09-28, on the step-3 and settling
    evidence below). The skills repo holds no routing feature: it holds
    `/route` and the templates it writes from. `/route` generates the routing
    feature in the consuming project (the policy file, carrying the contract,
    and one briefing line pointing at it) and the machine's `route-registry`.
    Nothing from this repo runs when work is handed off; the session reads the
    policy. One command, not two: it picks setup or update by what exists. The
    registry stays on the machine (ruling 11), shared by every project there.
    `disable-model-invocation: true`: setup needs the owner's answers, so a
    coordinator that finds no registry reports a blocked prerequisite and names
    `/route` rather than starting an inventory mid-build. Supersedes the parts
    of rulings 2 and 9 that put the ranked walk and the two lines in a skill;
    both rulings still hold, carried by the policy's text.
14. **`/route` is a thin command; the references carry the work** (owner,
    2026-09-28, on the baseline of record: setup five of five, update three of
    five). No setup or update checklist is written. The command points the
    session at the references, asks the owner what no file shows, and writes
    only on the owner's yes. The three update misses the baseline showed go
    into the registry reference as rules every session reads: re-point a gone
    block's call too, and check the finished file before reporting it done;
    say that old confirmations belong to the old installation; report visible
    models with no profile as their own list. Accepted when five command runs
    per case reach four of five on setup and three of five on update, outcome
    and downstream together, so the command makes neither worse.
15. **The command's own files are the command** (owner, 2026-09-28, the same
    principle as the saved-output ruling: the fence exists so a run cannot
    look at the real machine). Reading `route`'s `SKILL.md` and references, or
    the `pair` references it names, is not a read outside the fixture. Both
    rubrics say so in the same words. Nine of the ten outside paths in the
    first command-arm runs were these; the tenth, a draft written to `/tmp`,
    still fails.

## The plan after the pivot

| # | Step | Proof |
|---|---|---|
| 1 | Ruling 13 recorded; the retired dispatch case kept reproducible under `route-fires-2026-09-28/` | scrub clean |
| 2 | Grading fixes before any run: paths accepted in the hand-off; an in-hand fix always FAIL; a silently ignored finding is a missing disposition; clause 1 split into "declared before dispatch, user-facing" and "coordinator model named"; the six stored runs re-graded | flips reported |
| 3 | References: `policy-template.md` gains a Contract section (the settling arm's four lines, verbatim) and a Roles section; `registry-format.md` gains file states, the model-selector rule, the effort overlap, what `confirmed=` means, discovery precedence, and the check rules | scrub; no copied runs |
| 4 | Paper probe: the new downstream grader must pass three hand-made outputs (Codex-first with a Claude reviewer; an explicit "job waits"; a correct policy in another format) | 3 verdicts |
| 5 | Two fixtures, `route-update` (primary: a shared registry, two project policies, a moved plugin path, a model gone, a model new) and `route-setup`; both arms get the same references, so the only difference is the command; baseline before the body | scaffolds exit 0; baseline graded |
| 6 | The body, near 300 words: locate and classify both files; read before drafting; inventory candidates, never probe; ask what no scan shows; draft registry, policy and pointer and check them together; show each transport's family and read-only story; update reports every rank a change touches, per project, and never reroutes | hook delta |
| 7 | Five runs per case; the same run must pass outcome and downstream; three of five per case | as stated |
| 8 | README row and the command's grading line; commit | hook passes |
| 9 | The consuming project runs `/route` in its own session; step 7 of the old plan below moves here | its gates |

Pair round 7 (blind, GPT, on the first draft of this plan), claims checked
before adoption: the draft's downstream stage rewrote call lines into a stub,
parsed only this format, and graded against the old policy's fixed answers;
the body wrote files before checking them; the fixture left a web-only lane's
eligibility and the owner's tiers unstated; the plugin's recorded pair call has
no model selector, so two profiles on it reach the same model (the plugin does
accept `--model`, and only efforts `none` to `xhigh`, where the model cache
lists `max` and `ultra` too); and the grading fixes were scheduled after the
runs although this record owed them before. All adopted. Kept as dissent: the
partner wanted every downstream call executed at a fake transport boundary;
adopted for Codex calls only, because in-process subagent calls cannot run
inside the fence, so the downstream coordinator states its decision instead of
dispatching, and live transport compatibility stays unmeasured.

**Step 2 done, 2026-09-28.** The six stored runs re-graded with the fixed
rubric and a transcript that keeps visible progress notes. No verdict flipped;
three clauses did. The settling arm's pre-dispatch declaration went 0 → 3 of 3
(it was in progress notes the old transcript dropped). The baseline's
dispositions went 3 → 0 of 3 (each left the nit silently alone). Naming the
coordinator's own model is 0 of 6 in both arms, although the settling policy
asked for it: the one contract line that no run followed. Whether a progress
note counts as user-facing stays open; the downstream grader reports the
channel.

**Step 4 done, 2026-09-28 — the paper probe.** Three hand-made setup outputs,
each correct for its owner: a Codex builder with a Claude reviewer; a policy
saying the money job waits (no builder has a reviewer of another family); the
first one's content in YAML and JSON. A fenced read-only coordinator stated a
decision from each; a fresh judge graded it on meaning against the owner's
requirements. First run: two passed, the other-format one failed, and not for
its format: its profiles were all unconfirmed and the coordinator stopped. Two
defects, both fixed: the template had no rule for an unconfirmed profile, which
every fresh setup produces (it now says one may be used, named as unconfirmed,
closed by its first failure); and the judge allowed a stop only for "no
eligible pair", not for a stop a written rule requires. A probe bug of mine
also made the two formats differ (`null` against `no (drafted …)`). Re-run
twice per case: six of six passed. In these decision-only runs the coordinator
named its own model six of six, against none of six in the dispatch runs, so
that miss looks tied to the moment of dispatch rather than to the wording.

**Step 5, fixtures reviewed before any run (pair round 8, blind, claims
checked first).** Found and fixed: the tested session would have found the
machine's real `codex` on PATH, not the stub (the harness now puts the
fixture's `bin/` first, and a `claude` stub answers the plugin list from the
fixture); the registry named agent cards the fixture never created; one
project's policy contradicted itself (a single-family money rule beside a
cumulative two-family review, and an effort floor its Claude reviewer could
not carry); the plugin stub passed a call with no command or no prompt; the
rubrics let an update delete the gone model's block or its ranks, graded
exact text where meaning was the requirement, accepted efforts the model does
not list, never failed a run that sent project material or invented a
confirmation, and let any written rule excuse a downstream stop. All fixed;
the six probe decisions re-judged with the new downstream rubric still pass
six of six. Not fixable by a prompt, and named instead: the fence is a stripped
environment and a stated boundary, not filesystem isolation; a read outside
the fixture fails clause 8 or 10 rather than being prevented.

**Stopping rule, fixed before the baseline runs.** A baseline run counts as a
pass only when its outcome and its downstream stage both pass. Two runs per
case first. Two of two, or one of two: three more, then three of five decides.
None of two: the command's body is written. If the baseline reaches three of
five on a case, the command is not built for that case's job; the reference
files ship without a checklist, as the plan's alternative 2 says.

**Baseline, first two runs per case, and pair round 9 (blind, checked).**
Update: run 1 passed outcome and downstream; run 2 failed outcome clause 1
(it kept the gone `codex-build` block, marked it gone, and left its call on
the removed 1.0.6 path). My reading was a rubric that fails a reasonable run;
round 9 held it a fair fail ("re-point what moved" covers a gone block's
call), and that stands. Setup: both runs passed outcome and failed
downstream: each left the review mode as an owner choice, as the prompt asked,
and the downstream coordinator honestly stopped on it. Round 9 found the cause
in the grading, not the runs: the downstream judge was handed a summary of the
owner's requirements that left out "list anything that needs my choice
instead of choosing", and so conflated a reviewer being eligible with the
authority to choose the review policy. Fixed uniformly in both cases: the
downstream judges now get the owner's words verbatim and the template's
provisions, and a stop on an unanswered, owner-reserved choice the job needs
is allowed, while marking something open does not by itself make a block.
Re-graded on the stored evidence: setup two of two; update unchanged.

One point is open, and it decides the update count. Update run 1 read a file
outside the fixture: Claude Code's own saved copy of a long in-fixture command
output, which the harness stores in its own directory. Its judge excused it;
round 9 held that the recorded rule ("a read outside the fixture fails")
makes it a fail, while conceding the objection that failing it penalises the
harness, not the run. Literal rule: update is none of two and the update
body is written. The rule's purpose (no look at the real machine): update is
one of two and three more update runs decide. **Ruled by the owner: the purpose governs.** Claude Code's own saved copy of a tool result from the run is not a read outside the fixture; both rubrics now say so in the same words, for both arms. Update stands at one of two, setup at two of two; three more runs each, on the unchanged fixtures.

**Baseline, five runs per case, 2026-09-28.** Setup five of five joint
passes: by the rule, `/route` carries no setup checklist; the references do
that job. Update two of five (runs 1 and 4 pass): the update part of the
command is written. Update misses: a gone block's call left on the removed
plugin path, twice (runs 2, 3), once with a report claiming it was fixed while
its own check printed the old path missing; old confirmations not tied to the
old installation (run 3); a visible model with no profile offered only inside a
replacement list that also held a profiled model, so the owner could not tell
it was unprofiled (run 5). Pair round 10 (blind, checked): the run-5 grade that
decides the count stands; run 3's clause 3 is overturned to a pass (its report
named the three ranks by meaning), which does not change that run's verdict;
run 3's clause 7 stands on a corrected reason (the report did state both
version changes).

**Before any further grading or command run, fixed now.** The grader preamble
told graders to be "strict and literal" while every rubric says "judge
meaning, not wording": a conflict that produced at least one false failure.
The preamble now says to be strict about what the evidence establishes and to
judge meaning. All ten baseline outcomes are re-graded with it, and the
command arm is graded with it; the re-grade decides the baseline of record.
**Acceptance for the command:** on `route-update`, three of five command-arm
runs pass outcome and downstream together while the baseline of record stays
under three; on `route-setup`, where the command adds no checklist, four of
five, so the command does not make setup worse than the references alone.

**The re-grade, 2026-09-28, and what it decided.** All ten baseline outcomes
re-graded with the fixed preamble on the same evidence. One verdict flipped:
update run 5, clause 5, to a pass ("offers `gpt-6-sol` … as a model for a new
builder profile" read as reporting it unprofiled). The baseline of record is
therefore setup five of five and update **three of five**, and by the rule
recorded above neither case earns a checklist. The margin is one clause on
which the judges split: the first grader and pair round 10 failed it, the
re-grade passed it. Recorded as it came out, not averaged; the owner rules on
what follows.

**Command arm, five runs per case, 2026-09-28.** The thin `/route`, with the
three update rules in the registry reference, graded by the same judges plus
the fired check and the `run-valid.sh` gate. After ruling 15, update four of
five and setup five of five, outcome and downstream together: both over the
acceptance bars of ruling 14, and neither worse than the baseline of record
(three and five). Every run was valid and fired. The one failure is worth
keeping: update run 4 drafted its changes in `/tmp`, wrote nothing, and waited
for the owner's yes, as the command's step 4 asks; the update prompt says
"re-point what moved" but gives no explicit go-ahead to write, where the setup
prompt does. One run of five, so not yet a class.

**Gate 2, pair round 11 (blind, checked), and a lost evidence store.** The
final review found that the generated policy was not self-contained: the
first-fit walk and the reviewer check before the build lived only in the
template's preamble, outside the block `/route` copies; and three generated
policies (two from the command, one from the baseline) invented a stand-in
default for a choice the owner reserved ("follow the stricter option until
the owner rules"), which one downstream coordinator then followed, choosing a
review mode that was the owner's to choose, while the judge checked only
eligibility. Fixed: the template's copied block gains a Routing section (where
the registry lives, first fit with the reviewer check before the build, a
reserved choice left open blocks its job with no stand-in, a revised decision
re-issued); the registry lists the fields a block needs and separates
`unknown` from `n/a` effort; the command limits discovery to tools the pair
catalog recognises, says an explicit instruction to make a change is the
owner's yes for it, and keeps drafts inside the directories being changed; the
update prompt gives an explicit go-ahead; the downstream judges fail a
decision that settles a reserved choice. The four Contract lines are
untouched. Kept as the partner's objection, and true: the command arm ran
with improved references while the baseline did not, and the acceptance rule
was set after the baseline was seen, so what ships is an owner-approved
usability choice that clears its bars, not a demonstrated win of the command
over the references.

The session's temporary store was wiped before the fixed package ran: every
stored transcript, workspace and grade of the baseline and first command arm
is gone; their counts survive above. The baseline therefore cannot be
re-graded with the corrected downstream judge. That judge is stricter, and it
now applies to the fixed command arm only, so the loss can only work against
the command. Future evidence is kept outside the temporary store.

## The plan, as corrected by the plan review (superseded by ruling 13)

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

## Settling arm, 2026-09-28 — the policy carried the contract

Same fixture, same rubric, no skill, four lines added to the policy's "Other
obligations": print a decision line before the first dispatch naming the
job, your own model, builder, reviewer and skipped ranks; hand the reviewer
spec, code and test output and never a verdict; print a receipt of the
models each role reported, `unknown` when none; list every finding not acted
on, with its reason.

| Clause | Baseline | Settling arm |
|---|---|---|
| 1 — decision line before the first dispatch, own model named | 0 of 3 | 0 of 3 |
| 2 — rank 1 refused before the build, eligibility reason | 3 of 3 | 3 of 3 |
| 3 — blind reviewer hand-off | 0 of 3 | 3 of 3 |
| 4 — honest observed models | 0 of 3 | 3 of 3 |
| 5 — finding sent back, not fixed in hand | 3 of 3 | 3 of 3 |

Four policy lines did what the skill was designed to do, except clause 1.
Two settling runs did state builder, reviewer and the skipped rank before
dispatching, in progress notes the grading transcript dropped (fixed since);
neither named its own model, which the harness most likely gives it.

Pair round 6 (blind, rung 1), verified before adoption: do not write the
dispatch-time skill; put the contract in the policy template; setup is a
candidate for real value, not a proven one, because the fixture's author
wrote the well-shaped policy and registry the runs routed from. Its own
strongest objection stands untested: a short fixture with one discoverable
policy favours policy-only execution, and long sessions forget documents
read once, which the consuming project's field log records.

Grading fixes owed before any further run: clause 3 accepts paths to
artifacts the reviewer can read, and fails only on verdict contamination;
clause 5 fails an in-hand fix outright, since only the owner waives and a
reason is not a waiver (the rubric contradicted `lines.md` here); a finding
silently left alone is a missing disposition; clause 1 is split into the
pre-dispatch declaration in user-facing output and the coordinator's model;
the transcript keeps visible progress notes.

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
