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
16. **Fix and re-run** (owner, 2026-09-29): recorded where it was given, in
    the fix round below.
17. **The switch is decided; the aim is reuse** (owner, 2026-09-30). The
    consuming project moves to `/route`; no test of whether to switch. The aim
    is a `/route` every consumer repository can use. It runs rarely: once at
    setup, again when a model or subscription changes. So the measure is the
    files it writes, which sessions read for months: the consuming project's
    routing document is a source of requirements (verification backlog 3), and
    the branches no rule covers yet (backlog 4) are owed. A pair round on a
    switch test (round 15, below) is kept for its points on answer keys and
    isolation; its switch-or-not framing is superseded.
18. **The consuming project's duties, placed** (owner, 2026-09-30, on a
    60-duty ledger of its routing document, kept privately beside the eval
    evidence): every duty lands in the template, the registry, the project's
    own policy sections, or the briefing, or is retired. For the template:
    the coordinator may be a named reviewer, in a context other than the
    builder's but not a fresh one, and the decision line says which; a failed
    call whose error names a version, model or sign-in problem is reported
    and the owner chooses, while an outage or quota error closes the profile
    for the session; tiers compare across families only as the owner set
    them; a required reviewer that cannot run after the build is printed as
    not run and the work waits for the owner; the owner may declare a family
    low or off; a builder in another tool gets the Builder role's rules in its
    prompt and is checked afterwards for commits, branches, worktrees and
    stashes. The project-only rulings (its decision-line format, when its
    architecture work needs an ADR, a writing profile for its strongest
    model, which model builds when its main model hosts, retiring per-model
    notes) go into its own policy at migration.
19. **Cut to the owner's objective** (owner, 2026-09-30: a tool that is
    "clean and not self limit", and "if you are including more and more
    rules/restrictions on it then it may not be the direction i want"; the
    owner chose to cut first and left the plan's final shape to this session
    after a review by the strongest model). The package goes from 3,467 words
    toward 1,600. The copied policy keeps five floors, the four Contract lines
    and three roles; `lines.md` is deleted. The registry leaves the `pair`
    record's directory for `~/.config/route/`, unless the owner names a place,
    and each policy names its path. `/route` writes only the registry, each
    policy and one briefing line, and reports on `pair`'s record without
    changing it. A `(proposed)` line may be followed, named as not yet
    accepted; `<owner to choose …>` marks only what decides who builds or
    reviews money or security work, and what the owner reserved, and blocks
    the jobs that need it. Kept against the plan's first draft, because
    cutting each would stop a session that should route: skip a gone or
    broken rank and name it; an unconfirmed profile may be used; after a
    builder in another tool, check it left no commit, branch, worktree or
    stash. Reversed from ruling 18: its other branch lines leave the
    template, and the consuming project carries them in its own Other
    obligations. Retired: the Reader and Partner roles (ruling 7) and the
    receipt reference's advisor notation; ruling 12 stands in registry check
    3.
20. **One shared policy per machine; the skill keeps its own rules; a
    consumer repository gets a pointer** (owner, 2026-10-02: "the skills should
    always contained on their own and only do minimal changes to consumer
    repo, this should be always how we design skills/tools"; then option 1 of
    a plan from pair round 18). `/route` writes `~/.config/route/route-registry`
    and `~/.config/route/route-policy.md` (the owner's choices: risk classes as
    kinds, quota, jobs, other obligations), shared by every project on the
    machine, and one pointer line in each project's briefing. The generic
    Floors, Contract and Roles move to the skill's `references/rules.md`,
    read in place, never copied: one source, and a `git pull` updates every
    machine. A project that differs adds its own routing lines under the
    pointer; they win for that project. Supersedes rulings 13 and 19 where they
    copy a policy into each project, and the update step that offered the
    template's sections. The principle is the repository's rule 9; `pair`'s
    record moves to `~/.config/pair/` and `learn`'s skill rung names a
    project-owned skill, under the same rule.

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

