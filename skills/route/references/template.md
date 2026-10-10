# Route template

`/route` reads this file to write the owner's two files. Sessions never read
it: they read `rules.md`, which names both files.

## Contents

- 1. The dictionary
- 2. The jobs
- The pointer line
- Before writing: the checks
- Updating

## 1. The dictionary — `~/.config/route/dictionary.md`

Every model this machine can hand work to. It names this machine's tools and
paths, so it is never committed.

```markdown
# Model dictionary — this machine

Owner: <who rules on these files> · Revised: <date> · Tools seen: <name version, …>

## <name, as the jobs table writes it>

- Model: <the selector the tool takes>
- Family: <anthropic | openai | google | …> · Tier: <strong | capable | light | unknown>
- Good for: <one line, the owner's words or (proposed)>
- Cost: <plan or quota, the owner's words>
- Write call: <host that makes it>: <the whole invocation, "<prompt>" its only hole, for work that changes files> · writes: yes
- Read-only call: <host that makes it>: <the invocation for a review or a read> · writes: no, <enforced (how) | instruction only>
- Effort: <what the call carries | n/a>
- Confirmed: <the date a call was seen working, with tool versions | no (drafted <date>)>
- Gone: <the date its tool or model disappeared; omit while it is installed>
```

Writing an entry:

- One entry per model. Omit a call the model will not make; its write and read-only calls differ.
- A call that must reach one model names it. Without a selector a call reaches the tool's configured default, and `Model` is that default.
- Effort is what the call carries: a value the model lists and the tool accepts, or, with no effort flag, the tool's configured default.
- A tier the owner has not given is `unknown`, and fits no rank that compares tiers.
- A listed model is a candidate until the owner keeps it. A model the tool marks hidden is never a candidate.
- A web app the owner pastes into is found only by asking. Its read-only call is `manual: <how the ask and the reply travel>`; the jobs notes say what it never receives.
- No entry for the coordinator, the session the owner picked, or for second-opinion partners, which are `pair`'s.

How to write a call:

- Each call names the host that makes it — the agent app a session runs in, not the tools one session has switched on: `Claude Code` (its Agent tool), `any` (any app with a shell), `manual` (a person carries it). A session on a host a call does not name cannot make that call.
- Claude Code subagents: the Agent tool with `model=<opus | fable | sonnet | haiku>`. Write call: a type that can edit, such as `general-purpose`. Read-only call: a type without edit tools, such as `Plan`; it keeps Bash, so `writes: no, instruction only`.
- Codex through its Claude Code plugin: `node "<installPath>/scripts/codex-companion.mjs" task --fresh --model <m> --effort <e> "<prompt>" < /dev/null`, with `installPath` taken from `claude plugin list --json` for `codex@openai-codex`. The write call adds `--write`; the read-only call never does (enforced by the Codex sandbox). Efforts: `none` to `xhigh`. `< /dev/null` is mandatory. Keep `--fresh`: `rules.md` sends every round to a fresh call, so no call carries `--resume`.
- Codex CLI without the plugin: read-only only, `codex exec --sandbox read-only --skip-git-repo-check "<prompt>" < /dev/null`. A CLI write call is unverified: ask the owner.
- Write paths resolved, the home directory as `$HOME` inside double quotes: a quoted `~` does not expand.

## 2. The jobs — `~/.config/route/jobs.md`

Each job's models, ranked to do the work and to review it, and the owner's notes. These five
rows are the starting jobs; the owner may add rows.

```markdown
# Jobs — this machine

Owner: <who rules on these files> · Revised: <date>

| Job | Do (ranked) | Review (ranked) | Notes |
|---|---|---|---|
| Small fix — cause known, no design choice, a few files; a rule file only as its own row's Notes allow | main session | main session reads its own diff; the failing check now passes | |
| Build — a feature or change from a clear spec | <name> (<when>) → <name> (<when>) | <name> → <name> | |
| Money-security build — <the owner's kinds: payments, auth, secrets, access rules, …> | <name> → … | <name> → …; at least one of another family than the builder | |
| Rule file — a change to instructions an agent loads before working: a briefing, an agent card, a skill's rules, prompt rules, these route files | main session | <name> (another family, when that family's tool loads the file) → <name> (fresh context) | each reviewer reads the diff as instructions it would load and names any line it would read otherwise, any path or tool only one host has, and any rule the diff dropped; when no reader of the loading family ran, the receipt says so. Trims and moves count even when "no rule changed"; a purely mechanical pointer, path, date or typo fix that changes no instruction's authority, scope or obligation is a Small fix; a generated rule file is built as a Build and reviewed here |
| Research — facts from outside the repository | main session's own tools → <reader> (by hand) | main session checks every cited fact | <what a manual lane never receives> |

## Notes

- Quota: <family>: spend on <…>; never on <…>.
- <each rule the owner holds for every project that the rows do not express>
- Retired: <date> — <rule> — <why it no longer holds, and who ruled>
```

Reading a row: a cell names models as the dictionary does, `main session`
(the coordinator does it) or `owner` (a person does it). Reviewers are
alternatives, the first that fits, unless the cell says cumulative. A Do rank uses the model's write call, or its read-only call where the job changes no files; a Review rank uses its read-only call. A rank's
condition sits in brackets, judged from the task. A rule that no longer holds
is retired with a dated line, never deleted.

## The pointer line

Added once to a project's agent briefing (`AGENTS.md`, or `CLAUDE.md` where
that is the briefing; once where one links to the other), word for word:

```
Routing: before each hand-off (every fix round and re-review included) and before editing agent instructions, read the `route` skill's rules (`~/.claude/skills/route/references/rules.md`; Codex: `~/.agents/skills/route/references/rules.md`). If they or the files they name are missing, say so and ask the owner to run `/route`; never guess a model.
```

## Before writing: the checks

1. Every name a job uses has a dictionary entry, or is `main session` or `owner`.
2. Every model a Review rank names has a read-only call.
3. The money-security row reaches a builder whose reviewers exist and are eligible: at least one of another family than the builder, none of a lower tier, none in the builder's context, no manual lane the notes bar from code, never an advisor.
4. Every cumulative reviewer list can be satisfied in full.
5. Every rank naming a gone, stale or unconfirmed model is listed.
6. Every `<owner to choose …>` cell is listed with the jobs it blocks.
7. The money-security row names security work, or marks it `<owner to choose …>`.
8. Every starting job keeps this template's scope and review requirements, its placeholders filled, or the difference is listed with the owner's dated note that made it.
9. For every host the owner coordinates from, every Do and Review cell has `main session`, `owner`, or a rank whose call for that role that host can make, or the row's Notes say that role waits for the owner there.

A failed check is reported with the row it concerns, never fixed by quietly
editing a rank. A file is missing (setup), malformed (an entry without Family,
Tier, a call or Confirmed; a call with a hole other than `"<prompt>"`), stale
(a confirmed version differs from the installed tool, a resolved path no longer
exists, or the tool's default model changed), or current.

## Updating

1. Re-point every call whose path or tool moved, a gone model's too. Read the file back and confirm no call names a removed path.
2. Old confirmations belong to the old installation: a model confirmed on a version or path no longer installed is unconfirmed; say so.
3. Report every visible model with no entry as its own list, old and new, and rank none: adopting one is the owner's choice.
4. List every rank a change touches, in the jobs and in any project's own routing lines, and edit none to replace a gone model. A session skips the gone rank and takes the next one already written.
5. A starting job missing from the jobs is added with `<owner to choose …>` cells.
