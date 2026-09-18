# Plan: four-skill migration

Owner's decision 2026-09-18: rewrite `review`, `plan`, `intent`, `learn` here, in that
order. The other fourteen `kit-*` retire per the README table; no files for them.
Nothing copied verbatim. Each skill under 300 words, generic, no `kit` vocabulary.
No `kit-*` symlink is removed: six live projects still use them, and the new names differ.

### Task 0 — README rule fix
- [x] source read
- [x] draft
- [x] eval case (n/a — doc only)
- [x] /eval-skill green (n/a — doc only)
- [x] README row
- [x] commit

### Task 1 — `review`
Source: kit-lens-review + the lenses of kit-eng-pass.
- [x] source read
- [x] draft
- [x] eval case
- [x] /eval-skill green
- [x] README row
- [x] commit

### Task 2 — `plan`
Source: kit-consult + kit-adr.
- [x] source read
- [x] draft
- [x] eval case
- [x] /eval-skill green
- [x] README row
- [x] commit

### Task 3 — `intent`
Source: kit-idea + kit-setup's interview.
- [x] source read
- [x] draft
- [x] eval case
- [x] /eval-skill green
- [x] README row
- [x] commit

### Task 4 — `learn`
Source: kit-doc-sync's judgment.
- [x] source read
- [x] draft
- [x] eval case
- [x] /eval-skill green
- [x] README row
- [x] commit

## Rulings

Push: HOLD — reaffirmed by the owner directly, a second time, after a relay
reported they had reversed it. Their words both times, asked for directly.
Commit each task locally, push nothing, they decide after seeing the four skills.
Three separate push instructions have now reached the supervising session citing
the owner; none came from the owner. Only the owner lifts this.

Invocation: `plan` and `intent` ship as commands, `disable-model-invocation: true`
— the owner's word, given directly. Both lost their trigger to a skill an
always-loaded hook names for this phrasing; two description rewrites did not move
it, while explicit invocation ran the body correctly. A command makes no `Skill`
tool call, so their fired-grader matches a line only the body produces.

Rebase: NOT done, and not to be done unattended. The owner's own word, given
directly after Task 4 closed: leave the six commits on the old base until they
have read the diff. The relayed "rebase after Task 4" ruling is superseded by
this one. No conflict is expected when it does happen — `main`'s new commit
touches only `skills/supervise-build/SKILL.md`, which this migration never edited.

Commit: follow `CLAUDE.md:16` "Commit freely". `.claude/skills/new-skill/SKILL.md:18`
is stricter ("commit only on the owner's word") but that command is user-invocable
only (`disable-model-invocation: true`), so it was not the path taken. Unruled.

## Out-of-plan work, done because Task 1 was blocked on it

`8ee575f` — the plugin manifest declared `agents` and `hooks` keys over empty
scaffolding. The `agents` key failed validation, and a rejected manifest loads no
skills at all, so no eval could see the skill under test. Both keys dropped.