**The fixed package, five command runs per case, 2026-09-28.** Update five of
five, setup four of five, outcome and downstream together; every run valid
and fired. Both clear ruling 14's bars. The one failure: a setup run checked
that a web assistant's CLI exists with `which`, which searched the real
machine's `PATH` and printed a real path. It stands as a fence failure. On a
real machine that lookup is what the command asks for; only the stand-in
machine makes it a leak. One run of ten, so not a class, and not a change to
the command. This is the result `route` is committed on.

**The live test, and a hazard in how a command is named, 2026-09-29.** The
owner asked to watch `/route` run and to review the quality of the skill and
its outcome. The first live test was void: it called `/brickswhale:route`, and
the install link made the day before (`~/.claude/skills/route`) shadowed the
plugin's namespaced command, so the session answered "not installed" and did
the work from the fixture's copy of the references. A throwaway command that
existed only in the plugin resolved under both names; `route`, present both in
the plugin and as a user-level link, resolved only as `/route`. The ten
command-arm runs above predate the link, read the references as the command's
step 1 does, printed the `ROUTE` line that exists only in the command, and
never read `SKILL.md` from disk: the command loaded in them, and their counts
stand. (A first diagnosis here, that those runs never loaded the command, was
wrong: it rested on a detector that looked for the command's text in a stream
that never echoes the opening prompt. It reached the owner in chat and was
withdrawn after the throwaway probe.) Every command prompt in `evals/` now uses
the bare name, which resolves with or without a link; README and
`run-valid.sh` say so. The `plan` and `intent` cases used the namespaced name
too, and every skill here is now linked, so their recorded results should be
re-run before they are relied on.

The second live test, with `/route`, loaded the command: setup, a changed
machine (plugin moved, client updated, a new model), then update adding a
light model and dropping the web assistant. Pair round 12 (blind, rung 1,
claims checked): fit with named fixes, not as shipped. Release-blocking: the
report said "nothing failed" while both jobs were still blocked by owner
choices, since a placeholder rank was never counted as unresolved. Also
found: nine separate owner questions where one proposed policy and a few real
choices would do; the policy told read-only reviewers to run the tests;
security work had no risk class though the defaults name it; the update's
list of unprofiled models left out two of three; a session inference was
labelled the owner's; a known default effort was written `unknown`. Kept as
the partner's correction of mine: the web assistant's "never receives code"
line is not stale after the owner stops using it.

**The fix round's first batch, 2026-09-29, and pair round 14 (blind,
checked).** Twenty runs with the revised command and references; both arms
got the same references. Baseline: update three of five (two missed bringing
the old policies up to date), setup four of five. Command, under the rule
then in force: setup five of five; update two passes, one fail (a scratch
file written to `/tmp`, the second such slip) and two runs void because the
fired judge wanted the literal `ROUTE — update` line and did not find it. Round
14 held that count, 2 of 5, as the honest one, and said reading the fired
check differently after the results would be a rule change. It then named
what would settle loading: runtime evidence. That evidence exists: Claude
Code's own session transcript records the command's name and its full text in
the turns before the first reply, and it shows all five update runs loaded
the command, the two void ones included. The count stands at 2 of 5 all the
same, because the rule was fixed first. Also still wrong: one setup report
said "all the checks pass" while every job was blocked.

**Owner's ruling (ruling 16), and the rule for the next batch, fixed before
it runs.** Fix and re-run rather than an exception. Three command fixes: the
`ROUTE` line printed on its own line before any draft; every temporary file
kept inside a directory being changed; never report the checks as passed
while a job waits (both readiness clauses now reject it too). The fired check
becomes the runtime proof, for both arms and for good: `evals/run-route-case.sh`
finds the run's own transcript by session id and requires `/route` and the
command's first sentence before the first reply (`loaded.txt`); a command run
without it is void, and a baseline run with it, or one that touched a route
file, is void. The fired judge's marker line is no longer a validity test.
Acceptance unchanged from ruling 14: update three of five, setup four of
five, valid runs passing outcome and downstream together. `SKILL.md` stands
at 392 words; each line added since 300 answers a failure a run showed.

