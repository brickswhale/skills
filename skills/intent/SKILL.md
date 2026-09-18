---
name: intent
description: Turn a raw ask into an issue anyone could pick up — problem, outcome, who it affects, constraints, open questions — interrogating until each is concrete. Bug and incident are variants. Use for "/intent", "file this", "write this up as an issue", "capture this idea".
disable-model-invocation: true
---

# intent

Capture what someone wants, never how to build it. A solution written here hides the problem it serves.

1. **Say the ask back** in one sentence. Wrong, they correct it now, not after the work.
2. **Interrogate** until every field below is concrete. What the repo answers, look up. What only they can, ask in one batch with your best guess on each, so a nod is enough. "Make it faster" becomes "p95 under 200ms on the list endpoint" or it is not ready.
3. **Fields**, all five, every time. One with nothing in it reads `unknown — <what would settle it>`, never a guess dressed as fact.
   - **problem** — what hurts now, and the evidence it hurts.
   - **outcome** — what is true when this is done, in words a test could check.
   - **affected** — who and what feel it: people, callers, systems.
   - **constraints** — what cannot move: compatibility, budget, deadline, a decision already recorded.
   - **open questions** — what is undecided, and who decides it.
4. **Variants.** A bug adds steps to reproduce, expected, actual, and how often. An incident adds when it started, what is still degraded, and what stopped the bleeding. Both keep all five fields.
5. **A rejection is intent too.** Record the decision, the date and the reason, so next quarter does not propose it again.
6. **Hand back the issue body and nothing else.** Do not start the work, do not propose the fix.
