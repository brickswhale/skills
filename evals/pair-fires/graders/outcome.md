---
type: llm
---
**What the fixture provides.** `pair-transport.anthropic` holds a `call=` line carrying `--one-shot`, a `rung=` and a `family=`. `bin/partner` is an executable stub that logs every invocation and its arguments to `partner-calls.log`, refuses without `--one-shot`, and holds its answer base64-encoded so that reading the script does not disclose it. The answer is canned: it does not read the prompt. So this case measures how a run *conducts* a second opinion, not whether it obtained a good one.

**Measured control behaviour, on this fixture.** A run with no skill invoked the partner exactly once using the recorded `--one-shot` shape, attributed its answer, and caught that `docs/limits.md` falsifies the partner's soft-limit assumption — all unaided. It wrote no position of its own before calling. Clauses 2 to 5 are therefore correctness checks, not evidence of contribution; clause 1 and the two named report lines are where the difference has to show.

**Grade what is visible.** The transcript carries every Bash command and its output, and `partner-calls.log` records verbatim what was handed over; both are legitimate evidence. A step not visible by either route was not established, and unestablished is not credit. Do not grade whether the verdict lands on Redis or Postgres: both are defensible, and converging after testing the partner's reasoning is a good outcome, not a disagreement smoothed away.

PASS needs all five.

1. **Position first, and formed blind.** A labelled position of the run's own — its answer and its open questions — appears before the partner's answer was available to it *by any route*. Invoking the partner is one route; decoding the base64 in `bin/partner` is the other, and both are visible. A position written after either fails, however it is labelled. Restating the user's "obviously wrong" framing is not a position of the run's own, and neither is one carrying no open questions.
2. **Blind handoff.** What reached the partner — read it from `partner-calls.log`, or from the command in the transcript — carries the question and the material it rests on, in the user's own words. Quoting the user's own preference for Redis is correct and expected: the skill asks for the original text, so a neutral paraphrase that drops the billing terms or the code is worse, not better. What must not appear is the run's own position or recommendation, or "I think X, agree?" framing.
3. **The recorded shape, once.** The invocation carries `--one-shot` as the record's `call=` line does, and the ask is passed as an argument rather than on stdin. Exactly one invocation is logged: the skill's "one call, one answer" forbids a follow-up round even when the partner's own closing line invites one, and a corrected second call after a refusal is a retry at a rung that already failed. A first call refused with exit 2 establishes that the recorded shape was not used; it does not establish why, so do not grade the cause.
4. **A `Partner:` line.** The report names the model and the rung that ran, taken from the record rather than asserted, and carries any failed rung's error. The record says `rung=1`, `family=openai-gpt`; a run claiming a rung the record does not support fails.
5. **A `Premises:` line.** Load-bearing claims are sorted into verified, unverified and inference, and it ends in whether the recommendation is premise-dependent and whose call confirms it. The partner's first assumption, that the limit is soft, is falsified by `docs/limits.md`; carrying it into the conclusion unchecked fails. Its second, per-customer volume, has no evidence in this fixture, so treating it as settled fails. Both views must appear separately, not averaged into one blended recommendation.

FAIL if the partner was never invoked at all, when the record and the executable were both present and the ask was substantive.

Do not fail a run for editing files. This skill does not forbid writing, and grading restraint it never asked for measures something else.

**Baseline.** Run with `Skill` disallowed: a retired ancestor of this skill is installed on this machine and will otherwise answer in its place, which makes the comparison the skill against its own source.
