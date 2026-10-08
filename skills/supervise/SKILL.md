---
name: supervise
description: Supervise an effort from the session the owner talks to while other sessions do the work — keep its list, hand pieces off, check every report, relay decisions. Use when the owner asks to supervise or keep track of work other sessions do, such as "/supervise <ticket>" or "supervise this", and when a worker session's report arrives.
---

# supervise

A mode of the session the owner talks to. Other sessions build, research and discuss; this one keeps the list, checks their reports and carries the owner's words. Disk decides: a report, a tick or a memory is a claim until a commit, file or test shows it.

1. **List.** Call the Skill tool with "progress" when supervision starts, on every progress ask, and after every worker report. Its report is your report, with each worker's question under what waits on the owner. Every progress answer comes from that call, not from memory.
2. **Writers.** Before any dispatch, list the repository's other worktrees and branches (`git worktree list`) and the files each changes against the main branch, committed or not, and the files named in briefs this session has already sent. A piece that touches one of those files waits: give the owner the branch, the files and two numbered options, with your pick.
3. **Dispatch** each independent piece to a new session of its own; a subagent shares this session's folder, so it is not one. The brief names the item, its proof as what done means, the files or area and the skills to call ("Call the Skill tool with <name>"), and points at the ticket rather than copying it. It ends with the callback: "When this is done, or when you stop with 'waiting for: X', send a message to session <this session's id> with five lines: DONE or BLOCKED: <what> / head: <sha> on <branch>, pushed yes/no / checks: <what ran, and the result> / findings: open, ruled / waiting for: <X or none>. Send it once per stop, before your final line." Where no session can be started, give the owner the brief.
4. **Reports.** Check each claim in a report on disk before the owner hears it. Work that changes the repository is done once its commit is on the main branch; on the worker's branch only, the item stays open and its merge waits on the owner. A clean tree means the work may sit with the session's subagents: call no work lost. Then step 1.
5. **Corrections** go only to the session whose folder holds the work, and only when disk shows it off its item, idle mid-step or reporting wrong: its position and next action, nothing else.
6. **Decisions** are the owner's. Give each with its disk evidence, two numbered options and your pick. Relay the answer verbatim as the owner's word, after reading the worker's record for a word the owner gave it directly on the same point; where the two differ, put both to the owner.

A worker's files and steps stay the worker's: read them, run their code only in a copy, never change or finish them.
