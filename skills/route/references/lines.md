# The decision line and the receipt

Two lines per job. The **decision line** is printed before anything is handed
off; the **receipt** after the work and its review come back. Both go in the
chat, and wherever the project logs its work. What a session must do is in the
project policy's Contract section, which `/route` writes; this file is the
longer form behind it, with the field rules and examples. A policy never
depends on this file being installed.

## Decision line

```
Route: job <id> · coordinator <model>, user-chosen; advisor <model|off|unknown>; also did <roles|none> · do <profile>; <model>; <effort|n/a> · rank <k> — <why it fits> · review <profiles> (<cumulative|alternatives>) — <why> · bypassed <profile — reason; …|none> · exceptions <requirement — disposition|none>
```

- **Before, not after.** Nothing for this job is dispatched until the line is
  printed. A line written afterwards is a log entry, not a decision.
- **coordinator** is an input, the owner's pick. `also did` names every other
  role it plays on this job, because the floors bind that work too.
- **advisor** is configuration, not proof a consultation happened. `unknown`
  is never written as `off`. An advisor consult is never the review.
- **do** is a registry profile, or `coordinator` when the session does the
  work itself.
- **review** names every reviewer that will run, and says whether the list is
  cumulative or alternatives, as the policy does.
- **bypassed** names every higher rank not taken and why, including a builder
  refused **because no eligible reviewer exists for it**. That check happens
  here, before the build, not after it.
- **exceptions** is a requirement not met and what happens: the named person
  who waived it, or `job waits`. A reason is not a waiver.
- **Revised decisions** are re-issued, never edited in place:
  `Route (attempt 2): …`, with the failed attempt in `bypassed`.

## Receipt

```
Receipt: job <id> · observed <role> <model|unknown>; … · verdicts <role> <verdict>; … · dismissed <finding — reason; …|none> · usage <what was measured|—>
```

- **observed** comes from the run's own evidence: the subagent's report of its
  model, the tool's output. A value copied from the registry is not observed;
  write `unknown`.
- **verdicts** per reviewer, in its own words: `clean`, `FIX-FIRST (3)`, …
- **dismissed** lists every finding the coordinator did not act on, with the
  reason. A dismissal the evidence contradicts is a wrong dismissal, however
  well worded; the reason has to survive the files.

## Examples

Illustrative. Profile names are the reader's own registry's.

Ordinary job, done by the coordinator:

```
Route: job readme-fix · coordinator opus, user-chosen; advisor off; also did builder · do coordinator; opus; xhigh · rank 1 — two lines, cause known · review none — the policy's ordinary docs job needs no review · bypassed none · exceptions none
```

Money-security job, rank 1 refused before the build:

```
Route: job refund-limit · coordinator opus, user-chosen; advisor off; also did none · do codex-build; Codex config default; medium · rank 2 — rank 1 has no eligible reviewer · review fable-review (alternatives) — money-security needs a family other than the builder's · bypassed sonnet-build — no reviewer outside its family is available today · exceptions none
Receipt: job refund-limit · observed builder unknown (the plugin reports none); reviewer claude-fable-5-1 · verdicts fable-review FIX-FIRST (2) · dismissed "rename the helper" — style only, outside the spec · usage —
```

A decision revised at dispatch time:

```
Route (attempt 2): job docs-sweep · coordinator opus, user-chosen; advisor off; also did none · do sonnet-build; sonnet; n/a · rank 2 — the fallback for bulk text · review coordinator (alternatives) — ordinary · bypassed codex-build — attempt 1 returned a usage-limit error; that family is off for the session · exceptions none
```
