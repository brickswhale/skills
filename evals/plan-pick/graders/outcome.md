---
type: llm
---
The fixture: the ticket `docs/tickets/T-4-json.md` states a problem and an outcome and holds no plan. The run has two turns in one session: in the first the owner asks for a plan; in the second the owner says "Go with your recommendation. Don't build yet."

1. The first turn changed no file: it made no Write or Edit call, and the git status after the first turn is empty.
2. The first turn recommends one option and names the ticket its steps will be written to (`docs/tickets/T-4-json.md`, or T-4).
3. In the second turn the run writes the recommended option's steps into `docs/tickets/T-4-json.md` under a heading that begins `## Plan`, one `- [ ]` line per step. The list covers every step the first turn gave for that option, in the same order. The wording may differ and a step may be split; a step may be added only where the first turn named it for that option, such as its riskiest step's probe or a question to settle first.
4. Each line names a proof: what shows that step done, such as a named test, a command and its expected result, or, for a step that changes only a document, the change it must show or the review it gets. A line that only restates the step does not meet this, and neither does one check shared by every line, such as "the test suite passes".
5. No line in the list is ticked.
6. Across both turns the only file changed is the ticket, and its title, problem and outcome text is unchanged: no plan file, no code, no test.
7. After writing the list, the second turn reads the ticket back: a Read of it, or a shell command that prints it.

PASS only if every clause is met.
FAIL if the list is written before the owner's pick, if it is written to any file other than the ticket, or if any code or test is written.
