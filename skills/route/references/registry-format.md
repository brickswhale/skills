# The route registry

One file per machine, named `route-registry`. It lists the models this machine
can hand work to, one block per **profile**. Every project on the machine
reads the same file; it names this machine's tools and paths and nothing about
a project, so it is never committed. `/route` builds it and keeps it current.

## Where it lives

`~/.config/route/route-registry`, unless the owner names another place. Each
policy's header names the path, with `~` for the home directory, so the
committed file names no account.

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
| `tier` | `strong`, `capable`, `light`, or `unknown`: the owner's ruling, not a measurement; across families it is a stated preference |
| `role` | `builder`, `reviewer` or `reader` |
| `card` | the agent definition the call uses, or `—` |
| `call` | the whole invocation, verbatim, with `"<prompt>"` as its only hole |
| `effort` | the effort the call carries, or `n/a` where the host sets it |
| `writes` | `yes`, or `no` with how that is held: `enforced (<mechanism>)` or `instruction only` |
| `confirmed` | the date a call was **seen working**, with the tool versions; `no (drafted <date>)` until then |
| `gone` | optional: the date its tool or model disappeared; the block stays so the ranks that name it can be found |

## Rules for a profile

- **One model, several profiles.** A read-only reviewer card and a writing
  builder card are different calls, so different blocks.
- **A call that must reach one model names it.** Without a model selector a
  call reaches the tool's configured default, and `model=` is that default.
- **Effort is what the call really carries**: a value both the model lists
  and the transport accepts, or, with no effort flag, the tool's configured
  default.
- **A tier the owner has not given is `unknown`**, and fits no rank that
  compares tiers.
- **A listed model is a candidate** until the owner keeps it. A model the
  tool marks hidden is never a candidate.
- **External calls** take their shape from `pair`'s catalog: the whole line
  verbatim, resolved paths, the mandatory redirections. A `builder` profile may
  carry a write flag and says `writes=yes`.
- **A web app the owner pastes into** is found only by asking. Record it as
  `role=reader`, `call=manual: <how the ask and the reply travel>`, and write
  in the policy what it may never receive.

## What does not go here

- **Partners.** A second opinion runs `pair`, which keeps its own record.
- **The coordinator.** It is the session the owner picked.
- **Session state.** A family closed for the day goes in the decision line.
- **Preferences.** Which profile a job tries first is the policy's.

## File states

- **missing**: no file at the path. Setup.
- **malformed**: a duplicate key or profile, a block missing any of
  `profile`, `model`, `family`, `tier`, `role`, `call`, `writes` or
  `confirmed`, or a call with a hole other than `"<prompt>"`.
- **stale**: a `confirmed` version differs from the installed tool, a resolved
  path no longer exists, or the tool's configured default model changed.
- **current**: none of the above.

## Checks, run with the policy before anything is written

1. Every rank names a profile in this file, `coordinator`, or `owner`.
2. Every `reviewer` profile is `writes=no`.
3. Every money-security job has a builder whose required reviewers all exist
   and are eligible: another family where the policy asks for one, a tier not
   lower than the builder's, a context other than the builder's, not a manual
   lane the policy bars from code, never an advisor.
4. Every cumulative review list can be satisfied in full.
5. Every rank naming a `gone`, stale or unconfirmed profile is listed, per
   project.
6. Every `<owner to choose …>` line is listed with the jobs it blocks.
7. The risk classes name security work, or mark it `<owner to choose …>`.

A failed check is reported to the owner with the rank it concerns, never fixed
by quietly editing a rank.

## Updating an existing registry

1. **Re-point every call** whose path or tool moved, a `gone` block's call
   too. Read the finished file back and confirm no call names a removed path.
2. **Old confirmations belong to the old installation.** A profile confirmed
   on a tool version or path no longer installed is unconfirmed; say so.
3. **Report every visible model with no profile as its own list**, old and
   new, and rank none: adopting one is the owner's choice.
4. **List every rank a change touches, per project**, and edit none to
   replace a gone model: that replacement is the owner's. A session skips the
   gone rank and takes the next one already written.
