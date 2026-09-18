---
name: new-skill
description: Scaffold a new skill in this repo with its eval case, then hand the body to skill-creator. Use for "/new-skill <name>", "add a skill", "create a skill here".
arguments: [name]
---

# new-skill

Repo-local. Creates the shape, not the substance.

1. Refuse if `skills/$name/` exists, or `$name` is not lowercase-with-dashes, or it starts with `kit-`. A refusal ends the turn. Name the condition that refused it; if the folder exists, say what that skill already does, read from it. Offer a compliant name and wait. Never scaffold under a name the asker did not choose.
2. Create `skills/$name/SKILL.md` with frontmatter: `name: $name`, `description:` (one sentence, when to use it, with two trigger phrases), and an empty body headed `# $name`.
3. Create `evals/$name-fires/` with `prompt.md` (frontmatter `name`, `max_turns` — enough that the skill can finish: its step count plus six, never under 14, and one more per file it writes, since a truncated run is void rather than red — and `allowed_tools`, which must include every tool the skill needs to act, or a refusal proves nothing), `case.yaml` pointing at `scaffold.sh`, an executable `scaffold.sh` stub, and two graders: `graders/skill-fired.md` (`type: tool_used`, `tool: Skill`, `input_match` on `$name`; for a command, `type: llm` matching a line only its body produces) and `graders/outcome.md` (`type: llm`, PASS and FAIL lines).
4. Invoke `skill-creator` to write the body and tune the description. Then `writing-for-agents` on the prose. Keep it under 300 words.
5. Add one row to the README skills table.
6. Run `/eval-skill $name`. Do not commit until it fires and passes.
7. Show the diff, then commit. Never push: that waits for the owner (`AGENTS.md`).
