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
5. **Build.** Classify the owner's ask before drafting options. An order to fix or implement, without a request for discussion: do not call `plan` or `pair` or wait for another pick under this step; investigate and carry out the order. A problem report, behavior question or proposal without an implementation order, or an explicit request for discussion: run `plan` and `pair` on the cause and possible solutions, whoever will build. Show both views and stop for the owner's pick. Follow `pair`'s failure rules; report an unavailable partner. Next turn, record on the ticket the fixes weighed, the partner's view apart from yours, and the pick. For either path, before building, record the cause and evidence (or uncertainty), chosen fix, who authorized it and why, and cause-fix versus workaround. Build yourself (say why on the ticket), or hand off under `route`, using the re-checked ticket and authorized work as the builder prompt.
6. **Test, then review, then commit**: the reviewer `route` names, or `review` where the project has no routing line. Commit when the checks pass and no blocking finding is open, or on the owner's word. A finding you do not fix goes on the ticket with its reason. A design change is the owner setting, changing or rejecting a choice, one the spec made or left open, rather than holding the work to the spec. It never reaches a builder unsettled: stop the build loop, settle it with the owner on the cheapest preview you can make yourself (a sketch, a mock, a sample output) unless the owner's words leave the builder nothing to choose, write it into the ticket's spec with the owner's word, then make one fix round that carries it.
7. **Wrap up.** Set the ticket's status, then end with this block, each line filled or `not done — <why>`:
   - ticket: <id>, <status before> → <status after>
   - follow-ups: each one, and the ticket it was written to
   - receipt: who built, who reviewed, at what effort
   - not fixed: each finding in this task left open, and its reason
   - log: the line written, or the commit that carries it
