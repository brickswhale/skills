# Routing policy template

`/route` fills the block below into `~/.config/route/route-policy.md`, one per
machine and shared by every project on it: every `<…>` from the owner's
answers, the lines that do not apply deleted. The policy holds only the
owner's choices; the generic Floors, Contract and Roles stay in this skill's
`references/rules.md`, read in place.

The shape, so any agent reads it the same way:

- One `## Job:` heading per job; under it, one line per rank.
- A rank names a registry `profile`, `coordinator` (the session does it
  itself) or `owner` (a person does it).
- Every review list says **cumulative** (every line runs) or
  **alternatives** (the first that fits runs).
- A rank's condition is prose after the dash, judged from the job in hand.
- An obligation that no longer holds is retired with a dated line under
  **Retired**, never deleted.

A project gets one line in its agent briefing (`AGENTS.md`, or `CLAUDE.md`
where that is the briefing; once where one links to the other), and its own
routing lines under it only when the owner adds them:

```
Routing: before handing work off, read `~/.config/route/route-policy.md` and the files it names. If you cannot, say so and ask the owner to run `/route`; never guess a model.
```

```markdown
# Routing policy — this machine

Owner: <who rules on this file> · Revised: <date>
Registry: `<path of this machine's route-registry, with ~ for the home directory>`
Rules: the `route` skill's `references/rules.md`, installed under `~/.claude/skills/route/` and `~/.agents/skills/route/`

## Risk classes

- money-security: <kinds: payments, auth, secrets, access rules, …; a project names its own paths under its pointer>
- ordinary: everything else.

## Quota

- <family>: spend on <…>; never on <…>.

## Job: <id> — <what this job is, one line>

Do (ranked):
1. <profile | coordinator> — <when this rank fits>

Review (<cumulative | alternatives>):
1. <profile | coordinator | owner> — <when>

## Other obligations

- <each rule the owner holds for every project that the lines above do not express>

## Retired

- <date> — <obligation> — <why it no longer holds, and who ruled>
```
