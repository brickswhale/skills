---
name: eval-skill
description: Run a skill's eval case safely and say whether the result counts. Use for "/eval-skill <name>", "eval this skill", "does the skill fire", "did that eval really pass".
arguments: [name]
---

# eval-skill

Not an evaluation system. A safe runner and an honesty gate — the only fenced one available. Anthropic ships two better evaluators: `skill-creator` does ablation and variance, and `claude plugin eval` does both natively, but neither can be fenced here.

1. Try `claude plugin eval . --case "$name*" --runs 5`. If it runs, read `evals/results/` and stop here — it has ablation and scoring this does not. It has refused as early access every time so far; no timeline is known.
2. **Isolate.** Per run: an empty temp dir outside the repo, `scaffold.sh` in it, delete the script. A `.claude/skills/` skill is not in the plugin — copy it into the temp dir's own `.claude/skills/`.
3. **Run it fenced:** `claude -p "<prompt>" --output-format stream-json --verbose --max-turns <max_turns> --allowedTools <allowed_tools> --disallowedTools "SendMessage,ListAgents,mcp__ccd_session_mgmt__send_message" --plugin-dir <this repo>`, output outside the repo. Five times, fresh fixture each; wait for each result before reading it. The fence is the point: an eval once messaged a live build session about its own fixture, and a subagent-based runner cannot be fenced this way — its restraint is instruction, not enforcement.
4. **Gate:** `evals/run-valid.sh <name> <run.jsonl> <scaffold-exit>`. INVALID is void, never a pass or fail.
5. **Baseline once:** same case, no `--plugin-dir`, `Skill` in `--disallowedTools` — six skills here have a retired `kit-*` ancestor installed, and one answered in its place. A bare run that passes the rubric means the rubric is not measuring the skill.
6. **Report** what the runs showed: fired, rubric, the count, the baseline. Green is three of five with the baseline failed. Delete the temp dirs.
