# skills

One place for every custom skill. One folder per skill, `<name>/SKILL.md`, the open Agent Skills format both Claude Code and Codex read.

## Install, once per machine

```sh
git clone https://github.com/brickswhale/skills.git ~/Documents/shj/projects/skills
for d in ~/Documents/shj/projects/skills/*/; do n=$(basename "$d"); ln -sfn "$d" ~/.claude/skills/$n; ln -sfn "$d" ~/.agents/skills/$n; done
```

Symlinks, so `git pull` updates every skill everywhere. Re-run the loop only when a skill is added or removed.

## Rules

- A skill is a checklist, never a script. Under 300 words.
- A skill that a tool can replace is deleted the day the tool exists.
- No `kit-*` here. Those belong to agent-kit, frozen.

## Skills

| Skill | Use |
|---|---|
| `supervise-build` | read a build session's position from disk, compare with its plan, send one correction. `/supervise-build "build driver"`, or unattended: `/loop 20m /supervise-build "build driver"` |
