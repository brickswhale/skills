# brickswhale plugin

One place for every custom skill, agent, and hook. Reused across every project, read by Claude Code and Codex.

```
.claude-plugin/plugin.json   the plugin manifest
skills/<name>/SKILL.md       skills; a user-invoked one is a command (`disable-model-invocation: true`)
agents/<name>.md             subagent definitions, when earned
hooks/hooks.json             shared hooks, when earned
```

## Install, once per machine

```sh
git clone https://github.com/brickswhale/skills.git ~/skills
for d in ~/skills/skills/*/; do n=$(basename "$d"); ln -sfn "$d" ~/.claude/skills/$n; ln -sfn "$d" ~/.agents/skills/$n; done
```

Symlinks, so `git pull` updates every skill everywhere. Re-run the loop only when a skill is added or removed. Claude Code can also install it as a plugin from this git URL; the symlink path is the one that serves Codex too.

## Structure

Flat. One folder per skill under `skills/`, holding `SKILL.md` and, where a skill needs reference data too long to inline, a `references/` beside it — the hook word-caps and genericity-checks `SKILL.md` alone, so anything else there is scrubbed by hand or not committed. No category folders: the plugin manifest can list several skill directories, and the install loop reads one level, so a category, when there are enough skills to need one, becomes a second directory listed in `plugin.json`, never a nested path. Until then the table below groups skills by SDLC stage. A command is a skill with `disable-model-invocation: true`; there is no `commands/` folder.

Frontmatter keys Claude Code reads: `name`, `description`, `disable-model-invocation`, `user-invocable`, `allowed-tools`, `context: fork`, `arguments`. Nothing else.

## Evals

Every skill has at least one eval case under `evals/<skill>-<case>/`, in the layout `claude plugin eval` reads: `prompt.md` with frontmatter, `graders/*.md`, optional `case.yaml` with a `scaffold_script` that builds a self-contained fixture. Two graders minimum: one proving the skill fired, and an `llm` grader with a PASS/FAIL rubric for the outcome. For a model-invoked skill the first is `tool_used: Skill`; a command makes no `Skill` call, so its case invokes it by slash name and the grader is an `llm` one matching a line only its body produces. Under `--plugin-dir` a slash name is namespaced `/<plugin>:<name>`. Run before a skill is merged:

```sh
claude plugin eval . --case '<skill>*' --runs 5
```

All eight skills have now been run five times against a no-plugin baseline on their own fixture, with `Skill` disallowed in the baseline because seven of them have a retired `kit-*` ancestor still installed — one of which answered in its skill's place before that was caught. Findings rarely separate a skill from the model: the bare model reported every one of `review`'s, and `gate`'s version disagreement, unaided. What separates them is the contract — a JSON verdict with provenance, a ruling with its waiver named, a judgement that may be "don't".

Green is **three of five**, not one. A fifteen-run ablation on one collection line — the same instruction as buried prose, as a bare tick-box, and as a tick-box naming the method — scored 4/5, 3/5 and 3/5. The wording made no difference the runs could show; the base rate was about seventy percent either way. So a single green is a dice roll, and a rule that accepts one is satisfied by re-running until it lands. Results go to `evals/results/`, ignored by git. `claude plugin eval` refuses as early access; no timeline is known, so nothing here is planned around it opening. Meanwhile `/eval-skill <name>` runs the same case by hand with `claude -p`. A skill with no eval is a draft. A skill whose eval never fires gets its `description` fixed, not its eval.

Anthropic ships two evaluators better at measuring than this one. `skill-creator` runs a with-skill and a without-skill arm and reports variance; `claude plugin eval` does ablation natively and reads this layout already. `/eval-skill` exists for one reason they do not cover: it is fenced. It runs in a temp dir outside the repo with messaging tools blocked by the CLI, after an eval once messaged a live session about its own fixture. A subagent-based runner cannot be fenced that way — checked, not assumed: a probe subagent has `ListAgents` loaded, `SendMessage` reachable and some seventeen session tools available, and `skill-creator` sets no tool restrictions in any of its agent definitions. Its runner also writes a command file into the project under test.

## Working on this repo

Two repo-local skills in `.claude/skills/`, not installed globally: `/new-skill <name>` scaffolds a skill and its eval case, `/eval-skill <name>` runs it fenced and says whether the result counts. Not commands — both dropped `disable-model-invocation` so an agent can run them, which is what rule 7 asks for. Their job is to make sure every skill here is well made. They never leave this repo.

## Rules