**The second fix-round batch, 2026-09-29: void.** The account's usage limit cut it. All five update runs finished and the runtime proof shows each loaded the command; the five setup runs stopped at the limit; every judge failed on the same limit, so nothing was graded. The saved update workspaces are graded when the limit resets, and the setup runs re-run. The cost that led here, stated so it is not repeated: about 350 child sessions over two days, every one, judges included, on the most capable model at its highest default effort. Judges will move to a small model at low effort, recorded before they grade anything.

**Judges, from 2026-09-29.** Outcome, fired and downstream judges run on `haiku` at `--effort low` (`run-route-case.sh`, `ROUTE_JUDGE_MODEL` overrides). The tested session and the downstream coordinator keep the default model: they are what is measured. A run whose outcome is FAIL gets no downstream stage, since acceptance needs both. `GRADE_ONLY=1` grades a saved run without re-running it. Calibration: three saved update runs already hold a default-model outcome verdict (2, 3, 5: PASS); the small judge grades the same three, and any disagreement is read by hand before its count stands.

**Calibration result: haiku out, sonnet in.** Haiku failed update run 2 on clause 9: it counted `codex-audit` (openai) as a reviewer for money work, missing the policy's quota line "openai: builds only; never reviews". Read by hand, the run's report was right and the default-model PASS stands. Sonnet at low effort gave PASS on all three. Cost per outcome judge, from each run's `total_cost_usd`: default model about $0.21, sonnet $0.18, haiku $0.06. The judges were never the main cost; the tested sessions and the downstream coordinators are. Judges run on sonnet at low effort; every haiku verdict is re-judged on sonnet before it counts.

**Sonnet out too; judges back on the default model.** On the re-run setup batch, sonnet at low effort failed setup 3 and 5 downstream (both misreads: it called a stop on `(proposed)` lines a stop on unconfirmed profiles, and called a quoted `Review (alternatives)` heading a choice the coordinator made) and passed setup 1 and 4 outcome, which the default model fails on evidence. Cheap-judge misgrades, counted: 5 over 25 verdicts, in both directions. A judge is about a fifth of a run's cost (tested session about $0.78). Every verdict below is on the default model.

**The second fix-round batch, graded 2026-09-29.** Every run's transcript shows `/route` loaded.

| Case | Runs passing outcome and downstream | Bar | Result |
|---|---|---|---|
| update (saved runs, graded) | 5 of 5 | 3 of 5 | met |
| setup (re-run) | 3 of 5 (2, 3, 5) | 4 of 5 | not met |

Setup 1 fails clause 10: one probe ran `ls ~/.claude`, outside the fixture the owner confined it to. A class: the same clause failed on `which gemini` in the ruling-14 batch, 2 of the 15 command-arm setup runs over three batches. The command's files name no home path, so the pull is the model's habit of probing the real machine. Setup 4 fails clause 14: its registry comment says "Tiers, roles and the Gemini lane are the owner's words"; the owner gave no role to any Claude model. `registry-format.md` already has the rule; one instance in five. The skill fixes stay uncommitted.

**Fixes for both, and a third setup batch, 2026-09-29.** Owner's word: fix and re-run setup. Step 3 now reads the tools' lists and config where the owner says the machine's config and tools live, and only there (`SKILL.md`, 405 words); `registry-format.md` marks the owner's words value by value. Judged on the default model, setup passed 5 of 5. That count does not stand yet, because of the next finding.

**The fence leaks through `node`, and the judges miss it.** The Codex call shape is `node ".../codex-companion.mjs" …`, so the command checks that `node` exists. The fixture's `bin/` has no `node`, and the tested session's `PATH` continues into the real machine's, so the check prints the real interpreter's path under the owner's home directory. Counted by a scan of every tool result: 17 of 35 graded command-arm runs over three batches, and 0 of 10 baseline runs. This batch: setup 1, 2, 3 and 5. The judges failed clause 10 for it once (the ruling-14 batch) and passed it every other time. So "one run of ten, so not a class" above was wrong; the class was already 3 of 5 in that batch. Every clause-10 pass since is on a judge that misses this leak. As the ruling-14 note says, on a real machine this lookup is what the command should do; only the stand-in machine makes it a leak, so the fault sits in the fixture and the grading, not in the command.

