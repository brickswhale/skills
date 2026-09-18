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

## Rules

- This repo is public. No client names, no home paths, no credentials in any skill, ever.
- A skill is a checklist, never a script. Under 300 words.
- A skill that a tool can replace is deleted the day the tool exists.
- Nothing copied from agent-kit verbatim. A `kit-*` skill is rewritten here only when a real ticket shows its judgment step done badly twice, and its `kit-*` symlink is removed that day.

## Skills

| Skill | Use |
|---|---|
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
