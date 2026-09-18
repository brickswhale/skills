---
name: gate
description: At a phase boundary, has the work earned the next phase's cost? Every criterion answered against an artifact, with "not yet" a real answer. Use before the next chunk of investment: "/gate", "are we ready for the next phase", "phase checkpoint".
---

# gate

The bar: confidence to invest the next phase's cost. Not perfection, not polish it won't need.

**Collect first.** Tick each; paste what it printed.

- [ ] The written criteria — issue, plan, whatever exists. None: ask what done means, stop.
- [ ] Per criterion: the artifact that shows it — command output, a file, a diff. Run it.
- [ ] `grep -ri` each declaration **name** — version, package name, entry points — never the value you hold: a value search returns only copies that agree. Paste every hit.
- [ ] Each function touched this phase: `grep` its bare name, count the hits.
- [ ] In the notes: every TODO's revisit condition; the test or run behind each "handled" or "works".

**Not evidence:** a note asserting it · absence of a test · a file standing in for one you cannot get · your own bar.

**One label per criterion.**

- **met** — the artifact shows it.
- **not met** — you ran it and it failed; paste the failure.
- **not established** — you tried and cannot settle it here; say what you tried and what would.


**Verdict: READY or NOT YET**, with what flips it. READY is unavailable while a criterion is open; recommending they proceed anyway is READY in disguise — name the criterion waived.

**Close:** stop doing · cheapest wins · their one open question.
