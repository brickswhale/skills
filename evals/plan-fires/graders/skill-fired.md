---
type: llm
---
PASS if the answer shows the skill's own procedure ran: it opens with the line `PLAN ONLY — nothing will be changed`, and the body that follows is the skill's shape — numbered ordered steps, a blast-radius count taken from a command, a named riskiest step, and numbered alternatives including a do-nothing option.
FAIL if that opening line is absent, if the answer is free-form advice with none of that shape, or if the run reports the command was not available.
