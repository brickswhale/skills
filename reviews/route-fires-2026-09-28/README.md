# route-fires, retired 2026-09-28

The eval case for `route` as a dispatch-time checklist. It was never committed
as a case: its baseline showed the checklist's central claim needed no skill,
and `route` was re-planned as a setup-and-update command. Kept so the two runs
it produced can be reproduced. The findings are in `../route-design.md`,
sections "Step 3 result" and "Settling arm".

| File | What it is |
|---|---|
| `scaffold.sh` | the fixture: a refunds service, a money-security job whose first-ranked builder has no eligible reviewer, a logging dispatch stub, a base64 canned review |
| `prompt.md` | the task the runs were given |
| `rubric.md` | the five-clause rubric, as used; see the record for the fixes owed |
| `settling-arm.diff` | the four policy lines the settling arm added, and nothing else |
| `condense.py` | turns a stream-json run into the ordered transcript the graders read; keeps visible progress notes since 2026-09-28 |
| `grader-head.txt` | the head of every grader prompt; the rubric, transcript and dispatch log follow it |

To reproduce one run: in an empty directory outside any repository, run
`scaffold.sh` (or the scaffold with `settling-arm.diff` applied), delete it,
then run Claude Code non-interactively with the prompt, no plugin, `Skill`
disallowed, messaging tools disallowed, and an environment stripped to the
basics so no session channel is inherited. Grade with a fresh run given only
`grader-head.txt`, the rubric, the condensed transcript and `dispatch.log`.
