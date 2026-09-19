# Partner transports

Reference data for `pair`: agent surfaces that can answer as a partner, the exact
one-shot call each needs, and the edges that have cost real sessions real time.

This is a catalog, not code. Never shell-evaluate a line from it. Use it to
recognise a candidate, to write a transport record, and to repair one that has
gone stale. An entry without a verified date is a candidate, not a
recommendation.

## Limits that bind every transport here

These hold whatever partner you reach for, and they are the reason this file is
a catalog of recognised surfaces rather than a licence to go looking.

- **Enumerate; do not probe.** Check that a binary exists on PATH, and stop
  there. Running an unknown binary to find out what it is makes the search
  itself the risk, and a partner search is not worth executing something
  unrecognised on the user's machine.
- **Send nothing until the transport is confirmed.** Discovery is the wrong
  moment to hand over file contents, error text or anything else from the
  project. Confirm what the partner is, which family it belongs to and whether
  its read-only story is enforced or merely instructed; get the user's yes; then
  send the material.
- **A partner advises, it does not act.** Pairing buys a second opinion on one
  question. An ask shaped as "have the other model fix this" is not a pair call,
  and routing work through a partner turns an advisory transport into an
  unreviewed second implementer. Say so and hand the work back.
- **A mutating tool is not eligible.** Where a transport can change state and
  its read-only behaviour cannot be enforced, it is a candidate only with that
  gap named out loud in the confirmation you ask for — never silently, and never
  by default.

## Why a record is not enough on its own

A transport record caches one entry from this file. The cache is what gets read
later, so a partial cache is what will actually be believed.

The expensive case: an entry had carried a mandatory redirection for months,
while the record stored only the binary, the family and the read-only flag. A
later session reused the record, rebuilt the rest of the command from memory,
omitted the redirection, and hung with no bound at all. The knowledge was never
missing. The lossy copy is what was reused.

So a record must carry the whole `call=` line, verbatim, and reuse must invoke
that line rather than reconstruct one. If the record has no `call=`, or its
`call=` no longer matches the entry here, rewrite the record from this file
before calling.

## Codex CLI (`codex`) — verified, field use

- **One-shot call:** `codex exec --sandbox read-only --skip-git-repo-check "<prompt>" < /dev/null`
- `< /dev/null` is **mandatory** in a non-interactive shell. With a prompt
  argument and stdin still open, the command waits to append stdin to the prompt
  and hangs indefinitely, printing only that it is reading more input.
- `codex exec resume --last "<text>"` is **not** a call shape. It continues an
  earlier session, so it is a second attempt under another name; it may launch
  over a process that is still alive; and it rejects `--sandbox`, so it cannot
  carry read-only enforcement. Listed here to be recognised and refused.
- `-o <file>` writes the final message to a file, which helps when stdout
  carries streaming noise. Long asks: budget generously and set a bound.
- **Read-only:** enforced by the CLI through `--sandbox read-only`.
- **Family:** OpenAI GPT.

## Codex over MCP — verified, with a caveat

- A session-connected tool that opens a Codex conversation; a second tool
  continues it by thread id.
- **Caveat:** a long ask exceeds the MCP transport timeout. Observed, more than
  once. Prefer the CLI for anything substantial; MCP is fine for short asks.
- **Read-only:** through a `sandbox` parameter set to read-only.

## Claude Code CLI (`claude`) — unverified as a partner

- **One-shot call:** `claude -p "<prompt>"`, print mode, non-interactive.
- **Read-only:** no single sandbox flag. The candidate mechanism is restricting
  tools to read-only ones, which is **unverified**. Until a real session
  confirms it, offer this transport only with that gap named out loud in the
  confirmation you ask for.
- **Family:** Anthropic Claude. Against an Anthropic host this is rung 2 at
  best, and rung 3 if the model is the same.

## In-process subagent, same family — rung 2, candidate

The fallback rung, and the reason transport enumeration has a third category at
all. A host that can spawn a subagent **with a model override** gives a rung-2
partner with no external process, no separate authentication and no rate limit
shared with the CLI transports — which is why it survives a rung-1 outage. It
still spends the host account's own budget, so it survives one provider's limit,
not every limit.

- **One-shot call:** spawn one subagent whose entire prompt is the ask plus the
  primary material. No continuation turn. The blind-ask and one-attempt rules
  apply unchanged.
- **Blindness holds only if you mechanise it.** This is the easiest transport to
  leak on, because the host composes the prompt in the same context that holds
  its own answer, and the subagent usually inherits file access, so it can reach
  the host's position without a word being leaked to it. Two countermeasures,
  both required: echo the prompt into the chat before spawning, which restores
  the auditability a CLI gives for free; and name the paths the subagent may
  read, keeping your own working notes outside them.
- **Read-only is by instruction, not enforcement.** A subagent normally inherits
  the host's tools. Name that gap in the confirmation, and prefer a read-only
  agent type where the platform offers one.
- **Family: the host's own.** Different weights, shared lineage. Never present
  it as cross-family diversity, and say `rung 2 (unconfirmed)` when you cannot
  confirm the model override took effect.

## Gemini CLI (`gemini`) — unverified

Existence check only. If it is present, confirm the call shape, the
non-interactive mode and the read-only story in a real session before offering
it as a partner.

## Adding an entry

Name · family · one-shot call shape · continuity mechanism, if any · read-only
enforcement · sharp edges · verification status and date.

Found a new edge, or verified a candidate during real use? Add it here with the
date. A record that disagrees with this file is stale, and this file wins.
