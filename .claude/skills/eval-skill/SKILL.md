---
name: eval-skill
description: Run a skill's eval case by hand, and say whether a finished run means anything. Use for "/eval-skill <name>", "eval this skill", "does the skill fire", "did that eval really pass".
arguments: [name]
---

# eval-skill

Same case files `claude plugin eval` reads, by hand. Report only what the runs showed.

1. Try `claude plugin eval . --case "$name*" --runs 5`. If it runs, read `evals/results/` and stop here.
2. Per run: empty temp dir, `scaffold.sh` in it, delete the script. A `.claude/skills/` skill is not in the plugin — copy it into the temp dir's own `.claude/skills/`.
3. Run the prompt body of `prompt.md` there: `claude -p "<prompt>" --output-format stream-json --verbose --max-turns <max_turns> --allowedTools <allowed_tools> --disallowedTools "SendMessage,ListAgents,mcp__ccd_session_mgmt__send_message" --plugin-dir <this repo>`, output to a file outside the repo. Five times, fresh fixture each. Wait for each to write its result before reading it. An eval must never reach a real session: `supervise-build`'s first run messaged the live build session.
4. **Check validity before grading:** `evals/run-valid.sh <name> <run.jsonl> <scaffold-exit>`. INVALID is VOID, not red — never in the tally. Fix the harness, rerun, change no skill.
5. Grade `skill-fired`: the output has a `Skill` call matching `$name`. A command makes none — grade its marker rubric. Yes or no.
6. Grade the `llm` rubric against the final `result` text: PASS or FAIL, with the sentence that decided it.
7. Report per run: loaded, fired, rubric. Then the tally. Green is three of five; below that, say the count rather than "failed".
8. Did not fire, though step 4 confirmed it loaded: fix the `description`, never the eval. Rerun.
9. Delete the temp dirs. Nothing from a run enters the repo.
