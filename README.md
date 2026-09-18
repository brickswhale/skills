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

Flat. One folder per skill under `skills/`. No category folders: the plugin manifest can list several skill directories, and the install loop reads one level, so a category, when there are enough skills to need one, becomes a second directory listed in `plugin.json`, never a nested path. Until then the table below groups skills by SDLC stage. A command is a skill with `disable-model-invocation: true`; there is no `commands/` folder.

Frontmatter keys Claude Code reads: `name`, `description`, `disable-model-invocation`, `user-invocable`, `allowed-tools`, `context: fork`, `arguments`. Nothing else.

## Evals

Every skill has at least one eval case under `evals/<skill>-<case>/`, in the layout `claude plugin eval` reads: `prompt.md` with frontmatter, `graders/*.md`, optional `case.yaml` with a `scaffold_script` that builds a self-contained fixture. Two graders minimum: one proving the skill fired, and an `llm` grader with a PASS/FAIL rubric for the outcome. For a model-invoked skill the first is `tool_used: Skill`; a command makes no `Skill` call, so its case invokes it by slash name and the grader is an `llm` one matching a line only its body produces. Under `--plugin-dir` a slash name is namespaced `/<plugin>:<name>`. Run before a skill is merged:

```sh
claude plugin eval . --case '<skill>*' --runs 1
```

Results land in `evals/results/`, ignored by git. `claude plugin eval` is in early access and may refuse to run; until it opens, `/eval-skill <name>` runs the same case by hand with `claude -p` and grades it. Same files, same verdict. A skill with no eval is a draft. A skill whose eval never fires gets its `description` fixed, not its eval.

## Working on this repo

Two repo-local commands in `.claude/skills/`, not installed globally: `/new-skill <name>` scaffolds a skill and its eval case, `/eval-skill <name>` runs the eval. Their job is to make sure every skill here is well made. They never leave this repo.

## Rules

- This repo is public. No client names, no home paths, no credentials in any skill, ever.
- A skill is a checklist, never a script. Under 300 words.
- A skill that a tool can replace is deleted the day the tool exists.
- Nothing copied from agent-kit verbatim. A `kit-*` skill is rewritten here only when a real ticket shows its judgment step done badly twice, or on the owner's word. Its `kit-*` symlink stays until the last project using it moves to the new name.

## Skills

| Skill | Use |
|---|---|
| `intent` | a raw ask becomes an issue — problem, outcome, affected, constraints, open questions, interrogated until each is concrete. A command: `/intent <ask>` |
| `plan` | an ask becomes ordered steps — files, the test per step, blast radius, riskiest step, numbered alternatives. A command: `/plan <ask>` |
| `review` | four lenses over a diff — bugs, security, does it match the plan, scope creep — every finding verified against the code and given a counted class, verdict as JSON. `/review` |
| `supervise-build` | read a build session's position from disk, compare with its plan, send one correction. `/supervise-build "build driver"`, or unattended: `/loop 20m /supervise-build "build driver"` |

## agent-kit skills, where each one goes

| kit skill | goes to |
|---|---|
| kit-consult, kit-adr | `plan` skill, here, when earned |
| kit-idea, kit-setup interview | `intent` skill, here, when earned |
| kit-lens-review, kit-eng-pass lenses | `review` skill, here, when earned |
| kit-doc-sync judgment | `learn` skill, here, when earned |
| kit-setup, kit-prompt-cycle, kit-batch, kit-report, kit-pause | driver commands: init, next, auto gates, status, next |
| kit-eng-pass checks, kit-pair | Stop hook, routing ladder |
| kit-log, kit-phase-map, kit-milestone-gate, kit-problem-log | GitHub: PR and Issue comments, Projects, Issue history |
| kit-inline, kit-recenter | retired |

## How a `kit-*` skill migrates here

Trigger-based, never scheduled. One skill at a time.

1. **Trigger.** A real ticket shows that judgment step done badly twice. Note the ticket in the commit message.
2. **Rewrite.** Under 300 words, generic, no kit vocabulary, no project names. The old skill is source material, not text to copy.
3. **Test.** Invoke it once on that real ticket. Keep it only if it changed the outcome.
4. **Retire.** Remove that `kit-*` symlink when the last project using it migrates to the driver. Projects still on the old name keep working until then; the new name differs, so the two coexist without colliding. One copy of each thing, once nothing reads the old one.

Likely order: `review` (the driver's review prompt needs its lenses first), `plan`, `intent`, `learn`. No dates.
