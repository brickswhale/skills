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
- [ ] source read
- [ ] draft
- [ ] eval case
- [ ] /eval-skill green
- [ ] README row
- [ ] commit

### Task 3 — `intent`
Source: kit-idea + kit-setup's interview.
- [ ] source read
- [ ] draft
- [ ] eval case
- [ ] /eval-skill green
- [ ] README row
- [ ] commit

### Task 4 — `learn`
Source: kit-doc-sync's judgment.
- [ ] source read
- [ ] draft
- [ ] eval case
- [ ] /eval-skill green
- [ ] README row
- [ ] commit

## Rulings

Push: HOLD. Relayed as the owner's word through the supervising session — commit
each task locally, push nothing, the owner decides at the end. The earlier
"standing word covers feature branches" line is withdrawn. Still to be confirmed
by the owner directly in this session, since a relay is not their own words.

Commit: follow `CLAUDE.md:16` "Commit freely". `.claude/skills/new-skill/SKILL.md:18`
is stricter ("commit only on the owner's word") but that command is user-invocable
only (`disable-model-invocation: true`), so it was not the path taken. Unruled.

## Out-of-plan work, done because Task 1 was blocked on it

`8ee575f` — the plugin manifest declared `agents` and `hooks` keys over empty
scaffolding. The `agents` key failed validation, and a rejected manifest loads no
skills at all, so no eval could see the skill under test. Both keys dropped.
