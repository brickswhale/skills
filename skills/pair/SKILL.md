---
name: pair
description: A second opinion from a different model, run so the partner's answer cannot shape yours. Use for "/pair", "pair this", "second model opinion", "ask the other model too", "what would another model say".
---

# pair

1. **Write your position first.** Your answer and open questions, labelled, in the chat — before reading anything the partner produced.
2. **Ask blind.** Send the question and primary material in the original words, not a summary. Never your position. Ask the partner to name its assumptions. One call, one answer: no second round.
3. **Call the recorded shape.** This machine keeps a record, `pair-transport.<host-family>`, with a `call=` line. Use it verbatim, putting the ask in its `"<prompt>"` slot as one literal argument — never on stdin, never shell-evaluated. Rebuilt from binary and memory, a call drops a documented flag and hangs. No record, or a `call=` disagreeing with `references/transports.md`: rewrite it from that file, and get a yes before any unconfirmed transport. Bound the call if the host offers a timeout.
4. **The ladder.** Rung 1, a different model family. Rung 2, same family, different model. Rung 3, same model, near-worthless: only by name, never by descent. One attempt per rung. A terminal failure — non-zero exit, refused auth, a dated limit — closes that rung: descend and say why. A hang proves nothing, a process may still be alive, and it ends the path: answer alone.
5. **Report it.** A `Partner:` line naming the model and rung that ran, from the record, with any failed rung's error. A `Premises:` line sorting load-bearing claims into verified, unverified and inference, ending in whether the recommendation is premise-dependent and whose call confirms it. Then both views separately, and where they part. Never average. A weaker partner's agreement is near-zero evidence.
