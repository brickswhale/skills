---
name: pair
description: A second opinion from a different model, run so its answer cannot shape yours. Use for "/pair", "pair this", "second model opinion", "ask the other model too", "what would another model say".
---

# pair

1. **Write your position first.** Your answer and open questions, labelled in the chat, before reading anything the partner produced.
2. **Ask blind.** Send the question and primary material in the original words, not a summary. Never your position. Ask it to name its assumptions. One call, one answer.
3. **Call the recorded shape.** This machine keeps a record, `pair-transport.<host-family>`, with a `call=` line. Use it verbatim, putting the ask in its `"<prompt>"` slot as one literal argument — never on stdin, never shell-evaluated. Rebuilt from binary and memory, a call drops a documented flag and hangs. No record, or a `call=` disagreeing with `references/transports.md`: rewrite it from that file, whose limits on what you may run, send and delegate bind here. Get a yes before any unconfirmed transport, and bound the call if the host allows.
4. **The ladder.** Rung 1, a different model family. Rung 2, same family, different model. Rung 3, same model: only by name, never by descent. One attempt per rung. A terminal failure — non-zero exit, refused auth, a dated limit — closes that rung: descend, say why. A hang proves nothing, a process may still be alive, and ends the path: answer alone.
5. **Report it.** A `Partner:` line naming the model and rung that ran, from the record, with any failed rung's error. A `Premises:` line sorting load-bearing claims into verified, unverified and inference, ending in whether the recommendation is premise-dependent and whose call that is. Then both views separately, where they part. Never average. A weaker partner's agreement is near-zero evidence.
