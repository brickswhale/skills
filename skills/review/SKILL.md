---
name: review
description: Review uncommitted work before it lands — four lenses (bugs, security, does the diff match the plan, scope creep), every finding verified against the code and given a counted class, returned as JSON. Use whenever someone asks you to look over a diff or changes: "/review", "review my changes", "audit this before I commit", "is this safe to land".
---

# review

A finding you have not reproduced is a rumor.

1. **Read.** `git diff`, `git status`. Name the plan it claims to follow — ticket, plan file, the ask in thread. None named: say so, review the diff alone.
2. **Run.** The declared test command. Record count and failures. A layer you cannot run here is reported not run, with its command.
3. **Lenses.** Four passes, each blind to the last:
   - **bugs** — inputs and state reaching a wrong result or crash.
   - **security** — untrusted input, secrets, permissions, injection.
   - **plan** — does the diff do what the plan says, all of it?
   - **scope** — what is in the diff nobody asked for.
4. **Verify.** Read the cited lines and state the concrete failure: inputs → wrong outcome. Cannot state it, drop it — a false important costs more than a missed nit.
5. **Class.** Every survivor names its class, then one command counts its siblings and reports that number. Two or more, the class is the finding and the fix sweeps all of them.
6. **Report** JSON and nothing else — a house style preferring prose does not apply, the caller parses this:

```json
{"verdict": "ready | fix first | rethink",
 "findings": [{"severity": "important|nit", "file": "", "line": 0,
               "claim": "", "evidence": "", "class": ""}],
 "executed": ["every command you ran"]}
```

Surface, never fix: the fix is the next job.
