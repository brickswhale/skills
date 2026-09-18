---
name: eval-skill
description: Run a skill's eval case by hand, and say whether a finished run means anything. Use for "/eval-skill <name>", "eval this skill", "does the skill fire", "did that eval really pass".
arguments: [name]
---

# eval-skill

Same case files `claude plugin eval` reads, by hand. Report only what the run showed.

1. Try `claude plugin eval . --case "$name*" --runs 1`. If it runs, read `evals/results/` and stop here.
2. Else, for each `evals/$name-*/`: make an empty temp dir, run `scaffold.sh` in it, delete the script. A `.claude/skills/` skill is not in the plugin — copy it into the temp dir's own `.claude/skills/`.
3. Run the prompt body of `prompt.md` there: `claude -p "<prompt>" --output-format stream-json --verbose --max-turns <max_turns> --allowedTools <allowed_tools> --disallowedTools "SendMessage,ListAgents,mcp__ccd_session_mgmt__send_message" --plugin-dir <this repo>`, output to a file outside the repo. Wait for it. An eval must never reach a real session: `supervise-build`'s first run did, and messaged the live build session.
4. **Confirm it loaded, before grading anything.** The init event must list the skill and carry no `plugin_errors`. A rejected manifest loads zero skills with the flag passed; it answers anyway, reading like a normal result. A run where the skill was invisible is VOID, not red: fix the load, run again, change nothing.
5. Grade `skill-fired`: the output has a `Skill` tool call whose input matches `$name`. A command makes none — grade its marker rubric instead. Yes or no.
6. Grade the `llm` rubric yourself against the final `result` text: PASS or FAIL, with the sentence that decided it.
7. Report: case, loaded, fired, rubric, turns, duration. One line each.
8. Did not fire, though step 4 confirmed it loaded: fix the `description`, never the eval. Run again.
9. Delete the temp dir. Nothing from the run enters the repo.
