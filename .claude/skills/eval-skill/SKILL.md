---
name: eval-skill
description: Run one skill's eval case by hand until `claude plugin eval` leaves early access. Use for "/eval-skill <name>", "eval this skill", "does the skill fire".
arguments: [name]
---

# eval-skill

Same case files `claude plugin eval` reads, run by hand. Report only what the run showed.

1. Try `claude plugin eval . --case "$name*" --runs 1`. If it runs, read `evals/results/` and stop here.
2. Else, for each `evals/$name-*/`: make an empty temp dir, run `scaffold.sh` in it, delete the script.
3. Run the prompt body of `prompt.md` there: `claude -p "<prompt>" --output-format stream-json --verbose --max-turns <max_turns> --allowedTools <allowed_tools> --disallowedTools "SendMessage,ListAgents,mcp__ccd_session_mgmt__send_message" --plugin-dir <this repo>`, output to a file outside the repo. Wait for it. Without `--plugin-dir` the subprocess cannot see the skill. An eval must never reach a real session: the first run of `supervise-build` did, and messaged the live build session about the fixture.
4. **Confirm it loaded, before grading anything.** The init event must list the skill and carry no `plugin_errors`. A rejected manifest loads zero skills with the flag passed, and the run answers anyway — the bare model, reading like a normal result. A run where the skill was invisible is VOID, not red: fix the load, run again, change nothing.
5. Grade `skill-fired`: the output has a `Skill` tool call whose input matches `$name`. A command makes none — grade its marker rubric instead. Yes or no.
6. Grade the `llm` rubric yourself against the final `result` text: PASS or FAIL, with the sentence that decided it.
7. Report: case, loaded, fired, rubric, turns, duration. One line each.
8. Did not fire, and step 4 confirmed it loaded: fix the `description` in `SKILL.md`, never the eval. Run again.
9. Delete the temp dir. Nothing from the run enters the repo.
