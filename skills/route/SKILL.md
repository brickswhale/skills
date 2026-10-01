---
name: route
description: Set up or update model routing — which model builds and which reviews — writing the machine's model registry and its one routing policy on the owner's yes. Run once per machine, and again when a model or subscription changes. A command: "/route", "set up model routing", "update routing".
disable-model-invocation: true
---

# route

Writes this machine's model registry and its one routing policy, both under `~/.config/route/` and shared by every project on the machine. Sessions read them, with the rules in this skill's `references/rules.md`, to decide who builds and who reviews. A project gets one pointer line in its agent briefing; everything else, other skills included, this command only reads.

1. **Read** `references/registry-format.md`, `references/policy-template.md`, `references/rules.md`, and `pair`'s call catalog beside this skill, `../pair/references/transports.md`.
2. **Setup or update.** No registry or policy means setup; otherwise update them, keeping every owner-written line. For each project the owner names, add the pointer line once. A project with its own routing document: list what it obliges that the rules and the policy do not, and leave the document to the owner.
3. **Enumerate.** Read the tools' own model lists and config. Run only version and list commands, of tools you can identify. Ask the owner, in one message, what no file shows: subscriptions, each kept model's tier, what counts as money or security work, what may go where.
4. **Propose.** Draft the registry and the policy together. Credit the owner only with what the owner said, never widened. Mark `<owner to choose …>` what decides who builds or reviews money or security work, and what the owner reserved; mark every other recommendation `(proposed)`. Run the registry checks, then show the drafts with each model's family, whether it can write, and every failed check. Write on the owner's yes.
5. **Report** the files written; profiles added, changed or gone; each rank a change touches; failed checks; which jobs can run now and which wait, and on what. Name anything stale in `pair`'s record, `~/.config/pair/`, or in a project's own routing lines, and change neither.