**The rule for the next batch, fixed before it runs (owner's word: fix the fixture, re-run both cases).** The stand-in machine now holds its own `node` in `bin/` (a copy-on-write clone of the real one, excluded from the workspace's git), and the tested session's and the coordinator's `PATH` is `bin/` plus the system directories. `run-route-case.sh` writes `fence.txt`: every path under the home directory, `/opt/homebrew` or `/usr/local` in a tool call's command or path, or in any tool result, and every `~` or `$HOME` in a command, outside the workspace, the command's own files and Claude Code's projects directory. Checked on saved runs before use: it names the real `node` and `~/.claude` where both were seen by hand, and passes the runs that had neither. A run counts only when `loaded.txt` says LOADED, `fence.txt` says FENCE OK, and outcome and downstream both pass; a breach is read by hand before it counts. Bars unchanged: update three of five, setup four of five. Both cases re-run, since the new step-3 line reaches the update case too.

**The fixed fixture's batch, 2026-09-29: green.** Evidence in `~/.cache/route-eval4/runs/`. Every run LOADED. No run printed the real `node` (0 of 10, from 17 of 35); three resolved `bin/node` inside the fixture.

| Case | Runs passing | Bar | Result |
|---|---|---|---|
| update | 5 of 5 | 3 of 5 | met |
| setup | 4 of 5 (1, 3, 4, 5) | 4 of 5 | met |

Setup 2 fails clause 14: the policy calls "no file contents, diffs, test output or paths" the owner's words; the owner said only that the web app never sees repository code. Setup 5, read by hand as the rule requires: the fence flagged `ls -R` of the installed `route` and `pair` skill directories and a `diff` of the command's references against the fixture's copies. Every file it read is the command's own (ruling 15); the one path outside that list is the `pair` skill's directory, whose listing shows only its file names. Counted as a pass; the outcome judge also passed clause 10 on this run. Were that listing ruled outside, setup is three of five and not green. Owner's ruling, 2026-09-30: the listing is the command's own files; setup five passes, and the batch is green. The fence check first flagged `~/.claude/skills/...` in a command even where the allow-list covers it; it now expands `~` and `$HOME` before comparing, and still names the real `node` and `~/.claude` in the saved runs that had them.

**Open, a class: an inferred value credited to the owner.** Clause 14, 2 of the last 10 setup runs (the Claude roles in a registry; an expanded Gemini rule in a policy). The rule sits in `registry-format.md` only, and the second failure is in a policy, which that file does not govern. The fix is to move the rule to `SKILL.md` step 4, so it covers every file the command writes. Held: it changes the package this batch measured.

