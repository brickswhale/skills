# skills — agent briefing

What this is: SHJing's own plugin. Skills, agents, hooks, reused across every project by Claude Code and Codex. Public repo.

Layout: `.claude-plugin/plugin.json`, `skills/<name>/SKILL.md`, `agents/`, `hooks/hooks.json`. Installed by symlink, see README.

Rules:
1. A skill is a checklist, never a script. Under 300 words. `wc -w` before commit.
2. Frontmatter: `name` equals the folder, `description` says when to use it, with the trigger phrases. A command is a skill with `disable-model-invocation: true`.
3. Generic. No project names, no home paths, no client names, no credentials. Public.
4. Nothing copied from agent-kit verbatim. Migration rules and table in README.
5. A skill a tool can replace is deleted the day the tool exists.
6. Every skill has an eval under `evals/<skill>-<case>/` in the `claude plugin eval` layout, run green once before commit. See README.
7. To add a skill: `/new-skill <name>`, then `/eval-skill <name>`. Both live in this repo's `.claude/skills/`, not global, and neither writes the skill. `skill-creator` writes the body and tunes the description, `writing-for-agents` the prose. `/eval-skill` only gates the result — fired, pass or fail — before the commit. Nothing else.

Commit freely. Never push without the owner's word.
