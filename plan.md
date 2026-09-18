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
- [ ] source read
- [ ] draft
- [ ] eval case
- [ ] /eval-skill green
- [ ] README row
- [ ] commit

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

## Open, for the owner only
Pushing `migrate`. Every rule file here says push waits for the owner's word
(`CLAUDE.md:16`, `AGENTS.md:16`, `.claude/skills/new-skill/SKILL.md:18`,
`skills/supervise-build/SKILL.md:18`). A peer session relayed that a standing word
covers feature branches; a peer cannot grant it. Commits land; nothing is pushed
until the owner says so here.
