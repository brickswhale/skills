#!/usr/bin/env bash
# A small plugin repo whose manifest declares an `agents` key over empty
# scaffolding, so validation rejects it and zero skills load. The recorded run
# in runs/last.jsonl is what that produces: no Skill call, a fluent answer from
# the bare model, and a plugin_errors entry nobody read. Never commits itself.
set -e
git init -q -b main . && git config user.email t@t && git config user.name t
mkdir -p .claude-plugin agents skills/greet evals/greet-fires/graders runs
: > agents/.gitkeep

cat > .claude-plugin/plugin.json <<'JSON'
{
  "name": "toolbelt",
  "description": "Personal skills, reused across projects.",
  "version": "0.1.0",
  "skills": "./skills",
  "agents": "./agents"
}
JSON

cat > skills/greet/SKILL.md <<'MD'
---
name: greet
description: Write the first message a new contributor sees — what the project is, the one command that proves their setup works, and who to ask. Use for "/greet", "write the welcome", "onboarding message".
---

# greet

1. **Name the project in one line.** What it does, for whom. No history.
2. **One command that proves the setup works.** It must be runnable from a fresh clone and fail loudly when something is missing.
3. **Who to ask.** A person or a channel, not a mailing list nobody reads.
4. **Cut everything else.** A welcome nobody finishes is a welcome nobody reads.
MD

cat > evals/greet-fires/prompt.md <<'MD'
---
name: greet-fires
max_turns: 10
allowed_tools: [Read, Bash, Glob, Grep, Skill]
---
We keep losing new contributors in their first hour. Write the welcome they land on.
MD

printf 'context:\n  scaffold_script: scaffold.sh\n' > evals/greet-fires/case.yaml
cat > evals/greet-fires/scaffold.sh <<'GS'
#!/usr/bin/env bash
set -e
git init -q -b main . && git config user.email t@t && git config user.name t
mkdir -p src
printf '# toolbelt\n' > README.md
git add -A -- . ":!scaffold.sh" && git commit -qm init
GS
chmod +x evals/greet-fires/scaffold.sh
printf -- '---\ntype: tool_used\ntool: Skill\ninput_match: %s"skill"\\s*:\\s*"[^"]*greet"%s\n---\n' "'" "'" > evals/greet-fires/graders/skill-fired.md
printf -- '---\ntype: llm\n---\nPASS if it names the project in one line, gives one runnable verification command, and names a person or channel.\nFAIL if it writes project history, lists more than one command, or points at a mailing list.\n' > evals/greet-fires/graders/outcome.md

# The run that came back. Skill never loaded; the bare model answered anyway.
cat > runs/last.jsonl <<'JSONL'
{"type":"system","subtype":"init","cwd":"/tmp/eval-greet","session_id":"e1f2a3","tools":["Read","Bash","Glob","Grep","Skill"],"mcp_servers":[],"model":"claude-opus-5","permissionMode":"default","skills":["artifact-design","code-review","init"],"plugin_errors":["invalid manifest file at .claude-plugin/plugin.json. Validation errors: agents: Invalid input"]}
{"type":"assistant","message":{"role":"assistant","content":[{"type":"text","text":"Here is a welcome message for new contributors:\n\n# Welcome to toolbelt\n\ntoolbelt started in 2023 as a handful of shell aliases and grew into the shared automation layer the whole team leans on. Over the years it absorbed the old deploy scripts, the release checklist and a fair amount of tribal knowledge.\n\n## Getting started\n\n```\ngit clone <repo>\ncd toolbelt\nnpm install\nnpm run build\nnpm test\n```\n\nQuestions? Post to dev-list@example.com and someone usually replies within a few days."}]}}
{"type":"result","subtype":"success","is_error":false,"duration_ms":24180,"num_turns":3,"result":"Here is a welcome message for new contributors:\n\n# Welcome to toolbelt\n\ntoolbelt started in 2023 as a handful of shell aliases and grew into the shared automation layer the whole team leans on. Over the years it absorbed the old deploy scripts, the release checklist and a fair amount of tribal knowledge.\n\n## Getting started\n\n```\ngit clone <repo>\ncd toolbelt\nnpm install\nnpm run build\nnpm test\n```\n\nQuestions? Post to dev-list@example.com and someone usually replies within a few days.","session_id":"e1f2a3"}
JSONL

printf '# toolbelt — agent briefing\n\nSkills live in `skills/<name>/SKILL.md`, one folder each, under 300 words.\nEvery skill has an eval under `evals/<skill>-<case>/`, run green before commit.\nA rejected manifest loads nothing: check the run before trusting a verdict.\n' > AGENTS.md
git add -A -- . ":!scaffold.sh" && git commit -qm "toolbelt: greet skill and its eval case"