- This repo is public. No client names, no home paths, no credentials in any skill, ever.
- A skill is a checklist, never a script. Under 300 words.
- A skill that a tool can replace is deleted the day the tool exists.
- Nothing copied from agent-kit verbatim. A `kit-*` skill is rewritten here only when a real ticket shows its judgment step done badly twice, or on the owner's word. Its `kit-*` symlink stays until the last project using it moves to the new name.

## Skills

| Skill | Use |
|---|---|
| `consult` | an idea gets pressure-tested before anyone builds it — its real terms, the assumptions, the strongest objection, a verdict that may be "don't". Writes nothing, produces no plan. `/consult`, or any "what if we" |
| `intent` | a raw ask becomes an issue — problem, outcome, affected, constraints, open questions, interrogated until each is concrete. A command: `/intent <ask>` |
| `learn` | a mistake becomes one rule on the highest rung that can catch it — test, hook, skill line, briefing — replacing a line, never adding one. `/learn`, or when a lesson needs to stick |
| `pair` | a second opinion from another model on one question — your own position written first, the ask put blind, both views attributed and the dissent kept rather than averaged. `/pair`, or "second model opinion" |
| `plan` | an ask becomes ordered steps — files, the test per step, blast radius, riskiest step, numbered alternatives. A command: `/plan <ask>` |
| `review` | four lenses over a diff — bugs, security, does it match the plan, scope creep — every finding verified against the code and given a counted class, verdict as JSON. `/review` |
| `supervise-build` | read a build session's position from disk, compare with its plan, send one correction. `/supervise-build "build driver"`, or unattended: `/loop 20m /supervise-build "build driver"` |

## agent-kit skills, where each one goes

| kit skill | goes to |
|---|---|
| kit-lens-review, kit-eng-pass | `review` — done |
| kit-adr, kit-consult's ranking | `plan` — done |
| kit-consult's advisory mode | `consult` — done |
| kit-idea, kit-setup's interview | `intent` — done |
| kit-doc-sync | `learn` — done |
| kit-milestone-gate | `gate` — done |
| kit-recenter | attempted, rejected — see below |
| kit-report, kit-problem-log, kit-pause | wrappers round a CLI that does not exist here |
| kit-log, kit-phase-map | git and the issue tracker already hold this |
| kit-batch, kit-prompt-cycle, kit-inline | the framework's own orchestration; it retires with it |
| kit-pair | `pair` — done, on the owner's word; the catalog came too, the machine-local record did not |

## How a `kit-*` skill migrates here

Trigger-based, never scheduled. One skill at a time.

1. **Trigger.** A real ticket shows that judgment step done badly twice. Note the ticket in the commit message.
2. **Rewrite.** Under 300 words, generic, no kit vocabulary, no project names. The old skill is source material, not text to copy.
3. **Test.** Five runs on a scaffolded fixture, green three of five. Keep it only if it changed the outcome against a bare-model run on the same fixture.
4. **Retire.** Remove that `kit-*` symlink when the last project using it migrates to the driver. Projects still on the old name keep working until then; the new name differs, so the two coexist without colliding. One copy of each thing, once nothing reads the old one.

**Seven, after one reopening.** `review`, `plan`, `intent`, `learn`, `consult` and `gate` came
across, and the migration was declared closed at six. `pair` reopened it on the owner's word,
against the line this file used to carry — that its value was a machine-local transport record and
a catalog of sharp edges, with no home here. Half of that objection held. The record is genuinely
machine-local and stays there; the skill names only the filename it looks for and the lines that
file must carry. The catalog was the half that did not hold: it is generic knowledge about public
CLIs, it costs nothing against the word cap because the hook reads only `SKILL.md`, and a skill
pointing at a catalog it cannot name is worse than either keeping it out or bringing it in. It was
rewritten, scrubbed and now sits at `skills/pair/references/transports.md`. Of the eighteen kit
skills, nine were absorbed into these seven and the other nine are not coming: three are wrappers
round a CLI this repo does not have, two are document layouts git and the issue tracker already
hold, three are the old framework's own orchestration and retire with it, and one was attempted and
rejected.

`kit-recenter` is the one that was attempted and rejected, and the reason is worth keeping. It audits a session's own recent turns against its standing rules. Built here and evaluated, it twice raised a drift finding against a rule that appeared nowhere in its context, and when the rubric was tightened to demand a source, it invented the source too. A session cannot reliably tell a rule it was given from one it believes it was given, and the eval regime makes it worse: a fresh subprocess has no prior turns, so the fixture must hand it a transcript, which is a different skill from the one intended. Do not rebuild it without a way to verify a cited rule against a file the run actually read.

Reopening needs the trigger in step 1, not a tidy-up impulse. The `kit-*` symlinks stay until the last project using each one moves across.