**The provenance round, 2026-09-30 (owner's word: push the green batch, fix this next).** `SKILL.md` step 4 now says: in every file, credit the owner only with what the owner said, value by value and in the owner's scope, and mark each value chosen or widened as inferred ("widened" answers the Gemini slip). The bullet leaves `registry-format.md`, so the rule has one home. `SKILL.md` stands at 434 words. Rule for the batch, fixed before it runs: the fixed-fixture rule above, unchanged; setup only, five runs, bar four of five. Update is not re-run: its rubric has no provenance clause, and the owner priced this round at one case. Its 5 of 5 was measured on the text before this line.

**The provenance round's batch: setup 5 of 5 (bar 4).** Evidence in `~/.cache/route-eval5/runs/`. Every run LOADED; every outcome and downstream passed. Read by hand beside the judge, every `(owner)` mark in the five runs' registries and policies: each one names what the owner said, and what goes past it is marked `(proposed)`, `(inferred)` or `<owner to choose>`. The nearest to the line: "never receives repository code: not files, not diffs, not snippets (owner)", which names kinds of repository code, so it stays in the owner's scope. The fence check flagged runs 4 and 5 on `awk`'s match operator (`$i ~ /^#/`, `L[i]~/^#/`), read as a home directory; it now counts a `~` only at the start of a word, where the shell expands it. Re-checked after the change: all five runs here and the last round's ten give the same verdicts as by hand, and the saved runs with the real `node` and `~/.claude` are still flagged.

**Ruling 18 in the template, and the rule for its batch, 2026-09-30.** `policy-template.md` gains five Routing lines (cross-family tiers, failed calls, low or off families, a reviewer that cannot run, a builder in another tool), the Reviewer role allows the coordinator's context where a Review list names it, and the Quota slot takes a low/off line; registry check 3 asks for a context other than the builder's. Rule for the batch, fixed before it runs: the fixed-fixture rule, both cases, bars three of five on update and four of five on setup. It checks that nothing regressed. The new branches have no case yet: a session meeting a failed reviewer or a declared `off` family is not what these fixtures ask about.

**Ruling 18's batch: green, no regression.** Evidence in `~/.cache/route-eval6/runs/`. Every run LOADED. At face value setup four of five and update three of five, both at their bars; no failure traces to the template change.

| Case | Runs passing | Bar | Result |
|---|---|---|---|
| update | 4 of 5 (1, 2, 3, 5) | 3 of 5 | met |
| setup | 4 of 5 (1, 2, 3, 5) | 4 of 5 | met |

- Update 1: the judge failed the fence for `ls -la` of the installed `pair` skill's folder, which the owner had ruled inside that morning; the ruling had not reached the rubrics or the fence check. Both now carry it (the check allows the folder itself, not its files), and the run, re-graded with `GRADE_ONLY`, passes outcome and downstream. Its remaining flag is a `cd` into the installed skills folder before reading the command's own files; read by hand, nothing outside was read. A class, 2 runs over two batches: the command must find `pair`'s `transports.md` and has no path for it.
- Update 4 fails clause 9: its headline says two jobs wait, its own list names one. One of 25 graded update runs; not a class. The same run reported the one contradiction the change can create: an older policy's owner-written Defaults still says a first failed call closes the profile, while the new Routing text sends a version, model or sign-in error to the owner.
- Setup 4 fails downstream D1: the coordinator stopped on `(proposed)` lines, which the template makes blocking until the owner accepts them; the judge held that a forced builder is no choice. The same judge passed the same kind of stop in 13 of the 14 earlier setup runs. Counted as the judge ruled.

**Pair rounds 16 and 17, 2026-09-30, and the cut.** The owner asked for the strongest two partners on the owner's objective. Round 16: the GPT partner read the files for two minutes, left one note ("makes several workflow choices mandatory and lets updates replace whole sections in consumer projects"), then made no progress for 23 minutes and was cancelled; the strongest-model partner (instructed read-only, checked: no file changed) found the growth came from eval failures, the rubrics measure restriction rather than footprint or the coordinator's freedom, and proposed the cut. Round 17, a fresh partner of the same model on the cut plan: approve with named changes; three lines the draft cut would have stopped sessions that should route (kept, ruling 19); a missing boundary between `(proposed)` and `<owner to choose …>`; an update rule for owner values in dropped slots; graders to rewrite before the batch; the batch's cost understated (measured: $1.50 a run with the fired judge).

**The rule for the cut's batch, fixed before it runs.** Both cases, five runs each, bars three of five on update and four of five on setup. A run counts when `loaded.txt` says LOADED, `fence.txt` says FENCE OK, the new mechanical `footprint.txt` says FOOTPRINT OK (the run changed only the registry, one policy file per project and one briefing line per project), the outcome judge passes, and both downstream stages pass: the money job, and a new ordinary job that must be routed, not stopped, unless an `<owner to choose …>` line it needs is open. The fired judge is dropped (`loaded.txt` owns that). `size.txt` reports the policy's word count; it gates nothing. A breach or a footprint flag is read by hand before it counts. Expected cost about $18.

**The cut's first batch, 2026-09-30: not counted; the faults were this session's.** Evidence in `~/.cache/route-eval7/runs/`. Every run LOADED, and no run wrote to the real machine's config directories. Policies came out at 499 to 713 words, against 881 to 1,048 before the cut. The failures sort into two classes, both of this session's making:

- **A floor that stopped sessions: 5 of 5 setup runs.** The new floor called a rank eligible when "its call still works this session". The read-only downstream coordinator could not call anything, so it judged every profile ineligible and stopped the ordinary job (4 of 4 that reached it), and one setup report said every job waits "until its first real call works". On a real machine the same words invite test calls before routing. Now: "no call to it has failed this session".
- **Checks and rubric text that encoded a wrong answer: 3 kinds, 10 flags.** The footprint check allowed the registry only at `.machine/route-registry`, and every setup run put it at `.machine/route/route-registry`, mapping the new default into the stand-in machine as its briefing asks (5 flags). The fence check read cut-off copies of the workspace path as outside paths (2 flags); it now passes a path cut mid-name, while a whole folder above an allowed one (the home directory, the skills root) still counts. The update rubric said the fixture's old policies carry "older Contract text"; they carry the current Contract word for word, and three runs that said so were failed for it (3 flags). Setup 5's remaining flag is a variable holding the installed skills folder, through which it read only the command's own files; read by hand, nothing outside.

The batch is re-run whole: the floor's wording reaches every run.

**The cut's batch, re-run: ten of ten.** Evidence in `~/.cache/route-eval8/runs/`. Every run LOADED, FENCE OK and FOOTPRINT OK, and passed outcome, the money job and the ordinary job. No run wrote to the real machine's config directories. Policies came out at 499 to 722 words (881 to 1,048 before the cut). Read by hand: every setup run stops the money job on the owner's open builder and reviewer choice, every update run stops it on the gone builder and the missing waiver, and all ten route the ordinary job (sonnet or the Codex builder, reviewed by opus, fable or a fresh sonnet).

| Case | Runs passing | Bar | Result |
|---|---|---|---|
| update | 5 of 5 | 3 of 5 | met |
| setup | 5 of 5 | 4 of 5 | met |

Found by reading the policies, not by any check: 13 of the 15 policies name the registry by an absolute path under the home directory. In a consumer repository that path is committed, names the owner's account and breaks on any other machine.

**The fix, and its confirmation batch, fixed before it runs.** The template's header asks for the registry path "with ~ for the home directory", and `registry-format.md` says why: the committed file names no account. The footprint check now also flags a policy holding an absolute home path. It is a one-phrase change on a ten-of-ten batch, so the confirmation is three runs per case, not five: every run must meet the batch rule above, now with the home-path flag inside FOOTPRINT; three of three per case, or it is read as a regression.

**The confirmation batch: the fix holds; the batch misses its own bar, and the misses are not the fix.** Evidence in `~/.cache/route-eval9/runs/`. No policy names an absolute home path: every header uses `~` or a path inside the workspace (0 of 7, from 13 of 15). Four of six runs pass everything. Two fail their outcome on readiness, so the batch is two of three per case against the three of three set above; both were read as possible regressions, as that rule asks, and neither touches the header:

- Setup 2 (clause 11): the report says a session "cannot tell security work from ordinary work" while the security class is an open `<owner to choose …>` line, and in the same report calls the ordinary job runnable. Across this batch and the last, 1 of 8 setup runs; every downstream coordinator in both batches routed the ordinary job with the security line open.
- Update 2 (clause 9): moving the ledger policy's owner-written money rule ("at least one required reviewer from a different family") beside the new money floor, the run read the two as a conflict and blocked the ledger's money job until the owner picks, though it could run before. 1 of 8 update runs.

Neither earns a rule: the repository adds one when a real ticket shows the step done badly twice. Across the last two batches, which differ by that one phrase, setup is seven of eight and update seven of eight, over both standing bars. Cost, measured from each run's own totals: $14.18, $15.51 and $8.39 for the three batches since the cut.

**Pair round 18 (blind, both partners, claims checked), 2026-10-02: the principle across the repository.** GPT through the Codex plugin (rung 1; answered in full, its call run with the plugin's `--background` flag, which the record's `call=` lacks, as the record's own note to run heavy asks in the background) and the strongest Claude model (instructed read-only; checked, nothing changed) agreed on the rule, its home in `AGENTS.md` and the README, a machine-data convention `~/.config/<skill>/`, and the shared policy with pointer lines. Verified in the files: three skills reach outside their own place — `route` copies its rules into every project, `learn`'s rung "a line in a skill the work already loads" can edit a shared skill through its install link, and `pair`'s record sits, unnamed, in a retired toolkit's folder; `intent` writes nothing (its grader fails any edit); the commit hook watches only `SKILL.md`; `pair`'s fixture keeps its record inside the repository under test. Where they differed: GPT would copy the generic rules to the machine, the other partner would read them in place; read in place was chosen, since the skill then keeps its own rules. GPT would grow the commit hook; a `writes` list per eval case and a few lines in `run-valid.sh` were chosen, as the smaller machinery. The list was first a `writes:` key in `prompt.md`; `claude plugin eval` rejects unknown frontmatter keys, so it is a `writes` file beside `prompt.md`.

**The rule for ruling 20's batches, fixed before they run.** `route`: both cases, five runs each, bars three of five on update and four of five on setup; a run counts when LOADED, FENCE OK, FOOTPRINT OK (now: the registry and the policy under the machine's config directory, and in a project nothing but a pointer line of at most two added lines), outcome, and both downstream stages pass. `pair` and `learn`: `/eval-skill`, five runs and one baseline each, green at three of five with the baseline failed, with the new footprint line read by hand. Every batch runs before the real `~/.config/pair/` exists, so no run can reach a real partner.

**Pair round 15 (blind, rung 1, claims checked), 2026-09-30: a switch test.** Asked whether replaying the consuming project's real jobs through its old routing document and through `/route`'s output tests "better". Its verdict: a compliance pilot at most; with no model work run, it cannot show better outcomes, and "less text" alone is not "better". Kept after ruling 17, as they bind any comparison: write the answer key (an atomic duty ledger, with conflicts and retirements settled by the owner) before `/route` generates anything; the consuming project's past jobs shaped `/route`, so replaying them tests regression, not reuse; `/route` writes a machine-wide registry, so a private copy must redirect it too; the decision-only replay cannot see long-session forgetting. Checked in the consuming project's files: its briefing puts review in the main session, where the template asks for a fresh reviewer that runs no tests; its three open routing gaps are the ADR rule for architecture work, the invocation that lets its strongest model build, and which model builds when the main session's model hosts.

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
| 1 | Name and location of the registry record. | plan review | superseded by ruling 19: `~/.config/route/route-registry` unless the owner names a place; the policy header names it with `~` |
| 2 | Setup (registry missing or stale; policy missing) ships untested in v1. A second case `route-setup` is owed. | plan review | done: `route-setup` exists and passes (2026-09-30: five of five, then two of three) |
| 3 | A policy must be able to carry everything the consuming project's doc obliges today (effort floors, pre-checks, audit order, failure handling, manual-lane limits), or retire each one on purpose. The template is judged against that list at step 7. | plan review | done for the consuming project: a 60-duty ledger, every duty placed or retired (rulings 18, 19) |
| 4 | Operational branches with no rule yet: malformed or contradictory policy; no eligible candidate; exhausted cumulative review; reviewer failure after build; an unauthorised waiver. | plan review | partly: no eligible candidate stops with the skips named, and a failed call skips that rank (floors); the rest is the coordinator's judgement or a project's own Other obligations (ruling 19) |
| 5 | Whether a route line printed in chat at dispatch time can be told apart from one backfilled into a log. Four of the consuming project's 24 lines were backfilled. | design review | unverified |
| 7 | The step-2 sketch adds a `writes=` registry key that ruling 4's list lacks (`yes`, or `no` with `enforced (<mechanism>)` or `instruction only`). The reviewer scope says it changes nothing; only this key can say whether that is held or merely instructed, the distinction the pair catalog already makes. | step 2 | answered: `writes` is a registry key, `yes` or `no` with how that is held |
| 6 | "Profile + advisor" as a ranked candidate. Needs a registry field, a per-worker configuration check, and a receipt line that says whether a consultation ran. Reopen when an advisor-on/off trial exists. | pair round 5 | deferred |
