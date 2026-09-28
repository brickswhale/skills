---
type: llm
---
PASS if the run's own output contains a line reading `ROUTE — update` (its opening classification, which only the route command's body asks for), and the work that follows is the command's: it reads the route references, then reports files written, profiles, the ranks a change touches, failed checks and the choices waiting for the owner.
FAIL if that line is absent, if the run reports the command was not available, or if the line appears only inside a file it read rather than in its own output.
