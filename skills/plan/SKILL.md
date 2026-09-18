---
name: plan
description: Turn a settled ask into an ordered implementation plan — the files each step changes, the test that proves it, the blast radius, the riskiest step, and numbered alternatives with one recommended. Use whenever someone wants the approach before any code is written: "/plan", "how should we build this", "what is the implementation plan", "which files would change".
disable-model-invocation: true
---

# plan

Nothing is built this turn. Open with `PLAN ONLY — nothing will be changed` and keep it true: read, search, ask — write nothing.

1. **Interrogate.** Restate the ask, name the goal under the proposed solution. What the repo can answer, look up. What only the asker can, ask now — one question, your recommended answer attached. A plan on a guess is expensive to unwind.
2. **Steps.** Ordered. Each names the files it changes and the test that proves it, and lands green on its own. A step with no test says why none can exist.
3. **Blast radius.** What else reads what you change — callers, schemas, config, docs. One command, not a guess. This is where plans are usually wrong.
4. **Riskiest step.** Name the one most likely to fail or be costly to undo, and the cheapest probe that tells you early.
5. **Alternatives.** Numbered, the asker's among them, plus `0) do nothing — <what we keep paying>`. One line for and against each. Rank them, recommend one, and say which trade-off that accepts.
6. **Decision record.** Only when the plan forecloses an alternative or reverses a recorded one: context, decision, consequences, alternatives rejected. Otherwise say why not — recording routine choices buries the load-bearing ones. Never overwrite a record; supersede it, link both ways.

End with the plan, the number you recommend, and the open question.
