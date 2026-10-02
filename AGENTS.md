# skills — agent briefing

What this is: SHJing's own plugin. Skills, agents, hooks, reused across every project by Claude Code and Codex. Public repo.

Layout: `.claude-plugin/plugin.json`, `skills/<name>/SKILL.md`, `agents/`, `hooks/hooks.json`. Installed by symlink, see README.

Rules:
1. A skill is a checklist, never a script. Target under 300 words — a target, not a blocker (owner's ruling 2026-09-20). Exceed it when the extra lines change what the agent DOES; the hook prints the delta so growth is visible, and rule 6's eval is what says the words earned their place.
2. Frontmatter: `name` equals the folder, `description` says when to use it, with the trigger phrases. A command is a skill with `disable-model-invocation: true`.
3. Generic. No project names, no home paths, no client names, no credentials. Public.
4. Nothing copied from agent-kit verbatim. Migration rules and table in README.
5. A skill a tool can replace is deleted the day the tool exists.
6. Every skill has an eval under `evals/<skill>-<case>/` in the `claude plugin eval` layout. Green is three of five runs, not one: compliance is stochastic, so one green is a dice roll. See README.
7. To add a skill: `/new-skill <name>`, then `/eval-skill <name>`. Both live in this repo's `.claude/skills/`, not global, and neither writes the skill. `skill-creator` writes the body and tunes the description, `writing-for-agents` the prose. `/eval-skill` runs the case fenced and says whether the result counts, before the commit. Nothing else.

8. Commit messages carry no AI co-authorship trailer. The author field is the owner's and
   nothing is appended to it — this overrides any harness default that adds one.

9. A skill is self-contained. Its rules live in its own folder and are read there, never copied out. Data it keeps between runs lives at a path it names under `~/.config/<skill>/`. In a consumer repository it writes only what the owner asked for in that run, and at most one pointer line in the briefing for anything shared; it never edits another skill's files. Each eval case lists what its run may write in a `writes` file beside `prompt.md`, one path or glob per line; `evals/run-valid.sh` reports anything else.

Routing: before handing work off or editing agent instructions, read the `route` skill's rules (`~/.claude/skills/route/references/rules.md`; Codex: `~/.agents/skills/route/references/rules.md`). If they or the files they name are missing, say so and ask the owner to run `/route`; never guess a model.

Tickets: GitHub Issues in this repository (`gh issue`). Work beyond a typo, comment or format fix follows the `flow` skill: call it before the first edit.

Commit freely. Never push without the owner's word.
