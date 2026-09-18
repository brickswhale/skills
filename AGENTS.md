# skills — agent briefing

What this is: SHJing's own plugin. Skills, agents, hooks, reused across every project by Claude Code and Codex. Public repo.

Layout: `.claude-plugin/plugin.json`, `skills/<name>/SKILL.md`, `agents/`, `hooks/hooks.json`. Installed by symlink, see README.

Rules:
1. A skill is a checklist, never a script. Under 300 words. `wc -w` before commit.
2. Frontmatter: `name` equals the folder, `description` says when to use it, with the trigger phrases. A command is a skill with `disable-model-invocation: true`.
3. Generic. No project names, no home paths, no client names, no credentials. Public.
4. Nothing copied from agent-kit verbatim. Migration rules and table in README.
5. A skill a tool can replace is deleted the day the tool exists.
6. Test a new skill by invoking it once on a real task before commit. Say what it did.

Commit freely. Never push without the owner's word.
