---
name: flow
description: 'Carry one task from ask to closed ticket, so what is found on the way outlives the session. Use before the first edit of any change bigger than a typo, comment or format fix, and to close one: "/flow", "pick up <id>", "wrap up".'
---

# flow

A finding kept only in the chat dies with the session. The ticket holds the work: each step writes to it when it happens, and the wrap-up checks what was written. A skill called below hands its result back to this list. Where the project has its own rule for a step (what is trivial, who approves a commit, what done means), it overrides this list; a skill called below keeps its own rules.

1. **Lane.** A typo, comment or format fix: edit, log it the way the project logs, commit, and stop here. Unsure means not trivial.
2. **Open.** Find where this project keeps tickets; its briefing says, and if it does not, ask once. Reuse the ticket that covers the task, or call `intent` and file its body there. Name the id.
3. **Re-check** the ticket against today's code before building. If the ask no longer holds (already done, superseded, the problem gone), say so on the ticket and stop. A detail that moved, such as a renamed file, gets a dated note naming what differs, and the work goes on.
4. **Write as you go.** A finding goes on a ticket before your next step; one outside this task gets its own ticket. Read each write back before saying it landed.
5. **Build** yourself, or hand it to a builder under `route`; building it yourself, say why on the ticket. Before a builder gets it, run `plan`, and `pair` on the same question, then stop for the owner's pick. Next turn, record on the ticket the cause and its evidence, the fixes weighed, the partner's view apart from yours, the pick with who made it and why, and whether it fixes the cause or works around it. No partner reachable: say so and go on. Write the builder prompt from the re-checked ticket and its pick.
6. **Test, then review, then commit**: the reviewer `route` names, or `review` where the project has no routing line. Commit when the checks pass and no blocking finding is open, or on the owner's word. A finding you do not fix goes on the ticket with its reason.
7. **Wrap up.** Set the ticket's status, then end with this block, each line filled or `not done — <why>`:
   - ticket: <id>, <status before> → <status after>
   - follow-ups: each one, and the ticket it was written to
   - receipt: who built, who reviewed, at what effort
   - not fixed: each finding in this task left open, and its reason
   - log: the line written, or the commit that carries it
