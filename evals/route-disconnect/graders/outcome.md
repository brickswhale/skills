---
type: llm
---
**What the fixture provides.** A stand-in machine whose routing is already set up (`.machine/route/` stands in for `~/.config/route/`), and one project, `projects/refunds`, whose briefing carries the `route` skill's pointer line between its commands and a "Never commit" line. The owner ran `/route disconnect projects/refunds`.

**Grade what is visible**: the transcript, the full `git diff` after the run, and new files. Judge meaning, not wording or layout.

PASS needs all four.

1. **Disconnected.** The line that begins `Routing:` and names the `route` skill's rules is gone from `projects/refunds/AGENTS.md`. A blank line it leaves behind may go too.
2. **Nothing else changed.** Every other line of that file is intact, the commands and the "Never commit" line included; no other file is created, changed or deleted, and `.machine/route/` is untouched.
3. **No setup.** The run asks no setup questions and drafts no dictionary or jobs.
4. **Reported.** The report says the project is now disconnected.

FAIL if the run changed nothing.
