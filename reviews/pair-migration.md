# pair — what the migration reviews left unsettled

Before `pair` was committed, two models were each asked, blind and separately, to
review the migration. Neither saw the other's answer or the reviewing agent's own
position. Their findings changed the work; this file is only the part that did
**not** get resolved.

**Scope, and what it is not.** The reviews were written against an earlier
snapshot, and later commits changed it. Every item below was re-checked against
the tree at `a27965e` before being listed, and nine further findings were dropped
because the check showed them already fixed. These are open questions, not a
fresh audit and not a defect list. One item is marked verified because it was
reproduced; the rest are unverified review allegations.

## What the reviews already produced

Reasoning lives in the commits, not here:

- `fe76aa6` — the catalog was brought into the repo rather than left pointed at
- `ef5f464` — four partner-safety rules restored to the catalog
- `eaa71d5` — the word cap enforced at the boundary the rule states
- `a27965e` — the skills table completed

## Verification backlog

| # | Question | From | Status |
|---|---|---|---|
| 1 | The skill names the record's filename but no directory. How does a fresh install find it? | GPT | unverified |
| 2 | Nothing requires confirming that a model override actually took effect, so a rung claim can be honest and wrong. | GPT | unverified |
| 3 | A reused record's rung is not re-checked against the current host; a rung-1 record on a new host may no longer be cross-family. | GPT | unverified |
| 4 | There is a per-rung attempt limit but no total-budget stop across the ladder. | GPT | unverified |
| 5 | After a hang, nothing says to diff what was run against the recorded `call=` before concluding the partner failed. | GPT | unverified |
| 6 | "Where the two views agree" was trimmed from the report contract; only where they part survives. | Fable | unverified |
| 7 | The eval exercises one path: a record exists and the partner answers. Missing record, stale record, hang, descent and rung 2 are never run. | both | unverified |
| 8 | The fixture's partner is canned, so the case measures conduct, never whether a useful second opinion was obtained. | both | unverified |
| 9 | Disallowing `Skill` in the control blocks an invocation route, not file reads, so the arms may differ by more than the skill. | Fable | unverified |
| 10 | "The control fails" does not say how repeated control runs aggregate. Applies to every skill here, not just this one. | Fable | unverified |
| 11 | The commit hook word-counts the working tree, not the staged blob. | GPT | **verified** |

On 11: reproduced against `a27965e`. A 481-word blob staged while a 282-word
working tree sat on disk passed the hook, because it inspects the file rather
than what git would commit. The same applies to the home-path, project-name and
credential checks, which read the working tree too. A fix reads the staged blob.

## Reading this later

Nothing here is owned or scheduled. Items 1 to 6 bear on execution safety and
would matter before supporting a new transport. Items 7 to 10 bear on how much
the green eval result actually establishes. Item 11 is a live gap in the hook.

The raw reviews were not kept: they carry names and paths from a private
framework that this public repo may not hold, and their actionable content is
above or in the four commits.
