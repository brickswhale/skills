---
name: eval-skill
description: Run a skill's eval case safely and say whether the result counts. Use for "/eval-skill <name>", "eval this skill", "does the skill fire", "did that eval really pass".
arguments: [name]
---

# eval-skill

Not an evaluation system. A safe runner and an honesty gate. `claude plugin eval` is the better evaluator, so use it wherever it runs; this runner covers the cases it refuses. Test on each model the skill is meant for: Sonnet and Opus, unless the owner names others.

1. **Anthropic's runner first,** for a skill under `skills/` whose rubric needs no command run: `claude plugin eval . --case "$name*" --runs 5 --scaffold --no-publish --judge-model opus --threshold 0.6 --model <model> --allow-tools <the Write and Edit the case lists>`, once per model. It never loads a `.claude/skills/` skill, and it refuses any Bash grant where the machine's Docker config folder holds links: those cases go on to step 2. Exit 1 is a score under the threshold, not an error; any other error is fixed, not routed around. Read the report, judge it by step 6, and stop.
2. **Isolate.** Per run: an empty temp dir outside the repo, `scaffold.sh` in it, delete the script. A `.claude/skills/` skill is not in the plugin — copy it into the temp dir's own `.claude/skills/`.
3. **Run it fenced:** `claude -p "<prompt>" --model <model> --setting-sources project,local --output-format stream-json --verbose --max-turns <max_turns> --allowedTools <allowed_tools> --disallowedTools "SendMessage,ListAgents,mcp__ccd_session_mgmt__send_message" --plugin-dir <this repo>`, output outside the repo and the fixture. A case's `followup.md` is a second turn: the same command with `--resume <the first run's session id>` and its body, and the git status between the turns goes to the grader. Five times per model, fresh fixture each; wait for each result before reading it. The fence is the point: an unfenced run can message a live session about its own fixture, and loads the owner's own hooks, plugins and output style, so it measures them along with the skill; and a subagent-based runner cannot be fenced this way — its restraint is instruction, not enforcement.
4. **Gate:** `evals/run-valid.sh <name> <run.jsonl> <scaffold-exit> <fixture> <case>`. INVALID is void, never a pass or fail. A `FOOTPRINT:` line names what the run changed beyond the case's `writes` file (rule 9): read it before counting.
5. **Baseline once per model:** same case, no `--plugin-dir`, `Skill` in `--disallowedTools` as a second fence. The gate's "not in the session's skills" is what a baseline should show; any other INVALID voids it. A bare run that passes the rubric means the rubric is not measuring the skill.
6. **Report** per model what the runs showed: fired, each grader, the count, the baseline. Green is three of five on each grader with the baseline failed, on each model. Delete the temp dirs.
