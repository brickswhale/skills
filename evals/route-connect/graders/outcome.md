---
type: llm
---
**What the fixture provides.** A stand-in machine whose routing is already set up (`.machine/route/` stands in for `~/.config/route/`), and one project, `projects/refunds`, whose briefing has no routing line. The owner ran `/route connect projects/refunds`.

**Grade what is visible**: the transcript, the full `git diff` after the run, and new files. Judge meaning, not wording or layout.

PASS needs all four.

1. **Connected.** `projects/refunds/AGENTS.md` gains the `route` skill's pointer line, once, word for word as the skill's template gives it. A blank line beside it is fine.
2. **Nothing else changed.** No other line of that file changes, no other file is created, changed or deleted, and `.machine/route/` is untouched.
3. **No setup.** The run asks no setup questions and drafts no dictionary or jobs.
4. **Reported.** The report says the project is now connected.

FAIL if the run changed nothing.
