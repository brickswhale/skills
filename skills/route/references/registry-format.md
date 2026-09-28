# The route registry

One file per machine, named `route-registry`. It lists the models this machine
can hand work to, one block per **profile**, and it is never committed to any
repository: it names this machine's tools and paths and nothing about a
project. Every project on the machine reads the same file. `/route` builds it
and keeps it current; this file says what a correct one looks like.

## Where it lives

In the directory that holds the `pair` skill's `pair-transport.<host-family>`
record. No record yet: ask the owner which directory is this machine's config
directory, and use the answer. A location the owner names always wins.

## Format

Plain text. A line starting with `#` is a comment. A block is a run of
`key=value` lines; a blank line ends it. Split each line at its **first** `=`,
so a value may itself contain `=`. Never source the file into a shell or
evaluate a value.

| Key | Holds |
|---|---|
| `profile` | the name a policy ranks, such as `sonnet-build`; unique in the file |
| `model` | the model the call reaches, as the tool names it |
| `family` | the model's maker: `anthropic`, `openai`, `google`, … |
| `tier` | `strong`, `capable` or `light`: the owner's ruling, not a measurement. Across families no honest scale exists, so a cross-family tier is a stated preference |
| `role` | `builder`, `reviewer` or `reader` |
| `card` | the agent definition the call uses, or `—` |
| `call` | the whole invocation, verbatim, with `"<prompt>"` as its only hole |
| `effort` | the effort the call carries, or `n/a` where the host sets it |
| `writes` | `yes`, or `no` with how that is held: `enforced (<mechanism>)` or `instruction only` |
| `confirmed` | the date a call was **seen working**, and the tool versions it was seen on; `no (drafted <date>)` until then |
| `gone` | optional: the date its tool or model disappeared; the block stays so ranks that name it can be found |

## Rules for a profile

- **One model, several profiles.** A read-only reviewer card and a writing
  builder card are different calls, so they are different blocks with the
  same `model`.
- **A call that must reach one model names it.** Without a model selector a
  call reaches the tool's configured default, and its `model=` is that
  default. Two profiles with the same call reach the same model, whatever
  their `model=` says.
- **Effort is the overlap.** Only a value both the model lists and the
  transport accepts. Not yet known: `unknown`, and ask; `n/a` means the host
  sets it.
- **A listed model is a candidate.** It becomes a profile when the owner keeps
  it, and `confirmed` when a call is seen working. A model the tool marks
  hidden is never a candidate.
- **External calls** take their shape from `pair`'s `references/transports.md`
  and keep its rules: the whole line verbatim, resolved paths, the mandatory
  redirections. That catalog forbids write flags because a partner advises;
  a `builder` profile may carry one and says `writes=yes`.
- **A web app the owner pastes into** is found only by asking, never by
  scanning. Record it as `role=reader`, `call=manual: <how the ask and the
  reply travel>`, and write in the policy what it may never receive.

## What does not go here

- **Partners.** A second opinion runs `pair`, which keeps its own record.
  `/route` reads that record and reports it when stale; it never rewrites it.
- **The coordinator.** It is the session the owner picked, not a candidate.
- **Session state.** "That family is off today" or a quota error lasts one
  session and goes in the decision line, never here.
- **Preferences.** Which profile a job tries first is the project policy's.

## File states

- **missing**: no file where it should be. Setup.
- **malformed**: a duplicate key in a block, a duplicate profile, a block
  missing any of `profile`, `model`, `family`, `tier`, `role`, `call`,
  `writes` or `confirmed` (the checks depend on each), or a call with a hole
  other than `"<prompt>"`.
- **stale**: a `confirmed` version differs from the installed tool, a resolved
  path no longer exists, or the tool's configured default model changed.
- **current**: none of the above.

## Checks, run with the policy before anything is written

1. Every rank names a profile in this file, `coordinator`, or `owner`.
2. Every `reviewer` profile is `writes=no`.
3. Every money-security job has a builder whose required reviewers all exist
   and are eligible: another family where the policy asks for one, a tier
   not lower than the builder's, a fresh context, not a manual lane the
   policy bars from code, never an advisor.
4. Every cumulative review list can be satisfied in full.
5. A rank naming a `gone`, stale or unconfirmed profile is listed by project.

A failed check is reported to the owner with the rank it concerns. It is
never fixed by quietly editing a rank.

## Updating an existing registry

1. **Re-point every call** whose path or tool moved, a `gone` block's call
   too: it stays so the ranks naming it can be found, and it stays correct.
   Then read the finished file back and confirm no call names a removed path
   before reporting the work done.
2. **Old confirmations belong to the old installation.** Say so for every
   profile whose `confirmed` names a tool version or path no longer
   installed; a changed profile is `no` until a call is seen working.
3. **Report visible models with no profile as their own list**, apart from
   any replacement you suggest, and rank none of them: adopting one is the
   owner's choice.
4. **List every rank a change touches, per project**, and reroute none: a
   gone model's ranks wait for the owner.

## Example

Illustrative, not a registry. Build yours from the live tools and the owner's
answers; never copy these values.

```
profile=sonnet-build
model=sonnet
family=anthropic
tier=capable
role=builder
card=implementer
call=Agent tool, subagent_type=implementer, model=sonnet, one prompt, no continuation
effort=n/a
writes=yes
confirmed=no (drafted 2026-09-28)

profile=codex-build
model=<a model the Codex cache lists>
family=openai
tier=capable
role=builder
card=—
call=node "<resolved plugin root>/scripts/codex-companion.mjs" task --fresh --write --model <that model> --effort medium "<prompt>" < /dev/null
effort=medium
writes=yes
confirmed=2026-09-28 (codex-cli <version>, plugin <version>)

profile=web-research
model=the owner's web assistant
family=google
tier=capable
role=reader
card=—
call=manual: print the ask between copy markers; the owner pastes the reply back
effort=n/a
writes=no, enforced (no repository access)
confirmed=2026-09-28 (owner)
```
