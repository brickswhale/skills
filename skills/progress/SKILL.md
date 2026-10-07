---
name: progress
description: Re-checks a plan's list against its evidence, fixes what has gone stale, then reports progress as one fixed checklist; drafts the list from evidence when none exists. Use whenever someone asks how far a piece of work has got or what is left, such as "what's the progress", "what's left" or "/progress", including mid-task, after a side discussion, or when the plan is already in your context.
---

# progress

1. **Find the list.** Name the effort: the one the ask names, else the one this session is working on. Its list is the `- [ ]` list in the effort's ticket, or in the file the ticket or the project's briefing points to; the briefing says where tickets live. Note the ticket's status. No list: step 2, then step 5. A list: steps 3 to 5. Done when you can give the list's path or URL, or say "no list" and where you looked.
2. **Draft the list.** Read the evidence: the ticket, its commits, notes, open branches. Write each item as `- [ ] <item> — proof: <what shows it done> — from: <source>`, run the proofs you can, and tick the items whose proof holds. Head it DRAFT and keep it in your report; it goes into the ticket when the owner agrees. No ticket either: say so and propose one, with a title. Done when every item has a proof and a source, and nothing is written.
3. **Check the list.** Run or read the proof of every open item, and of every item when asked for a full check: the test, the file, a linked ticket's state, the owner's recorded word. Then read what changed since the list's `Checked:` line (since the list was written, where it has none): each commit, and any uncommitted change. A change that touches an item gets that item re-checked; a change that adds work on this effort which no item covers is new work. An item with no proof named is checked by the best evidence you find: shown done, that evidence becomes its proof, written onto its line; still open, it gets a proof proposed, what would show it done. Done when each of these items has a verdict, its evidence, and a proof: named in the list, or proposed.
4. **Fix the list now.** Tick, untick or mark blocked, each only with proof, write in the proofs step 3 found, and set `Checked: <date> at <commit>`; these need no one's word. An open item carries at most one note, replaced at each check: `blocked by <what or who>`, or `(<date>: <why it is open>)`. New work, a proposed proof, and an item that looks dropped, split or out of order go on a `Proposed:` line below the list; the items themselves and their order change only on the owner's word. Done when the list reads back with each change.
5. **Report** in this shape:

```
Progress: <effort> (<ticket status>) — <done>/<total> · checked <date> · <list path or URL>
Changed:
- <item>: <before> → <after> — <proof>      (or: nothing changed)
Waiting on you:
- <decision, OK or action; each Proposed line is one OK>   (or: nothing)
List:
- [x] <n> done: <names, on one line>      (a DRAFT: each item on its own line, with proof and source)
- [ ] <item> — now: <next action>
- [ ] <item> — blocked by <what>
Proposed:
- <new work, or a drop, split or move> — from: <source>    (or: none)
- proof for <open item>: <what would show it done>
Next: <one step>
```
