---
name: new-skill
description: Scaffold a new skill in this repo with its eval case, then hand the body to skill-creator. Use for "/new-skill <name>", "add a skill", "create a skill here".
arguments: [name]
---

# new-skill

Repo-local. Creates the shape, not the substance.

1. Refuse if `skills/$name/` exists, or `$name` is not lowercase-with-dashes, or it starts with `kit-`.
2. Create `skills/$name/SKILL.md` with frontmatter: `name: $name`, `description:` (one sentence, when to use it, with two trigger phrases), and an empty body headed `# $name`.
3. Create `evals/$name-fires/` with `prompt.md` (frontmatter `name`, `max_turns: 12`, `allowed_tools`), `case.yaml` pointing at `scaffold.sh`, an executable `scaffold.sh` stub, and two graders: `graders/skill-fired.md` (`type: tool_used`, `tool: Skill`, `input_match` on `$name`; for a command, `type: llm` matching a line only its body produces) and `graders/outcome.md` (`type: llm`, PASS and FAIL lines).
4. Invoke `skill-creator` to write the body and tune the description. Then `writing-for-agents` on the prose. Keep it under 300 words.
5. Add one row to the README skills table.
6. Run `/eval-skill $name`. Do not commit until it fires and passes.
7. Show the diff. Commit only on the owner's word. Never push.
