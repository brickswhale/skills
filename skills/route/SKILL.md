---
name: route
description: Set up or update model routing — which model builds and which reviews — writing the machine's model registry and each project's routing policy on the owner's yes. Run at setup and when a model or subscription changes. A command: "/route", "set up model routing", "update routing".
disable-model-invocation: true
---

# route

Writes this machine's model registry and a short routing policy per project, which sessions read to decide who builds and who reviews. It writes only those files and one pointer line in each project's agent briefing; everything else, other skills included, it only reads.

1. **Read** `references/registry-format.md`, `references/policy-template.md`, and `pair`'s call catalog beside this skill, `../pair/references/transports.md`.
2. **Setup or update.** No registry means setup. For each project the owner names: with no policy, draft one from the template; with one, keep every owner-written line and offer the template's current Floors, Contract and Roles. An owner-written value whose slot the template dropped moves to Other obligations.
3. **Enumerate.** Read the tools' own model lists and config. Run only version and list commands, of tools you can identify. Ask the owner, in one message, what no file shows: subscriptions, each kept model's tier, what counts as money or security work, what may go where.
4. **Propose.** Draft the registry and every policy change together. Credit the owner only with what the owner said, never widened. Mark `<owner to choose …>` what decides who builds or reviews money or security work, and what the owner reserved; mark every other recommendation `(proposed)`. Run the registry checks, then show the drafts with each model's family, whether it can write, and every failed check. Write on the owner's yes.
5. **Report** the files written; profiles added, changed or gone; each rank a change touches, per project; failed checks; which jobs can run now and which wait, and on what. Name anything stale in `pair`'s record or in a policy's owner-written lines, and change neither.
